openListView(folder){
  global
  guiControl, -redraw, guiListView
  guiClick := a_guiControl

  menu, myContextMenu, add, open, contextOpenFile
  menu, myContextMenu, add, properties, contextProperties
  menu, myContextMenu, default, open

  ; if single character treat as drive
  stringLen, length, guiClick
  if (length = 1){
    folder := guiClick . ":"
  }

  ; navigate subfolders 
  if (guiClick != "guiListView" && !folder){
    folder := guiClick
  }

  ; if downloads click vdownloads is passed here
  if (guiClick = "downloads"){
    folder := downloadsPath
  }

  ; remove trailing backslash
  lastChar := subStr(folder, 0)
  if (lastChar = "\"){
    folder := subStr(folder, 1, -1)
  }

  ; detect double click in main gui
  if (folder = previousFolder){
    guiHide()
    run %folder%
    return
  }
  previousFolder := folder

  lv_delete()
  lv_setImageList(imageListFiles)
  lv_add(,"..")
  splitpath, folder,,parentFolder

  ; folders first

  fileList := ""
  loop, files, %folder%\*.*, d
  {
    if (regExMatch(a_loopFileAttrib, "i)h|s")){ ; skip hidden / system
      continue
    }
    ; timeModified first for sorting
    fileList .= a_loopFileTimeModified "`t" a_loopFileFullPath "`t" a_loopFileName "`t" a_loopFileExt "`t" a_loopFileSize "`n" 
  }

  if (folder = downloadsPath){
    sort, fileList, r ; sort by date.
  }

  loop, parse, fileList, `n
  {
    if (!a_loopField){ ; omit the last linefeed (blank item) at the end of the list
      continue
    }

    stringSplit, fileItem, a_loopField, %a_tab% ; split at tab

    dateModified := fileItem1
    fullPath := fileItem2
    fileName := fileItem3
    fileExt := fileItem4
    fileSize := fileItem5

    formatTime, dateModified,%dateModified%,yyyyMMdd_hHmm

    splitPath, fullPath,,, fileExt ; get extension
    if (regExMatch(fileExt, "i)exe|ico|ani|cur|png")){
      extID := fileExt ; special ID as a placeholder
      iconNumber := 0 ; flag it as not found so that these types can each have a unique icon.
    }
    else { ; some other extension/file-type, so calculate its unique iD.
      extID := 0 ; initialize to handle extensions that are shorter than others.
      loop 7 ; limit the extension to 7 characters so that it fits in a 64-bit value.
      {
        extChar := subStr(fileExt, a_index, 1)
        if not extChar ; no more characters.
          break
        extID := extID | (asc(extChar) << (8 * (a_index - 1))) ; derive a unique iD by assigning a different bit position to each character
      }
      iconNumber := iconArray%extID% ; check array for existing ext icon
    }
    if (!iconNumber){ ; load icon if not found
      ; get icon. 0x101 is SHGFI_ICON+SHGFI_SMALLICON
      if (!dllCall("Shell32\SHGetFileInfo" . (a_isUnicode ? "W":"A"), "Str", fullPath, "UInt", 0, "Ptr", &sfi, "UInt", sfi_size, "UInt", 0x101)){
        iconNumber := 9999999 ; set it out of bounds to display a blank icon
      }
      else{ ; icon successfully loaded
        hIcon := NumGet(sfi, 0) ; extract the hIcon member from the structure
        iconNumber := dllCall("ImageList_ReplaceIcon", "Ptr", imageListFiles, "Int", -1, "Ptr", hIcon) + 1 ; add icon. + 1 because imagelist starts at 0
        dllCall("DestroyIcon", "Ptr", hIcon) ; destroy original
        iconArray%extID% := iconNumber ; cache as extension icon if used again
      }
    }

    lv_add("icon" . iconNumber,fileName,,,dateModified,fullPath)
  }

  ; files

  fileList := ""
  loop, files, %folder%\*.*, f
  {
    if (regExMatch(a_loopFileAttrib, "i)h|s")){ ; skip hidden / system
      continue
    }
    ; timeModified first for sorting
    fileList .= a_loopFileTimeModified "`t" a_loopFileFullPath "`t" a_loopFileName "`t" a_loopFileExt "`t" a_loopFileSize "`n" 
  }

  if (folder = downloadsPath){
    sort, fileList, r ; sort by date.
  }

  loop, parse, fileList, `n
  {
    if (!a_loopField){ ; omit the last linefeed (blank item) at the end of the list
      continue
    }

    stringSplit, fileItem, a_loopField, %a_tab% ; split at tab

    dateModified := fileItem1
    fullPath := fileItem2
    fileName := fileItem3
    fileExt := fileItem4
    fileSize := fileItem5

    fileSize := round((fileSize / 1000000),1) " MB"
    formatTime, dateModified,%dateModified%,yyyyMMdd_hHmm

    splitPath, fullPath,,, fileExt ; get extension
    if (regExMatch(fileExt, "i)exe|ico|ani|cur|png")){
      extID := fileExt ; special ID as a placeholder
      iconNumber := 0 ; flag it as not found so that these types can each have a unique icon.
    }
    else { ; some other extension/file-type, so calculate its unique iD.
      extID := 0 ; initialize to handle extensions that are shorter than others.
      loop 7 ; limit the extension to 7 characters so that it fits in a 64-bit value.
      {
        extChar := subStr(fileExt, a_index, 1)
        if not extChar ; no more characters.
          break
        extID := extID | (asc(extChar) << (8 * (a_index - 1))) ; derive a unique iD by assigning a different bit position to each character
      }
      iconNumber := iconArray%extID% ; check array for existing ext icon
    }
    if (!iconNumber){ ; load icon if not found
      ; get icon. 0x101 is SHGFI_ICON+SHGFI_SMALLICON
      if (!dllCall("Shell32\SHGetFileInfo" . (a_isUnicode ? "W":"A"), "Str", fullPath, "UInt", 0, "Ptr", &sfi, "UInt", sfi_size, "UInt", 0x101)){
        iconNumber := 9999999 ; set it out of bounds to display a blank icon
      }
      else{ ; icon successfully loaded
        hIcon := NumGet(sfi, 0) ; extract the hIcon member from the structure
        iconNumber := dllCall("ImageList_ReplaceIcon", "Ptr", imageListFiles, "Int", -1, "Ptr", hIcon) + 1 ; add icon. + 1 because imagelist starts at 0
        dllCall("DestroyIcon", "Ptr", hIcon) ; destroy original
        iconArray%extID% := iconNumber ; cache as extension icon if used again
      }
    }

    formatTime, dateModified, %fileItem1%, yyyyMMdd_hHmm
    lv_add("icon" . iconNumber, fileName, fileExt, fileSize, dateModified, fullPath)
  }

  guiControl, +redraw, guiListView

  ; size columns
  col1Width := (listViewWidth / 2) - 30
  lv_modifycol(1,col1Width)
  col2Width := (listViewWidth / 2) / 3
  lv_modifycol(2,col2Width)
  lv_modifycol(2,"right")
  lv_modifycol(3,col2Width)
  lv_modifycol(3,"integer center")
  lv_modifycol(4,col2Width)
  lv_modifycol(4,"left")
  lv_modifycol(5,0)

  ; show
  newWidth := (guiWidth + listViewWidth)
  gui, show, w%newWidth%
}