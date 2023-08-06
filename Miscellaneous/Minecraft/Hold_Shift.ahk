#SingleInstance Ignore
Send("{Shift down}")

End::
Pause:: {
 Send("{Shift up}")
 ExitApp
}

Shift::ExitApp