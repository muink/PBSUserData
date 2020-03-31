:: PBSUserData
:: Portable System UsersAppData For Windows
:: Author: muink

@echo off
if "%~1" == "" exit

pushd %~1 2>nul
:--init--
set "CURRENTPC=%UserDomain%"
set "CURRENTUSER=%UserName%"

set "PRESET=Contacts:Documents:Downloads:Favorites:Links:Music:Pictures:Saved Games:Searches:Videos"


:--pcname--
md "%CURRENTPC%" 2>nul || goto :--username--
pushd "%CURRENTPC%"
	call:[WTini] "%CD%" "" 15
popd

:--username--
md "%CURRENTPC%\%CURRENTUSER%" 2>nul || goto :--desktop--
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

:--desktop--
md "%CURRENTPC%\%CURRENTUSER%\Desktop" 2>nul || goto :--appdata--
pushd "%CURRENTPC%\%CURRENTUSER%\Desktop"
call:[WTini] "%CD%" imageres.dll 174
popd

:--appdata--
md "%CURRENTPC%\%CURRENTUSER%\AppData" 2>nul || goto :--microsoft--
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

:--microsoft--
md "%CURRENTPC%\%CURRENTUSER%\AppData\Roaming\Microsoft" 2>nul || goto :--windows--
pushd "%CURRENTPC%\%CURRENTUSER%\AppData\Roaming\Microsoft"
call:[WTini] "%CD%" "" 69
popd

:--windows--
md "%CURRENTPC%\%CURRENTUSER%\AppData\Roaming\Microsoft\Windows" 2>nul || goto :--template--
pushd "%CURRENTPC%\%CURRENTUSER%\AppData\Roaming\Microsoft\Windows"
call:[WTini] "%CD%" "" 69
setlocal enabledelayedexpansion
set "KEY=Network Shortcuts=imageres.dll:28;Printer Shortcuts=imageres.dll:48;SendTo=imageres.dll:176;Themes=themeui.dll:0"
:--windows--#loop
for /f "tokens=1* delims=;" %%i in ("!KEY!") do (
	for /f "tokens=1,2 delims==" %%k in ("%%i") do call:[MKKEY] "%CD%" "%%~k" "%%~l"
	set "KEY=%%j"
	goto :--windows--#loop
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

:[MKKEY]
setlocal enabledelayedexpansion
set "pa=%~1\%~2"
set "key=%~2"
set "value=%~3"
set "value2=%value::=" "%"
if "%value%" == "%value2%" set value2=" "%value%
md "%pa%" 2>nul
call:[WTini] "%pa%" "%value2%"
endlocal
goto :eof
