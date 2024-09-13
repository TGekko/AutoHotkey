;@Ahk2Exe-ExeName Risk of Rain 2 - Reference.exe
;@Ahk2Exe-SetMainIcon Risk of Rain 2.compile.ico

#SingleInstance Force

FileInstall("Reference.png", A_Temp "\Risk of Rain 2 - Reference.exe.png")
OnExit((z*) => FileDelete(A_Temp "\Risk of Rain 2 - Reference.exe.png"))

reference := Gui("+AlwaysOnTop +ToolWindow -Caption -Disabled +E0x20 +LastFound", "AutoHotkey :: Risk of Rain 2.exe > GUI:Item Reference")
reference.BackColor := "100100"
WinSetTransColor("100100 153", reference.Hwnd)
h := A_ScreenHeight
w := A_ScreenWidth
reference.Add("Picture", (h < w ? "w-1 h" h : "w" w " h-1"), A_Temp "\Risk of Rain 2 - Reference.exe.png")

#HotIf WinActive("ahk_exe Risk of Rain 2.exe")
 ~LControl:: {
  if(WinExist("AutoHotkey :: Risk of Rain 2.exe > GUI:Item Reference")) {
   reference.Hide()
  } else {
   reference.Show("x0 y0 w" A_ScreenWidth " h" A_ScreenHeight " NoActivate")
  }
  KeyWait("LControl")
 }
#HotIf WinExist("AutoHotkey :: Risk of Rain 2.exe > GUI:Item Reference")
 ~Pause::
 ~Delete:: {
  reference.Hide()
 }
#HotIf