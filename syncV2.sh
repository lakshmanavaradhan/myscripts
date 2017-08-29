# copy ssh id between servers
a()
{
sleep 2;
DF=$(diff -r syn/a syn/b)
if [ "$DF" != ""  ]
then
#sync changes local with changes
rsync -avzh --delete syn/a/ syn/b 
#rsync -avh  syn/a/ prod@1.9.0.23:/home/prod/a # rync the changes with server
#add server ips for mutiple server 
for i in 1.0.0.32 # use ip  
do
#rsync -avh syn/a/ prod@$i:/home/prod/a --delete
rsync -avh --delete syn/a/ prod@$i:/home/prod/a 
done
else
echo nochanges 
fi
a
}
a


