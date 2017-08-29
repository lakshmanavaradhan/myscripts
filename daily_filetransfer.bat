@echo off

: sf
rem #######################month#################################
set month-num=%date:~3,2%
if %month-num%==01 set mo-name=jan
if %month-num%==02 set mo-name=feb
if %month-num%==03 set mo-name=mar
if %month-num%==04 set mo-name=apr
if %month-num%==05 set mo-name=may
if %month-num%==06 set mo-name=jun
if %month-num%==07 set mo-name=jul
if %month-num%==08 set mo-name=aug
if %month-num%==09 set mo-name=sep
if %month-num%==10 set mo-name=oct
if %month-num%==11 set mo-name=nov
if %month-num%==12 set mo-name=dec
rem #######################date##################################
set day=%date:~0,2%
rem #######################mkdir#################################
mkdir C:\Users\OPSOL\Desktop\New\%mo-name%\%day%\serverfile
mkdir C:\Users\OPSOL\Desktop\New\%mo-name%\%day%\backup
echo ####################################################################
rem ##################################foldername#########################
echo enter foldername
echo.
set/p fdname= 
echo %fdname%
rem  #####################read filename ##########################
echo enter filename
echo.
SET/p filename= 
echo %filename%
rem ######################download file from server ################################
"C:\Program Files (x86)\PuTTY\pscp.exe" -pw 12345 prod@ip:/home/prod/%fdname%/%filename%  C:\Users\OPSOL\Desktop\New\%mo-name%\%day%\serverfile\
"C:\Program Files (x86)\PuTTY\pscp.exe" -pw 12345 prod@ip:/home/prod/%fdname%/%filename%  C:\Users\OPSOL\Desktop\New\%mo-name%\%day%\backup\
rem ########################open file from loacal and sever file#################################
"C:\Program Files (x86)\Notepad++\notepad++.exe" C:\Users\OPSOL\Desktop\New\%mo-name%\%day%\serverfile\%filename%  C:\Users\OPSOL\Desktop\New\%mo-name%\%day%\%filename%
echo comparison done 
echo.
echo "##########################################"
echo "1.  Type yes to move developer file"
echo "2.  Type yes1 to move edited serverfile"
echo.
rem read user option
echo type action
set /p opt= 
IF "%opt%" == "1" ( 
    	"C:\Program Files (x86)\PuTTY\pscp.exe" -pw 12345 C:\Users\OPSOL\Desktop\New\%mo-name%\%day%\%filename% prod@ip:/home/prod/%fdname%/
) 

IF "%opt%" == "2" ( 
    	"C:\Program Files (x86)\PuTTY\pscp.exe" -pw 12345 C:\Users\OPSOL\Desktop\New\%mo-name%\%day%\serverfile\%filename% prod@ip:/home/prod/%fdname%/

) 

goto sf

pause

