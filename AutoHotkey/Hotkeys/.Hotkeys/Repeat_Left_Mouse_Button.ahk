#SingleInstance Ignore
loop {
 MouseClick, left, , , , , D
 MouseClick, left, , , , , U
 Sleep, 16
 if (repeat = 1) {
  ExitApp
 }
}

End::repeat := 1
Pause::repeat := 1