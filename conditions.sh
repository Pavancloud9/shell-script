#!/bin/bash

NUMBER=600

if [ $NUMBER -gt 800 ]

then
    echo "given number is  greather than $NUMBER"
else
    echo "given number is less than or equal to $NUMBER"

date=$(date)

echo "time stamp is $date"

fi