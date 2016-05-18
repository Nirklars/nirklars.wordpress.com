#SingleInstance force
#NoEnv
SendMode Input
#IfWinActive Amidst
Enter::
clip:=
send ^n
random neg, 0,1
if neg = 0
{
  clip =-
}
random length, 4,16
random rand, 1, 9
r := r & %rand%
clip = %clip%%rand%
Loop %length%
{
  sleep 10
  random rand, 0, 9
  r := r & %rand%
  clip = %clip%%rand%
}
sleep 50
clipboard = %clip%
SendInput {Raw}%clip%
send {enter}
sleep 50
send {enter}
sleep 50
return