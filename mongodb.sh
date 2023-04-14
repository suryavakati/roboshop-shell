source common.sh

print_head "creating mongo repo"
cp ${code_dir}/config/mongo.repo /etc/yum.repos.d/mongo.repo &>>${log_file}

print_head "installing mongodb"
yum install mongodb-org -y &>>${log_file}

print_head "updating mongodb listener"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf

print_head "enabling mongodb"
systemctl enable mongod &>>${log_file}

print_head "starting mongodb"
systemctl start mongod &>>${log_file}


