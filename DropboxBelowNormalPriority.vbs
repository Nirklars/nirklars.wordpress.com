Const NORMAL_WINDOW = 1
Dim oShell, sParams
comSpec = Chr(34) & CreateObject("WScript.Shell").ExpandEnvironmentStrings("%comspec%") & Chr(34)
dropboxPath = Chr(34) & CreateObject("WScript.Shell").ExpandEnvironmentStrings("%ProgramFiles(x86)%") & "\Dropbox\Client\Dropbox.exe" & Chr(34)
cmd = comSpec & " /c start /belownormal " & Chr(34) & "Dropbox" & Chr(34) &" " & dropboxPath & " /systemstartup"
CreateObject("Wscript.Shell").Run cmd,0,True