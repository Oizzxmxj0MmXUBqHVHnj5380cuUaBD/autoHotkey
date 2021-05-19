#if getKeyState("capslock", "P") && !numberSwitch && !capsToggle && !winActive("ahk_exe vmconnect.exe") && !winActive("ahk_exe mstsc.exe")

*h::sendinput {blind}{left downtemp}
h up::sendinput {blind}{left up}
*j::send {blind}{down downtemp}
j up::send {blind}{down up}
*k::send {blind}{up downtemp}
k up::send {blind}{up up}
*l::send {blind}{right downtemp}
l up::send {blind}{right up}

*a::send {blind}{home downtemp}
a up::send {blind}{home up}
*e::send {blind}{End downtemp}
e up::send {Blind}{End up}

`;::send {wheelup 1}
;`; up::send {pgup up}
'::send {wheeldown 1}
;' up::send {pgdn up}

*w::send {blind}^{right downtemp}
w up::send {blind}^{right up}
*b::send {blind}^{left downtemp}
b up::send {blind}^{left up}

o::send {blind}{end}{enter}
+o::send {shift up}{blind}{home}{home}{enter}{up}

g::
if !gtap
  settimer, gtap, -300
gtap++
return
gtap:
if gtap = 2
  send {blind}^{home}
keywait, g
gtap =
return

+g::send {blind}{shift up}^{end}