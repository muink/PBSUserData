:: PBSUserData
:: Portable System UsersAppData For Windows
:: Author: muink

@echo off
if "%~1" == "" exit

set "nodedir=%~1"
pushd %nodedir%
:--init--
set "USERDOMAIN=%UserDomain%"
set "USERNAME=%UserName%"
rem MachineGUID
for /f "delims=" %%i in ('reg query HKLM\SOFTWARE\Microsoft\Cryptography /v MachineGuid 2^>nul') do (
    for /f "delims=" %%o in ('echo %%i ^| find /i "MachineGuid"') do (
        for /f "tokens=3 delims= " %%p in ("%%o") do (
            set "CURRENTPC=%%p"
        )
    )
)
rem dmi info
rem wmic csproduct get UUID
for /f "delims=" %%i in ('whoami /user /fo list 2^>nul') do (
    for /f "delims=" %%o in ('echo %%i ^| find /i "SID:"') do (
        for /f "tokens=2 delims= " %%p in ("%%o") do (
            set "CURRENTUSER=%%p"
        )
    )
)

set "PRESET=Contacts:Desktop:Documents:Downloads:Favorites:Links:Music:Pictures:Saved Games:Searches:Videos"


:--icon--
if not exist desktop.ini call:[WTini] "%cd%" "" "69"

:--pcname--
md "%CURRENTPC%" 2>nul || (
	call:[WTini] "%CURRENTPC%" "" 15 "%USERDOMAIN%"
	goto :--template--
)
pushd "%CURRENTPC%"
	call:[WTini] "%CD%" "" 15 "%USERDOMAIN%"
popd

:--username--
md "%CURRENTPC%\%CURRENTUSER%" 2>nul || (
	call:[WTini] "%CURRENTPC%\%CURRENTUSER%" imageres.dll 208 "%USERNAME%"
	goto :--game--
)
pushd "%CURRENTPC%\%CURRENTUSER%"
call:[WTini] "%CD%" imageres.dll 208 "%USERNAME%"
setlocal enabledelayedexpansion
:--username--#loop
for /f "tokens=1* delims=:" %%i in ("!PRESET!") do (
	md "%%~i" 2>nul
	set "PRESET=%%j"
	goto :--username--#loop
)
endlocal
popd

:--game--
md "%CURRENTPC%\%CURRENTUSER%\Game" 2>nul || goto :--appdata--
pushd "%CURRENTPC%\%CURRENTUSER%\Game"
call:[WTini] "%CD%" "imageres.dll" -186
setlocal enabledelayedexpansion
set "PRESET=Local:LocalLow:Roaming"
:--game--#loop
for /f "tokens=1* delims=:" %%i in ("!PRESET!") do (
	md "%%~i" 2>nul
	call:[WTini] "%CD%\%%~i" "" 69
	set "PRESET=%%j"
	goto :--game--#loop
)
endlocal
popd

:--appdata--
md "%CURRENTPC%\%CURRENTUSER%\AppData" 2>nul || goto :--local--
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

:--local--
md "%CURRENTPC%\%CURRENTUSER%\AppData\Local\Microsoft" 2>nul || goto :--local2--
pushd "%CURRENTPC%\%CURRENTUSER%\AppData\Local\Microsoft"
call:[WTini] "%CD%" "" 69
popd
:--local2--
md "%CURRENTPC%\%CURRENTUSER%\AppData\Local\Microsoft\Windows" 2>nul || goto :--roaming--
pushd "%CURRENTPC%\%CURRENTUSER%\AppData\Local\Microsoft\Windows"
call:[WTini] "%CD%" "" 69
setlocal enabledelayedexpansion
set "KEY=Themes=themeui.dll:0;Fonts=:38"
:--local2--#loop
for /f "tokens=1* delims=;" %%i in ("!KEY!") do (
	for /f "tokens=1,2 delims==" %%k in ("%%i") do call:[MKKEY] "%CD%" "%%~k" "%%~l"
	set "KEY=%%j"
	goto :--local2--#loop
)
endlocal
popd

:--roaming--
md "%CURRENTPC%\%CURRENTUSER%\AppData\Roaming\Microsoft" 2>nul || goto :--roaming2--
pushd "%CURRENTPC%\%CURRENTUSER%\AppData\Roaming\Microsoft"
call:[WTini] "%CD%" "" 69
popd
:--roaming2--
md "%CURRENTPC%\%CURRENTUSER%\AppData\Roaming\Microsoft\Windows" 2>nul || goto :--template--
pushd "%CURRENTPC%\%CURRENTUSER%\AppData\Roaming\Microsoft\Windows"
call:[WTini] "%CD%" "" 69
setlocal enabledelayedexpansion
set "KEY=Network Shortcuts=imageres.dll:28;Printer Shortcuts=imageres.dll:48;SendTo=imageres.dll:176;Themes=themeui.dll:0"
:--roaming2--#loop
for /f "tokens=1* delims=;" %%i in ("!KEY!") do (
	for /f "tokens=1,2 delims==" %%k in ("%%i") do call:[MKKEY] "%CD%" "%%~k" "%%~l"
	set "KEY=%%j"
	goto :--roaming2--#loop
)
endlocal
popd

:--template--

if exist "%~dp0One-off_Run.cmd" (
	call "%~dp0One-off_Run.cmd" "%nodedir%" 2>nul
	del /f /q "%~dp0One-off_Run.cmd" >nul 2>nul
)

popd & goto :eof


:[WTini]
setlocal enabledelayedexpansion
set "icolib=%~2"
if "%icolib%" == "" set "icolib=SHELL32.dll"
set "pa=%~1"
del /f /q /a "%pa%\desktop.ini" 2>nul
(echo.[.ShellClassInfo]
echo.IconResource=%%SystemRoot%%\system32\%icolib%,%~3
if not "%~4" == "" echo.LocalizedResourceName=%~4)>"%pa%\desktop.ini"
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
