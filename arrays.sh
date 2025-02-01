#/bin/bash

NAMES=("sai" "pavan" "arjun")

echo "First name: ${NAMES=[0]}"
echo "second name: ${NAMES[1]}"
echo "Third name: ${NAMES[3]}"

echo "All names are: ${NAMES[@]}"