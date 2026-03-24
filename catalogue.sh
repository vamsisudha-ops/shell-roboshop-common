#!/bin/bash 

source ./common.sh 
app_name=catalogue

app_setup 
nodejs_setup 
systemd_setup 

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo  ## add full path for smoother execution
VALIDATE $? "Copy mongo repo"

dnf install mongodb-mongosh -y &>>$LOG_FILE
VALIDATE $? "Install MongoDB Client"

INDEX=$(mongosh mongodb.daws86sd.fun --quiet --eval "db.getMongo().getDBNames().indexOf('catalogue')") #mongodb command not linux command
if [ $INDEX -le 0 ]; then
    mongosh --host $MONGODB_HOST </app/db/master-data.js &>>$LOG_FILE
    VALIDATE $? "Load $app_name products"
else 
    echo -e "$app_name products already loaded ... $Y SKIPPING $N"
fi 

app_restart 
print_total_time