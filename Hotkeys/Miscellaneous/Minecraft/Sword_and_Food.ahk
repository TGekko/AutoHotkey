#SingleInstance Ignore
repeat := true
MouseClick "Right",,,,, "D"
while(repeat) {
 MouseClick "Left"
 Sleep 650
}
MouseClick "Right",,,,, "U"
ExitApp

End::repeat := false
Pause::repeat := false