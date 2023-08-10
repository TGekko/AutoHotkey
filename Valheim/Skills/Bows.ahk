#SingleInstance Ignore

Loop {
 Send("{LButton down}")
 Sleep(1600)
 Send("{LButton up}")
 Sleep(1600)
}

~*Pause::
~*End:: {
 Send("{LButton up}")
 ExitApp
}