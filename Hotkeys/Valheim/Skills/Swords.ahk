#SingleInstance Ignore
repeat := true

while(repeat) {
 Send "{LButton}"
 Sleep 700
 Send "{LButton}"
 Sleep 700
 Send "{LButton}"
 Sleep 2900
}
ExitApp

~*Pause::repeat := false
~*End::repeat := false