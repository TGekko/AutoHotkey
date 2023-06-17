#SingleInstance Ignore
repeat := true

while(repeat) {
 Send "E"
 Sleep 50
 Send "Q"
 Sleep 50
}
MouseClick "Left"
ExitApp

End::repeat := false
Pause::repeat := false