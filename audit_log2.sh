> /scripts/auditlog/fail
> /scripts/auditlog/buf.txt
> /scripts/auditlog/ip.txt
> /scripts/auditlog/pass
> /scripts/auditlog/daily
> /scripts/auditlog/mainout.txt
> /scripts/auditlog/daily_ftp
> /scripts/auditlog/upload
> /scripts/auditlog/download
> /scripts/auditlog/ftp_movements.txt
> /scripts/auditlog/daily
> /scripts/auditlog/f
#create directory
mkdir -p /scripts/auditlog
#varialbes
DATE=`date +'%b %d'`
DAT=`date +'%-d'`
#echo $DAT
#TDATA=`date '+%b'`; echo "$TDATA   "`date '+%-d'`
#DAT=$(echo "$TDATA  " `date '+%-d'`)
#TDATA=`date '+%b'`; DDATA=`date '+%-d'`; echo "${TDATA}  ${DDATA}"
#echo $DATE
count=0
#working
##DAY=`date '+%-d'`       ##uncoment for 1-9
DAY=`date '+%d'`
MON=`date '+%b'`
echo $DAY $MON
success=success
fail=failed
#dailylog  auth log
##grep -E "^$MON.*  $DAY" /var/log/auth.log >> daily   ###uncomennt for 1-9
######  grep -E "^$MON.* $DAY" /var/log/auth.log >> daily
# daily log ftp
##grep -E "$MON.  *$DAY" /var/log/vsftpd.log >>daily_ftp      ###uncomment for 1-9
######  grep -E "$MON. *$DAY" /var/log/vsftpd.log >>daily_ftp

#0-9
a()
grep -E "$MON.* $DAT" /var/log/auth.log >> /scripts/auditlog/daily
grep -E "$MON.  *$DAT" /var/log/vsftpd.log >> /scripts/auditlog/daily_ftp
echo a
#10+
b()
#DAT=`date +'%-d'`;MON=`date '+%b'`;echo $DAT;grep -E "$MON.* $DAT" /var/log/auth.log | head -10
grep -E "^$MON. *$DAY" /var/log/auth.log >> /scripts/auditlog/daily
grep -E "$MON. *$DAY" /var/log/vsftpd.log >> /scripts/auditlog/daily_ftp

d=`date +'%d'`

if [ $d -gt 9 ]
then
b
echo greater
else
a
echo smaller

fi
#ssh fail
> /scripts/auditlog/fail
echo "SSH" >> /scripts/auditlog/mainout.txt
grep -E 'sshd.*Failed' /scripts/auditlog/daily >> /scripts/auditlog/fail
grep -E 'sshd.*Accepted'  /scripts/auditlog/daily >> /scripts/auditlog/pass # to get total pass
ssh_f=$(cat /scripts/auditlog/fail | wc -l) # total fail
ssh_p=$(cat /scripts/auditlog/pass | wc -l)
echo total_ssh_Passed = $ssh_p >> /scripts/auditlog/mainout.txt
echo total_ssh_failed = $ssh_f >> /scripts/auditlog/mainout.txt
> /scripts/auditlog/fail
grep -E 'sshd.*Failed.*invalid'  /scripts/auditlog/daily >> /scripts/auditlog/fail
awk '{print $11}' /scripts/auditlog/fail | sort -k1 |uniq >> /scripts/auditlog/buf.txt
awk '{print $13}' /scripts/auditlog/fail | sort -k1 |uniq >> /scripts/auditlog/ip.txt
echo "Date      |       user    |       ip      |       status          |       attemps  " >> /scripts/auditlog/mainout.txt
echo "-----------------------------------------------------------------------------------" >> /scripts/auditlog/mainout.txt
while read b; do
while read c; do
#echo $b #namw
#echo $c  #ip
echo " "
out=$(grep -E "$b.*$c" /scripts/auditlog/fail| wc -l)
#echo $out #count
if [ $out -eq 0  ]
then
echo .
else
echo ""${DATE}"    |    "${b}"    |    "${c}"   |       "${fail}"       |       "${out}"  " >> /scripts/auditlog/mainout.txt
fi
done < /scripts/auditlog/ip.txt
done < /scripts/auditlog/buf.txt

