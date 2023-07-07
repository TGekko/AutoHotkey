#SingleInstance Ignore

Loop() {
 MouseClick("Left",,,,, "D")
 MouseClick("Left",,,,, "U")
 Sleep 16
}

Pause::
End:: {
 MouseClick("Left",,,,, "U")
 ExitApp
}