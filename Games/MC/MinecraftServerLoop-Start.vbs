'===================================================================================
'SETTINGS
'===================================================================================

'Change this to your server launcher
serverFile = "Server Start.bat"

'Change this file name to whichever you prever
logFileName = "MCServerCrashLog.txt"

'Internal wait timer to prevent accidentally overflowing the log file
waitTimer = 2000

'Show more junk while running, only for testing purposes
debugMode = false

'===================================================================================
'DECLARATIONS
'===================================================================================

'Declare Shell object in order to start other programs
set shellServer = WScript.CreateObject("WScript.Shell")

'Declare variables
Dim localPath, crashCount
'Find local path where the script run from
localPath = CreateObject("Scripting.FileSystemObject").GetAbsolutePathName(".")
'Set the application path
appPath = localpath & "\" & serverFile

'Declare Log function variables
Dim logFile, logFSO
logFile = localPath & "\" & logFileName

'Declare File System object in order to write to log file
Set logFSO = CreateObject("Scripting.FileSystemObject")
Set stopCommandFSO = CreateObject("Scripting.FileSystemObject")

If logFSO.FileExists(logFile) Then
	'Delete old log when starting if there is one
	logFSO.DeleteFile logFile
End If 

'===================================================================================
'PROGRAM
'===================================================================================

Log "The server started for the first time."

'Master loop
Do
	'Abort the loop if command is saved
	If stopCommandFSO.FileExists(localPath & "\StopLoop.nothing") Then
		Log "The server automatic reboot loop has been stopped."
		stopCommandFSO.DeleteFile localPath & "\StopLoop.nothing"
		wscript.quit
	End If 
	
	
	'Start the server and wait for it to crash or terminate
	Return = shellServer.Run("CMD /C CD "& localpath & " & """ & AppPath & """" , 1, true)
	
	'Count number of crashes/restarts this far
	crashCount = crashCount + 1
	
		'Write to log file
	Log "The server has crashed or restarted. Total " & crashCount & " times." 
	
	'More information
	if debugMode = true then
		WScript.Echo "The server has crashed or restarted. Total " & crashCount & " times since starting." 
	end if

	'Internal wait timer to prevent accidentally overflowing the log file
	WScript.Sleep waitTimer
Loop
wscript.quit

'===================================================================================
'FUNCTIONS
'===================================================================================

Function checkProcess(processName)
	'Get list of running processes
	Set colProcessList = GetObject("Winmgmts:").ExecQuery ("Select * from Win32_Process")
	'Go through every item in the process list
	For Each objProcess in colProcessList
		'Return value if process was found
		If objProcess.name = processName then
			checkProcess = True 
		else
			checkProcess = False
		End if
	Next
end Function

Function killProcess(processName)
	'Get list of running processes
	Set colProcessList = GetObject("Winmgmts:").ExecQuery ("Select * from Win32_Process")
	'Go through every item in the process list
	For Each objProcess in colProcessList
		'Return value if process was found
		If objProcess.name = processName then
			'Terminate process
			objProcess.terminate
		End if
	Next
end Function

Sub Log (msg)
    Set stream = logFso.OpenTextFile(logFile, 8, True)
    stream.writeline date & " " & time & ": " & msg
    stream.close
end sub