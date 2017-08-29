> dftemp
> df_temp	
> tty

touch cpy_tty
##########################################################################################################
# refer /etc/bash.bashrc to get sync,date and  duplicates
#to get username in history
#u_name=$(whoami)
#date and time
#HISTTIMEFORMAT="$u_name -- %d/%m/%y %T "

# Avoid duplicates..
#export HISTCONTROL=ignoredups:erasedups

# Append history entries..
#shopt -s histappend

# After each command, save and reload history
#export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

##########################################################################################################
w > temp
# remove 1st 2 lines  and 3 colm is ip
sed -e '1d;2d' temp > tty
# reading local session (:0) and remove the local session form tty file
> temp
grep -wv ":0" tty >  tem
#to remove spaces (# sapce issue with cat command on variable assigning and getting unique identities)
#a=$(cat temp )
#echo $a | awk '{print $1" "$2" "$3" "$4}' > temp
# reading multiple line cat wont work
while read a
do
echo $a | awk '{print $1" "$2" "$3" "$4}' >>temp
done < tem

                                                         echo temp = 
                                                         cat temp
#comparing file size and doing action  
if [ -s $cpy_tty ]
then
#cat cpy_tty
#comparing the file content difference
DF=$(diff temp cpy_tty)
i=0 
   if [ "$DF" != ""  ]
   then
# moving differnet lines to df_temp
   diff temp cpy_tty > df_temp
                                                          #echo df_temp =
						                                  # cat df_temp
# remove 1st line
   sed 1d df_temp > dftemp
                                                          #echo dftemp =
                                                          # cat df_temp
# remove 1st char in line
   b=$(cat dftemp)
   b=${b#"< "} 
   #cat temp   
#make entry in history
  #z=$(whoami) ; echo user "$a" "$(date)" >> /$z/.bash_history
#copy new entry to cpy_tty
   echo $b | awk '{print $1" "$2" "$3" "$4}' >> cpy_tty # space" > " matters 
   echo cpy
   cat cpy_tty 
# to make entery in history file
   a=$(awk 'END {print $1}' cpy_tty) ; echo user "$a" "$(date)" >> /home/$a/.bash_history #user personal history # end in awk to get last line
   echo user "$a" "$(date)" >> /root/.bash_history   #root history
   else
   echo "."
   fi
else
#cp temp cmp_tty 
cp temp cpy_tty
echo "ssaa"
fi 



