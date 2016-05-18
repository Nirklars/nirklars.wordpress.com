'Declare shell object
set shell = CreateObject("WScript.Shell")

'Function to put quotation marks around paths to avoid space issues
function qPath(vl)
  qPath = Chr(34) & vl & Chr(34)
end function

'User defined settings, EDIT THIS
'---------------------
'Choose a free drive letter
TCLetter = "Q"
'The path to your TrueCrypt installation
TCPath = "%PROGRAMFILES(x86)%\TrueCrypt\TrueCrypt.exe"
'The path to your TrueCrypt file container
TCVolumeFile = "D:\FirefoxProfile.tc"
'The path to your Firefox installation
FirefoxPath = "%PROGRAMFILES(x86)%\Mozilla Firefox\firefox.exe"
'The path to your Firefox Profile
FirefoxProfilePath = TCLetter & ":\Firefox Profile"

'Arguments to TrueCrypt, DON'T EDIT THIS
'---------------------
TCMountArgs = " /letter " & TCLetter & " /m ts /volume "
TCDismountArgs = " /dismount " & TCLetter & " /force /auto /wipecache /quit "

shell.Run qPath(TCPath) & TCMountArgs & qPath(TCVolumeFile) & " /quit", 1, true
shell.Run qPath(FirefoxPath) & " -profile " & qPath(FirefoxProfilePath), 1, true
shell.Run qPath(TCPath) & TCDismountArgs, 1, true

wscript.quit