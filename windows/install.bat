@echo off
set unattended=no
if "%1"=="/u" set unattended=yes

set name=amalgamation
set ahk=autohotkey2.exe

set scriptdir=%~dp0
set scriptfile=%scriptdir%%name%.ahk
set autostart=%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup
set destfile=%autostart%\%name%.vbs

if "%1"=="/env" exit /b 0

echo =================================================
echo =  Installing %name%.ahk! Please wait...  =
echo =================================================
echo.

where %ahk% >nul 2>nul
if errorlevel 1 (
	echo ^> AutoHotkey ^(%ahk%^) not found in your %%PATH%%!
	goto err
) else if not exist "%scriptfile%" (
	echo  ^> %name%.ahk not found!
	goto err
) else if exist "%destfile%" (
	echo  ^> Already installed!
	goto die
)

echo Set fso = CreateObject("Scripting.FileSystemObject")                                    > "%destfile%"
echo path = "%scriptfile%"                                                                  >> "%destfile%"
echo filename = Chr(34) ^& fso.GetFileName(path) ^& Chr(34)                                 >> "%destfile%"
echo dirname = fso.GetParentFolderName(path)                                                >> "%destfile%"
echo CreateObject("Shell.Application").ShellExecute "%ahk%", filename, dirname, "runas", 0  >> "%destfile%"
echo.                                                                                       >> "%destfile%"

if not exist "%destfile%" (
	echo  ^> Couldn't create '%destfile%'!
	goto die
)

mklink %HOME%\Desktop\%name% "%destfile%" >nul 2>nul

for /F "delims=" %%f in ("%destfile%") do (
	start /D "%%~dpf" "" "%destfile%"
)

echo  ^> Copied and started '%destfile%'.
echo.
echo ===========================================
echo =        Yeehaw! No Errors! Ready!        =
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
