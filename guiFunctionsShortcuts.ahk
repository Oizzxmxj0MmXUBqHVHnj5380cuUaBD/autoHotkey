guiExplorer(){
  run "shell:::{20D04FE0-3AEA-1069-A2D8-08002B30309D}" ; for qttabbar
  guiHide()
}

explorer(){
  guiHide()
  if winExist, explorer
    winActivate
  else
    run "shell:::{20D04FE0-3AEA-1069-A2D8-08002B30309D}"
}

firefox(){
  guiHide()
  if !fileExist(a_programFiles . "\Mozilla Firefox\firefox.exe"){
    choco()
    run cup firefox
  }
  if (winExist("ahk_exe firefox.exe")){
    winActivate, ahk_class mozillaWindowClass
    winActivate, firefox
  }
  else
    run firefox
}

caffeine(){
  global
  guiHide()
  if !caffeine {
    guicontrol, +c9AA83A, caffeineGui
    run powercfg.exe /X monitor-timeout-ac 0,, hide
    run powercfg.exe /X monitor-timeout-dc 0,, hide
    run powercfg.exe /X standby-timeout-ac 0,, hide
    run powercfg.exe /X standby-timeout-dc 0,, hide
    run powercfg.exe /X hibernate-timeout-ac 0,, hide
    run powercfg.exe /X hibernate-timeout-dc 0,, hide
  } else {
    guicontrol, +c935c25, caffeineGui
    run powercfg.exe /X monitor-timeout-ac 10,, hide
    run powercfg.exe /X monitor-timeout-dc 3,, hide
    run powercfg.exe /X standby-timeout-ac 0,, hide
    run powercfg.exe /X standby-timeout-dc 5,, hide
    run powercfg.exe /X hibernate-timeout-ac 0,, hide
    run powercfg.exe /X hibernate-timeout-dc 10,, hide
  }
  caffeine := !caffeine
}

tvnviewer(){
  guiHide()
  if !fileexist(a_programfiles . "\tightvnc\tvnviewer.exe") {
    choco()
    runwait, cup tightvnc -ia 'ADDLOCAL=Viewer', %chocoPath%
  }
  run %programfiles%\tightvnc\tvnviewer.exe
}

scrcpy(){
  guiHide()
  if !fileexist(a_appdatacommon . "\chocolatey\bin\scrcpy.exe") {
    choco()
    ;sleep 5000
    runwait cup scrcpy, %chocoPath%
  }
  ;run %a_appdatacommon%\chocolatey\bin\adb.exe shell ime set --user 0 com.farmerbb.secondscreen.free/com.farmerbb.secondscreen.service.DisableKeyboardService,,hide
  run %a_appdatacommon%\chocolatey\bin\scrcpy.exe -S --stay-awake --window-borderless --render-driver=opengls,,hide
}

ncpa(){
  guiHide()
  run ncpa.cpl
}

env(){
  guiHide()
  run rundll32.exe sysdm.cpl`, EditEnvironmentVariables
}

networkShareCenter(){
  guiHide()
  run control.exe /name microsoft.networkandsharingcenter
}

audioDevices(){
  guiHide()
  run mmsys.cpl
}

programsFeatures(){
  guiHide()
  run appwiz.cpl
}

regedit(){
  guiHide()
  run regedit
}

mstsc(){
  guiHide()
  run mstsc.exe
}

platformTools(){
  global
  guiHide()
  if !fileexist(a_appdatacommon . "\chocolatey\bin\adb.exe") {
    choco()
    runwait cup adb, %chocoPath%
  }
  run cmd /k cd /d "%downloads%"
  sleep 404
  send adb{space}
}

taskschd(){
  guiHide()
  run taskschd.msc
}

startFolders(){
  guiHide()
  run explorer.exe "%A_AppData%\microsoft\windows\start menu\programs"
  run explorer.exe "%A_AppDataCommon%\microsoft\windows\start menu\programs"
}

themeFolder(){
  guiHide()
  run explorer.exe "%a_windir%\resources\themes"
}

openTaskmgr(){
  guiHide()
  run taskmgr
}

syncthing() {
  guiHide()
  run %a_programfiles%\synctrayzor\synctrayzor.exe
}