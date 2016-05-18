/*
	This script checks if the specified process is running
	If the process is not running, it will be started
	If the process is not responding, it will be terminated and then restarted
	A log with timestamps is kept
	There is no way to terminate it, you have to close it using task manager or commandline: taskkill /im autohotkey.exe
	Limitations: Doesnt work on invisible windows
	http://nirklars.wordpress.com
*/

#SingleInstance force 

; Settings - edit this
ProgramName:="exampleGame.exe"
CheckInterval:=5000
NotRespondingTimeout:=1000
DeleteOldLog:=true
LogFilePath=%A_ScriptDir%\%A_ScriptName%.log

if DeleteOldLog
{
	IfExist, %LogFilePath%
	{
		FileDelete, %LogFilePath%
	}
}

; Functions
MsgLog(message)
{
	global
	FormatTime, TimeString,,yyyy-MM-dd HH:mm
	FileAppend,[%TimeString%] %message%`n,%LogFilePath%
	return
}

ProcessKill(ProcessID) 
{
	MsgLog("Kindly closing " ProcessID "...")
    WinClose,ahk_pid %ProcessID%
    WinWaitClose,ahk_pid %ProcessID%,,1
    if (ErrorLevel)
    {
		MsgLog("Force closing " ProcessID "...")
        Process,Close,%ProcessID%
        return ErrorLevel
    }
    return 1
}

; Program
MsgLog("Script started")
Loop
{
	CheckIntervalTemp := CheckInterval
	
	Process, Exist, %ProgramName%
	{
		If ! errorLevel 
		{
			IfExist, %ProgramName%
			{
				MsgLog(ProgramName " is not running - starting")
				Run,%ProgramName%
			}
		}
		else
		{
			ProcessID:= ErrorLevel
			WinGet, processWindow, ID, ahk_pid %ProcessID%
			Responding := DllCall("SendMessageTimeout", "UInt", processWindow, "UInt", 0x0000, "Int", 0, "Int", 0, "UInt", 0x0002, "UInt", NotRespondingTimeout, "UInt *", 0)
			If Responding = 1
			{
				; MsgLog(ProgramName " is responding")
			}
			Else
			{
				MsgLog(ProgramName " is not responding")
				ProcessKill(ProcessID)
				CheckIntervalTemp := 0
			}
			
		}
		
		
	}
	Sleep CheckIntervalTemp
}