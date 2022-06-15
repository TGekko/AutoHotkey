#SingleInstance Force
SetTitleMatchMode, 2
DetectHiddenWindows, On
loaded := false
reticle := 0x0

all := [".Hotkeys", 0, "Citra", "Magicka", "Minecraft", "Risk of Rain 2", "Sonic Adventure DX", "Superliminal", "Terraria", "The Escapists 2", "Valheim", 0, "Internet", "Voicemeeter", "Windows"]
showMenu() {
 global loaded
 if(loaded) {
  global all
  for i, item in all {
   if(item != 0) {
    path := % A_WorkingDir "\" item ".ahk"
    if(WinExist(path)) {
     Menu, stop, Enable, %item%
    } else {
     Menu, stop, Disable, %item%
    }
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
 if(item = 0) {
  Menu, start, Add
  Menu, stop, Add
  Menu, edit, Add
 } else {
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
}

troubleshooters := [["&Internet Connection", "NetworkDiagnosticsWeb"], ["&Hardware and Devices", "DeviceDiagnostic"], ["Incoming &Connections", "NetworkDiagnosticsInbound"], ["&Microphone", "AudioRecordingDiagnostic"], ["&Network Adapter", "NetworkDiagnosticsNetworkAdapter"], ["&Playing Audio", "AudioPlaybackDiagnostic"], ["&Search and Indexing", "SearchDiagnostic"], ["&Windows Update", "WindowsUpdateDiagnostic"]]
for i, troubleshooter in troubleshooters {
 act := Func("runWindowsTroubleshooter").Bind(troubleshooter[2])
 label := troubleshooter[1]
 Menu, trouble, Add, %label%, % act
 if(i = 1) {
  Menu, trouble, Default, 1&
  Menu, trouble, Add
 }
}

generalhotkeys := [["Show Menu", "Win+Right Click", "#RButton"], 0, ["Hold Left Click", "Alt+9", "!9"], ["Repeat Left Click", "Alt+0", "!0"], ["Hold Right Click", "Alt+Shift+9", "!+9"], ["Repeat Right Click", "Alt+Shift+0", "!+0"], 0, ["Stop Running Hotkey", "Pause or End", "Pause"], 0, ["Move Mouse Up", "Alt+Up", "!Up"], ["Mouse Mouse Down", "Alt+Down", "!Down"], ["Mouse Mouse Left", "Alt+Left", "!Left"], ["Mouse Mouse Right", "Alt+Right", "!Right"], ["Left Click", "Alt+[", "![["], ["Right Click", "Alt+]", "!]]"], 0, ["Toggle Reticle", "Alt+Insert", "!Insert"]]

for i, item in generalhotkeys {
 if(item = 0) {
  Menu, list, Add
 } else {
  label := item[1]
  act := item[3]
  Menu, list, Add, %label%, %act%
 }
}
for i, item in generalhotkeys {
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

scripthotkeys := {}

scripthotkeys["Citra"] := [["Go Home", "Controller Home"]]

scripthotkeys["Magicka"] := [["Show Spell Menu", "Alt+Right Click"], 0, ["Cast Charm", "Numpad 0"], ["Cast Conflagration", "Numpad 1"], ["Cast Confuse", "Numpad 2"], ["Cast Corporealize", "Numpad 3"], ["Cast Crash to Desktop", "Numpad 4"], ["Cast Fear", "Numpad 5"], ["Cast Invisibility", "Numpad 6"], ["Cast Meteor Storm", "Numpad 7"], ["Cast Raise Dead", "Numpad 8"], ["Cast Summon Death", "Numpad 9"], ["Cast Summon Elemental", "Numpad Add"], ["Cast Thunder Storm", "Numpad Dot"], ["Cast Vortex", "Numpad Subtract"]]

scripthotkeys["Minecraft"] := [["Swing Sword and Eat Food", "Alt+1"], ["Hold Shift", "Alt+Shift"]]

scripthotkeys["Risk of Rain 2"] := [["Show Item Reference", "Left Control"], ["Show Help", "Right Control"]]

scripthotkeys["Sonic Adventure DX"] := [["Forward", "W"], ["Left", "A"], ["Backward", "S"], ["Right", "D"], ["Jump", "Space"], ["Camera Left", "Left Arrow"], ["Camera Right", "Right Arrow"], ["Action", "E or Down"], ["Look Around", "Up"], ["Back", "Backspace"], ["Pause", "Escape or Enter"]]

scripthotkeys["Superliminal"] := [["Click", "Forward Slash"], 0, ["Move Mouse Up", "Up"], ["Move Mouse Right", "Right"], ["Move Mouse Down", "Down"], ["Move Mouse Left", "Left"]]

scripthotkeys["Terraria"] := [["Duplicate Honey", "Alt+1"], ["Duplicate Lava", "Alt+2"]]

scripthotkeys["The Escapists 2"] := [["Train Strength", "Alt+1"]]

scripthotkeys["Valheim"] := [["Press E 10 times", "Alt+E"], ["Scroll Through Hotbar", "Alt+Scroll"], ["Move Mouse", "Arrow Keys"], 0, ["Train Bow", "Alt+1"], ["Train Jump", "Alt+2"], ["Train Run", "Alt+3"], ["Train Sneak", "Alt+4"], ["Train Sword", "Alt+5"]]

scripthotkeys["Internet"] := [["Skip Forward 17 times", "Control+Right"], ["Skip Backward 17 times", "Control+Left"], ["Toggle Browser Theatre Mode", "Control+Shift+Windows+Forward Slash"], 0, ["Theatre - Toggle Black/White", "Backquote"], ["Theatre - Hide Browser", "Pause"]]

scripthotkeys["Voicemeeter"] := [["Restart Audio Engine", "Control+Numpad Dot"], 0, ["Increase Volume by 2%", "Control+Numpad Add"], ["Decrease Volume by 2%", "Control+Numpad Subtract"], ["Increase Auxiliary Volume by 2%", "Control+Shift+Numpad Add"], ["Decrease Auxiliary Volume by 2%", "Control+Shift+Numpad Subtract"], 0, ["Mute", "Control+Numpad 0"], ["Set Volume to 10%", "Control+Numpad 1"], ["Set Volume to 20%", "Control+Numpad 2"], ["Set Volume to 30%", "Control+Numpad 3"], ["Set Volume to 40%", "Control+Numpad 4"], ["Set Volume to 50%", "Control+Numpad 5"], ["Set Volume to 60%", "Control+Numpad 6"], ["Set Volume to 70%", "Control+Numpad 7"], ["Set Volume to 80%", "Control+Numpad 8"], ["Set Volume to 90%", "Control+Numpad 9"], ["Set Volume to 100%", "Control+Numpad Multiply"], 0, ["Toggle Solo Mode", "Control+Numpad Divide"], ["Toggle Solo Mode With Message", "Control+Shift+Numpad Divide"]]

scripthotkeys["Windows"] := [["Activate Window Profile - Main", "Control+Windows+Comma"], 0, ["Center Active Window Horizontally", "Windows+Numpad 0"], ["Center Active Window", "Windows+Numpad Dot"], ["Center Active Window Vertically", "Windows+Numpad Enter"], 0, ["Move Active Window and Size to 50% of the Screen", "-"], ["Bottom Left", "Windows+Numpad 1"], ["Bottom Center", "Windows+Numpad 2"], ["Bottom Right", "Windows+Numpad 3"], ["Center Left", "Windows+Numpad 4"], ["Center", "Windows+Numpad 5"], ["Center Right", "Windows+Numpad 6"], ["Top Left", "Windows+Numpad 7"], ["Top Center", "Windows+Numpad 8"], ["Top Right", "Windows+Numpad 9"], 0, ["Move Active Window Up", "Windows+Alt+Numpad 8"], ["Move Active Window Right", "Windows+Alt+Numpad 6"], ["Move Active Window Down", "Windows+Alt+Numpad 2"], ["Move Active Window Left", "Windows+Alt+Numpad 4"], 0, ["Resize Active Window by +5% of the Screen", "Windows+Numpad Multiply"], ["Resize Active Window by -5% of the Screen", "Windows+Numpad Divide"], ["Resize Active Window to Fill the Screen", "Windows+Numpad Subtract"], ["Resize Active Window to Fill Screen && Taskbar", "Windows+Alt+Numpad Subtract"], 0, ["Toggle Active Window Always On Top", "Control+Windows+A"], ["Toggle Taskbar Always On Top", "Control+Windows+Alt+A"], 0, ["Toggle Active Window Borderless Mode", "Control+Windows+B"], 0, ["Toggle Window Transparency (50%)", "Control+Windows+T"], ["Toggle Window Transparency (Custom)", "Control+Windows+Alt+T"], 0, ["Toggle Theatre Mode", "Control+Windows+Forward Slash"], ["Toggle Soft Theatre Mode", "Control+Windows+Alt+Forward Slash"]]

for n, script in all {
 name := StrReplace(script, " ")
 if(script = 0) {
  Menu, scriptlist, Add
 } else if(scripthotkeys[script]) {
  for i, item in scripthotkeys[script] {
   if(item = 0) {
    Menu, scriptlist%name%, Add
   } else {
    label := item[1]
    Menu, scriptlist%name%, Add, %label%, Nothing
   }
  }
  for i, item in scripthotkeys[script] {
   if(item = 0) {
    Menu, scriptlist%name%, Add
   } else {
    label := item[2]
    if(i = 1) {
     Menu, scriptlist%name%, Add, %label%, Nothing, +Break
    } else {
     Menu, scriptlist%name%, Add, %label%, Nothing
    }
   }
  }
  Menu, scriptlist, Add, %script%, :scriptlist%name%
 } else if(n = 1) {
  Menu, scriptlist, Add, .Hotkeys.ahk, :list
  Menu, scriptlist, Default, 1&
 }
}

Menu, hotkey, Add, &.Hotkeys.ahk, :Tray
Menu, hotkey, Default, 1&
Menu, hotkey, Add
Menu, hotkey, Add, Windows &Troubleshooters, :trouble
act := Func("runWindowsTroubleshooter").Bind("NetworkDiagnosticsWeb")
Menu, hotkey, Add, &Internet Connection, % act
Menu, hotkey, Add
Menu, hotkey, Add, Script &Hotkeys, :scriptlist
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

Nothing:
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
