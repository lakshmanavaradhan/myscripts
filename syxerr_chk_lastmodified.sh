err=$(find /DATA/www/abc  -cmin -1 | grep '.php')
count=$(find /DATA/www/abc/  -cmin -1 | grep '.php'|wc -l)
if [ $count = 0 ]
then
echo no new file
exit
else
echo $err
word=$(echo $err |grep " " |  wc -w)
echo $word
for i  in $(seq 1 $word)
do
  syx=$(echo $err | awk -v var="$i" '{print $var}')
  echo $syx
  php -l $syx
done
fi
