#!/bin/bash 

source ./common.sh 

check_root

cp $SCRIPT_DIR/rabbitmq.repo vim /etc/yum.repos.d/rabbitmq.repo &>>$LOG_FILE
VALIDATE $? "Adding RabbitMQ repo"
dnf install rabbitmq-server -y &>>$LOG_FILE
VALIDATE $? "Installing RabbitMQ Server"
systemctl enable rabbitmq-server &>>$LOG_FILE
VALIDATE $? "Enabling RabbitMQ Server"
systemctl start rabbitmq-server &>>$LOG_FILE
VALIDATE $? "Starting RabbitMQ"
rabbitmqctl add_user roboshop roboshop123 &>>$LOG_FILE
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"
VALIDATE $? "Setting up Permissions"

print_total_time 
