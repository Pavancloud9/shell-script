#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]
then
    echo "ERROR: you must have sudo access to execute this script"
    exit
dnf install mysql

if [ $? -ne 0 ]
then
   echo "Installing mysql...failure"
   exit
else
   echo "Installing mysql...SUCCESS"
fi

dnf install git 

if [ $? -ne 0 ]
then
    echo "Installing Git...FAILURE"
    exit
else
    echo "Installing Git...SUCCESS"

fi