#ssh fail vaild user
> /scripts/auditlog/fail
> /scripts/auditlog/buf.txt
> /scripts/auditlog/ip.txt
grep -E 'sshd.*Failed' /scripts/auditlog/daily >>/scripts/auditlog/fail
cat /scripts/auditlog/fail | grep -v 'invalid' >/scripts/auditlog/f
awk '{print $9}' /scripts/auditlog/f | sort -k1 |uniq >> /scripts/auditlog/buf.txt
awk '{print $11}' /scripts/auditlog/f | sort -k1 |uniq >> /scripts/auditlog/ip.txt
while read b; do
while read c; do
#echo $b #namw
#echo $c  #ip
echo " "
out=$(grep -E "$b.*$c" /scripts/auditlog/fail| wc -l)
#echo $out #count
if [ $out -eq 0  ]
then
echo .
else
echo ""${DATE}"    |    "${b}"    |    "${c}"   |       "${fail}"       |       "${out}"  " >> /scripts/auditlog/mainout.txt
count=`expr $count + $out`
fi
done </scripts/auditlog/ip.txt
done </scripts/auditlog/buf.txt
#echo $count

#ssh pass
> /scripts/auditlog/pass
> /scripts/auditlog/ip.txt
> /scripts/auditlog/buf.txt
grep -E 'sshd.*Accepted'  /scripts/auditlog/daily >> /scripts/auditlog/pass
awk '{print $9}' /scripts/auditlog/pass | sort -k1 |uniq >> /scripts/auditlog/buf.txt
awk '{print $11}' /scripts/auditlog/pass | sort -k1 |uniq >> /scripts/auditlog/ip.txt
#echo "Date              |       user    |       ip      |       status  |       attemps "
while read b; do
while read c; do
#echo $b #namw
#echo $c  #ip
echo " "
out=$(grep -E "$b.*$c" /scripts/auditlog/pass | wc -l)
#echo $out #counti
echo ""${DATE}"    |    "${b}"    |    "${c}"   |       "${success}"    |       "${out}"  " >> /scripts/auditlog/mainout.txt
done </scripts/auditlog/ip.txt
done </scripts/auditlog/buf.txt
echo " "  >> /scripts/auditlog/mainout.txt

#ftp
> /scripts/auditlog/pass
> /scripts/auditlog/fail
echo " "
echo  "FTP" >> /scripts/auditlog/mainout.txt
grep "OK LOGIN" /scripts/auditlog/daily_ftp >>/scripts/auditlog/pass
grep "FAIL LOGIN" /scripts/auditlog/daily_ftp >>/scripts/auditlog/fail
ftp_p=$(cat /scripts/auditlog/pass | wc -l)
echo total login success = $ftp_p >> /scripts/auditlog/mainout.txt
ftp_f=$(cat /scripts/auditlog/fail | wc -l)
echo total login fail = $ftp_f >> /scripts/auditlog/mainout.txt
echo " "
echo "Date      |       user    |       ip      |       status          |       attemps  " >> /scripts/auditlog/mainout.txt
echo "-----------------------------------------------------------------------------------" >> /scripts/auditlog/mainout.txt

