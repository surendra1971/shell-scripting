#!/bin/bash



ID=$(id -u)
if [ $ID -ne 0 ] ; then 
    echo -e "this script is run bt the root user"
    exit 1  
fi

echo -n "Installing nginx:"
yum install nginx -y  &>>  "/tmp/frontend.log"
if [ $? -eq 0 ] ; then
        echo "success"
else 
    echo "fail"
fi

echo -n "downloading the frontend component:"
curl -s -L -o /tmp/frontend.zip "https://github.com/stans-robot-project/frontend/archive/main.zip"
if [ $? -eq 0 ] ; then
        echo "success"
else 
    echo "fail"
fi

echo -n "performing cleanup: "
cd /usr/share/nginx/html
rm -rf *    &>>  "/tmp/frontend.log"

if [ $? -eq 0 ] ; then
        echo "success"
else 
    echo "fail"
fi

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