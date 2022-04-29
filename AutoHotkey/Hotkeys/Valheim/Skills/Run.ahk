#SingleInstance Ignore
end := 0

run := 0
while (end = 0) {
 if (run = 0) {
  Send {Shift down}
  run := run + 1
 } else if (run > 12) {
  Send {Shift up}
  run := 0
  Sleep, 3000
 } else {
  Send {A down}
  Sleep, 250
  Send {A up}{W down}
  Sleep, 250
  Send {W up}{D down}
  Sleep, 250
  Send {D up}{S down}
  Sleep, 250
  Send {S up}
  run := run + 1
 }
}
Send {Shift up}
ExitApp

~*Pause::end := 1
~*End::end := 1