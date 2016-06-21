@echo off
::Unicode
CHCP 1252
echo %~dp0
::Remove old log file
if exist "%~dp0\robocopylog.txt" del "%~dp0\robocopylog.txt"
::Ignore the following file types. You can add more separated by space
set exclude=*.bak *.backup
::Go through each line in the folders.txt file
for /f "skip=2 delims=" %%f in ('find /v "" %~dp0\folders.txt') do (
  ::Check if the relative path from current directory works 
  if exist "%~dp0\%%f" (
    ::Sync relative path
		robocopy "%%f" "%~dp0\%%f" /v /xf %exclude% /mir /tee /fft /log+:robocopylog.txt
	) else (
	::Sync absolute path if relative didnt work
		robocopy "%%f" "%~dp0\%%~nf" /v /xf %exclude% /mir /tee /fft /log+:robocopylog.txt
	)
)
::Wait for keyboard input before closing the window. Remove pause if you want it to close
pause