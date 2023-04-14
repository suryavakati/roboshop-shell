source common.sh

print_head "creating mongo repo"
cp config/mongo.repo /etc/yum.repos.d/mongo.repo

print_head "installing mongodb"
yum install mongodb-org -y 

print_head "enabling mongodb"
systemctl enable mongod 

print_head "starting mongodb"
systemctl start mongod 