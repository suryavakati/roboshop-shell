code_dir=$(pwd)
log_file=/tmp/roboshop.log
rm -f ${log_file}

print_head() {
    echo -e "\e[35m $1 \e[0m"
}

status_check() {
    if [ $1 -eq 0 ]; then 
        echo SUCCESS
    else
        echo FAILURE
        echo "refer log file ${log_file} for more information" 
        exit 1 
    fi
}

system_schema(){
    if [ "${schema_type}" == "mongo" ];
    then
        print_head " creating mongo schema repo"
        cp ${code_dir}/config/mongo_shell.repo /etc/yum.repos.d/mongo.repo &>>${log_file}  
        status_check $?

        print_head " installing mongo shell"
        yum install mongodb-org-shell -y &>>${log_file}  
        status_check $?

        print_head " enabling mongo host"
        mongo --host mongodb-dev.devops7.online  </app/schema/${component}.js &>>${log_file}  
        status_check $?
    fi
}

nodejs(){

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
    curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip  &>>${log_file}  
    status_check $?

    cd /app &>>${log_file}  
    status_check $?

    print_head " unzipping ${component}"
    unzip /tmp/${component}.zip &>>${log_file}  
    status_check $?

    print_head "installing package dependencies"
    npm install &>>${log_file}  
    status_check $?

    print_head "creating ${component} service"
    cp ${code_dir}/config/${component}.service /etc/systemd/system/${component}.service &>>${log_file}  
    status_check $?

    print_head " reloading services, enabling and starting user service"
    systemctl daemon-reload &>>${log_file}  
    status_check $?
    systemctl enable ${component} &>>${log_file}  
    status_check $?
    systemctl start ${component} &>>${log_file}  
    status_check $?

    system_schema
    
}