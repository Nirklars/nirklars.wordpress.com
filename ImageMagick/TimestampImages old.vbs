'Simple timestamp adding using ImageMagic convert.exe and identify.exe
'Written by Nicklas H http://nirklars.wordpress.com

'---DECLARATIONS SECTION---

Set args = Wscript.Arguments
Set FSO = CreateObject("Scripting.FileSystemObject")
Set SHELL = CreateObject("WScript.Shell")

'Get proper current directory
SHELL.CurrentDirectory = FSO.GetParentFolderName(Wscript.ScriptFullName) 

'Declare folder to check files in
Set objFolder = FSO.GetFolder(SHELL.CurrentDirectory)
Set colFiles = objFolder.Files

'Declare global variables
Dim OutputFile 
Dim OutputFileContent
Dim FirstLineCheck
FirstLineCheck = false
OutputFile = SHELL.CurrentDirectory & "\timestamp-log.txt"

'---FONT SETTINGS---

fontStyle = "Arial-Bold"
fontColor = "#FFD800"
fontOutlineColor = "#000000"

'---PROGRAM SECTION---

MkDir("stamped")

'Go through all files in the current folder
For Each objFile in colFiles
	complies = false
	'check file extensions
	if InStr(objFile.Name,".jpg") > 0 then 
		complies = true
	elseif InStr(objFile.Name,".png") > 0 then 
		complies = true
	elseif InStr(objFile.Name,".jpeg") > 0 then 
		complies = true
	elseif InStr(objFile.Name,".gif") > 0 then 
		complies = true
	else
		'skip
	end if
	
	if complies = true then
		'do stuff
		
		Log(objFile.Name)
		Log("Timestamp: " & GetImageDate(objFile.Name))
		Log("Resolution: " & GetImageSize(objFile.Name))
		
		arrSize = Split(GetImageSize(objFile.Name))
		width = arrSize(0)
		height = arrSize(1)
		
		timestampSize = Round(width / 3)
		timestampOffset = Round(width / 20)
		timestampOutlineWidth = Round(width / 600)
		timestamp = GetImageDate(objFile.Name)
		
		command = Quote(SHELL.CurrentDirectory & "\convert.exe") & " -background none -stroke " & fontOutlineColor & " -strokewidth " & timestampOutlineWidth & " -font " & fontStyle & " -fill " & fontColor & " -size " & timestampSize & "x -gravity center label:" & Quote(timestamp) & " " & Quote(SHELL.CurrentDirectory & "\" & objFile.Name) & " +swap -gravity southeast -geometry +" & timestampOffset & "+" & timestampOffset & " -stroke " & fontOutlineColor & " -strokewidth " & timestampOutlineWidth & " -composite " &  Quote(SHELL.CurrentDirectory & "\stamped\" & objFile.Name)
		Log("Command: " & command)
		
		RunCommand(command)
		
		'query = RunCommand(command)
		'query = SHELL.run(command, 0, true)
		
	end if
Next

SaveFile()

'---FUNCTIONS SECTION---

'Run imagemagick identify from commandline and return the results
Function GetImageSize(fileName)
	command = Quote(SHELL.CurrentDirectory & "\identify.exe") & " -format " & Quote("%w %h") & " " & Quote(SHELL.CurrentDirectory & "\" & fileName)
	'Log(command)
	strReturn = RunCommand(command)
	if strReturn = "" then
		strReturn = "Could not get resolution"
	end if
	GetImageSize = strReturn
End Function

'Run imagemagick identify from commandline and return the results
Function GetImageDate(fileName)
	command = Quote(SHELL.CurrentDirectory & "\identify.exe") & " -format " & Quote("%[EXIF:DateTimeOriginal]") & " " & Quote(SHELL.CurrentDirectory & "\" & fileName)
	'Log(command)
	strReturn = RunCommand(command)
	if strReturn = "" then
		strReturn = "Timestamp missing"
	end if
	GetImageDate = strReturn
End Function

'Run commandline utility and return the output string
Function RunCommand(command)
	Set objExec = SHELL.Exec(command)
	returnString = ""
	Do While Not objExec.StdOut.AtEndOfStream
		returnString = returnString & objExec.StdOut.ReadLine()
	Loop
	Set objExec = Nothing
	RunCommand = returnString
End Function

'Write a new line in the output file
Function Log(strLine)
	'Skip line break on the first entry
	if FirstLineCheck = false then
		OutputFileContent = strLine
		FirstLineCheck = true
	else
		OutputFileContent = OutputFileContent & vbNewLine & strLine
	end if
End Function

'Save the output file
Function SaveFile()
    Set stream = FSO.OpenTextFile(OutputFile, 2, True)
    stream.write OutputFileContent
    stream.close
	OutputFileContent = "" 'Clear memory
End Function

'Function to put quotation marks around paths
function Quote(this)
  Quote = Chr(34) & this & Chr(34)
end function

'Create folder until success
function MkDir(myFolder)
	do
		'Fix env strings
		myFolder = translateEnvStr(myFolder)
		
		Err.Clear
		On Error Resume Next
		if FSO.FolderExists(myFolder) = true then 
			exit do
		else
			FSO.CreateFolder(myFolder)
			if ErrorMessage() = false then
				exit do
			end if
		end if
		WScript.Sleep 1000
	loop
end function

'Delete a file if it exists, wait if it doesnt work and retry
function DelFile(myFile)
	do
		'Fix env strings
		myFile = translateEnvStr(myFile)
		
		Err.Clear
		On Error Resume Next
		if FSO.FileExists(myFile) then
			FSO.DeleteFile(myFile)
			if ErrorMessage() = false then
				exit do
			end if
		else
			exit do
		end if
		WScript.Sleep 1000
	loop
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
		translated = SHELL.ExpandEnvironmentStrings(result)
		
		'When we are done we replace the original EnvironmentString with the translated in strLargeEES
		strLargeEES = Replace(strLargeEES,result,translated)
	'Repeat
	next
	
	'When done return the whole translated string to the function call
	translateEnvStr = strLargeEES
end function