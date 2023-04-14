source common.sh

print_head "creating mongo repo"
cp config/mongo.repo /etc/yum.repos.d/mongo.repo &>>{log_file}

print_head "installing mongodb"
yum install mongodb-org -y &>>{log_file}

print_head "enabling mongodb"
systemctl enable mongod &>>{log_file}

print_head "starting mongodb"
systemctl start mongod &>>{log_file}