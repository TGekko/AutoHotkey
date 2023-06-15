;
; General.ahk
;
; This script provides a menu containing shortcuts to commonly used or desired features in the Windows operating system.
; Once running, use the following hotkey to open the menu: Win+Right Click
;

#SingleInstance Force
menus := {
 loaded: false,
 general: Menu(),
 call: menus_call
}
menus_call(function, parameters:="__", menuvariables*) {
 if(parameters == "__") {
  function()
  return
 }
 if(Type(parameters) != "Array") {
  parameters := [parameters]
 }
 function(parameters*)
}
showMenu() {
 global menus
 if(menus.loaded) {
  menus.general.Show()
 }
}
openFolder() {
 Run A_WorkingDir
}
runWindowsTroubleshooter(troubleshooter) {
 Run "*RunAs " A_ComSpec " /c msdt.exe /id " troubleshooter,, "Hide"
}

menus.trouble := Menu()
troubleshooters := [["&Internet Connection", "NetworkDiagnosticsWeb"], ["&Hardware and Devices", "DeviceDiagnostic"], ["Incoming &Connections", "NetworkDiagnosticsInbound"], ["&Microphone", "AudioRecordingDiagnostic"], ["&Network Adapter", "NetworkDiagnosticsNetworkAdapter"], ["&Playing Audio", "AudioPlaybackDiagnostic"], ["&Search and Indexing", "SearchDiagnostic"], ["&Windows Update", "WindowsUpdateDiagnostic"]]
for i, troubleshooter in troubleshooters {
 menus.trouble.Add(troubleshooter[1], menus.call.Bind(runWindowsTroubleshooter, troubleshooter[2]))
 if(i == 1) {
  menus.trouble.Default := "1&"
  menus.trouble.Add()
 }
}

menus.general.Add("&General.ahk", A_TrayMenu)
menus.general.Default := "1&"
menus.general.Add()
menus.general.Add("Windows &Troubleshooters", menus.trouble)
menus.general.Add("&Internet Connection", menus.call.Bind(runWindowsTroubleshooter, "NetworkDiagnosticsWeb"))
A_TrayMenu.Add()
A_TrayMenu.Add("Open Script &Folder", menus.call.bind(openFolder, "__"))
A_TrayMenu.Add("Open Script &Menu", menus.call.bind(showMenu, "__"))

menus.loaded := true

#RButton::showMenu()
