:: PBSUserData
:: Portable System UsersAppData For Windows
:: Author: muink

@echo off
%~1 mshta vbscript:createobject("shell.application").shellexecute("%~f0","::","","runas",1)(window.close)&exit

:Init
cd /d %~dp0
call .\MakeInit.cmd "%~dp0"
set "CURRENTPROFILE=%UserProfile%"
set "CURRENTDEVICE=%~d0"
set "LASTDEVICE=%~d0"
set "LASTDEVFILE=%~dp0%CURRENTPC%\%CURRENTUSER%.dev"
for /f "delims=" %%i in ('type "%LASTDEVFILE%" 2^>nul') do set "LASTDEVICE=%%~i"

set "ERRORLOG=%~dp0%CURRENTPC%\%CURRENTUSER%.Error.log"
null>"%ERRORLOG%" 2>nul
set /a ERRORCOUNT=0

:Gen_Links
call:[MakeLink] "%~dp0%CURRENTPC%\%CURRENTUSER%" "%CURRENTPROFILE%" "desktop.ini AppData Game"
call:[MakeLink] "%~dp0%CURRENTPC%\%CURRENTUSER%\Game\Local" "%CURRENTPROFILE%\AppData\Local" "desktop.ini"
call:[MakeLink] "%~dp0%CURRENTPC%\%CURRENTUSER%\Game\LocalLow" "%CURRENTPROFILE%\AppData\LocalLow" "desktop.ini"
call:[MakeLink] "%~dp0%CURRENTPC%\%CURRENTUSER%\Game\Roaming" "%CURRENTPROFILE%\AppData\Roaming" "desktop.ini"
call:[MakeLink] "%~dp0%CURRENTPC%\%CURRENTUSER%\AppData\Local" "%CURRENTPROFILE%\AppData\Local" "desktop.ini Microsoft"
call:[MakeLink] "%~dp0%CURRENTPC%\%CURRENTUSER%\AppData\LocalLow" "%CURRENTPROFILE%\AppData\LocalLow" "desktop.ini Microsoft"
call:[MakeLink] "%~dp0%CURRENTPC%\%CURRENTUSER%\AppData\Roaming" "%CURRENTPROFILE%\AppData\Roaming" "desktop.ini Microsoft"
call:[MakeLink] "%~dp0%CURRENTPC%\%CURRENTUSER%\AppData\Roaming\Microsoft\Windows" "%CURRENTPROFILE%\AppData\Roaming\Microsoft\Windows" "desktop.ini"
call:[MakeLink] "%~dp0%CURRENTPC%\%CURRENTUSER%\AppData\Local\Microsoft\Windows" "%CURRENTPROFILE%\AppData\Local\Microsoft\Windows" "desktop.ini"
echo.%~d0>"%~dp0%CURRENTPC%\%CURRENTUSER%.dev"


if %ERRORCOUNT% gtr 0 (
	echo.%ERRORCOUNT% errors have occurred and the error log will be opened for you...
	ping -n 5 127.0.0.1 >nul
	notepad "%ERRORLOG%"
)
goto :eof




:[MakeLink]
pushd %~1
for /f "delims=" %%i in ('dir /a /b') do (
	echo."%%~i"|findstr /v "%~3" >nul && (
		if exist "%~2\%%~i" (
			dir /al "%~2\%%~i\.." 2>nul|findstr /r "<SYMLINKD*>\ [ ]*%%~i" >nul && (
				for /f "tokens=2 delims=[]" %%l in ('dir /al "%~2\%%~i\.." 2^>nul^|findstr /r /c:"<SYMLINKD*>  *%%~i"') do (
					if not "%%~l" == "%CD%\%%~i" (
						if "%%~l" == "%LASTDEVICE%%~pn1\%%~i" (
							for /f "tokens=2 delims=<>" %%n in ('dir /al "%~2\%%~i\.." 2^>nul^|findstr /r /c:"<SYMLINKD*>  *%%~i"') do (
								if "%%~n" == "SYMLINKD" (
									rd /q "%~2\%%~i" >nul 2>nul
									mklink /d "%~2\%%~i" "%CD%\%%~i"
								)
								if "%%~n" == "SYMLINK" (
									del /f /q "%~2\%%~i" >nul 2>nul
									mklink "%~2\%%~i" "%CD%\%%~i"
								)
							)
						) else echo."%~2\%%~i" is linked to another location, Unable to create symlink...>>"%ERRORLOG%" && set /a ERRORCOUNT+=1
					)
				)
			) || echo."%~2\%%~i" is exist, Unable to create symlink...>>"%ERRORLOG%" && set /a ERRORCOUNT+=1
		) else dir /ad /b "%%~i" >nul 2>nul && mklink /d "%~2\%%~i" "%CD%\%%~i" || mklink "%~2\%%~i" "%CD%\%%~i"
	)
)
popd
