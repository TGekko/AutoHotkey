#SingleInstance Ignore
repeat := true

while(repeat) {
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
 Sleep, 3000
}
ExitApp

~*Pause::repeat := false
~*End::repeat := false