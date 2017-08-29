#current script pid
cur_pid=$(echo $$)
t_time=010000
cur_time=$(date +%s)
ter_time=`expr $cur_time + 100` #18000000
echo "terminate time"
echo $ter_time
check_loop()
{
#current_time
cur_time=$(date +%s)
echo "current time"
echo $cur_time
#to get process name , time , process id
# while for reading multiple scripts
#spt file object 
while read spt ; do 
#echo $spt
a=$(ps -eo etime,args,pid  | sort -k1 -r  | grep "$spt" | awk '{print $1}');
#removing 2data outputs
b=$(echo $a |awk -F ' ' '{print $1}')
#time removing ":"
c_time=$(echo $b | sed -e 's/://g')
#echo $c_time
#if condition
if [ $c_time -gt $t_time ]
then 
#get pid of the script
get_id=$(ps -eo etime,args,pid  | sort -k1 -r  | grep "$spt" | awk '{ print $(NF)}')
get_pid=$(echo $get_id | awk -F ' ' '{print $1}' )
echo $get_pid
kill -9 $get_pid
echo "killed $spt"
else 
echo 
if [ $cur_time -gt $ter_time ]
then 
echo "terminate"
#kill the current script
kill -9 $cur_pid
fi
fi
done<scripts
sleep 5
check_loop

}
check_loop
