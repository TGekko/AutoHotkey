#SingleInstance Ignore

Loop() {
 Send("{Shift down}")
 Loop(12) {
  Send("{A down}")
  Sleep(250)
  Send("{A up}{W down}")
  Sleep(250)
  Send("{W up}{D down}")
  Sleep(250)
  Send("{D up}{S down}")
  Sleep(250)
  Send("{S up}")
 }
 Send("{Shift up}")
 Sleep(3000)
}

~*Pause::
~*End:: {
 Send("{Shift up}{W up}{A up}{S up}{D up}")
 ExitApp
}