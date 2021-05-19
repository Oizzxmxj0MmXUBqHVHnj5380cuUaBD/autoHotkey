#if getKeyState("capslock", "P") && !numberSwitch && !capsToggle && !winActive("ahk_exe vmconnect.exe") && !winActive("ahk_exe mstsc.exe")

`::send ``

enter::send ^!{tab}

t::
\::commandRoot()

esc::`
;f::F4
7::ListLines
8::ListVars
9::ListHotkeys
0::KeyHistory
-::Volume_Down
=::Volume_Up

space::send {blind}{del downtemp}
space up::send {blind}{del up}
+space::send {blind}{backspace downtemp}
+space up::send {blind}{backspace up}

.::send {home}{home}{tab}
,::send {home}+{tab}
>::send {home}{home}+{end}+{right}^{x}{end}{enter}{home}^{v}{delete}{up}
<::send {home}{home}+{end}+{right}^{x}{up}^{v}{up}

q::
  if (getVirtualDesktopCount() < 2){
    send ^#d
    switchDesktop(1)
  }
  wintitleOfActiveWindow:="ahk_id " WinActive("A")
  sendWindowToDesktop(wintitleOfActiveWindow,2,true)
  while (getVirtualDesktopCount() > 2) {
    fixVDs = 1
    switchDesktop(getVirtualDesktopCount())
    send #^{f4}
  }
  if (fixVDs){
    switchDesktop(2)
  }
return

tab::
  wintitleOfActiveWindow:="ahk_id " WinActive("A")
  sendWindowToDesktop(wintitleOfActiveWindow,1,true)
return