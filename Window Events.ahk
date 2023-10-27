#SingleInstance Force
#NoTrayIcon
Persistent

#Include "Common.ahk"

includes(array, values, any:=true, title:=false) {
 if(Type(values) != "Array")
  values := [values]
 matches := 0
 for(avalue in array) {
  for(vvalue in values) {
   try {
    if(avalue == vvalue || (title && WinGetID(avalue) = vvalue))
     if(any || matches++ == values.Length) {
      return true
     }
     break
    }
  }
 }
 return false
}

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