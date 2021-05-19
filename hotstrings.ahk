#if !winactive("ahk_exe vmconnect.exe") && !winactive("ahk_exe mstsc.exe") && !numberSwitch

:C:THanks::Thanks
:C:THe::The
:*:teh::the

; allows double, triple, quad, etc. tapping keys but retains original function if any other key pressed.
:*:@::
  k=
  input, k, l1 i t0.25
  if (k = "@") {
    input, k, l1 i t0.25
    if (k = "@") {
      input, k, l1 i t0.25
      if (k = "@") {
        sendInput email3@example.invalid ; last one must exclude %k% or else '@' will be added at the end
      } else {
        sendInput email2@example.invalid%k%
      }
    } else {
      sendInput email1@example.invalid%k%
    }
  } else {
    sendInput @%k%
  }
return

; another example
:*:q::
  k=
  input, k, l1 i t0.25
  if (k = "q") {
    input, k, l1 i t0.25
    if (k = "q") {
      input, k, l1 i t0.25
      if (k = "q") {
        sendInput 4taps
       } else {
        sendInput 3taps%k%
      }
    } else {
      sendInput 2taps%k%
    }
  } else {
    sendInput q%k%
  }
return