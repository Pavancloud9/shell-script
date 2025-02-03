#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ]
   then
   echo "ERROR: You must have sudo access to execute"
   exit

dnf list installed mysql

