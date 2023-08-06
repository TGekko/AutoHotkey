#SingleInstance Ignore

Loop {
 MouseClick("Right",,,,, "D")
 MouseClick("Right",,,,, "U")
 Sleep 16
}

Pause::
End:: {
 MouseClick("Right",,,,, "U")
 ExitApp
}