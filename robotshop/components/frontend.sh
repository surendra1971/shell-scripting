#!/bin/bash

COMPONENT=frontend
ID=$(id -u)
if [ $ID -ne 0] ; then 
    echo -e "this script is run bt the root user"
    exit 1  
fi

echo "Installing nginx:"
yum install nginx -y  &>>  "/tmp/$(COMPONENT).log"





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