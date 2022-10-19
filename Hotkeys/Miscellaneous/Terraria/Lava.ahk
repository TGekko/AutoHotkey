#SingleInstance Ignore
MouseClick, left
Sleep, 1500
loop {
 MouseClick, left, , , , , D
 Sleep, 250
 MouseClick, left, , , , , U
 Sleep, 1000
 if (repeat = 1) {
  MouseClick, left
  ExitApp
 }
}

End::repeat := 1
Pause::repeat := 1