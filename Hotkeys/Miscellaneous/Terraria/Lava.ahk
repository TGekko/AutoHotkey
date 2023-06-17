#SingleInstance Ignore
repeat := true
MouseClick "Left"
Sleep 1500
while(repeat) {
 MouseClick "Left",,,,, "D"
 Sleep 250
 MouseClick "Left",,,,, "U"
 Sleep 1000
}
MouseClick "Left"
ExitApp

End::repeat := false
Pause::repeat := false