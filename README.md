# AutoHotkey

This is a compendium of the tricks I've learned in AutoHotkey.

I started using it many years ago and it has become vital to my workflow.

The main use is to turn the capslock key into a meta key which switches layers when held or tapped. I wanted to be able to do as much as possible without having to remove my hands from the home row while typing. This is especially important as I prefer a 60% keyboard layout.

---

# Usage

git clone https://.git, 

## The scripts

They're all called together as a stack from main.ahk

A brief rundown of each:

### capsClip.ahk

Again, there are many clipboard managers out there, this is just my take on it.  

---

### capsControl.ahk

Replicates control key functions

---

### capsMouse.ahk

KDE style window movement. Much of this is the same implementations found elsewhere:

---

### capsMovement.ahk

Replicates some Vim keybindings.  

---

### capsOther.ahk

Misc. Indent. Move line up / down. Move window to desktop.

---

### capsToggle.ahk

Tapping capslock by itself opens the GUI and toggles a separate layer switch with keys for various other functions.

---

### capsVim.ahk

Mimics several of Vim's keybindings. Includes tap actions for D and Y.

---

### functions.ahk

commandRoot() - opens powershell at current folder location, desktop if nothing open  
camelCase() - converts current line or selected text to camel case  
getMonMouseIn() - detects which monitor mouse is in for gui location  
cmdOutVar() - sets CMD output to variable. used for ipconfig  
getPublicIP() - used to detect if VPN is connected  
getDrives() - for drive space GUI  
getCPU - for CPU load GUI  
globalMemoryStatusEx() - for returning RAM usage  
getMemory() - for RAM usage GUI
getDate() - for GUI

---

### functionsListView.ahk

openListView(folder) - attaches a listview to the main GUI with folder contents

---

### functionsVirtualDesktops.ahk

Functions for moving windows and switching between virtual desktops

---

### functionsWeather.ahk

Gets current and upcoming conditions from lat / long

---

### guiFunctions.ahk

Functions for generating the GUI

---

### guiFunctionsShortcuts.ahk

Fuctions mainly for GUI clicks

---

### header.ahk


Environment setup. Will set powercfg.exe options to make caffeine status accurate.

---

### hotstrings.ahk

There are several ways to handle multi-tapping and string replacement but using `input` with a timer has been the best for me. This is where I put my regular hotstring replacements and 'tapdance' keys. For example, multi-tapping the '@' symbol inputs my various email addresses.

---

### labels.ahk

Code blocks that didn't work as functions for whatever reason

---

### numberSwitch.ahk

Started as a utility for 40% keyboards and grew.

This one has a learning curve:

Shift + shift, release one shift, home row button - send number, toggle layer off when released.  
example: press both shifts, release one, press A, S, D, release shift. This will type 234. Normal typing will resume after releasing shift.

Shift + shift + home row button - send symbol, toggle layer off when released.  
example: press both shifts, press A, S, D, release both shifts. This will type @#$. Normal typing will resume after releasing shift.

Shift + shift, release both without typing - toggle layer on. Esc, return, or tapping shift will toggle off.  
example: Press shift + shift and release both then press A, S, D, shift + A, S, D, tap shift. This will type 234@#$, and return to normal typing.

---

### regularRemaps.ahk

Various other tricks

---

### variables.ahk

Various global variables