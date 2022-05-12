#SingleInstance Ignore
loop {
 MouseClick, right, , , , , D
 MouseClick, right, , , , , U
 Sleep, 16
 if (repeat = 1) {
  ExitApp
 }
}

End::repeat := 1
Pause::repeat := 1