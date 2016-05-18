; TOGGLE WINDOWED FULLSCREEN AND HIDE TASKBAR FOR WINDOWS 8
#SingleInstance
SetTitleMatchMode, 2

; Change these values to screen size if it doesn't work as intended.
; Custom DPI scales or such can cause trouble being rounded down
; scr_x = 1920
; scr_y = 1080
scr_x:=A_ScreenWidth
scr_y:=A_ScreenHeight

;Uncomment this line to figure out your current screen size with custom DPIs
; msgbox %A_ScreenWidth% x %A_ScreenHeight%

; Custom DPIs can also cause rounding errors with your window ending up off screen. Add or subtract one to fix that:
; scr_x:=A_ScreenWidth - 1


; !^F12 means to hold down CONTROL and ALT before pressing F12 to toggle
!^F12::
WinGet, TempWindowID, ID, A
if (WindowID != TempWindowID)
{
	WindowID:=TempWindowID
}

WinGet Style, Style, ahk_id %WindowID%
if (Style & 0xC40000)
{
	;Maximize 
	WinGetPos, WinPosX, WinPosY, WindowWidth, WindowHeight, ahk_id %WindowID%
	WinSet, Style, -0xC40000, ahk_id %WindowID%
	WinMove, ahk_id %WindowID%, , 0, 0, scr_x, scr_y
	;Hide windows taskbar
	WinHide, ahk_class Shell_TrayWnd
	;Hide classic shell windows button
	WinHide, ahk_class ClassicShell.CMenuContainer
}
else
{
	;Minimize 
	WinSet, Style, +0xC40000, ahk_id %WindowID%
	WinMove, ahk_id %WindowID%, , WinPosX, WinPosY, WindowWidth, WindowHeight
	;Show windows taskbar
	WinShow, ahk_class Shell_TrayWnd
	;Show classic shell windows button
	WinShow, ahk_class ClassicShell.CMenuContainer
}
return