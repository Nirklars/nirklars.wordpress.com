@echo off & cls
rem enable variables referencing themselves inside loops
SetLocal EnableDelayedExpansion

rem optional settings
set fontcolor=#FFD800
set fontoutlinecolor=#000000
set fontstyle="Arial-Bold"

rem create a new folder where the stamped images will be placed
mkdir stamped

rem loop through all jpg png jpeg and gif files in the current folder
for /f "delims=" %%a in ('dir /b /A:-D /T:C "%cd%\*.jpg" "%cd%\*.png" "%cd%\*.jpeg" "%cd%\*.gif"') do (
	rem retrieve image date and time
	SetLocal EnableDelayedExpansion
	for /f "tokens=1-2" %%i in ('identify.exe -ping -format "%%w %%h" "%cd%\%%a"') do set W=%%i& set H=%%j

	rem retrieve image timestamp to perform size and distance calculations on
	SetLocal EnableDelayedExpansion
	for /f "tokens=1-2 delims=" %%k in ('identify -format "%%[EXIF:DateTimeOriginal]" "%cd%\%%a"') do set timestamp=%%k
	
	rem set timestamp to no timestamp if there is no timestamp
	if "!timestamp!" == "" (
		set timestamp=No timestamp
	)
	
	rem print some information about the process
	echo %%a is !W! x !H! stamp !timestamp! ...

	rem set timestamp size to a fourth of the screen width
	set /A timestampsize = !W! / 3

	rem set timestamp offset distance from side of the screen
	set /A timestampoffset = !W! / 20

	rem set timestamp outline relative size
	set /A outlinewidth = !W! / 600

	rem echo !timestampsize! !timestampoffset!
	
	rem create a custom image with the timestamp with transparent background and combine it with the image
	convert.exe ^
	-verbose ^
	-background none^
	-stroke !fontoutlinecolor! ^
	-strokewidth !outlinewidth! ^
	-font !fontstyle! ^
	-fill !fontcolor! ^
	-size !timestampsize!x ^
	-gravity center label:"!timestamp!" "%cd%\%%a" +swap ^
	-gravity southeast ^
	-geometry +!timestampoffset!+!timestampoffset! ^
	-stroke !fontoutlinecolor! ^
	-strokewidth !outlinewidth! ^
	-composite "%cd%\stamped\%%a"

	endlocal
	endlocal
	echo.
)
endlocal
echo Complete!
pause