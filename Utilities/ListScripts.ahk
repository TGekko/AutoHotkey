DetectHiddenWindows, On
WinGet, List, List, ahk_class AutoHotkey
scripts := ""
Loop % List {
   WinGetTitle, title, % "ahk_id" List%A_Index%
   scripts .=  (scripts ? "`r`n" : "") . RegExReplace(title, " - AutoHotkey v[\.0-9]+$")
}
MsgBox, % scripts