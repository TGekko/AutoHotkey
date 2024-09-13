#SingleInstance Force
#NoTrayIcon

reference := Gui("+AlwaysOnTop +ToolWindow -Caption -Disabled +E0x20 +LastFound", "AutoHotkey :: Risk of Rain 2.ahk > GUI:Item Reference")
reference.BackColor := "100100"
WinSetTransColor("100100 153", reference.Hwnd)
h := A_ScreenHeight
w := A_ScreenWidth
reference.Add("Picture", (h < w ? "w-1 h" h : "w" w " h-1"), "Risk of Rain 2\Reference.png")

#HotIf WinActive("ahk_exe Risk of Rain 2.exe")
 ~LControl:: {
  if(WinExist("AutoHotkey :: Risk of Rain 2.ahk > GUI:Item Reference")) {
   reference.Hide()
  } else {
   reference.Show("x0 y0 w" A_ScreenWidth " h" A_ScreenHeight " NoActivate")
  }
  KeyWait("LControl")
 }
#HotIf WinExist("AutoHotkey :: Risk of Rain 2.ahk > GUI:Item Reference")
 ~Pause::
 ~Delete:: {
  reference.Hide()
 }
#HotIf