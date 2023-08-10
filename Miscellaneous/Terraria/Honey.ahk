#SingleInstance Ignore

MouseClick "Left"
Sleep 1500
Loop {
 MouseClick "Left",,,,, "D"
 Sleep 250
 MouseClick "Left",,,,, "U"
 Sleep 1500
}

Pause::
End:: {
 MouseClick "Left",,,,, "U"
 MouseClick "Left"
 ExitApp
}