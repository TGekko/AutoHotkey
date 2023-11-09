#SingleInstance Force
#NoTrayIcon
Persistent

#Include "Common.ahk"

detector := Gui()
DllCall("RegisterShellHookWindow", "UInt",detector.Hwnd)
messenger := DllCall("RegisterWindowMessage", "Str","SHELLHOOK")
OnMessage(messenger, recipient)

recipient(message, id, *) {
 transparent := GetSetting("Transparent Windows", true)
 if(message == 1) {
  try {
   if(includes(transparent, WinGetProcessName("ahk_id " id)) ||
      includes(transparent, id,, true)) {
    WinSetTransparent(Round(255 * 0.85), "ahk_id " id)
   }
  }
 }
}