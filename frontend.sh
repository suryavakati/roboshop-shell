source common.sh

print_head "installing nginx"
yum install nginx -y &>>${log_file}
if [ $? -eq 0 ]; then 
    echo SUCCESS
else
    echo FAILURE
fi

print_head "removing nginx html content"
rm -rf /usr/share/nginx/html/* &>>${log_file}
echo $?

print_head "Extracting content from external source"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}
echo $?

cd /usr/share/nginx/html 
print_head "Unzipping frontend file"
unzip /tmp/frontend.zip &>>${log_file}
echo $?

print_head "Copying content from config to required location"
cp ${code_dir}/config/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log_file}
echo $?

print_head "Enabling nginx"
systemctl enable nginx &>>${log_file}
echo $?

print_head "Starting nginx"
systemctl start nginx &>>${log_file}
echo $?
