DetectHiddenWindows true
list := WinGetList("ahk_class AutoHotkey")
scripts := ""
for i, item in list {
   title := WinGetTitle("ahk_id" item)
   scripts .=  (scripts ? "`r`n" : "") . RegExReplace(title, " - AutoHotkey v[\.0-9]+$")
}
msgBox scripts