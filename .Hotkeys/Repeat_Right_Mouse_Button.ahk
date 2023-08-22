#SingleInstance Force

exit(exitreason, exitcode) {
 MouseClick("Right",,,,, "U")
}
OnExit(exit)

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
 ExitApp
}