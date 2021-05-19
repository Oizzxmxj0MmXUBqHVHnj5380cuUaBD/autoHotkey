initializeVirtualDesktops()
{
  global
  iVirtualDesktopManager := comObjCreate("{AA509086-5CA9-4C25-8F95-589D3C07B48A}", "{A5CD92FF-29BE-454C-8D04-D82879FB3F1B}")
  getWindowDesktopID := vTableVirtualDesktops(iVirtualDesktopManager, 4)
  iServiceProvider := comObjCreate("{C2F03A33-21F5-47FA-B4BB-156362A2F239}", "{6D5140C1-7436-11CE-8034-00AA006009FA}")
  iVirtualDesktopManagerInternal := comObjQuery(iServiceProvider, "{C5E0CDCA-7B6E-41B2-9FC4-D93975CC467B}", "{F31574D6-B682-4CDC-BD56-1827860ABEC6}")
  moveViewToDesktop := vTableVirtualDesktops(iVirtualDesktopManagerInternal, 4) ; void moveViewToDesktop(object pView, iVirtualDesktop desktop);
  getCurrentDesktop := vTableVirtualDesktops(iVirtualDesktopManagerInternal, 6) ; iVirtualDesktop getCurrentDesktop();
  canViewMoveDesktops := vTableVirtualDesktops(iVirtualDesktopManagerInternal, 5) ; bool canViewMoveDesktops(object pView);
  getDesktops := vTableVirtualDesktops(iVirtualDesktopManagerInternal, 7) ; iObjectArray getDesktops();
  switchDesktop := vTableVirtualDesktops(iVirtualDesktopManagerInternal, 9) ; void switchDesktop(iVirtualDesktop desktop);
  immersiveShell := comObjCreate("{C2F03A33-21F5-47FA-B4BB-156362A2F239}", "{00000000-0000-0000-C000-000000000046}") 
  if !(iApplicationViewCollection := comObjQuery(immersiveShell,"{1841C6D7-4F9D-42C0-AF41-8747538F10E5}","{1841C6D7-4F9D-42C0-AF41-8747538F10E5}" ) ) ; 1607-1809
  {
    msgBox iApplicationViewCollection interface not supported.
  }
  getViewForHwnd := vTableVirtualDesktops(iApplicationViewCollection, 6) ; (IntPtr hwnd, out IApplicationView view);
}

getVirtualDesktopCount()
{
  global
  iObjectArray := 0
  dllCall(getDesktops, "UPtr", iVirtualDesktopManagerInternal, "UPtrP", iObjectArray, "UInt")

  ; iObjectArray:GetCount method
  ; https://docs.microsoft.com/en-us/windows/desktop/api/objectarray/nf-objectarray-iObjectArray-getcount
  vd_Count := 0
  dllCall(vTableVirtualDesktops(iObjectArray,3), "UPtr", iObjectArray, "UIntP", vd_Count, "UInt")
  return vd_Count
}

switchDesktop(whichDesktop)
{
  global
  iObjectArray := 0
  dllCall(getDesktops, "UPtr", iVirtualDesktopManagerInternal, "UPtrP", iObjectArray, "UInt")

  varSetCapacity(vd_strGUID, (38 + 1) * 2)
  varSetCapacity(vd_GUID, 16)

  iVirtualDesktop := 0

  ; https://github.com/nullpo-head/Windows-10-Virtual-Desktop-Switching-Shortcut/blob/master/VirtualDesktopSwitcher/VirtualDesktopSwitcher/VirtualDesktops.h
  dllCall("Ole32.dll\CLSIDFromString", "Str", "{FF72FFDD-BE7E-43FC-9C03-AD81681E88E4}", "UPtr", &vd_GUID)

  ; iObjectArray:GetAt method
  ; https://docs.microsoft.com/en-us/windows/desktop/api/objectarray/nf-objectarray-iObjectArray-getat
  dllCall(vTableVirtualDesktops(iObjectArray,4), "UPtr", iObjectArray, "UInt", whichDesktop -1, "UPtr", &vd_GUID, "UPtrP", iVirtualDesktop, "UInt")

  switchIdesktop(iVirtualDesktop)
}

