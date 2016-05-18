'===================================================================================
'DECLARATIONS
'===================================================================================

'Declare variables
Dim localPath, crashCount
'Find local path where the script run from
localPath = CreateObject("Scripting.FileSystemObject").GetAbsolutePathName(".")

'Declare File System object in order to write to files
Set stopCommandFSO = CreateObject("Scripting.FileSystemObject")
stopCommandFile = localPath & "\StopLoop.nothing"

'===================================================================================
'PROGRAM
'===================================================================================

Write "This file will stop the loop."
wscript.quit

'===================================================================================
'FUNCTIONS
'===================================================================================

Sub Write (msg)
    Set stream = stopCommandFSO.OpenTextFile(stopCommandFile, 8, True)
    stream.writeline date & " " & time & ": " & msg
    stream.close
end sub