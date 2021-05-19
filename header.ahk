#keyHistory, 0 ; optional
#noEnv
#persistent ; optional
#singleInstance, force
autoTrim, off
coordMode, mouse, screen
detectHiddenWindows, on
menu, tray, icon, pifmgr.dll, 27 ; optional
setCapsLockState, alwaysOff
setTitleMatchMode, 2
setWorkingDir, %a_scriptDir%
;#useHook, on ; might be necessary for laptop

; set power options so caffeine status is accurate on load
run powercfg.exe /X hibernate-timeout-ac 0,, hide
run powercfg.exe /X hibernate-timeout-dc 10,, hide
run powercfg.exe /X monitor-timeout-ac 10,, hide
run powercfg.exe /X monitor-timeout-dc 3,, hide
run powercfg.exe /X standby-timeout-ac 0,, hide
run powercfg.exe /X standby-timeout-dc 5,, hide