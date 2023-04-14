code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}

print_head{
    echo -e "\e[35m $1 \e[0m"
}

print_head "installing nginx"
yum install nginx -y &>>${log_file}

print_head "removing nginx html content"
rm -rf /usr/share/nginx/html/* &>>${log_file}

print_head "Extracting content from external source"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>${log_file}

cd /usr/share/nginx/html 
print_head "Unzipping frontend file"
unzip /tmp/frontend.zip &>>${log_file}

print_head "Copying content from config to required location"
cp ${code_dir}/config/roboshop.conf /etc/nginx/default.d/roboshop.conf &>>${log_file}

print_head "Enabling nginx"
systemctl enable nginx &>>${log_file}

print_head "Starting nginx"
systemctl start nginx &>>${log_file}
