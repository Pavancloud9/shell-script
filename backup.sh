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

echo "script started executing at:$TIMESTAMP"

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

FILES=$(find $SOURCE_DIR -name "*.log" -mtime +$DAYS)   # find cmnd will find the files

if [ -n "$FILES" ]  # This is true files are there
then
   echo "Files are $FILES"
   ZIP_FILE="$DEST_DIR/app-logs-$TIMESTAMP.zip"  # with this name we are going to save
   find $SOURCE_DIR -name "*.log" -mtime +$DAYS | zip -@ "$ZIP_FILE" 


   if [ -f "$ZIP_FILE" ]
then
    echo "Zip file has been created successfully"
while read -r filepath # here filepath is the variable name, you can give any name
        do
            echo "Deleting file: $filepath" &>>$LOG_FILE_NAME
            rm -rf $filepath
            echo "Deleted file: $filepath"
        done <<< $FILES
else
   echo "ERROR:: Failed to create Zip file"
   exit
fi
else
   echo "ERROR:: No files to found"
fi