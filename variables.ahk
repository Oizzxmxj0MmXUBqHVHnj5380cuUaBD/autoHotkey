global downloadsPath
envGet, downloadsPath, downloadsPath
if (!downloadsPath){
  downloadsPath = % comObjCreate("shell.application").nameSpace("shell:downloads").self.path
  if (!downloadsPath){
    msgBox couldn't get downloadsPath.`nexiting
    exit
  }
  regWrite, reg_sz, HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment, downloadsPath, %downloadsPath%
  envUpdate
}

caffeine = 0

setTrans = 1

guiWidth := (A_ScreenWidth / 10)
guiHalfWidth := (guiWidth / 2)
guiQuarterWidth := (guiWidth / 4)
listViewWidth := (A_ScreenWidth / 3)

regRead, cur, HKEY_cURRENT_uSER\SOFTWARE\microsoft\windows\currentVersion\explorer\sessionInfo\1\virtualDesktops, currentVirtualDesktop
regRead, all, HKEY_cURRENT_uSER\SOFTWARE\microsoft\windows\currentVersion\explorer\virtualDesktops, virtualDesktopIDs
global currentDesktop := (floor(InStr(all,cur) / strlen(cur)) + 1)

; variables for icons in file browser
sfi_size := a_ptrSize + 8 + (a_isUnicode ? 680 : 340)
varSetCapacity(sfi, sfi_size)

imageListFiles := iL_create(10)
imageListBookmarks := iL_create(10)
imageListSystem := iL_create(10)