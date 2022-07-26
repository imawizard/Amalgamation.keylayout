@echo off
set unattended=no
if "%1"=="/u" set unattended=yes

set scriptdir=%~dp0
call %scriptdir%install.bat /env

echo =================================================
echo =   Deleting %name%.ahk! Please wait...   =
echo =================================================
echo.

openfiles >nul 2>&1
if not errorlevel 1 (
    taskkill /f /im "%ahk%" >nul 2>&1
	if not errorlevel 1 (
		echo  ^> Terminated '%ahk%'.
	)
) else (
	echo  ^> Skipping terminating the process, requires admin privileges.
)

if not exist "%destfile%" (
	echo  ^> Nothing to remove.
	goto die
)

del "%destfile%" >nul 2>nul
if exist "%destfile%" (
	echo  ^> Failed to remove '%destfile%'!
	goto die
)

echo  ^> Removed '%destfile%'.
echo.
echo ===========================================
echo =        Yeehaw! No Errors! Done!         =
echo ===========================================

if [%unattended%] == [yes] exit /b 0
<nul set /p =Press any key...
pause >nul
exit /b 0

:err
echo.
echo ######################################
echo ######### AN ERROR OCCURED! ##########
echo ######################################

:die
if [%unattended%] == [yes] exit /b 1
<nul set /p =Press any key...
pause >nul
exit /b 1
