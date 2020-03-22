:: PBSUserData
:: Portable System UsersAppData For Windows
:: Author: muink

@echo off
if "%~1" == "" exit

pushd %~1 2>nul
:--init--
set "CURRENTPC=%UserDomain%"
set "CURRENTUSER=%UserName%"

set "PRESET=Contacts:Desktop:Documents:Downloads:Favorites:Links:Music:Pictures:Saved Games:Searches:Videos"


:--pcname--
md "%CURRENTPC%" 2>nul || goto :--username--
pushd "%CURRENTPC%"
	call:[WTini] "%CD%" "" 15
popd

:--username--
md "%CURRENTPC%\%CURRENTUSER%" 2>nul || goto :--appdata--
pushd "%CURRENTPC%\%CURRENTUSER%"
call:[WTini] "%CD%" imageres.dll 207
setlocal enabledelayedexpansion
:--username--#loop
for /f "tokens=1* delims=:" %%i in ("!PRESET!") do (
	md "%%~i" 2>nul
	set "PRESET=%%j"
	goto :--username--#loop
)
endlocal
popd

:--appdata--
md "%CURRENTPC%\%CURRENTUSER%\AppData" 2>nul || goto :--template--
pushd "%CURRENTPC%\%CURRENTUSER%\AppData"
call:[WTini] "%CD%" "" 69
setlocal enabledelayedexpansion
set "PRESET=Local:LocalLow:Roaming"
:--appdata--#loop
for /f "tokens=1* delims=:" %%i in ("!PRESET!") do (
	md "%%~i" 2>nul
	call:[WTini] "%CD%\%%~i" "" 69
	set "PRESET=%%j"
	goto :--appdata--#loop
)
endlocal
popd

:--template--

if exist "%~dp0One-off_Run.cmd" (
	call "%~dp0One-off_Run.cmd" "%~1" 2>nul
	del /f /q "%~dp0One-off_Run.cmd" >nul 2>nul
)

popd & goto :eof


:[WTini]
setlocal enabledelayedexpansion
set "icolib=%~2"
if "%icolib%" == "" set "icolib=SHELL32.dll"
set "pa=%~1"
(echo.[.ShellClassInfo]
echo.IconResource=%SystemRoot%\system32\%icolib%,%~3)>"%pa%\desktop.ini"
attrib +r "%pa%"
attrib +s +h "%pa%\desktop.ini"
endlocal
goto :eof
