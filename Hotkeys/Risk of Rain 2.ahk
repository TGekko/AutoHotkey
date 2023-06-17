#SingleInstance Force
#NoTrayIcon
visible := []

reference := Gui("+AlwaysOnTop +ToolWindow -Caption -Disabled +E0x20 +LastFound", "AutoHotkey :: Risk of Rain 2.ahk > GUI:Item Reference")
reference.BackColor := "100100"
WinSetTransColor "100100 153", reference.Hwnd
help := Gui("+AlwaysOnTop +ToolWindow -Caption -Disabled +E0x20 +LastFound", "AutoHotkey :: Risk of Rain 2.ahk > GUI:Help")
help.BackColor := "100100"
WinSetTransColor "100100 153", help.Hwnd

h := A_ScreenHeight
w := A_ScreenWidth
reference.Add("Picture", (h < w ? "w-1 h" h : "w" w " h-1"), "Risk of Rain 2\Reference.png")
help.Add("Picture", (h < w ? "w-1 h" h : "w" w " h-1"), "Risk of Rain 2\Help.png")

#HotIf WinActive("ahk_exe Risk of Rain 2.exe")
 ~LControl:: {
  toggle(reference, "Item Reference")
  KeyWait "LControl"
 }
 ~RControl::toggle(help, "Help")
#HotIf WinExist("AutoHotkey :: Risk of Rain 2.ahk > GUI")
 ~Pause::
 ~Delete:: {
  reference.Hide()
  help.Hide()
 }
#HotIf

toggle(ui, title) {
 if(WinExist("AutoHotkey :: Risk of Rain 2.ahk > GUI:" title)) {
  ui.Hide()
 } else {
  ui.Show("x0 y0 w" A_ScreenWidth " h" A_ScreenHeight " NoActivate")
 }
}