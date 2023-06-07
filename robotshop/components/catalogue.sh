#!/bin/bash 

COMPONENT="catalogue"
LOGFILE="/tmp/${COMPONENT}.log"
APPUSER="roboshop"

ID=$(id -u)

if [ $ID -ne 0 ] ; then 
    echo -e "\e[31m This script is expected to be run by a root user or with a sudo privilege \e[0m"
    exit 1
fi 

stat() {
    if [ $1 -eq 0 ] ; then 
        echo -e "\e[32m success \e[0m"
    else 
        echo -e "\e[31m failure \e[0m"
        exit 2
    fi 
}

echo -e "*********** \e[35m $COMPONENT Installation has started \e[0m ***********"

echo -n  "Configuring the $COMPONENT repo :"
curl --silent --location https://rpm.nodesource.com/setup_16.x | sudo bash -  &>> $LOGFILE
stat $?

echo -n "Installing NodeJS :"
yum install nodejs -y   &>> $LOGFILE 
stat $? 

id $APPUSER &>> $LOGFILE
if [ $? -ne 0 ] ; then 
    echo -n "Creating the Service Account :"
    useradd $APPUSER  &>> $LOGFILE
    stat $?
fi 

echo -n "Downloading the $COMPONENT component :"
curl -s -L -o /tmp/catalogue.zip "https://github.com/stans-robot-project/catalogue/archive/main.zip"
stat $? 

echo -n "Copying the $COMPONENT to $APPUSER home directory :"
cd /home/${APPUSER}/
unzip -o /tmp/catalogue.zip  &>> $LOGFILE
stat $?

echo -n "Modifying the ownership :"
mv  -o $COMPONENT-main/ $COMPONENT
chown -R $APPUSER:$APPUSER /home/roboshop/$COMPONENT/
stat $?

echo -n "Installing NPM $COMPONENT artifacts"
cd /home/${APPUSER}/${COMPONENT}/
npm install   &>> $LOGFILE
stat $?

echo -n " updating the $COMPONENT systemd file: "
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' /home/${APPUSER}/${COMPONENT}/systemd.servce
mv /home/${APPUSER}/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service
stat $?

echo -n "Starting ${COMPONENT} service :"
systemctl daemon-reload   &>> $LOGFILE
systemctl enable $COMPONENT  &>> $LOGFILE
systemctl restart $COMPONENT &>> $LOGFILE
stat $? 

echo -e "*********** \e[35m $COMPONENT Installation has completed \e[0m ***********"

# $ curl -s -L -o /tmp/catalogue.zip "https://github.com/stans-robot-project/catalogue/archive/main.zip"
# $ cd /home/roboshop
# $ unzip /tmp/catalogue.zip
# $ mv catalogue-main catalogue
# $ cd /home/roboshop/catalogue
# $ npm install
# $ npm install
