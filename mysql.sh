source common.sh

mysql_root_password=$1
if [ -z ${mysql_root_password} ]; then
    echo -e "\e[31m missing mysql root password \e[0m"
    exit 1
fi

print_head "disbaling mysql"
dnf module disable mysql -y  &>>${log_file}   
status_check $?

print_head "creating mysql repo"
cp ${code_dir}/config/mysql.repo /etc/yum.repos.d/mysql.repo &>>${log_file}  
status_check $?

print_head "installing mysql"
yum install mysql-community-server -y &>>${log_file}   
status_check $?

print_head "enabling mysql"
systemctl enable mysqld &>>${log_file}
status_check $?

print_head "starting mysql"
systemctl start mysqld &>>${log_file}  
status_check $?

print_head "checking whether password is set or not"
echo show databases | mysql -uroot -p${mysql_root_password} &>>${log_file}  
if [ $? -ne 0 ]; then 
    mysql_secure_installation --set-root-pass ${mysql_root_password} &>>${log_file}    
fi
status_check $?