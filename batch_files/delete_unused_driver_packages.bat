@echo Removing all unused driver packages from this computer
cd %windir%\inf
for %%d in (oem*.inf) do pnputil -d %%d
cd %~dp0%