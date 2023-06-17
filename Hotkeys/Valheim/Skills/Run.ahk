#SingleInstance Ignore
repeat := true

run := 0
while(repeat) {
 Send "{Shift down}"
 Loop 12 {
  Send "{A down}"
  Sleep 250
  Send "{A up}{W down}"
  Sleep 250
  Send "{W up}{D down}"
  Sleep 250
  Send "{D up}{S down}"
  Sleep 250
  Send "{S up}"
  if(!repeat)
   break 2
 }
 Send "{Shift up}"
 Sleep 3000
}
Send "{Shift up}"
ExitApp

~*Pause::repeat := false
~*End::repeat := false