#ftp pass
> /scripts/auditlog/pass
> /scripts/auditlog/buf.txt
> /scripts/auditlog/ip.txt
grep "OK LOGIN" /scripts/auditlog/daily_ftp  >> /scripts/auditlog/pass
awk '{print $8}' /scripts/auditlog/pass | sort -k1 |uniq >> /scripts/auditlog/buf.txt
awk '{print $12}' /scripts/auditlog/pass | sort -k1 |uniq >> /scripts/auditlog/ip.txt
#echo "Date              |       user    |       ip      |       status  |       attemps "
while read b; do
while read c; do
#echo $b #namw
#echo $c  #ip
echo " "
e=${b#"["} #remove 1st letter
d=${e%?}  #remove last letter
out=$(grep -E "$d.*$c" /scripts/auditlog/pass | wc -l)
#echo $out #counti
echo ""${DATE}"    |    "${b}"    |    "${c}"   |       "${success}"    |       "${out}"  " >> /scripts/auditlog/mainout.txt
done < /scripts/auditlog/ip.txt
done < /scripts/auditlog/buf.txt

#ftp fail
> /scripts/auditlog/fail
> /scripts/auditlog/buf.txt
> /scripts/auditlog/ip.txt
grep "FAIL LOGIN" /scripts/auditlog/daily_ftp >> /scripts/auditlog/fail
awk '{print $8}' /scripts/auditlog/fail | sort -k1 |uniq >> /scripts/auditlog/buf.txt
awk '{print $12}' /scripts/auditlog/fail | sort -k1 |uniq >> /scripts/auditlog/ip.txt
#echo "Date              |       user    |       ip      |       status  |       attemps "
while read b; do
while read c; do
#echo $b #namw
#echo $c  #ip
echo " "
e=${b#"["} #remove 1st letter
d=${e%?}  #remove last letter
out=$(grep -E "$d.*$c" /scripts/auditlog/fail | wc -l)
#echo $out #counti
if [ $out -eq 0  ]
then
echo .
else
echo ""${DATE}"    |    "${b}"    |    "${c}"   |       "${fail}"       |       "${out}"  " >> /scripts/auditlog/mainout.txt
count=`expr $count + $out`
fi
done < /scripts/auditlog/ip.txt
done < /scripts/auditlog/buf.txt
echo " " >>  /scripts/auditlog/mainout.txt

#sudo
> /scripts/auditlog/pass
> /scripts/auditlog/fail
echo " "
echo "SUDO" >> /scripts/auditlog/mainout.txt
grep -E 'sudo.*failure' /scripts/auditlog/daily  >> /scripts/auditlog/fail
grep -E 'sudo:session.*by' /scripts/auditlog/daily >> /scripts/auditlog/pass
sudo_f=$(cat /scripts/auditlog/fail | wc -l)
echo total sudo failed = $sudo_f >> /scripts/auditlog/mainout.txt
sudo_p=$(cat /scripts/auditlog/pass | wc -l)
echo total sudo passed  = $sudo_p >> /scripts/auditlog/mainout.txt
echo "Date      |       user    |       status          |       attemps  " >> /scripts/auditlog/mainout.txt
echo "--------------------------------------------------------------------" >> /scripts/auditlog/mainout.txt

#sudo fail
> /scripts/auditlog/fail
> /scripts/auditlog/buf.txt
> /scripts/auditlog/ip.txt
grep -E 'sudo.*failure' /scripts/auditlog/daily  >> /scripts/auditlog/fail
awk '{print substr($13,7,10 )}' /scripts/auditlog/fail| sort -k1 |uniq >> /scripts/auditlog/buf.txt
#echo "Date              |       user    |       ip      |       status  |       attemps "
while read b; do
#echo $b #namw
echo " "
out=$(grep -E "$b" /scripts/auditlog/fail | wc -l)
#echo $out #counti
echo ""${DATE}"    |    "${b}"      |       "${fail}"    |       "${out}"  " >> /scripts/auditlog/mainout.txt
done < /scripts/auditlog/buf.txt

#sudo success
> /scripts/auditlog/pass
> /scripts/auditlog/buf.txt
grep -E 'sudo:session.*by' /scripts/auditlog/daily >> /scripts/auditlog/pass
awk '{print substr($13,1,10 )}' /scripts/auditlog/pass| sort -k1 |uniq >> /scripts/auditlog/buf.txt
#echo "Date              |       user    |       ip      |       status  |       attemps "
while read b; do
#echo $b #namw
echo " "
out=$(grep -E "$b" /scripts/auditlog/pass | wc -l)
#echo $out #counti
echo ""${DATE}"    |    "${b}"      |       "${success}"    |       "${out}"  " >> /scripts/auditlog/mainout.txt
done < /scripts/auditlog/buf.txt

#FTP download
grep -E 'DOWNLOAD' /scripts/auditlog/daily_ftp >> /scripts/auditlog/download
echo Downloaded_files  >> /scripts/auditlog/ftp_movements.txt
echo "-----------------------------------------------------------" >> /scripts/auditlog/ftp_movements.txt
awk  '{print $13}' /scripts/auditlog/download |sort -k1 |uniq >> /scripts/auditlog/ftp_movements.txt

#FTP upload
grep -E 'UPLOAD' /scripts/auditlog/daily_ftp >> /scripts/auditlog/upload
echo " " >> /scripts/auditlog/ftp_movements.txt
echo Uploaded_files  >> /scripts/auditlog/ftp_movements.txt
echo "-----------------------------------------------------------" >> /scripts/auditlog/ftp_movements.txt
awk  '{print $13}' /scripts/auditlog/upload |sort -k1 |uniq >> /scripts/auditlog/ftp_movements.txt

# file movement count
out=$(cat /scripts/auditlog/ftp_movements.txt | wc -l)
COUNT=`expr $out - 5`
echo " " >> /scripts/auditlog/mainout.txt
echo "total file movement(both upload and download)="$COUNT >> /scripts/auditlog/mainout.txt
#mail
cat /scripts/auditlog/mainout.txt | mail -A /scripts/auditlog/ftp_movements.txt -s "$(hostname)_log_audit" support@productlabs.solutions


#backup daily
echo "###################################################################" >> /scripts/auditlog/audit_log_backup.txt
cat /scripts/auditlog/mainout.txt >> /scripts/auditlog/audit_log_backup.txt
echo "###################################################################" >> /scripts/auditlog/ftp_filemv_backup.txt
cat /scripts/auditlog/ftp_movements.txt  >> /scripts/auditlog/ftp_filemv_backup.txt

