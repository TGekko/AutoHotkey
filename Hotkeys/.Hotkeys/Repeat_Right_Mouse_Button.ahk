#SingleInstance Ignore
repeat := true
while(repeat) {
 MouseClick "Right",,,,, "D"
 MouseClick "Right",,,,, "U"
 Sleep 16
}
ExitApp

End::repeat := false
Pause::repeat := false