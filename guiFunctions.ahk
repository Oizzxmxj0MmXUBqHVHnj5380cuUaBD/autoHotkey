createGUI(){
  global
  gui, color,101010
  gui, margin, 2, -5
  gui, -caption +border +owner +lastFound +hwndHwnd3 -dPIScale ; +alwaysOnTop 
  getWeather()
  gui, add, text, x0 y+5 w%guiWidth% r0.25 0x10

  ; cpu / ram

  gui, font, s9 q5 cebf8ff
  ; populate elemets for cpu and ram to update
  gui, add, text,     x2  y+5   w%guiWidth%                         cffffff backgroundtrans vmainCPU    gopenTaskmgr
  gui, add, progress, x0  yp-1  wp          r1    background101010  c219186                 vcpuPercent
  gui, add, text,     x2  y+5   wp                                  cffffff backgroundtrans vmainRAM    gopenTaskmgr
  gui, add, progress, x0  yp-1  w%guiWidth% r1    background101010  c935c25                 vramPercent
  gui, add, text,     x0  y+7   w%guiWidth% r0.25         0x10

  ; drives

  driveGet, driveList, list
  firstDrive = 1
  loop, parse, driveList
  {
    if (firstDrive){
      firstDrive = 0
      ; v%a_loopField% resolves to drive letter, openListView gets gui_click, sees single character, and displays drive
      gui, add, text,     x0 y+5  w%guiWidth% r1 cffffff                  v%a_loopField%         gopenListView
      gui, add, progress, x0 yp   w%guiWidth% r1 c219186 background101010 vdrive%a_index%Percent
      gui, add, text,     x2 yp+1 w%guiWidth%    cffffff backgroundtrans  vdrive%a_index%
    } else {
      gui, add, text,     x0 y+5  w%guiWidth% r1 cffffff                  v%a_loopField%         gopenListView
      gui, add, progress, x0 yp   w%guiWidth% r1 c935c25 background101010 vdrive%a_index%Percent
      gui, add, text,     x2 yp+1 w%guiWidth%    cffffff backgroundtrans  vdrive%a_index%
    }
  }
  getDrives()
  gui, add, text, x2 y+7 w%guiWidth% r0.25 0x10

  ; shortcuts

  gui, add, text, x2              y+5   cebf8ff       gguiExplorer,   explorer
  gui, add, text,                          vdownloads gopenListView,  % " downloads"
  gui, add, text,                       cce6700       gfirefox,       firefox

  gui, font, s7 q5 cebf8ff
  gui, add, text, x%guiHalfWidth% yp                      gscrcpy,          scrcpy
  gui, add, text, x%guiHalfWidth% yp                      gtvnviewer,       t&vnviewer
  gui, add, text, x2              y+5        vsyncthing   gsyncthing,       syncthing
  gui, add, text, x%guiHalfWidth% yp c935c25 vcaffeineGui gcaffeine,        ca&ffeine


  gui, add, text, x0              y+5 w%guiWidth%   r0.25 0x10

  ; ip addresses

  gui, font, s10 q5 cebf8ff
  gui, add, text, w%guiWidth% r1 vmainLocalIP  gncpa
  gui, add, text, w%guiWidth%    vmainPublicIP gncpa
  gosub getLocalIP
  gui, add, text, x0 y+5 w%guiWidth% r0.25 0x10

  ; volume

  gui, add, slider, x0 w%guiWidth% range0-100 gVol vSet ,% volume

  ; date

  gui, font, s14 cebf8ff
  gui, add, text, w%guiWidth% r1.25 vmainDate
  getDate()

  desktopIndicatorX := (guiWidth - 30)
  gui, add, text, x%desktopIndicatorX% yp r1.25 c606060 backgroundtrans vmainDesktop, %currentDesktop%
  gui, font, s8 cebf8ff
  gui, show, hide
  winGetPos,,,, guiHeight

  ; listview
  gui, add, listView, x%guiWidth% y0 w%listViewWidth% h%guiHeight% vguiListView gguiExecute altSubmit, name | type | size | date | fullPath
}

