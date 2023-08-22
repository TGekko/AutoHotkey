#SingleInstance Force

exit(exitreason, exitcode) {
 MouseClick("Right",,,,, "U")
}
OnExit(exit)

MouseClick("Right",,,,, "D")

RButton::
End::
Pause:: {
 ExitApp
}
