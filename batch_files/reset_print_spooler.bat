@ECHO OFF

echo MAKE SURE YOU'RE RUNNING THIS AS ADMINISTRATOR!
echo Right-click it and select Run as Administrator if you didn't already.
pause

net stop spooler
echo Attempting to delete any files stuck in the spooler.
del /q /f "%WINDIR%\System32\spool\PRINTERS\*"
net start spooler

echo The spooler should now be reset, assuming nothing ugly happened!
pause