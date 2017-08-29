> b.txt
> count.txt
rm -f a.txt
mv $1 a.txt
awk '{print $17" "$18" "$19" "$20}' a.txt |grep "\/DATA/"|sort -k1|uniq >> b.txt

while read p; do
#echo $p
count=$(grep "$p" a.txt | wc -l)
get=$(grep -m 1 "$p" a.txt)
#echo $get
echo "${count}"_Total count of repeated errors_____"${get}"  >> count.txt
done <b.txt

#dev__name__add
> out
> mainout
END=$(cat name | wc -l)
for i in $(seq 1 $END)
do
echo $i
z=$(awk NR==$i'{print $1}' name)
#echo $z
z1=$(awk NR==$i'{print $2}' name)
#ge=$(grep "$z" count.txt)
#echo ${ge}_________________${z1} >>out
#echo " "  >>out
grep "$z" count.txt  >>out
while read q ; do
echo ${q}_____${z1} >> mainout
done
done<out

#
sort -nr mainout | head -n 5
