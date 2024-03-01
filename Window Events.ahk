#SingleInstance Force
#NoTrayIcon
Persistent
DetectHiddenWindows(true)

#Include "Common.ahk"

trayed := []

toTray(win) {
 if(!includes(trayed, win)) {
  Run('"' A_AhkPath '" "Windows\ToTray.ahk" "' win '" "wait"')
  trayed.push(win)
  SetTimer(() => (WinWaitClose(win), trayed.RemoveAt(includes(trayed, win))), -1)
 }
}

act(id, setting, action:= () => true) {
 setting:= GetSetting(setting, true)
 try
  if(includes(setting, WinGetProcessName("ahk_id " id)) ||
     includes(setting, id,, true))
   return action()
}

recipient(message, id, *) {
 if(message == 1) {
  act(id, "Transparent Windows", () => WinSetTransparent(Round(255 * 0.85), "ahk_id " id))
  act(id, "Close On Open", () => WinClose("ahk_id " id))
  act(id, "Open To Tray", () => toTray("ahk_id " id))
 }
}

detector := Gui()
DllCall("RegisterShellHookWindow", "UInt",detector.Hwnd)
messenger := DllCall("RegisterWindowMessage", "Str","SHELLHOOK")
OnMessage(messenger, recipient)