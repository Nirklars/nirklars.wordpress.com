'User defined settings, EDIT THIS
'---------------------
'Choose a free drive letter
TCLetter = "R"
'The path to your TrueCrypt installation
TCPath = "%PROGRAMFILES(x86)%\TrueCrypt\TrueCrypt.exe"
'The path to your TrueCrypt file container
TCVolumeFile = "D:\ThunderbirdProfile.tc"
'The path to your Firefox installation
FirefoxPath = "%PROGRAMFILES(x86)%\Mozilla Thunderbird\thunderbird.exe"
'The path to your Firefox Profile
FirefoxProfilePath = TCLetter & ":\Thunderbird Profile"

'Functions and program, DON'T EDIT THIS
'---------------------

'Declare shell object
set shell = CreateObject("WScript.Shell")
'Declare file system object
set filesys = CreateObject("Scripting.FileSystemObject")

'Function to put quotation marks around paths to avoid space issues and translate EnvironmentStrings
function qPath(vl)
  qPath = translateEnvStr(Chr(34) & vl & Chr(34))
end function

'Function that translates all EnvironmentStrings into real paths from inside a larger string. Lets call it strLargeEES.
function translateEnvStr(strLargeEES)
	'Count the number of % characters in the supplied string. This is done by removing all of the % from strLargeEES and subtract it from the original strLargeEES.
	intCharNum = Len(strLargeEES) - Len(Replace(strLargeEES, "%", ""))
	
	'Since there are two % signs for each EnvironmentString that means we divide the total number of EnvironmentStrings by...
	intExpandedStringsNum = intCharNum/2
	
	'Loop through all of the EnvironmentStrings. Because we need to translate each one separately.
	for i = 1 to intExpandedStringsNum
		'Cut out the part to the right of %
		strFirstCut = Right(strLargeEES,Len(strLargeEES)-InStr(strLargeEES,"%"))
		'Cut out the part to the left of %
		strSecondCut = Left(strFirstCut,InStr(strFirstCut,"%")-1)
		
		'The result from our cutting reveals the first EnvironmentString!
		result = "%" & strSecondCut & "%"
		'We translate this to the real folder by using a shell object
		translated = shell.ExpandEnvironmentStrings(result)
		
		'When we are done we replace the original EnvironmentString with the translated in strLargeEES
		strLargeEES = Replace(strLargeEES,result,translated)
	'Repeat
	next
	
	'When done return the whole translated string to the function call
	translateEnvStr = strLargeEES
end function

'Check if the drive already exists (i.e. is already mounted)
if filesys.DriveExists(TCLetter) then 
	if filesys.FileExists(translateEnvStr(FirefoxPath)) Then 
		'Run another window in firefox
		shell.Run qPath(FirefoxPath)
	else
		msgbox qPath(FirefoxPath) & " is not valid." & vbNewLine & "Please edit the settings!",vbExclamation,"Error!"
	end if
else
	'Arguments to TrueCrypt for mounting of the drive
	'---------------------
	TCMountArgs = " /letter " & TCLetter & " /m ts /volume "
	TCDismountArgs = " /dismount " & TCLetter & " /force /auto /wipecache /quit "

	shell.Run qPath(TCPath) & TCMountArgs & qPath(TCVolumeFile) & " /quit", 1, true
	
	'Check if the drive was successfully mounted
	if filesys.FolderExists(translateEnvStr(FirefoxProfilePath)) Then 
		shell.Run qPath(FirefoxPath) & " -profile " & qPath(FirefoxProfilePath), 1, true
		shell.Run qPath(TCPath) & TCDismountArgs, 1, true
	'else
		'msgbox qPath(FirefoxProfilePath) & " not found!" & vbNewLine & "Did you enter the correct password?",vbExclamation,"Error!"
	end if
	wscript.quit	
end if