#!/bin/bash
echo "querylog"
fs=$(du -m /DATA/www/mysqlquery.log | awk '{print$1}')
echo $fs
#change threshold 
if [ $fs -ge 3 ]
then
grep -i "alter" /DATA/www/mysqlquery.log  >> /home/opsol/lakshman/querylog/out.txt
grep -i "delete.*e_o" /DATA/www/mysqlquery.log  >> /home/opsol/lakshman/querylog/out.txt
grep -i "truncate" /DATA/www/mysqlquery.log  >> /home/opsol/lakshman/querylog/out.txt
grep -i "update.*e_o" /DATA/www/mysqlquery.log  >> /home/opsol/lakshman/querylog/out.txt
> /DATA/www/mysqlquery.log
fi
hr=$(date +"%H:%M")
echo $hr
if [ $hr = '14:45' ]
#if [ $hr -ge 21 ]
then
echo "mail"
#top split file 49mb each
split -b 51200000 /home/opsol/lakshman/querylog/out.txt  new
a=$(ls | grep "n")
#a="newaa newab newac newad newae"
for i in $a
do
echo $i
tar -cJf $i.tar.xz $i
done
echo mail -A *.tar.xz support@prosuctlab.solutions
#rm /home/opsol/lakshman/querylog/*.tar.xz 
#rm /home/opsol/lakshman/querylog/new
#> /home/opsol/lakshman/querylog/out.txt 
fi 
