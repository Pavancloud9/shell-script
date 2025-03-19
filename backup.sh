#!/bin/bash

SOURCE_DIR=$1
DEST_DIR=$2
DAYS=${3:-14}

LOGS_FOLDER="/home/ec2-user/shellscript-logs"
LOG_FILE=$(echo $0 )
TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
LOG_FILE_NAME="$LOGS_FOLDER/$LOG_FILE-$TIMESTAMP.log"

VALIDATE(){
   if [ $1 -ne 0 ]
then
    echo "$2...SUCCESS"
    exit
else
    echo "$2...FAILURE"
fi
}

mkdir -p /home/ec2-user/shellscript-logs

echo "script started executing at:$TIMESTAMP" &>>$LOG_FILE_NAME

USAGE(){
    echo "USAGE:: sh backup.sh <SOURCE_DIR> <DEST_DIR>"
    exit
}

if [ $# -lt 2 ]
then
    USAGE
fi

if [ ! -d $SOURCE_DIR ]
then
    echo "$SOURCE_DIR Does not exists...please check"
    exit
fi

if [ ! -d $DEST_DIR ]
then
  echo "$DEST_DIR does not exists...please check"
  exit
fi

FILES=$(find $SOURCE_DIR -name "*.log" -mtime +$DAYS)    

echo "Files are: $FILES"