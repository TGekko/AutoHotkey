#SingleInstance Force
#NoTrayIcon
Persistent

#Include "Common.ahk"

detector := Gui()
DllCall("RegisterShellHookWindow", "UInt",detector.Hwnd)
messenger := DllCall("RegisterWindowMessage", "Str","SHELLHOOK")
OnMessage(messenger, recipient)

recipient(message, id, *) {
 if(message == 1) {
  try {
   if(includes(GetSetting("Transparent Windows", true), WinGetProcessName("ahk_id " id)) ||
      includes(GetSetting("Transparent Windows", true), id,, true)) {
    WinSetTransparent(Round(255 * 0.85), "ahk_id " id)
   }
  }
 }
}