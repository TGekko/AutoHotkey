#SingleInstance Ignore
repeat := true

while (repeat) {
 Send "{LButton down}"
 Sleep 1600
 Send "{LButton up}""
 Sleep 1600
}
ExitApp

~*Pause::repeat := false
~*End::repeat := false