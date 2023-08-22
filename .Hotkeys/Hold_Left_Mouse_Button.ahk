#SingleInstance Force

exit(exitreason, exitcode) {
 MouseClick("left",,,,, "U")
}
OnExit(exit)

MouseClick("left",,,,, "D")

LButton::
End::
Pause:: {
 ExitApp
}