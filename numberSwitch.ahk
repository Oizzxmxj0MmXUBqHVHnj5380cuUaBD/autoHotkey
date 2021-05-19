#if !numberSwitch && !winactive("ahk_exe vmconnect.exe") && !winactive("ahk_exe mstsc.exe")

numberSwitchOff(){
  global
  numberSwitch = 0
  setTimer, numberSwitchToolTip, off
  toolTip
}

~*lshift::
  if (getKeyState("rShift", "p")) {
    setTimer, numberSwitchTooltip, 100
    numberSwitch=1
  }
return

~*rshift::
  if (GetKeyState("lShift", "p")) {
    setTimer, numberSwitchTooltip, 100
    numberSwitch=1
  }
return

; dual shift turns on numberSwitch, if key pressed before releasing either shift, send symbol / keys and deactivate

#if (getKeyState("lshift", "P") and getKeyState("rshift", "P"))

*capslock::
  send {blind}{!}{lshift up}{rshift up}
  numberSwitchOff()
return

*a::
  send {blind}{@}{lshift up}{rshift up}
  numberSwitchOff()
return

*s::
  send {blind}{#}{lshift up}{rshift up}
  numberSwitchOff()
return

*d::
  send {blind}{$}{lshift up}{rshift up}
  numberSwitchOff()
return

*f::
  send {blind}{`%}{lshift up}{rshift up}
  numberSwitchOff()
return

*g::
  send {blind}{^}{lshift up}{rshift up}
  numberSwitchOff()
return

*h::
  send {blind}{&}{lshift up}{rshift up}
  numberSwitchOff()
return

*j::
  send {blind}{*}{lshift up}{rshift up}
  numberSwitchOff()
return

*k::
  send {blind}{`(}{lshift up}{rshift up}
  numberSwitchOff()
return

*l::
  send {blind}{`)}{lshift up}{rshift up}
  numberSwitchOff()
return

*;::
send {blind}{_}{lshift up}{rshift up}
numberSwitchOff()
return

*'::
  send {blind}{+}{lshift up}{rshift up}
  numberSwitchOff()
return

*x::
  send !{f4}
  numberSwitch = 0
return

#if numberswitch && !winactive("ahk_exe vmconnect.exe") && !winactive("ahk_exe mstsc.exe")

; if one shift released before anything is pressed, activate numberSwitch2
*lshift up::
  if (getKeyState("rshift", "P") )
  {
    setTimer, numberSwitchToolTip, 100
    numberSwitch2=1
    numberSwitchOff()
  }
  if (a_priorKey = "lShift"){ ; if shift tapped, deactivate
    numberSwitchOff()
  }
return
*rshift up::
  if (getKeyState("lshift", "P") )
  {
    setTimer, numberSwitchToolTip, 100
    numberSwitch2=1
    numberSwitchOff()
  }
  if (a_priorKey = "RShift"){
    numberSwitchOff()
  }
return

; normal numberShift operations

capslock::
  if (getKeyState("lshift", "P") or getKeyState("rshift", "P"))
  {
    send {!}
  } else {
    send {1}
  }
return

a::
  if (getKeyState("lshift", "P") or getKeyState("rshift", "P"))
  {
    send {@}
  } else {
    send {2}
  }
return

s::
  if (getKeyState("lshift", "P") or getKeyState("rshift", "P"))
  {
    send {#}
  } else {
    send {3}
  }
return

d::
  if (getKeyState("lshift", "P") or getKeyState("rshift", "P"))
  {
    send {$}
  } else {
    send {4}
  }
return

f::
  if (getKeyState("lshift", "P") or getKeyState("rshift", "P"))
  {
    send {`%}
  } else {
    send {5}
  }
return

g::
  if (getKeyState("lshift", "P") or getKeyState("rshift", "P"))
  {
    send {^}
  } else {
    send {6}
  }
return

h::
  if (getKeyState("lshift", "P") or getKeyState("rshift", "P"))
  {
    send {&}
  } else {
    send {7}
  }
return

j::
  if (getKeyState("lshift", "P") or getKeyState("rshift", "P"))
  {
    send {*}
  } else {
    send {8}
  }
return

k::
  if (getKeyState("lshift", "P") or getKeyState("rshift", "P"))
  {
    send {`(}
  } else {
    send {9}
  }
return

l::
  if (getKeyState("lshift", "P") or getKeyState("rshift", "P"))
  {
    send {`)}
  } else {
    send {0}
  }
return

`;::
if (getKeyState("lshift", "P") or getKeyState("rshift", "P"))
{
  send {_}
} else {
  send {-}
}
return

'::
  if (getKeyState("lshift", "P") or getKeyState("rshift", "P"))
  {
    send {+}
  } else {
    send {=}
  }
return

esc::
  numberSwitchOff()
  numberswitch2=0
return

; f keys deactivate
1::commandRoot(subroutine := "", parameters*)
1 up::numberSwitchOff()
2::f2
2 up::numberSwitchOff()
3::f3
3 up::numberSwitchOff()
4::f4
4 up::numberSwitchOff()
5::f5
5 up::numberSwitchOff()
6::f6
6 up::numberSwitchOff()
7::f7
7 up::numberSwitchOff()
8::camelCase()
8 up::numberSwitchOff()
9::f9
9 up::numberSwitchOff()
0::f10
0 up::numberSwitchOff()
-::f11
- up::numberSwitchOff()
=::f12
= up::numberSwitchOff()

; enter deactivates
~enter::numberSwitchOff()

#if numberSwitch2
  ; if shifts released without pressing anything, leave numberSwitch activated
lshift up::
rshift up::
  if ((A_Priorkey = "lshift") or (A_PriorKey = "rshift")) {
    setTimer, numberSwitchToolTip, 100
    numberSwitch=1
  } else {
    numberSwitchOff()
  }
  numberSwitch2=0
return

*capslock::
  send {1}
return
*a::
  send {2}
return
*s::
  send {3}
return
*d::
  send {4}
return
*f::
  send {5}
return
*g::
  send {6}
return
*h::
  send {7}
return
*j::
  send {8}
return
*k::
  send {9}
return
*l::
  send {0}
return
*;::
send {-}
return
*'::
  send {=}
return

*1::commandRoot(subroutine := "", parameters*)
*2::send {f2}
*3::f3
*4::f4
*5::f5
*6::f6
*7::f7
*8::f8
*9::f9
*0::f10
*-::f11
*=::f12

esc::
  numberSwitchOff()
  numberSwitch2=0
return