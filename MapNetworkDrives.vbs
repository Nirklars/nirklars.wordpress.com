'This script will silently attempt to map network drives of your chosing and retry doing so for 120 seconds
'If drive letters are already mapped the script will exit
'nirklars.wordpress.com
set shell = wscript.createobject("WScript.shell")
set filesys = CreateObject("Scripting.FileSystemObject")

'Change this to the number of retries you want before giving up
timeout = 120
'Change this to the delay between retries, in milliseconds 1000=1 second
delay = 100

function MapDrive(pathNetwork, driveLetter,loginCred)
	count = 0
	do
		if filesys.DriveExists(driveLetter) or count > timeout then 
			'msgbox "Drive exists"
			exit do
		end if
		commandString = shell.ExpandEnvironmentStrings("%WINDIR%") & "\system32\net.exe use " & driveLetter & ": " & pathNetwork & " /p:no " & loginCred
		'InputBox " "," ",commandString
		shell.run(commandString), 0, true
		WScript.Sleep delay
		count = count + 1
	loop
end function

'Copy and paste for each network drive to map
MapDrive "\\netgear\test1","Y","/USER:guest" 
MapDrive "\\netgear\test2","Z","/USER:guest" 
MapDrive "\\netgear\test3","W","/USER:guest" 