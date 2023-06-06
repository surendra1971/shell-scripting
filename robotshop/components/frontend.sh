#!/bin/bash

LOGFILE="/tmp/frontend.log"

ID=$(id -u)
if [ $ID -ne 0 ] ; then 
    echo -e "this script is run bt the root user"
    exit 1  
fi
stat() {
    if [ $1 -eq 0 ] ; then
            echo "success"
    else 
        echo "fail"
        exit 2
    fi
}

echo -n "Installing nginx:"
yum install nginx -y  &>> LOGFILE
stat $?

echo -n "downloading the frontend component:"
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"
stat $?

echo -n "performing cleanup: "
cd /usr/share/nginx/html
rm -rf *    &>>  LOGFILE
stat $?

echo -n "Extracting frontend component: "

unzip /tmp/frontend.zip    &>>  LOGFILE
mv frontend-main/* .
mv static/* .               &>>  LOGFILE
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf
stat $?
ech0 -n "starting frontend services: "
systemctl enable nginx
systemctl start nginx
stat $?

# cd /usr/share/nginx/html
# rm -rf *
# unzip /tmp/frontend.zip
# mv frontend-main/* .
# mv static/* .
# rm -rf frontend-main README.md
# mv localhost.conf /etc/nginx/default.d/roboshop.conf
# The frontend is the service in RobotShop to serve the web content over Nginx.

# Install Nginx.

# ```
# # yum install nginx -y
# # systemctl enable nginx
# # systemctl start nginx

# ```

# Let's download the HTDOCS content and deploy it under the Nginx path.

# ```
# # curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"

# ```

# Deploy in Nginx Default Location.