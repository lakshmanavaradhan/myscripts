#limit
limit=1
#current_date
cur_date=$(date '+%b %d')
echo "Top 10 records."
echo "At this time : "; date
#process with load %
ps -eo pcpu,pid,user,args | sort -k 1 -r | head  > top_load   #if required sort -k 1 -n | tail
echo "\n";
# using for iterating load
for i in  2 3
do
#getting load for comapaning
ld=$(awk '{if (NR%'${i}'==0)  print $1 }' /home/opsol/lakshman/load/top_load)
# converting float to int
load=${ld%.*}
#compaing load with limit
if [ $load -gt $limit ]
then
#checking the relavent tiles with pid

        p_id=$(awk '{if (NR%'${i}'==0)  print $2 }' /home/opsol/lakshman/load/top_load)
        grep -wE "$p_id" /var/log/*.log  -r | grep "$cur_date"
        # grep -wE "1714" /var/log/ -r | grep "Jan 27"
		echo " "
else
        echo " "
fi
done
