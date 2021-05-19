#include %a_scriptDir%\header.ahk
#include %a_scriptDir%\variables.ahk
#include %a_scriptDir%\functions.ahk
#include %a_scriptDir%\functionsWeather.ahk
#include %a_scriptDir%\functionsVirtualDesktop.ahk
#include %a_scriptDir%\functionsListView.ahk
#include %a_scriptDir%\guiFunctions.ahk
#include %a_scriptDir%\guiFunctionsShortcuts.ahk

createGUI()
initializeVirtualDesktops()

setTimer, destroyCreateGUI, 1800000
setTimer, getLocalIP, 10000
setTimer, getCPU, 1000
setTimer, getMemory, 3000
setTimer, checkSyncthing, 1000


while (getVirtualDesktopCount() > 2) {
  switchDesktop(getVirtualDesktopCount())
  send #^{f4}
}
switchDesktop(1)

#include %a_scriptDir%\labels.ahk

return

#include %a_scriptDir%\regularRemaps.ahk
#include %a_scriptDir%\capsMouse.ahk
#include %a_scriptDir%\numberSwitch.ahk
#include %a_scriptDir%\capsClip.ahk
#include %a_scriptDir%\capsMovement.ahk
#include %a_scriptDir%\capsControl.ahk
#include %a_scriptDir%\capsOther.ahk
#include %a_scriptDir%\capsVim.ahk
#include %a_scriptDir%\hotStrings.ahk
#include %a_scriptDir%\capsToggle.ahk