showSystemGui(){
  global
  capsToggle=0
  capsToggle2=1
  lv_delete()
  lV_setImageList(imageListSystem)
  guiControl, -redraw, guiListView

  il_add(imageListSystem, a_winDir "\system32\mmsys.cpl",1)
  lv_add("Icon" . 1,"audioDevices",,-1)

  il_add(imageListSystem, a_winDir "\system32\sysdm.cpl",1)
  lv_add("Icon" . 2,"env",,-1)

  il_add(imageListSystem, a_winDir "\system32\mstsc.exe",1)
  lv_add("Icon" . 3,"mstsc",,-1)

  il_add(imageListSystem, a_winDir "\system32\ncpa.cpl",1)
  lv_add("Icon" . 4,"ncpa.cpl",,-1)

  il_add(imageListSystem, a_winDir "\system32\control.exe",1)
  lv_add("Icon" . 5,"networkShareCenter",,-1)

  il_add(imageListSystem, a_winDir "\system32\appwiz.cpl",1)
  lv_add("Icon" . 6,"programsFeatures",,-1)

  il_add(imageListSystem, a_winDir "\regedit.exe",1)
  lv_add("Icon" . 7,"regedit",,-1)

  il_add(imageListSystem, a_winDir "\system32\miguiresource.dll",2)
  lv_add("Icon" . 8,"taskschd",,-1)

  il_add(imageListSystem, a_winDir "\system32\imageres.dll", 4)
  lv_add("Icon" . 9,"startFolders",,-1)

  lv_add("Icon" . 9,"themeFolder",,-1)

  ;lv_modifycol(0,30)
  lv_modifycol(1)
  lv_modifycol(2,0)
  lv_modifycol(3,0)
  lv_modifycol(4,0)
  lv_modifycol(5,0)
  GuiControl, +Redraw, guiListView
  newWidth := (guiWidth + listViewWidth)
  gui, show, w%newWidth%
}

guiShow(){
  global
  if !capsToggle {
    capsToggle=1
    mouseGetPos, capsMouseX, capsMouseY
    activeMon := getMonMouseIn()
    sysGet, mwa%activeMon%, monitorWorkArea, %activeMon%
    final_x := max(mwa%activeMon%left, min(capsMouseX, mwa%activeMon%right - guiWidth))
    final_y := max(mwa%activeMon%top, min(capsMouseY, mwa%activeMon%bottom - guiHeight))
    getDate()
    getCPU()
    getMemory()
    soundGet, volume
    guicontrol,, set, % volume
    gui, show, x%final_x% y%final_y% w%guiWidth%
    winSet, transparent, 230, .ahk
  } else {
    guiHide()
  }
}

guiHide(){
  global
  capsToggle = 0
  capsToggle2 = 0
  bookmarksToggle = 0
  listviewToggle = 0
  previousFolder =
  bookMarksOpen = 0
  gui, hide
  gui, system:hide
}

guiExecute(){
  global
  if (A_GuiEvent = "DoubleClick"){
    listViewFocused := lv_getNext(0, "focused")
    lv_getText(lvName, listViewFocused,1)

    if (lvName = ".."){
      openListView(parentFolder)
    } else {
      lv_getText(fullPath, listViewFocused, 5)
      lv_getText(fileSize, listViewFocused, 3)
      if (fileSize = ""){ ; no file size = folder
        openListView(fullPath)
      } else if (fileSize = "-1"){ ; size manually set in functionsGUIshortcuts.ahk
        %lvName%()
      }
      else {
        guiHide()
        run %fullPath%,, useErrorLevel
      }
      if errorLevel
        msgBox could not open "%fullPath%".
    }
  }
}

guiDelete(){
  global
  listViewFocused := lv_getNext(0, "Focused")
  lv_getText(lvFullPath, listViewFocused,5)

  msgBox, 1, %lvFullPath%, delete %lvFullPath%?`n%bookmarksToggle%
  ifmsgBox ok
  {
    splitpath, lvFullPath,,parentOfDeleted
    fileRecycle %lvFullPath%
    openListView(parentOfDeleted)
  }
}

checkSyncthing(){
  if (!winExist("ahk_exe synctrayzor.exe")){
    guicontrol, +c935c25, syncthing
  } else {
    guicontrol, +c9AA83A, syncthing
  }
}