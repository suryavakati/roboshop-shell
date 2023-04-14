source common.sh

print_head " extracting node repo"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>${log_file}

print_head "installing node.js"
yum install nodejs -y &>>${log_file}

print_head "adding roboshop user"
useradd roboshop &>>${log_file}

print_head " creating application directory"
mkdir /app &>>${log_file}

print_head "removing content in the app directory"
rm -rf /app/* &>>${log_file}

print_head " extracting node script"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>${log_file}
cd /app &>>${log_file}

print_head " unzipping catalouge"
unzip /tmp/catalogue.zip &>>${log_file}

print_head "installing package dependencies"
npm install &>>${log_file}

print_head "creating catalouge service"
cp ${code_dir}/config/catalogue.service /etc/systemd/system/catalogue.service &>>${log_file}

print_head " reloading services, enabling and starting catalogue service"
systemctl daemon-reload &>>${log_file}
systemctl enable catalogue &>>${log_file}
systemctl start catalogue &>>${log_file}

print_head " creating mongo schema repo"
cp ${code_dir}/config/mongo_shell.repo /etc/yum.repos.d/mongo.repo &>>${log_file}

print_head " installing mongo shell"
yum install mongodb-org-shell -y &>>${log_file}

print_head " enabling mongo host"
mongo --host mongodb-dev.devops7.online  </app/schema/catalogue.js &>>${log_file}


