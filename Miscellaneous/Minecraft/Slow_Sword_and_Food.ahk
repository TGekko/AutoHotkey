#SingleInstance Ignore

MouseClick("Right",,,,, "D")
Loop {
 MouseClick("Left")
 Sleep(2000)
}

Pause::
End:: {
 MouseClick("Right",,,,, "U")
 ExitApp
}