#if !numberSwitch && !winactive("ahk_exe vmconnect.exe") && !winactive("ahk_exe mstsc.exe")

`::esc

#wheelUp::sendInput ^+{tab}
#wheelDown::sendInput ^{tab}

lwin up::
  if (!lwinOpen){
    lwinOpen = 1
    run everything.exe -p "%a_appData%\microsoft\windows\start menu\programs""""|""""%A_AppDataCommon%\microsoft\windows\start menu\programs" -s ".lnk "
  } else {
    lwinOpen = 0
    winClose ahk_class EVERYTHING
  }
return

#c::
  guiHide()
  if (getVirtualDesktopCount() < 2){
    send ^#d
  }
  switchDesktop(2)
  guicontrol, text, mainDesktop, 2
  run "%A_ProgramFiles%\Google\Chrome\Application\chrome.exe" --profile-directory="Default" google.com, "%A_ProgramFiles%\Google\Chrome\Application"
  run "%A_ProgramFiles%\Google\Chrome\Application\chrome.exe" --profile-directory="Profile 1" google.com, "%A_ProgramFiles%\Google\Chrome\Application"
return

lwin & space::
  ;setTimer, closeButtonTimer, off
  winGet, active_id, ID, a
  winSet, transparent, 25, ahk_id %active_id%
return
#space up::
  ;setTimer, closeButtonTimer, 50
  winGet, active_id, ID, a
  winSet, transparent, 255, ahk_id %active_id%
return

#s::suspend, toggle

alt & wheelUp::volume_up
alt & wheelDown::volume_down
alt & mButton::volume_mute

#rbutton::
  mousegetpos,,, currentWindowID
  winget, currentWindow, minmax, ahk_id %currentWindowID%
  if (setTrans){
    winSet, transparent, 230, ahk_id %currentWindowID%
  } else {
    winSet, transparent, 255, ahk_id %currentWindowID%
  }
  setTrans := !setTrans
return

#mbutton::
  mousegetpos,,, currentWindowID
  winget, currentWindow, minmax, ahk_id %currentWindowID%
  if (setTrans){
    winSet, transparent, 25, ahk_id %currentWindowID%
  } else {
    winSet, transparent, 255, ahk_id %currentWindowID%
  }
  setTrans := !setTrans
return

#g::
  clipboard=
  send, ^c
  sleep 0025
  run, http://www.google.com/search?q=%clipboard%
return

#e::run "shell:::{20D04FE0-3AEA-1069-A2D8-08002B30309D}"

$capslock::guiShow()

~$lctrl::
  keyWait lctrl, t0.25
  if !errorlevel {
    if (a_priorKey = "LControl")
      send {esc}
  }
  keywait lctrl
return

!z::reload