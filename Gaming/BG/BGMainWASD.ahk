#singleinstance force ; prevent multiple instances

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
