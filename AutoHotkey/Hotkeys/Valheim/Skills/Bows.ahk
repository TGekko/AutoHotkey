#SingleInstance Ignore
end := 0

while (end = 0) {
 Send {LButton down}
 Sleep, 1600
 Send {LButton up}
 Sleep, 1600
}
ExitApp

~*Pause::end := 1
~*End::end := 1