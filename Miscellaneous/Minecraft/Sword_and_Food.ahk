#SingleInstance Ignore

MouseClick("Right",,,,, "D")
Loop() {
 MouseClick("Left")
 Sleep(650)
}

Pause::
End:: {
 MouseClick("Right",,,,, "U")
 ExitApp
}