#clear files
> auth.txt
#date 
DATE=`date +'%b %d'`
DAT=`date +'%-d'`
DAY=`date '+%d'`
#echo $DAY $MON
#0-9
a()
grep -E "$MON.* $DAT" /var/log/auth.log --text >> /home/prod/Desktop/user-activity/auth.txt
#echo a
#10+
b()
grep -E "^$MON.* $DAY" /var/log/auth.log --text >>/home/prod/Desktop/user-activity/auth.txt
d=`date +'%d'`
if [ $d -gt 9 ] 
then 
b
#echo greater
else
a
#echo smaller
fi

#get active user 
active_user=$(grep '/bin/bash' /etc/passwd | awk -F: '{print$1}')
#to get active users/usr/sbin/nologin
echo "Active_Users With Login Access"
echo ===============================
a_users=$(echo $active_user | sed 's/ / | /g' )
echo $a_users

#no_login users
echo ""
nologin_user=$(grep -e '/bin/false' -e '/usr/sbin/nologin' /etc/passwd | awk -F: '{print$1}')
echo No Login_users and Deamon Users
echo ================================
nl_users=$(echo $nologin_user | sed 's/ / | /g' )
echo $nl_users

#group id and group users
echo ""
echo Group Name,Group Id and Group Users
echo ===================================
awk -F : '{print$1"     "$3"      "$4 }' /etc/group | column -t

#newly created users
echo""
echo Newly Added User
echo ================
grep -e 'new user' auth.txt --text | uniq | awk '{print $8" "$3}' | sed 's/^.....//g' |  sed 's/,//g' |column -t

# passwd changed
echo""
echo User password Changed
echo ================
grep -e 'password changed for' auth.txt --text | uniq | awk '{print $10"      "$3}' | column -t


#user deleted
echo""
echo Deleted User
echo ================
grep -e 'delete user' auth.txt --text | awk '{print$8"      "$3}' | uniq | sed 's/^.//g' | sed "s/'//g" |column -t











