#SingleInstance Ignore

id := WinGetID("A")
Loop {
 if(WinActive(id)) {
  MouseClick("Right",,,,, "D")
  MouseClick("Right",,,,, "U")
 }
 Sleep 16
}

Pause::
End:: {
 MouseClick("Right",,,,, "U")
 ExitApp
}