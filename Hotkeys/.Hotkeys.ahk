#SingleInstance Force
SetTitleMatchMode, 2
DetectHiddenWindows, On
loaded := false
reticle := 0x0

all := [".Hotkeys", "Citra", "Internet", "Magicka", "Minecraft", "Risk of Rain 2", "Sonic Adventure DX", "Superliminal", "Terraria", "The Escapists 2", "Valheim"]
showMenu() {
 global loaded
 if(loaded) {
  global all
  for i, item in all {
   path := % A_WorkingDir "\" item ".ahk"
   if(WinExist(path)) {
    Menu, stop, Enable, %item%
   } else {
    Menu, stop, Disable, %item%
   }
  }
  Menu, hotkey, Show
 }
}
startScript(name) {
 Run *RunAs "%name%.ahk"
}
stopScript(name) {
 path := % A_ScriptDir "\" name ".ahk"
 WinClose, %path% ahk_class AutoHotkey
}
editScript(name) {
 Run "C:\Windows\Notepad.exe" "%A_WorkingDir%\%name%.ahk"
}
openFolder() {
 Run %A_WorkingDir%
}
runWindowsTroubleshooter(troubleshooter) {
 Run *RunAs %A_ComSpec% /c msdt.exe /id %troubleshooter%,, Hide
}

for i, item in all {
 act := Func("startScript").Bind(item)
 Menu, start, Add, %item%, % act
 act := Func("stopScript").Bind(item)
 Menu, stop, Add, %item%, % act
 act := Func("editScript").Bind(item)
 Menu, edit, Add, %item%, % act
 if(i > 1) {
  startScript(item)
 } else {
  Menu, start, Default, 1&
  Menu, stop, Default, 1&
  Menu, edit, Default, 1&
 }
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

hotkeys := [["Show Menu", "Win+Right Click", "#RButton"], 0, ["Hold Left Click", "Alt+9", "!9"], ["Repeat Left Click", "Alt+0", "!0"], ["Hold Right Click", "Alt+Shift+9", "!+9"], ["Repeat Right Click", "Alt+Shift+0", "!+0"], 0, ["Stop Running Hotkey", "Pause or End", "Pause"], 0, ["Move Mouse Up", "Alt+Up", "!Up"], ["Mouse Mouse Down", "Alt+Down", "!Down"], ["Mouse Mouse Left", "Alt+Left", "!Left"], ["Mouse Mouse Right", "Alt+Right", "!Right"], ["Left Click", "Alt+[", "![["], ["Right Click", "Alt+]", "!]]"], 0, ["Toggle Reticle", "Alt+Insert", "!Insert"]]
for i, item in hotkeys {
 if(item = 0) {
  Menu, list, Add
 } else {
  label := item[1]
  act := item[3]
  Menu, list, Add, %label%, %act%
 }
}
for i, item in hotkeys {
 if(item = 0) {
  Menu, list, Add
 } else {
  label := item[2]
  act := item[3]
  if(i = 1) {
   Menu, list, Add, %label%, %act%, +Break
  } else {
   Menu, list, Add, %label%, %act%
  }
 }
}

Menu, hotkey, Add, &.Hotkeys.ahk, :Tray
Menu, hotkey, Default, 1&
Menu, hotkey, Add
Menu, hotkey, Add, Windows &Troubleshooters, :trouble
act := Func("runWindowsTroubleshooter").Bind("NetworkDiagnosticsWeb")
Menu, hotkey, Add, &Internet Connection, % act
Menu, hotkey, Add
Menu, hotkey, Add, Script &Hotkeys, :list
Menu, hotkey, Add, Toggle &Reticle, toggleReticle
Menu, hotkey, Add
Menu, hotkey, Add, &Start Script, :start
Menu, hotkey, Add, Sto&p Script, :stop
Menu, hotkey, Add, &Edit Script, :edit

Menu, Tray, Add
Menu, Tray, Add, Open Hotkey &Folder, openFolder
Menu, Tray, Add, Hotkey &Menu, showMenu

loaded := true



; Hotkeys

!9::Run, .Hotkeys\Hold_Left_Mouse_Button.ahk
!0::Run, .Hotkeys\Repeat_Left_Mouse_Button.ahk
!+9::Run, .Hotkeys\Hold_Right_Mouse_Button.ahk
!+0::Run, .Hotkeys\Repeat_Right_Mouse_Button.ahk

!Up::DllCall("mouse_event", "UInt", 0x01, "UInt", 0, "UInt", -1)
!Down::DllCall("mouse_event", "UInt", 0x01, "UInt", 0, "UInt", 1)
!Left::DllCall("mouse_event", "UInt", 0x01, "UInt", -1, "UInt", 0)
!Right::DllCall("mouse_event", "UInt", 0x01, "UInt", 1, "UInt", 0)
![::
 Click Left Down
 KeyWait LButton
return
![ Up::Click Left Up
![[:
 Click Left Down
 Click Left Up
return
!]::
 Click Right Down
 KeyWait RButton
return
!] Up::Click Right Up
!]]:
 Click Right Down
 Click Right Up
return
#RButton::showMenu()

!Insert::toggleReticle()

Pause:
 Send {Pause}
return



toggleReticle() {
 global reticle
 if(WinExist("ahk_id" reticle)) {
  Gui, %reticle%:Destroy
 } else {
  Gui, New, +AlwaysOnTop +ToolWindow -Caption -Disabled +E0x20 +LastFound +Hwndreticle
  Gui, Color, 100100
  WinSet, TransColor, 100100
  Gui, %reticle%:Add, Progress, % "w6 h12 x" . ((A_ScreenWidth / 2) -  3) . " y" . ((A_ScreenHeight / 2) - 16) . " background000000"
  Gui, %reticle%:Add, Progress, % "w12 h6 x" . ((A_ScreenWidth / 2) +  4) . " y" . ((A_ScreenHeight / 2) -  3) . " background000000"
  Gui, %reticle%:Add, Progress, % "w6 h12 x" . ((A_ScreenWidth / 2) -  3) . " y" . ((A_ScreenHeight / 2) +  4) . " background000000"
  Gui, %reticle%:Add, Progress, % "w12 h6 x" . ((A_ScreenWidth / 2) - 16) . " y" . ((A_ScreenHeight / 2) -  3) . " background000000"
  Gui, %reticle%:Add, Progress, % "w4 h10 x" . ((A_ScreenWidth / 2) -  2) . " y" . ((A_ScreenHeight / 2) - 15) . " backgroundFFFFFF"
  Gui, %reticle%:Add, Progress, % "w10 h4 x" . ((A_ScreenWidth / 2) +  5) . " y" . ((A_ScreenHeight / 2) -  2) . " backgroundFFFFFF"
  Gui, %reticle%:Add, Progress, % "w4 h10 x" . ((A_ScreenWidth / 2) -  2) . " y" . ((A_ScreenHeight / 2) +  5) . " backgroundFFFFFF"
  Gui, %reticle%:Add, Progress, % "w10 h4 x" . ((A_ScreenWidth / 2) - 15) . " y" . ((A_ScreenHeight / 2) -  2) . " backgroundFFFFFF"
  Gui, %reticle%:Show, x0 y0 w%A_ScreenWidth% h%A_ScreenHeight% NoActivate, AutoHotkey Reticle
 }
}
