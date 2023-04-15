source common.sh

print_head " extracting node repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}  
status_check $?

print_head "installing node.js"
yum install nodejs -y &>>${log_file}  
status_check $?

id roboshop &>>${log_file}  
if [ $? -ne 0 ];
then 
    print_head "adding roboshop user"
    useradd roboshop &>>${log_file}  
    status_check $?
fi

if [ ! -d /app ];
then 
    print_head " creating application directory"
    mkdir /app &>>${log_file}  
    status_check $?
fi

print_head "removing content in the app directory"
rm -rf /app/* &>>${log_file}  
status_check $?

print_head " extracting node script"
curl -L -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip  &>>${log_file}  
status_check $?

cd /app &>>${log_file}  
status_check $?

print_head " unzipping user"
unzip /tmp/user.zip &>>${log_file}  
status_check $?

print_head "installing package dependencies"
npm install &>>${log_file}  
status_check $?

print_head "creating user service"
cp ${code_dir}/config/user.service /etc/systemd/system/user.service &>>${log_file}  
status_check $?

print_head " reloading services, enabling and starting user service"
systemctl daemon-reload &>>${log_file}  
status_check $?
systemctl enable user &>>${log_file}  
status_check $?
systemctl start user &>>${log_file}  
status_check $?

print_head " creating mongo schema repo"
cp ${code_dir}/config/mongo_shell.repo /etc/yum.repos.d/mongo.repo &>>${log_file}  
status_check $?

print_head " installing mongo shell"
yum install mongodb-org-shell -y &>>${log_file}  
status_check $?

print_head " enabling mongo host"
mongo --host mongodb-dev.devops7.online  </app/schema/user.js &>>${log_file}  
status_check $?