sendWindowToDesktop(wintitle,whichDesktop,followYourWindow:=false,activate:=true)
{
  global
  thePView:=0

  detectHiddenWindows, on
  WinGet, outHwndList, List, %wintitle%
  detectHiddenWindows, off
  loop % outHwndList {
    ifEqual, false, % isValidWindow(outHwndList%a_index%), continue

    pView := 0
    dllCall(getViewForHwnd, "UPtr", iApplicationViewCollection, "Ptr", outHwndList%A_Index%, "Ptr*", pView, "UInt")

    pfcanViewMoveDesktops := 0
    dllCall(canViewMoveDesktops, "ptr", iVirtualDesktopManagerInternal, "Ptr", pView, "int*", pfcanViewMoveDesktops, "UInt") ; return value BOOL
    if (pfcanViewMoveDesktops)
    {
      theHwnd:=outHwndList%A_Index%
      thePView:=pView
      break
    }
  }

  if (thePView) {
    iObjectArray := 0
    dllCall(getDesktops, "UPtr", iVirtualDesktopManagerInternal, "UPtrP", iObjectArray, "UInt")

    varSetCapacity(vd_strGUID, (38 + 1) * 2)
    varSetCapacity(vd_GUID, 16)

    iVirtualDesktop := 0

    ; https://github.com/nullpo-head/Windows-10-Virtual-Desktop-Switching-Shortcut/blob/master/VirtualDesktopSwitcher/VirtualDesktopSwitcher/VirtualDesktops.h
    dllCall("Ole32.dll\CLSIDFromString", "Str", "{FF72FFDD-BE7E-43FC-9C03-AD81681E88E4}", "UPtr", &vd_GUID)

    ; iObjectArray:GetAt method
    ; https://docs.microsoft.com/en-us/windows/desktop/api/objectarray/nf-objectarray-iObjectArray-getat
    dllCall(vTableVirtualDesktops(iObjectArray,4), "UPtr", iObjectArray, "UInt", whichDesktop -1, "UPtr", &vd_GUID, "UPtrP", iVirtualDesktop, "UInt")

    dllCall(moveViewToDesktop, "ptr", iVirtualDesktopManagerInternal, "Ptr", thePView, "UPtr", iVirtualDesktop, "UInt")

    if (followYourWindow) {
      switchIdesktop(iVirtualDesktop)
      winActivate, ahk_id %theHwnd%
    }
  }
}


;start of internal functions
switchIdesktop(iVirtualDesktop)
{
  global switchDesktop, iVirtualDesktopManagerInternal
  ;activate taskbar before
  winActivate, ahk_class Shell_TrayWnd
  winWaitActive, ahk_class Shell_TrayWnd
  dllCall(switchDesktop, "ptr", iVirtualDesktopManagerInternal, "UPtr", iVirtualDesktop, "UInt")
  dllCall(switchDesktop, "ptr", iVirtualDesktopManagerInternal, "UPtr", iVirtualDesktop, "UInt")
  winMinimize, ahk_class Shell_TrayWnd
}

isValidWindow(hWnd)
{
  detectHiddenWindows, on
  return (getWindowTitle(hWnd) and isWindow(hWnd))
  detectHiddenWindows, off
}

getWindowTitle(hWnd) {
  winGetTitle, title, ahk_id %hWnd%
  return title
}

isWindow(hWnd){
  ; detectHiddenWindows, on
  winGet, dwStyle, style, ahk_id %hWnd%
  if ((dwStyle&0x08000000) || !(dwStyle&0x10000000)) {
    return false
  }
  winGet, dwExStyle, exStyle, ahk_id %hWnd%
  if (dwExStyle & 0x00000080) {
    return false
  }
  winGetClass, szClass, ahk_id %hWnd%
  if (szClass = "TApplication") {
    return false
  }
  ; detectHiddenWindows, off
  return true
}

vTableVirtualDesktops(ppv, idx)
{
  return numGet(numGet(1*ppv)+a_ptrSize*idx)
}
