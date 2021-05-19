; Capslock or xbutton1 and...
; scroll up = maximize current window
; scroll down = minimize
; middle button = close
; lbutton drag = move window
; rbutton drag = resize

#if !numberSwitch && !winactive("ahk_exe vmconnect.exe") && !winactive("ahk_exe mstsc.exe")

xbutton1 & wheelup::
capslock & wheelup::
  mousegetpos,,, currentWindowID
  winget, currentWindow, minmax, ahk_id %currentWindowID%
  if currentWindow {
    postMessage, 0x112, 0xF120,,, ahk_id %currentWindowID%
  }
  else {
    winmaximize, ahk_id %currentWindowID%
  }
return

xbutton1 & wheeldown::
capslock & wheeldown::
  mousegetpos,,, currentWindowID
  winget, currentWindow, minmax,ahk_id %currentWindowID%
  winminimize, ahk_id %currentWindowID%
return

xbutton1 & mbutton::
capslock & mbutton::
  mousegetpos,,, currentWindowID
  winget, currentWindow, minmax, ahk_id %currentWindowID%
  winClose, ahk_id %currentWindowID%
return

;xbutton1 & lbutton::
capslock & lbutton::
  mousegetpos, currentWindow_x1, currentWindow_y1, currentWindowID
  winget, currentWindow, minmax, ahk_id %currentWindowID%
  winrestore, ahk_id %currentWindowID%
  wingetpos, currentWindowX1, currentWindowY1,,, ahk_id %currentWindowID%
  loop
  {
    getkeystate, currentWindow_button, lbutton, p
    if currentWindow_button = u
      break
    mousegetpos, currentWindow_x2, currentWindow_y2
    currentWindow_x2 -= currentWindow_x1
    currentWindow_y2 -= currentWindow_y1
    currentWindowX2 := (currentWindowX1 + currentWindow_x2)
    currentWindowY2 := (currentWindowY1 + currentWindow_y2)
    winmove, ahk_id %currentWindowID%,, %currentWindowX2%, %currentWindowY2%
  }
return

xbutton1 & rbutton::
capslock & rbutton::
  mousegetpos, currentWindow_x1, currentWindow_y1, currentWindowID
  winget, currentWindow, minmax, ahk_id %currentWindowID%
  winrestore, ahk_id %currentWindowID%
  wingetpos, currentWindowX1, currentWindowY1, currentWindowW, currentWindowH, ahk_id %currentWindowID%
  if (currentWindow_x1 < currentWindowX1 + currentWindowW / 2)
  currentWindowleft := 1
  else
    currentWindowleft := -1
  if (currentWindow_y1 < currentWindowY1 + currentWindowH / 2)
  currentWindowup := 1
  else
    currentWindowup := -1
  loop
  {
    getkeystate, currentWindow_button, rbutton, p
    if currentWindow_button = u
      break
    mousegetpos, currentWindow_x2, currentWindow_y2
    wingetpos, currentWindowX1, currentWindowY1, currentWindowW, currentWindowH, ahk_id %currentWindowID%
    currentWindow_x2 -= currentWindow_x1
    currentWindow_y2 -= currentWindow_y1
    winmove, ahk_id %currentWindowID%,, currentWindowX1 + (currentWindowleft+1)/2*currentWindow_x2
    , currentWindowY1 + (currentWindowup+1)/2*currentWindow_y2
    , currentWindowW - currentWindowleft *currentWindow_x2
    , currentWindowH - currentWindowup *currentWindow_y2
    currentWindow_x1 := (currentWindow_x2 + currentWindow_x1)
    currentWindow_y1 := (currentWindow_y2 + currentWindow_y1)
  }
return

xbutton1 & lbutton::
capslock & xbutton1::send {blind}^!{tab downtemp}
xbutton1 & lbutton up::
capslock & xbutton1 up:: send {blind}^!{tab up}

xbutton1::
  if !xbutton1tap
    settimer, xbutton1tap, -300
  xbutton1tap++
return
xbutton1tap:
  if (xbutton1tap = 2){
    guiShow()
  } else {
    send {xbutton1}
  }
  keywait, xbutton1
  xbutton1tap =
return