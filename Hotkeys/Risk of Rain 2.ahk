#SingleInstance Force
#NoTrayIcon
visible := []

Gui, New, +AlwaysOnTop +ToolWindow -Caption -Disabled +E0x20 +LastFound +Hwndreference
Gui, Color, 100100
WinSet, TransColor, 100100 153
Gui, New, +AlwaysOnTop +ToolWindow -Caption -Disabled +E0x20 +LastFound +Hwndhelp
Gui, Color, 100100
WinSet, TransColor, 100100 153

if(A_ScreenHeight < A_ScreenWidth) {
 Gui, %reference%:Add, Picture, w-1 h%A_ScreenHeight%,  Risk of Rain 2\Reference.png
 Gui, %help%:Add, Picture, w-1 h%A_ScreenHeight%, Risk of Rain 2\Help.png
} else {
 Gui, %reference%:Add, Picture, w%A_ScreenWidth% h-1,  Risk of Rain 2\Reference.png
 Gui, %help%:Add, Picture, w%A_ScreenWidth% h-1, Risk of Rain 2\Help.png
}



#IfWinActive ahk_exe Risk of Rain 2.exe
 ~LControl::
  toggle(reference, "AutoHotkey :: Risk of Rain 2.ahk > GUI:Item Reference")
  KeyWait, LControl
  return
 ~RControl::toggle(help, "AutoHotkey :: Risk of Rain 2.ahk > GUI:Help")
#IfWinActive

#IfWinExist AutoHotkey :: Risk of Rain 2.ahk > GUI
 ~Pause::
 ~Delete::
  Gui, %reference%:Hide
  Gui, %help%:Hide
  return
#IfWinExist

toggle(ui, name) {
 if(WinExist("ahk_id" ui)) {
  Gui, %ui%:Hide
 } else {
  Gui, %ui%:Show, x0 y0 w%A_ScreenWidth% h%A_ScreenHeight% NoActivate, %name%
 }
}
