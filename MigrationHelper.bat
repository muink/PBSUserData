:: PBSUserData
:: Portable System UsersAppData For Windows
:: Author: muink

@echo off&mode con cols=120 lines=40

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

:--main--
echo.########################################################################################################################
echo.
echo.Current PC   Name:	%USERDOMAIN%			MUID: %CURRENTPC%
echo.Current User Name:	%USERNAME%			UUID: %CURRENTUSER%
echo.
echo.########################################################################################################################
pause & exit