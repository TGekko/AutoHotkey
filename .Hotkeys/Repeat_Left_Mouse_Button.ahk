#SingleInstance Ignore

id := WinGetID("A")
Loop {
 if(WinActive(id)) {
  MouseClick("Left",,,,, "D")
  MouseClick("Left",,,,, "U")
 }
 Sleep 16
}

Pause::
End:: {
 MouseClick("Left",,,,, "U")
 ExitApp
}