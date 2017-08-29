#!/bin/bash

name=$1
echo $name > a
un=$(awk -F"@" '{print $1}' a)
a=$(cat files.txt)
echo $a
echo Mention the path
read Path
cd /home/ABC/$Path
cp $a /home/ABC/backup
echo "Files copied in /home/espsupport/backup"
cd /home/ABC/backup
count=$(ls |wc -l)
echo "total number of files moved = $count"
echo "current working directory = $(pwd)"
tar -cf files.tar *
#echo "hi $un, I have attached requested files"
echo "hi $un, I have attached requested files" | mail  -s "test" -A files.tar $1
echo mail sent
#sleep 5
rm -f *

