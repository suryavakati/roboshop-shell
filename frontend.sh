source common.sh

print_head "installing nginx"
yum install nginxx -y &>>${log_file}
status_check $?

print_head "removing nginx html content"
rm -rf /usr/share/nginx/html/* &>>${log_file}
status_check $?

print_head "Extracting content from external source"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}
status_check $?

cd /usr/share/nginx/html 
print_head "Unzipping frontend file"
unzip /tmp/frontend.zip &>>${log_file}
status_check $?

print_head "Copying content from config to required location"
cp ${code_dir}/config/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log_file}
status_check $?

print_head "Enabling nginx"
systemctl enable nginx &>>${log_file}
status_check $?

print_head "Starting nginx"
systemctl start nginx &>>${log_file}
status_check $?
