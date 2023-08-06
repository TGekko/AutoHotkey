#SingleInstance Ignore

move := ["A", "W", "D", "S"]
Loop {
 for i, l in move {
  Send("{" move[i] " down}")
  Sleep(125)
  Send("{" move[Mod(i+2, 4)+1] " up}")
  Sleep(125)
 }
}

~*Pause::
~*End:: {
 Send("{W up}{A up}{S up}{D up}")
 ExitApp
}