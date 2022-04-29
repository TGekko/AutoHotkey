#SingleInstance Ignore
end := 0

sneak := 0
while (end = 0) {
 if (sneak = 0) {
  sneak := sneak + 1
 } else if (run > 12) {
  sneak := 0
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
  sneak := sneak + 1
 }
}
ExitApp

~*Pause::end := 1
~*End::end := 1