#SingleInstance Ignore
end := 0

while (end = 0) {
 Send {LButton}
 Sleep, 700
 Send {LButton}
 Sleep, 700
 Send {LButton}
 Sleep, 2900
}
ExitApp

~*Pause::end := 1
~*End::end := 1