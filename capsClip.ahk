; Capslock + shift + 1, 2, or 3 copies selected text into a clipboard. Capslock + 1, 2, or 3 pastes that text.
; Capslock + backspace selects all and cuts everything to a 4th clipboard. Capslock + 4 or capslock + hold backspace pastes that text.
; Capslock + shift + backspace is the same but it copies it instead of cutting

#if getKeyState("capslock", "P") && !numberSwitch && !capsToggle && !winActive("ahk_exe vmconnect.exe") && !winActive("ahk_exe mstsc.exe")

:*:1::
  k=
  input, k, l1 i t0.25
  if (k = "1") {
    input, k, l1 i t0.25
    if (k = "1") {
      ; 3 taps: tooltip
      tooltip %clip1%
      sleep, 2000
      tooltip
    } 
    else {
      ; 2 taps: copy
      temp := clipboard
      clipboard := ""
      send ^c
      clipwait
      if (clipboard = "")
        clip1 := temp
      else
        clip1 := clipboard
      clipboard := temp
    }
  }
  else {
    if (!getKeyState("1", "P")){
      ; 1 tap: paste
      temp := clipboard
      clipboard := ""
      clipboard := clip1
      clipwait
      send ^v
      sleep 300
      clipboard := temp
    }
    else {
      ; hold action: tooltip
      tooltip %clip1%
      while (getKeyState("1")) {
        sleep, 10
      }
      tooltip 
    }
  }
return

:*:2::
  k=
  input, k, l1 i t0.25
  if (k = "2") {
    input, k, l1 i t0.25
    if (k = "2") {
      {
        tooltip %clip2%
        sleep, 1000
        tooltip
      }
    } else {
      temp := clipboard
      clipboard := ""
      send ^c
      clipwait
      if (clipboard = "")
        clip2 := temp
      else
        clip2 := clipboard
      clipboard := temp
    }
  } else {
    temp := clipboard
    clipboard := ""
    clipboard := clip2
    clipwait
    send ^v
    sleep 300
    clipboard := temp
  }
return

:*:3::
  k=
  input, k, l1 i t0.25
  if (k = "3") {
    input, k, l1 i t0.25
    if (k = "3") {
      {
        tooltip %clip3%
        sleep, 1000
        tooltip
      }
    } else {
      temp := clipboard
      clipboard := ""
      send ^c
      clipwait
      if (clipboard = "")
        clip3 := temp
      else
        clip3 := clipboard
      clipboard := temp
    }
  } else {
    temp := clipboard
    clipboard := ""
    clipboard := clip3
    clipwait
    send ^v
    sleep 300
    clipboard := temp
  }
return

4::
  temp := clipboard
  clipboard := ""
  clipboard := clip4
  clipwait
  send ^v
  sleep 400
  clipboard := temp
return
^4::
  tooltip %clip4%
  sleep, 1000
  tooltip
return

backspace::
  if (!backspaceTap){
    settimer, backspaceTap, -300
  }
  backspaceTap++
return
backspaceTap:
  if (getkeystate("backspace","p")){
    temp := clipboard
    clipboard := ""
    clipboard := clip4
    clipwait
    send ^v
    sleep 300
    clipboard := temp
  } else if (backspaceTap = 1){
    temp := clipboard
    clipboard := ""
    send ^a^x
    clipwait
    if (clipboard = ""){
      clip4 := temp
    } else {
      clip4 := clipboard
    }
    clipboard := temp
  }
  keywait, backspace
  backspaceTap =
return

+backSpace::
  temp := clipboard
  clipboard := ""
  send ^a^c
  clipwait
  if (clipboard = "")
    clip4 := temp
  else
    clip4 := clipboard
  clipboard := temp
return

; another way

; 1::
;   temp := clipboard
;   clipboard := ""
;   clipboard := clip1
;   clipwait
;   send ^v
;   sleep 300
;   clipboard := temp
; return
; ^1::
;   tooltip %clip1%
;   sleep, 1000
;   tooltip
; return
; +1::
;   temp := clipboard
;   clipboard := ""
;   send ^c
;   clipwait
;   if (clipboard = "")
;     clip1 := temp
;   else
;     clip1 := clipboard
;   clipboard := temp
; return