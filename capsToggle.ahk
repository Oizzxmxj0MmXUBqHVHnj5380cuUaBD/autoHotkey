#if capsToggle && !winactive("ahk_exe vmconnect.exe") && !winactive("ahk_exe mstsc.exe") && !numberSwitch

a::
  guiHide()
  sleep 50
  mousegetpos,,, currentWindowID
  winget, currentWindow, minmax, ahk_id %currentWindowID%
  winSet, alwaysOnTop, toggle, ahk_id %currentWindowID%
  ;winClose, ahk_id %currentWindowID%
return

r::reload

space::showSystemGui()

e::
  guiHide()
  run "shell:::{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
return

x::
  guiHide()
  send !{f4}
return

f::firefox()

c::
  guiHide()
  ;sleep 50
  camelCase()
return

tab::
1::
  guiHide()
  switchDesktop(1)
  guicontrol, text, mainDesktop, 1
return

q::
2::
  guiHide()
  if (getVirtualDesktopCount() < 2){
    send ^#d
    ;switchDesktop(1)
  }
  switchDesktop(2)
  guicontrol, text, mainDesktop, 2
return

#if (capsToggle || capsToggle2 || bookmarksToggle) && !winactive("ahk_exe vmconnect.exe") && !winactive("ahk_exe mstsc.exe") && !numberSwitch

capslock & space::
  guiDelete()
  global listViewSwitch = 0
return

enter::guiExecute()

~lbutton::
esc::
  MouseGetPos, , , id, control
  WinGetTitle, title, ahk_id %id%
  WinGetClass, class, ahk_id %id%
  if (title != ".ahk" and class != "#32770"){
    sleep 50
    guiHide()
  }
return

#if capsToggle2 && !winactive("ahk_exe vmconnect.exe") && !winactive("ahk_exe mstsc.exe") && !numberSwitch

a::audioDevices()

e::env()

m::mstsc()

n::ncpa()

s::networkShareCenter()

p::programsFeatures()

r::regedit()

t::taskschd()

l::platformTools()

f::startFolders()

o::themeFolder()