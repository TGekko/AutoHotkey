#SingleInstance Ignore

id := WinGetID("A")
moves := ["a", "w", "d", "s"]
i := 1
move() {
 global
 if(WinActive(id)) {
  Send("{" (Mod(i, 1) == 0 ? moves[i] " down" : moves[Mod(Floor(i)+2, 4)+1] " up") "}")
  i := i == 4.5 ? 1 : i + 0.5
 }
}
SetTimer(move, 125)

~*Pause::
~*End:: {
 SetTimer(move, 0)
 Send("{w up}{a up}{s up}{d up}")
 ExitApp
}