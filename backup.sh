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

if [ ! -d $SOURCE_DIR ]   #If SOURCE directory does not exists throw below error msg
then
    echo "$SOURCE_DIR Does not exists...please check"
    exit
fi

if [ ! -d $DEST_DIR ]  #If DESTINATION directory does not exists throw below error msg
then
  echo "$DEST_DIR does not exists...please check"
fi

# If both SOURCE and DESTINATION directories exits we need to find the files now

FILES=$(find $SOURCE_DIR -name "*.log" -mtime +$DAYS)   #It will find out the files

if [ -n "$FILES" ]  # This is TRUE , files are there
then
   echo "Files are: $FILES"
   ZIP_FILE="$DEST_DIR/app-logs-$TIMESTAMP.zip"  #with this name we are going to save

find $SOURCE_DIR -name "*.log" -mtime +$DAYS | zip -@ "$ZIP_FILE"   
#it will zip all the files and it will give with zip name
else
    echo "no files found"
fi