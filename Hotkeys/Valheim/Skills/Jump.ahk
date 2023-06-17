#SingleInstance Ignore
repeat := true

while(repeat) {
 Send "{Space down}{Space up}""
 Sleep 100
 Send "{Space down}{Space up}"
 Sleep 1600
}
ExitApp

~*Pause::repeat := false
~*End::repeat := false