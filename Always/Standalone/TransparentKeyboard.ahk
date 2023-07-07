#SingleInstance Force
Persistent()

Loop() {
 WinWaitActive("ahk_exe explorer.exe ahk_class ApplicationFrameWindow")
 MsgBox("Found")
 WinSetTransparent(128)
 WinWaitNotActive()
}