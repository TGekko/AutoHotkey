#SingleInstance Ignore
end := 0

while (end = 0) {
 Send {Space down}{Space up}
 Sleep, 100
 Send {Space down}{Space up}
 Sleep, 1600
}
ExitApp

~*Pause::end := 1
~*End::end := 1