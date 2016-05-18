#singleinstance force ; prevent multiple instances

; increase this if you have a very slow computer to 1500 or 2000
sleepdelay := 1000

; Check and remember current resolution
x = %A_ScreenWidth%
y = %A_ScreenHeight%

run bgmain.exe ; start baldurs gate

sleep %sleepdelay% ; wait milliseconds

; old method of changing resolution
;run qres /x 1280 /y 720 

; change resolution temporarily
ChangeResolution(1280,720)

sleep %sleepdelay% ; wait milliseconds

WinActivate ahk_class ChitinClass ; focus on baldurs gate

sleep %sleepdelay% ; wait milliseconds

SetFakeFullscreen()

WinWaitClose ahk_class ChitinClass ; wait for baldurs gate to close

; old method of changing resolution
;run qres /x %x% /y %y%

; change back resolution
ChangeResolution(x,y)

sleep %sleepdelay%

ExitApp
return

;---Remapped keys 

; Swap arrow keys with WASD for panning
#IfWinActive ahk_class ChitinClass
a::left
left::a

; Swap arrow keys with WASD for panning
#IfWinActive ahk_class ChitinClass
d::right
right::d

; Swap arrow keys with WASD for panning
#IfWinActive ahk_class ChitinClass
w::up
up::w

; Swap arrow keys with WASD for panning
#IfWinActive ahk_class ChitinClass
s::down
down::s

; Select all party members using tilde
#IfWinActive ahk_class ChitinClass
SC029::SC00c
SC00c::SC029

;---Functions

SetFakeFullscreen()
{
	WinGet Style, Style, ahk_class ChitinClass ; retrieve window data
	WinSet Style, -0xC40000, ahk_class ChitinClass ; hide thickframe/sizebox
	WinSet Style, -0xC00000, ahk_class ChitinClass ; hide title bar
	WinSet Style, -0x800000, ahk_class ChitinClass ; hide thin-line border
	WinSet Style, -0x400000, ahk_class ChitinClass ; hide dialog frame
	WinMove, ahk_class ChitinClass, , 0, 0, A_ScreenWidth, A_ScreenHeight
}

ChangeResolution(w,h) 
{
	VarSetCapacity(dM,156,0)
	NumPut(156,dM,36)
	NumPut(0x5c0000,dM,40)
	NumPut(w,dM,108)
	NumPut(h,dM,112)
	DllCall( "ChangeDisplaySettingsA", UInt,&dM, UInt,0 )
}