getLocalIP:
  global previousIP
  ipconfig := cmdOutVar("ipconfig")
  ;if (previousIPs != ipconfig){
  ;  global publicIP := getPublicIP()
  ;  msgBox
  ;}
  regExMatch(ipconfig, "IPv4.*(10\.5\..*)", localIP)
  if (localIP1){
    guicontrol, +c9AA83A, mainlocalIP
  } else {
    regExMatch(ipconfig, "IPv4.*(192\.168\.0\..*)" , localIP)
    if (localIP1 ){
      guicontrol, +c935c25, mainlocalIP

    } else {
      regExMatch(ipconfig, "IPv4.*(172\.25\..*)" , localIP)
      if (localIP1 ){
        guicontrol, +c935c25, mainlocalIP
      }
    }
  }
  guicontrol, text, mainLocalIP, %localIP1%
  if (previousIP != localIP1 or !publicIP){
    getPublicIP()
    ;msgBox %previousIP% %localIP1%
  }
  previousIP := localIP1
return

numberSwitchTooltip:
  tooltip numberSwitch
return

GuiContextMenu: ; Launched in response to a right-click or press of the Apps key.
  if (A_GuiControl != "guiListView") ; Display the menu only for clicks inside the ListView.
    return
  ; Show the menu at the provided coordinates, A_GuiX and A_GuiY. These should be used
  ; because they provide correct coordinates even if the user pressed the Apps key:
  Menu, MyContextMenu, Show, %A_GuiX%, %A_GuiY%
return

ContextOpenFile: ; The user selected "Open" in the context menu.
ContextProperties: ; The user selected "Properties" in the context menu.
  ; For simplicitly, operate upon only the focused row rather than all selected rows:
  FocusedRowNumber := LV_GetNext(0, "F") ; Find the focused row.
  if not FocusedRowNumber ; No row is focused.
    return
  LV_GetText(FileName, FocusedRowNumber, 5) ; Get the text of the first field.
  LV_GetText(FileDir, FocusedRowNumber, 2) ; Get the text of the second field.
  if InStr(A_ThisMenuItem, "Open") ; User selected "Open" from the context menu.
    Run %FileName%,, UseErrorLevel
  else ; User selected "Properties" from the context menu.
    Run Properties "%FileName%",, UseErrorLevel
  if ErrorLevel
    MsgBox Could not perform requested action on "%FileName%".
return

vol:
  gui,submit,noHide
  soundSet,% set
return