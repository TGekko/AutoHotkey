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
   transparent := GetSetting("Transparent Windows", true)
   if(includes(transparent, WinGetProcessName("ahk_id " id)) ||
      includes(transparent, id,, true)) {
    WinSetTransparent(Round(255 * 0.85), "ahk_id " id)
   }
  }
  try {
   close := GetSetting("Close On Open", true)
   if(includes(close, WinGetProcessName("ahk_id " id)) ||
      includes(close, id,, true)) {
    WinClose("ahk_id " id)
   }
  }
 }
}