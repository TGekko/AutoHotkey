#SingleInstance Off
DetectHiddenWindows(true)
Persistent(true)

id := 0
if(A_Args.Length < 1)
 id := "ahk_id " WinGetID('A')
else {
 if(A_Args.length > 1) {
  if(InStr(A_Args[2], 'wait'))
   WinWait(A_Args[1])
 }
 id := "ahk_id " WinGetID(A_Args[1])
}
if(!WinExist(id))
 ExitApp

TraySetIcon(WinGetProcessPath(id),, true)
A_IconTip := WinGetTitle(id)

call(functions*) {
 for(item in functions)
  if(Type(item) = "Func" || Type(item) = "BoundFunc")
   item()
}
tryFunc(functions*) {
 for(item in functions)
  try call(item)
}

beforeExit(z*) {
 global
 if(WinExist(id))
  WinShow(id)
}
OnExit(beforeExit)

setTray(title := A_IconTip) {
 submenu := Menu()
 submenu.Add("Change Tray Title", (z*) => tryFunc(
  (() => A_IconTip := InputBox("Please input a new title.", "Change Tray Title: " A_IconTip,, A_IconTip).Value),
  setTray
 ))
 submenu.Add("Change Tray Icon", (z*) => tryFunc(
  TraySetIcon(FileSelect(1,, "Select Tray Icon: " A_IconTip, "*.ico; *.exe; *.jpg; *.png; *.dll; *.cpl; *.cur; *.ani; *.scr"),, true)
 ))
 A_TrayMenu.Delete()
 A_TrayMenu.Add(A_IconTip, submenu)
 A_TrayMenu.Add()
 A_TrayMenu.Add("Show Window", (z*) => WinClose(A_ScriptHwnd))
 A_TrayMenu.Default:= "Show Window"
 A_TrayMenu.Add("Hide Menu", (z*) => {})
 A_TrayMenu.Add()
 A_TrayMenu.Add("Exit", (z*) => call(
  OnExit.bind((z*) => WinClose(id)),
  WinClose.bind(A_ScriptHwnd)
 ))
}
setTray()

WinHide(id)