#SingleInstance Force

exit(exitreason, exitcode) {
 MouseClick("Left",,,,, "U")
}
OnExit(exit)

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
 ExitApp
}