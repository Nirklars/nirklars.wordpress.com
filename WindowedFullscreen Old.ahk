!^F12::
WinGet, TempWindowID, ID, A
If (WindowID != TempWindowID)
{
  WindowID:=TempWindowID
  WindowState:=0
}
If (WindowState != 1)
{
  WinGetPos, WinPosX, WinPosY, WindowWidth, WindowHeight, ahk_id %WindowID%
  WinSet, Style, ^0xC40000, ahk_id %WindowID%
  WinMove, ahk_id %WindowID%, , 0, 0, A_ScreenWidth, A_ScreenHeight
}
Else
{
  WinSet, Style, ^0xC40000, ahk_id %WindowID%
  WinMove, ahk_id %WindowID%, , WinPosX, WinPosY, WindowWidth, WindowHeight
}
WindowState:=!WindowState
return