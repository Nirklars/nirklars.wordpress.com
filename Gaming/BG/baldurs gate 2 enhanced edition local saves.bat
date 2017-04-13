@ECHO OFF
FOR /F "tokens=3 delims= " %%G IN ('REG QUERY "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders" /v "Personal"') DO (SET MYDOCUMENTS=%%G)
mkdir "%MYDOCUMENTS%\Baldur's Gate II - Enhanced Edition"
rmdir "%MYDOCUMENTS%\Baldur's Gate II - Enhanced Edition\portraits"
rmdir "%MYDOCUMENTS%\Baldur's Gate II - Enhanced Edition\save"
rmdir "%MYDOCUMENTS%\Baldur's Gate II - Enhanced Edition\characters"
rmdir "%MYDOCUMENTS%\Baldur's Gate II - Enhanced Edition\mpsave"
del "%MYDOCUMENTS%\Baldur's Gate II - Enhanced Edition\Baldur.lua"
pause
mklink /d "%MYDOCUMENTS%\Baldur's Gate II - Enhanced Edition\portraits" "%~dp0\portraits"
mklink /d "%MYDOCUMENTS%\Baldur's Gate II - Enhanced Edition\save" "%~dp0\Baldurs Gate II - Enhanced Edition\save"
mklink /d "%MYDOCUMENTS%\Baldur's Gate II - Enhanced Edition\characters" "%~dp0\Baldurs Gate II - Enhanced Edition\characters"
mklink /d "%MYDOCUMENTS%\Baldur's Gate II - Enhanced Edition\mpsave" "%~dp0\Baldurs Gate II - Enhanced Edition\mpsave"
mklink "%MYDOCUMENTS%\Baldur's Gate II - Enhanced Edition\Baldur.lua" "%~dp0\Baldurs Gate II - Enhanced Edition\Baldur.lua"
pause