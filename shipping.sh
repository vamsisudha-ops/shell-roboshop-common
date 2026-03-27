#!/bin/bash 
set -e    ## To exit from the script if any error occurs, if we skip to write Validate statement in the script
source ./common.sh 
app_name=shipping

check_root 
app_setup 
java_setup 
systemd_setup

dnf install mysql -y 

mysql -h $MYSQL_HOST -uroot -pRoboShop@1 -e 'use cities' &>>$LOG_FILE
VALIDATE $? "Checking root user accessing cities schema in MYSQLHOST Server"
if [ $? -ne 0 ]; then
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/schema.sql &>>$LOG_FILE
    VALIDATE $? "Creating app schema in Db"
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/app-user.sql &>>$LOG_FILE
    VALIDATE $? "Creating app user in Db"
    mysql -h $MYSQL_HOST -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$LOG_FILE
    VALIDATE $? "Creating masterdata in Db"
else
    echo -e "Shipping data is already loaded ... $Y SKIPPING $N"
fi 

app_restart 
print_total_time