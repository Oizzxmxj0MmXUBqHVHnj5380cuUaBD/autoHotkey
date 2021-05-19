#if getKeyState("capslock", "P") && !numberSwitch && !capsToggle && !winActive("ahk_exe vmconnect.exe") && !winActive("ahk_exe mstsc.exe")

z::send {blind}^{z downtemp}
z up::send {Blind}^{z up}

x::send {blind}^{x downtemp}
x up::send {Blind}^{x up}

c::send {blind}^{c downtemp}
c up::send {Blind}^{c up}

v::send {blind}^{v downtemp}
v up::send {Blind}^{v up}

r::send {blind}^{y downtemp}
r up:: send {blind}^{y up}

s::send {blind}^{s downtemp}
s up:: send {blind}^{s up}