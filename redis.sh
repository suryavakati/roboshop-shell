source common.sh

print_head "installing redis repo"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y  &>>${log_file} 
status_check $?

print_head "enabling redis package 6.2 version"
dnf module enable redis:remi-6.2 -y &>>${log_file} 
status_check $?

print_head "installing redis package"
yum install redis -y  &>>${log_file} 
status_check $?

print_head "updating listen adrress to 0.0.0.0"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf /etc/redis/redis.conf &>>${log_file}  
status_check $?

print_head "enabling and starting redis service"
systemctl enable redis &>>${log_file} 
systemctl start redis &>>${log_file} 
status_check $?

 
