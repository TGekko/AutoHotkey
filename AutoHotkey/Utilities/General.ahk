;
; General.ahk
;
; This script provides a menu containing shortcuts to commonly used or desired features in the Windows operating system.
; Once running, use the following hotkey to open the menu: Win+Right Click
;

#SingleInstance Force
loaded := false

showMenu() {
 global loaded
 if(loaded) {
  Menu, hotkey, Show
 }
}
openFolder() {
 Run %A_WorkingDir%
}
runWindowsTroubleshooter(troubleshooter) {
 Run *RunAs %A_ComSpec% /c msdt.exe /id %troubleshooter%,, Hide
}

troubleshooters := [["&Internet Connection", "NetworkDiagnosticsWeb"], ["&Hardware and Devices", "DeviceDiagnostic"], ["Incoming &Connections", "NetworkDiagnosticsInbound"], ["&Microphone", "AudioRecordingDiagnostic"], ["&Network Adapter", "NetworkDiagnosticsNetworkAdapter"], ["&Playing Audio", "AudioPlaybackDiagnostic"], ["&Windows Update", "WindowsUpdateDiagnostic"]]
for i, troubleshooter in troubleshooters {
 act := Func("runWindowsTroubleshooter").Bind(troubleshooter[2])
 label := troubleshooter[1]
 Menu, trouble, Add, %label%, % act
 if(i = 1) {
  Menu, trouble, Default, 1&
  Menu, trouble, Add
 }
}

Menu, hotkey, Add, &General.ahk, :Tray
Menu, hotkey, Default, 1&
Menu, hotkey, Add
Menu, hotkey, Add, Windows &Troubleshooters, :trouble
act := Func("runWindowsTroubleshooter").Bind("NetworkDiagnosticsWeb")
Menu, hotkey, Add, &Internet Connection, % act
Menu, Tray, Add
Menu, Tray, Add, Open Script &Folder, openFolder
Menu, Tray, Add, Open Script &Menu, showMenu

loaded := true

#RButton::showMenu()
