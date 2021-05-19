commandRoot(subroutine := "", parameters*) {
  _hwnd := winExist("A")
  winGetClass wClass, ahk_id %_hwnd%
  if (wClass == "ExploreWClass" || wClass == "CabinetWClass") {
    for window in comObjCreate("Shell.Application").windows
      if (window.hwnd == _hwnd)
      _path := try window.document.folder.self.path
    run powershell -noe -c &{ set-location '%_path%' }
    return
  } else {
    if winExist("ahk_class ConsoleWindowClass")
      winActivate
    else {
      run powershell -noe -c &{set-location "$([environment]::getfolderpath('desktop'))"}
    }
  }
}

choco(){
  global chocoPath := a_appDataCommon . "\chocolatey\bin"
  if !fileExist(chocoPath) {
    chocoTask =
    (
    if (-not (Test-Path -Path 'Env:\ChocolateyInstall')) {
      reg add hklm\software\microsoft\.netframework\v4.0.30319 /v SchUseStrongCrypto /t REG_DWORD /d 1 /f
      reg add hklm\software\wow6432node\microsoft\.netframework\v4.0.30319 /v SchUseStrongCrypto /t REG_DWORD /d 1 /f
      reg add 'hklm\software\policies\microsoft\internet explorer\main' /v disablefirstruncustomize /t REG_DWORD /d 1 /f
      Set-ExecutionPolicy Bypass -Scope Process -Force
      [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
      Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
      choco feature enable -n=allowglobalconfirmation
      choco feature enable -n=userememberedargumentsforupgrades
    }
    if (-not (Get-ScheduledTask | Where-Object TaskName -Match 'choco-upgrade-all-at')) {
      choco upgrade choco-upgrade-all-at
    }
    )
    run powershell.exe -c &{%chocoTask%}
  }
  if !fileExist(chocoPath) {
    msgBox, 4096,, choco not installed.`nexiting.
    exit
  }
}

camelCase(){
  oldClipboard := clipboard
  clipboard := ""
  sendInput {blind}^{c}
  clipWait 0.25
  newClipboard = %clipboard%
  if (!newClipboard or newClipboard = oldClipboard){
    sendInput {blind}{home}{home}+{end}^{c}
    clipWait 0.25
    ;sleep 100
    if (errorLevel){
      msgBox % "error at sendPlay {home}{home}+{end}^{c}"
    }
  }
  stringReplace clipboard,clipboard,',',useErrorLevel
  if ((errorLevel & 1) != 0){
    msgbox % "warning: unhandled quotes"
    newClipboard := regExReplace(clipboard, "(?=([^""]*("")[^""]*(""))*[^""]*$)([^a-zA-Z""]|\b)[a-zA-Z]", "$l0")
  } else {
    newClipboard := regExReplace(clipboard, "(?=([^""']*(""|')[^""']*(""|'))*[^""']*$)([^a-zA-Z""']|\b)[a-zA-Z]", "$l0")
  }
  clipboard := newClipboard
  clipWait 0.25
  if (errorLevel){
    msgBox % "error at clipboard := newClipboard"
  }
  sendInput {blind}^{v}
  sleep 100
  clipboard := oldClipboard
}

getMonMouseIn(monitor = 0) {
  mouseGetPos, monMouseInX, monMouseInY
  sysGet, monitorCount, 80 ; monitorcount, so we know how many monitors there are, and the number of loops we need to do
  loop, %monitorCount%
  {
    sysGet, mon%a_index%, monitor, %a_index% ; "monitor" will get the total desktop space of the monitor, including taskbars
    if ( monMouseInX >= mon%A_Index%left ) && ( monMouseInX < mon%A_Index%right ) && ( monMouseInY >= mon%A_Index%top ) && ( monMouseInY < mon%A_Index%bottom )
    {
      activeMon := a_index
      break
    }
  }
  return activeMon
}

cmdOutVar(sCmd, sEncoding:="CP0", sDir:="", ByRef nExitCode:=0) {
  dllCall( "CreatePipe", PtrP,hStdOutRd, PtrP,hStdOutWr, Ptr,0, UInt,0 )
  dllCall( "SetHandleInformation", Ptr,hStdOutWr, UInt,1, UInt,1 )
  varSetCapacity( pi, (a_ptrSize == 4) ? 16 : 24, 0 )
  siSz := varSetCapacity( si, (a_ptrSize == 4) ? 68 : 104, 0 )
  numPut( siSz, si, 0, "UInt" )
  numPut( 0x100, si, (a_ptrSize == 4) ? 44 : 60, "UInt" )
  numPut( hStdOutWr, si, (a_ptrSize == 4) ? 60 : 88, "Ptr" )
  numPut( hStdOutWr, si, (a_ptrSize == 4) ? 64 : 96, "Ptr" )

  if ( !dllCall( "CreateProcess", ptr,0, ptr,&sCmd, ptr,0, ptr,0, int,true, uInt,0x08000000
    , ptr,0, ptr,sDir?&sDir:0, ptr,&si, ptr,&pi ) )
  return ""
  , dllCall( "CloseHandle", ptr,hStdOutWr )
  , dllCall( "CloseHandle", ptr,hStdOutRd )

  dllCall( "CloseHandle", ptr,hStdOutWr )
  while ( 1 )
  {
    if ( !dllCall( "PeekNamedPipe", ptr,hStdOutRd, ptr,0, uInt,0, ptr,0, uIntP,nTot, ptr,0 ) )
      break
    if ( !nTot )
    {
      sleep, 100
      continue
    }
    varSetCapacity(sTemp, nTot+1)
    dllCall( "ReadFile", Ptr,hStdOutRd, Ptr,&sTemp, UInt,nTot, PtrP,nSize, Ptr,0 )
    sOutput .= StrGet(&sTemp, nSize, sEncoding)
  }

  dllCall( "GetExitCodeProcess", ptr,numGet(pi,0), uIntP,nExitCode )
  dllCall( "CloseHandle", ptr,numGet(pi,0) )
  dllCall( "CloseHandle", ptr,numGet(pi,a_ptrSize) )
  dllCall( "CloseHandle", ptr,hStdOutRd )
  return sOutput
}

getPublicIP() {
  if (ConnectedToInternet()){
    webObj := comObjCreate("winHttp.winHttpRequest.5.1")
    webObj.open("get", "https://checkip.amazonaws.com/")
    webObj.send()
    publicIP := webObj.responseText
    regExMatch(publicIP, "(x\.x\.x\.x|x\.x\.x\.x)" , pubIP)
    if (pubIP1 ){
      guicontrol, +c935c25, mainPublicIP
    } else {
      guicontrol, +c9AA83A, mainPublicIP
    }
    guicontrol, text, mainPublicIP, %publicIP%
  }
}

getDrives(){
  global
  Loop, parse, driveList
  {
    currentDrive := a_loopField ":\"
    driveGet, driveStatus, status, %currentDrive%
    if (driveStatus = "Ready"){
      driveGet, driveTotalRaw, capacity, %currentDrive%
      driveSpaceFree, driveFreeRaw, %currentDrive%
      driveUsedRaw := driveTotalRaw - driveFreeRaw
      driveUsed := round((driveUsedRaw / 1000),1) . " GB"
      driveFree := round((driveFreeRaw / 1000),1) . " GB"
      driveTotal := round((driveTotalRaw / 1000),1) . " GB"
      drivePercent := round((driveUsedRaw / driveTotalRaw) * 100)
      guiControl, , drive%a_index%Percent, %drivePercent%
      guiControl, text, drive%a_index%, %A_LoopField%: %driveUsed%, %driveTotal%
      if a_loopField = C
        guiControl, +c6089B4, drive%a_index%Percent
    }
  }
}

getCPU(){
  static PIT, PKT, PUT
  ifEqual, PIT,, return 0, dllCall( "GetSystemTimes", "Int64P",PIT, "Int64P",PKT, "Int64P",PUT )

  dllCall( "GetSystemTimes", "Int64P",CIT, "Int64P",CKT, "Int64P",CUT )
  , IdleTime := PIT - CIT, KernelTime := PKT - CKT, UserTime := PUT - CUT
  , SystemTime := KernelTime + UserTime 

  cpuLoad := ( ( SystemTime - IdleTime ) * 100 ) // SystemTime, PIT := CIT, PKT := CKT, PUT := CUT
  guicontrol, text, mainCPU, % "CPU: " cpuLoad "%"
  guiControl,, cpuPercent, %cpuLoad%
}

globalMemoryStatusEx() {
  static MEMORYSTATUSEX, init := varSetCapacity(MEMORYSTATUSEX, 64, 0) && numPut(64, MEMORYSTATUSEX, "UInt")
  if (dllCall("Kernel32.dll\GlobalMemoryStatusEx", "Ptr", &MEMORYSTATUSEX))
  {
    return { 2 : numGet(MEMORYSTATUSEX, 8, "UInt64")
      , 3 : numGet(MEMORYSTATUSEX, 16, "UInt64")
      , 4 : numGet(MEMORYSTATUSEX, 24, "UInt64")
    , 5 : numGet(MEMORYSTATUSEX, 32, "UInt64") }
  }
}

getMemory(){
  GMSEx := globalMemoryStatusEx()
  GMSExM01 := round(GMSEx[2] / 1024**2, 2) ; total physical memory in MB
  GMSExM02 := round(GMSEx[3] / 1024**2, 2) ; available physical memory in MB
  GMSExM03 := round(GMSExM01 - GMSExM02, 2) ; used physical memory in MB
  GMSExM04 := round(GMSExM03 / GMSExM01 * 100) ; used physical memory in %
  guiControl, text, mainRAM, % "RAM: " GMSExM04 "%"
  guiControl,, ramPercent, %GMSExM04%
}

getDate(){
  formatTime,date,,ddMMMyy
  stringUpper, date, date
  guiControl, text, mainDate, %date%
}