#SingleInstance Force
#NoTrayIcon
GroupAdd, browsers, ahk_exe chrome.exe
GroupAdd, browsers, ahk_exe msedge.exe
GroupAdd, browsers, ahk_exe firefox.exe



#IfWinActive ahk_group browsers
 ^Right::Send {Right 17}
 ^Left::Send {Left 17}
 ^+#/::
  if (not hide(dark)) {
   Gui, New, +AlwaysOnTop +ToolWindow -Caption +LastFound +Hwnddark
   Gui, %dark%:Color, 000000
   WinSet, TransColor, 100100
   WinGetPos, x, y, w, h, A
   WinMove, A,, %x%, % y-56
   x := x+10
   y := y+57
   w := w-20
   h := h-123
   Gui, %dark%:Add, Progress, x%x% y%y% w%w% h%h% c100100 background100100 Hwnddarkwindow, 100
   Gui, %dark%:Show, x0 y0 w%A_ScreenWidth% h%A_ScreenHeight% NoActivate, AutoHotkey :: Internet.ahk > GUI
  }
  return
#IfWinActive AutoHotkey :: Internet.ahk > GUI
 LButton up::hide(dark)
#IfWinActive

#IfWinExist AutoHotkey :: Internet.ahk > GUI
 ~Delete::hide(dark)
 ~Pause::
  GuiControlGet, darkwindowvisible, Visible, %darkwindow%
  if(darkwindowvisible == 1) {
   GuiControl, Hide, %darkwindow%
  } else {
   GuiControl, Show, %darkwindow%
  }
  return
 ~`::
  if(light) {
   try Gui, %dark%:Color, 000000
   light := false
  } else {
   try Gui, %dark%:Color, FFFFFF
   light := true
  }
  return
#IfWinExist



hide(ui) {
 if(WinExist("ahk_id" ui)) {
  Gui, %ui%:Destroy
  WinGetPos, x, y, w, h, A
  WinMove, A,, %x%, % y+56
  return true
 }
 return false
}