code_dir=$(pwd)
echo -e "\e[35m installing nginx \e[0m"
yum install nginx -y 

echo -e "\e[35m removing nginx html files \e[0m"
rm -rf /usr/share/nginx/html/* 

echo -e "\e[35m extracting data from external source \e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip 

cd /usr/share/nginx/html 
unzip /tmp/frontend.zip

echo -e "\e[35m copying roboshop configuration from config placing in required location \e[0m"
pwd
cp ${code_dir}/config/roboshop.conf /etc/nginx/default.d/roboshop.conf 

echo -e "\e[35m enabling nginx \e[0m"
systemctl enable nginx 

echo -e "\e[35m starting nginx \e[0m"
systemctl start nginx 