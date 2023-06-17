#SingleInstance Ignore
repeat := true
while(repeat) {
 MouseClick "Left",,,,, "D"
 MouseClick "Left",,,,, "U"
 Sleep 16
}
ExitApp

End::repeat := false
Pause::repeat := false