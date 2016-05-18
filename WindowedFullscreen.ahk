;Toggle fake windowed fullscreen!
;http://nirklars.wordpress.com

#singleinstance force

!^F12::
	WinGet, WindowID, ID, A
	WinGet Style, Style, ahk_id %WindowID% ; retrieve window data

	if (Style & 0xC40000) ; check if object is available
	{
		WinSet Style, -0xC40000, ahk_id %WindowID% ; hide thickframe/sizebox
		WinSet Style, -0xC00000, ahk_id %WindowID% ; hide title bar
		WinSet Style, -0x800000, ahk_id %WindowID% ; hide thin-line border
		WinSet Style, -0x400000, ahk_id %WindowID% ; hide dialog frame
	}
	else
	{
		WinSet Style, +0xC40000, ahk_id %WindowID% ; show thickframe/sizebox
		WinSet Style, +0xC00000, ahk_id %WindowID% ; show title bar
		WinSet Style, +0x800000, ahk_id %WindowID% ; show thin-line border
		WinSet Style, +0x400000, ahk_id %WindowID% ; show dialog frame
	}

	WinMove, ahk_id %WindowID%, , 0, 0, A_ScreenWidth, A_ScreenHeight
	
return