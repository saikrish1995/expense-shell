#!/bin/bash
#trying to create log files for everytime we run the script.

LOGS_FOLDER="/var/log/expense"
SCRIPT_NAME=$(echo $0 | cut -d "." -f1)
TIME_STAMP=$(date +%Y-%m-%d-%H-%M-%S)

LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME-$TIME_STAMP.Log"
mkdir -p $LOGS_FOLDER

USERID=$(id -u)

R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"

CHECK_ROOT(){
    if [ $USERID -ne 0 ]
    then
        echo -e "$R Please run this with superuser rights $N" | tee -a $LOG_FILE
        exit 1
    fi
}

VALIDATE(){
    if [ $1 -ne 0 ]
    then
        echo -e "$2 is ..$R FAILED..$N" | tee -a $LOG_FILE
        exit 1
    else
        echo -e "$2 is ..$G SUCCESS..$N" | tee -a $LOG_FILE
    fi
}

echo "Script started executing at: $(date)" | tee -a $LOG_FILE

CHECK_ROOT

dnf install mysql-server -y &>> $LOG_FILE
VALIDATE $? "MySQL-Server installation" | tee -a $LOG_FILE

systemctl enable mysqld &>> $LOG_FILE
VALIDATE $? "enabling mysqld" | tee -a $LOG_FILE

systemctl start mysqld &>> $LOG_FILE
VALIDATE $? "starting mysqld" | tee -a $LOG_FILE

mysql_secure_installation --set-root-pass ExpenseApp@1 &>> $LOG_FILE
VALIDATE $? "setting root password" | tee -a $LOG_FILE
