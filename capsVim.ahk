#if getKeyState("capslock", "P") && !numberSwitch && !capsToggle && !winActive("ahk_exe vmconnect.exe") && !winActive("ahk_exe mstsc.exe")

dExit(){
  global
  hotkey, if, % "getKeyState(""capslock"", ""P"") && !numberSwitch && !capsToggle && !winActive(""ahk_exe vmconnect.exe"") && !winActive(""ahk_exe mstsc.exe"")"
    hotkey, g, on
  dcount=
  gcount=
}

yExit(){
  global
  hotkey, if, % "getKeyState(""capslock"", ""P"") && !numberSwitch && !capsToggle && !winActive(""ahk_exe vmconnect.exe"") && !winActive(""ahk_exe mstsc.exe"")"
    hotkey, g, on
  ycount=
  gcount=
}

p::send ^{v}

u::send {blind}^{z downtemp}
u up:: send {blind}^{z up}

*/::send {blind}^{f downtemp}
/ up::send {blind}^{f uP}
n::send {blind}{f3 downtemp}
n up::send {blind}{f3 up}
+n::send {blind}+{f3 downtemp}
+n up::send {blind}+{f3 up}

+z::
  if (!ztap){
    settimer, ztap, -300
  }
  ztap++
return
ztap:
  if (getkeystate("z","p")){
    tooltip hold
  } else if (ztap = 2){
    send ^{s}!{f4}
  }
  keywait, z
  ztap =
return

; caps keys vim y

y::
  hotkey, if, % "getKeyState(""capslock"", ""P"") && !numberSwitch && !capsToggle && !winActive(""ahk_exe vmconnect.exe"") && !winActive(""ahk_exe mstsc.exe"")"
    hotkey, g, off
  if (!ycount){
    settimer, ytime, -300
  }
  ycount++
return
ytime:
  if (ycount = 1){
    temp := clipboard
    clipboard := ""
    send {blind}^{c}
    clipwait
    if (clipboard = "")
      clip2 := temp
    else
      clip2 := clipboard
    clipboard := temp
  }
  else if (ycount = 2){
    temp := clipboard
    clipboard := ""
    send {home}{home}+{end}+{right}^{c}
    clipwait
    if (clipboard = "")
      clip2 := temp
    else
      clip2 := clipboard
    clipboard := temp
  } else {
    temp := clipboard
    clipboard := ""
    clipboard := clip2
    clipwait
    send ^v
    sleep 300
    clipboard := temp
  }
  keywait y
  ycount=
return

; caps keys vim d

d::
  hotkey, if, % "getKeyState(""capslock"", ""P"") && !numberSwitch && !capsToggle && !winActive(""ahk_exe vmconnect.exe"") && !winActive(""ahk_exe mstsc.exe"")"
    hotkey, g, off
  if (!dcount){
    settimer, dtime, -300
  }
  dcount++
return
dtime:
  if (dcount = 1){
    temp := clipboard
    clipboard := ""
    send {blind}^{x}
    clipwait
    if (clipboard = ""){
      clip1 := temp
    } else {
      clip1 := clipboard
    }
    clipboard := temp
  } else if (dcount = 2){
    temp := clipboard
    clipboard := ""
    send {home}{home}+{end}+{right}^{x}
    clipwait
    if (clipboard = ""){
      clip1 := temp
    } else {
      clip1 := clipboard
    }
    clipboard := temp
  } else { ; hold
    temp := clipboard
    clipboard := ""
    clipboard := clip1
    clipwait
    send ^v
    sleep 300
    clipboard := temp
  }
  keywait d
  dExit()
return

; caps keys vim d 1

#if getkeystate("capslock","p") && (dcount=1) && !numberSwitch && !winactive("ahk_exe vmconnect.exe") && !winactive("ahk_exe mstsc.exe")

0::
a::
  settimer, dtime, off
  temp := clipboard
  clipboard := ""
  send {blind}+{home}^{x}
  clipwait
  if (clipboard = ""){
    clip1 := temp
  } else {
    clip1 := clipboard
  }
  clipboard := temp
  dExit()
return

e::
  settimer, dtime, off
  temp := clipboard
  clipboard := ""
  send {blind}+{end}^{x}
  clipwait
  if (clipboard = ""){
    clip1 := temp
  } else {
    clip1 := clipboard
  }
  clipboard := temp
  dExit()
return

w::
  settimer, dtime, off
  temp := clipboard
  clipboard := ""
  send {blind}^{right}^+{left}^{x}
  clipwait
  if (clipboard = ""){
    clip1 := temp
  } else {
    clip1 := clipboard
  }
  clipboard := temp
  dExit()
return

g::
  settimer, dtime, off
  if (!gcount){
    settimer, dgtime, -300
  }
  gcount++
return
dgtime:
  if gcount=2
  {
    temp := clipboard
    clipboard := ""
    send {blind}^+{home}^{x}
    clipwait
    if (clipboard = "")
      clip1 := temp
    else
      clip1 := clipboard
    clipboard := temp
  }
  keywait g
  dExit()
return

; caps keys vim d 2

#if (getkeystate("capslock","p") or GetKeyState("RAlt", "P")) && (dcount=2) && !numberSwitch && !winactive("ahk_exe vmconnect.exe") && !winactive("ahk_exe mstsc.exe")

w::
  settimer, dtime, off
  tooltip %dcount% d w
  dExit()
return

; caps keys vim y 1

#if (getkeystate("capslock","p") or GetKeyState("RAlt", "P")) && (ycount=1) && !numberSwitch && !winactive("ahk_exe vmconnect.exe") && !winactive("ahk_exe mstsc.exe")

0::
a::
  settimer, ytime, off
  send {blind}+{home}^{c}
  yExit()
return

e::
  settimer, ytime, off
  send {blind}+{end}^{c}
  yExit()
return

w::
  settimer, ytime, off
  if !n
    n=1
  loop %n%
  {
    send {blind}^{right}^+{left}^{c}
  }
  yExit()
return

g::
  settimer, ytime, off
  if !gcount
    settimer, ygtime, -300
  gcount++
return
ygtime:
  if gcount=2
    send {blind}^+{home}^{c}
  keywait g
  yExit()
return

; caps keys vim y 2

#if (getkeystate("capslock","p") or GetKeyState("RAlt", "P")) && (ycount=2) && !numberSwitch && !winactive("ahk_exe vmconnect.exe") && !winactive("ahk_exe mstsc.exe")

w::
  settimer, ytime, off
  tooltip %ycount% y w
  yExit()
return