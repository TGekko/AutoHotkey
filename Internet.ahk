#SingleInstance Force
#NoTrayIcon
GroupAdd("browsers", "ahk_exe chrome.exe")
GroupAdd("browsers", "ahk_exe msedge.exe")
GroupAdd("browsers", "ahk_exe firefox.exe")
dark := { Hwnd: 0 }
light := false


#HotIf WinActive("ahk_group browsers")
 ^Right::Send("{Right 17}")
 ^Left::Send("{Left 17}")
 ^+#/:: {
  global dark
  if(!hide(dark)) {
   dark := Gui("+AlwaysOnTop +ToolWindow -Caption +LastFound", "AutoHotkey :: Internet.ahk > GUI")
   dark.BackColor := "000000"
   WinSetTransColor("100100", dark.Hwnd)
   WinGetPos(&x, &y, &w, &h, "A")
   WinMove(x, y-56,,, "A")
   x += 10
   y += 57
   w -= 20
   h -= 123
   dark.Add("Progress", "x" x " y" y " w" w " h" h " c100100 background100100 vwindow", 100)
   dark.Show("x0 y0 w" A_ScreenWidth " h" A_ScreenHeight " NoActivate")
  }
 }
#HotIf WinActive("AutoHotkey :: Internet.ahk > GUI")
 LButton up::hide(dark)
#HotIf WinExist("AutoHotkey :: Internet.ahk > GUI")
 ~Delete::hide(dark)
 ~Pause::dark["window"].Visible := !dark["window"].Visible
 ~`:: {
  global light
  if(light) {
   dark.BackColor := "000000"
   light := false
  } else {
   dark.BackColor := "FFFFFF"
   light := true
  }
 }
#HotIf



hide(ui) {
 try {
  WinExist(ui.Hwnd)
  ui.Destroy()
  WinGetPos(&x, &y, &w, &h, "A")
  WinMove(x, y+56,,, "A")
  return true
 }
 return false
}