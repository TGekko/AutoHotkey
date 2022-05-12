#SingleInstance Ignore
MouseClick, right, , , , , D
loop {
 MouseClick, left
 Sleep, 650
 if (repeat = 1) {
  MouseClick, right, , , , , U
  ExitApp
 }
}

End::repeat := 1
Pause::repeat := 1