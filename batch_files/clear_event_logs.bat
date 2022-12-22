@ECHO OFF
echo Run this as administrator
for /f %%x in ('wevtutil el') do wevtutil cl "%%x"
pause