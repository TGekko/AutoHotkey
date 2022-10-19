#SingleInstance Ignore

loop {
 Send E
 Sleep, 50
 Send Q
 Sleep, 50
 if (repeat = 1) {
  MouseClick, left
  ExitApp
 }
}

End::repeat := 1
Pause::repeat := 1