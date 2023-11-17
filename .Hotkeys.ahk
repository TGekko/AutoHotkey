#SingleInstance Force
SetTitleMatchMode(2)
DetectHiddenWindows(true)
CoordMode("Mouse", "Screen")
SetNumLockState("AlwaysOn")
loaded := false

#Include "Common.ahk"
defaultsettings := [
 ["Internet Executables", "chrome.exe, msedge.exe, firefox.exe"],
 ["Menu Hotkey Delay", 0],
 ["Script Editor", A_AppData '\..\Local\Programs\Microsoft VS Code\Code.exe'],
 ["Transparent Windows", ""],
 ["Windows",, "11"]
]

all := [".Hotkeys", 0, "Magicka", "Risk of Rain 2", "Valheim", 0, "Internet", "Voicemeeter", "Windows", 0, "Miscellaneous", "Window Events"]
menus := {
 hotkeys: Menu(),
 start: Menu(),
 stop: Menu(),
 stoplistall: Menu(),
 edits: Menu(),
 trouble: Menu(),
 list: Menu(),
 scriptlist: Menu(),
 clip: Menu(),
 scripts: Map(),
 tray: A_TrayMenu,
}

showMenu() {
 global loaded
 if(loaded) {
  global all
  for(i, item in all) {
   if(item != 0) {
    path := A_WorkingDir "\" item ".ahk"
    if(WinExist(path)) {
     menus.stop.Enable(item)
    } else {
     menus.stop.Disable(item)
    }
   }
  }
  menus.hotkeys.Show()
 }
}
startScript(name) {
 Run('"' A_AhkPath '" "' name '.ahk"')
}
stopScript(name, path := true) {
 try WinClose((path ? A_ScriptDir "\" name ".ahk" : name) " ahk_class AutoHotkey")
}
editScript(name) {
 try {
  Run('"' GetSetting('Script Editor') '" "' A_WorkingDir '\' name '.ahk"')
 } catch {
  Run('"C:\Windows\Notepad.exe" "' A_WorkingDir '\' name '.ahk"')
 }
}
openFolder() {
 Run(A_WorkingDir)
}
runWindowsTroubleshooter(troubleshooter) {
 version := GetSetting('Windows')
 if(version = 10)
  Run(A_ComSpec " /c msdt.exe /id " troubleshooter,, "Hide")
 else if(version = 11)
  Run(A_ComSpec " /c start ms-contact-support://" (SubStr(troubleshooter, 1, 1) = "+" ? "?ActivationType=" SubStr(troubleshooter, 2) "&invoker=Emerald" : "smc-to-emerald/" troubleshooter),, "Hide")
}
sendHotkey(value) {
 try Sleep(GetSetting('Menu Hotkey Delay') * 1000)
 SendLevel(1)
 SendInput(value)
 SendLevel(0)
}
exitAll() {
 global all
 stop := [".Hotkeys\Hold_Left_Mouse_Button", ".Hotkeys\Hold_Right_Mouse_Button", ".Hotkeys\Move_Constantly", ".Hotkeys\Repeat_Left_Mouse_Button", ".Hotkeys\Repeat_Right_Mouse_Button"]
 for(item in all) {
  if(!(item = 0 || item = ".Hotkeys")) {
   stopScript(item)
  }
 }
 for(item in stop) {
  stopScript(item)
 }
}
OnExit((z*) => exitAll())

stopListAll() {
 menus.stoplistall.Delete()
 menus.stoplistall.Add("Stop all .Hotkeys.ahk scripts other than .Hotkeys.ahk", (z*) => exitAll())
 menus.stoplistall.Add()
 list := WinGetList("ahk_class AutoHotkey")
 for(item in list) {
  title := WinGetTitle("ahk_id " item)
  menus.stoplistall.Add(RegExReplace(title, " - AutoHotkey v[\.0-9]+$"), ((z*) => stopScript("ahk_id " z[1], false)).bind(item))
 }
 menus.stoplistall.Show()
}

;troubleshooters := [["&Internet Connection", "NetworkDiagnosticsWeb"], ["&Hardware and Devices", "DeviceDiagnostic"], ["Incoming &Connections", "NetworkDiagnosticsInbound"], ["&Microphone", "AudioRecordingDiagnostic"], ["&Network Adapter", "NetworkDiagnosticsNetworkAdapter"], ["&Playing Audio", "AudioPlaybackDiagnostic"], ["&Search and Indexing", "SearchDiagnostic"], ["&Windows Update", "WindowsUpdateDiagnostic"]]
troubleshooters := [["&Network and Internet", "+NetworkDiagnostics"], ["&Audio", "AudioTroubleshooter"], ["Background &Intelligent Transfer Service", "BITSTroubleshooter"], ["&Bluetooth", "BluetoothTroubleshooter"], ["&Camera", "CameraTroubleshooter"], ["&Printer", "PrinterTroubleshooter"], ["Pro&gram Compatibility", "ProgramCompatTroubleshooter"], ["&Video Playback", "VideoPlaybackTroubleshooter"], ["Windows &Media Player", "WMPTroubleshooter"], ["&Windows Update", "WindowsUpdateTroubleshooter"]]
for(i, troubleshooter in troubleshooters) {
 menus.trouble.Add(troubleshooter[1], ((z*) => runWindowsTroubleshooter(z[1])).bind(troubleshooter[2]))
 if(i = 1) {
  menus.trouble.Default := "1&"
  menus.trouble.Add()
 }
}

; Format
; "String"     == New Sub-menu
; -1           == Exit Sub-menu
; 0            == Dividing Line
; ["", "", ""] == ["Left menu item", "Right menu item", "Hotkey to Send when selected"]
scripthotkeys := Map()
scripthotkeys[".Hotkeys"] := [["Show Menu", "Win+Right Click", "#{RButton}"], 0, ["Hold Left Click", "Alt+9", "!9"], ["Hold Right Click", "Alt+0", "!0"], ["Repeat Left Click", "Alt+Shift+9", "!+9"], ["Repeat Right Click", "Alt+Shift+0", "!+0"], ["Move Constantly", "Alt+Shift+Backspace", "!+{Backspace}"], 0, ["Stop Running Hotkey", "Pause or End", "{Pause}"], 0, ["Move Mouse Up", "Alt+Up", "!{Up}"], ["Mouse Mouse Down", "Alt+Down", "!{Down}"], ["Mouse Mouse Left", "Alt+Left", "!{Left}"], ["Mouse Mouse Right", "Alt+Right", "!{Right}"], ["Left Click", "Alt+[", "!["], ["Right Click", "Alt+]", "!]"], 0, ["Toggle Reticle", "Alt+Insert", "!{Insert}"], ["Toggle Amplified Cursor", "Alt+Print Screen", "!{PrintScreen}"]]
scripthotkeys["Magicka"] := [["Show Spell Menu", "Alt+Right Click", "!{RButton}"], 0, ["Cast Charm", "Numpad 0", "{Numpad0}"], ["Cast Conflagration", "Numpad 1", "{Numpad1}"], ["Cast Confuse", "Numpad 2", "{Numpad2}"], ["Cast Corporealize", "Numpad 3", "{Numpad3}"], ["Cast Crash to Desktop", "Numpad 4", "{Numpad4}"], ["Cast Fear", "Numpad 5", "{Numpad5}"], ["Cast Invisibility", "Numpad 6", "{Numpad6}"], ["Cast Meteor Storm", "Numpad 7", "{Numpad7}"], ["Cast Raise Dead", "Numpad 8", "{Numpad8}"], ["Cast Summon Death", "Numpad 9", "{Numpad9}"], ["Cast Summon Elemental", "Numpad Add", "{NumpadAdd}"], ["Cast Thunder Storm", "Numpad Dot", "{NumpadDot}"], ["Cast Vortex", "Numpad Subtract", "{NumpadSub}"]]
scripthotkeys["Risk of Rain 2"] := [["Show Item Reference", "Left Control", "{LControl}"], ["Show Help", "Right Control", "{RControl}"]]
scripthotkeys["Valheim"] := [["Press E 10 times", "Alt+E", "!e"], ["Scroll Through Hotbar", "Alt+Scroll", ""], ["Move Mouse", "Arrow Keys", ""], ["Left Click", "Backslash", "\"], 0, ["Train Bow", "Alt+1", "!1"], ["Train Jump", "Alt+2", "!2"], ["Train Run", "Alt+3", "!3"], ["Train Sneak", "Alt+4", "!4"], ["Train Sword", "Alt+5", "!5"]]
scripthotkeys["Internet"] := [["Skip Forward 17 times", "Control+Right", "^{Right}"], ["Skip Backward 17 times", "Control+Left", "^{Left}"], ["Toggle Browser Theatre Mode", "Control+Shift+Windows+Forward Slash", "^!#/"], 0, ["Theatre - Disable Theatre Mode", "Delete", "{Delete}"], ["Theatre - Toggle Light Mode", "Backquote", "``"], ["Theatre - Hide Browser", "Pause", "{Pause}"]]
scripthotkeys["Voicemeeter"] := [["Restart Audio Engine", "Control+Numpad Dot", "^{NumpadDot}"], 0, ["Increase Volume by 2%", "Control+Numpad Add", "^{NumpadAdd}"], ["Decrease Volume by 2%", "Control+Numpad Subtract", "^{NumpadSub}"], ["Increase Non-Auxiliary Volume by 2%", "Control+Shift+Numpad Add", "^+{NumpadAdd}"], ["Decrease Non-Auxiliary Volume by 2%", "Control+Shift+Numpad Subtract", "^!{NumpadSub}"], 0, ["Set Volume to 0%", "Control+Numpad 0", "^{Numpad0}"], ["Set Volume to 10%", "Control+Numpad 1", "^{Numpad1}"], ["Set Volume to 20%", "Control+Numpad 2", "^{Numpad2}"], ["Set Volume to 30%", "Control+Numpad 3", "^{Numpad3}"], ["Set Volume to 40%", "Control+Numpad 4", "^{Numpad4}"], ["Set Volume to 50%", "Control+Numpad 5", "^{Numpad5}"], ["Set Volume to 60%", "Control+Numpad 6", "^{Numpad6}"], ["Set Volume to 70%", "Control+Numpad 7", "^{Numpad7}"], ["Set Volume to 80%", "Control+Numpad 8", "^{Numpad8}"], ["Set Volume to 90%", "Control+Numpad 9", "^{Numpad9}"], ["Set Volume to 100%", "Control+Numpad Multiply", "^{NumpadMult}"], 0, ["Toggle Solo Mode", "Control+Numpad Divide", "^{NumpadDiv}"], ["Toggle Solo Mode With Message", "Control+Shift+Numpad Divide", "^!{NumpadDiv}"]]
scripthotkeys["Windows"] := []
 scripthotkeys["Windows"].push(["Manage Window Profiles", "Control+Windows+\", "^#\"], ["Activate Window Profile: Default", "Control+Windows+Comma", "^#,"], 0)
 scripthotkeys["Windows"].push("Center or Expand Active Window", ["Center Active Window Horizontally", "Windows+Numpad 0", "#{Numpad0}"], ["Center Active Window", "Windows+Numpad Dot", "#{NumpadDot}"], ["Center Active Window Vertically", "Windows+Numpad Enter", "#{NumpadEnter}"], ["Expand Active Window to Fill Screen Horizontally", "Windows+Alt+Numpad 0", "#!{Numpad0}"], ["Expand Active Window to Fill Screen Vertically", "Windows+Alt+Numpad Enter", "#!{NumpadEnter}"], -1)
 scripthotkeys["Windows"].push("Move Active Window and Size to half of the Screen", ["Bottom Left", "Windows+Numpad 1", "#{Numpad1}"], ["Bottom Center", "Windows+Numpad 2", "#{Numpad2}"], ["Bottom Right", "Windows+Numpad 3", "#{Numpad3}"], ["Center Left", "Windows+Numpad 4", "#{Numpad4}"], ["Center", "Windows+Numpad 5", "#{Numpad5}"], ["Center Right", "Windows+Numpad 6", "#{Numpad6}"], ["Top Left", "Windows+Numpad 7", "#{Numpad7}"], ["Top Center", "Windows+Numpad 8", "#{Numpad8}"], ["Top Right", "Windows+Numpad 9", "#{Numpad9}"], -1)
 scripthotkeys["Windows"].push("Move Active Window and Size to one third of the Screen", ["Bottom Left", "Windows+Alt+Numpad 1", "#!{Numpad1}"], ["Bottom Center", "Windows+Alt+Numpad 2", "#!{Numpad2}"], ["Bottom Right", "Windows+Alt+Numpad 3", "#!{Numpad3}"], ["Center Left", "Windows+Alt+Numpad 4", "#!{Numpad4}"], ["Center", "Windows+Alt+Numpad 5", "#!{Numpad5}"], ["Center Right", "Windows+Alt+Numpad 6", "#!{Numpad6}"], ["Top Left", "Windows+Alt+Numpad 7", "#!{Numpad7}"], ["Top Center", "Windows+Alt+Numpad 8", "#!{Numpad8}"], ["Top Right", "Windows+Alt+Numpad 9", "#!{Numpad9}"], -1)
 scripthotkeys["Windows"].push("Resize Active Window", ["Resize Active Window by +5% of the Screen", "Windows+Numpad Multiply", "#{NumpadMult}"], ["Resize Active Window by -5% of the Screen", "Windows+Numpad Divide", "#{NumpadDiv}"], ["Resize Active Window to Fill the Screen", "Windows+Numpad Subtract", "#{NumpadSub}"], ["Resize Active Window to Fill Screen && Taskbar", "Windows+Alt+Numpad Subtract", "#!{NumpadSub}"], -1)
 scripthotkeys["Windows"].push("Move Window", ["Move Active Window Up By One Pixel", "Control+Windows+Numpad 8", "^#{Numpad8}"], ["Move Active Window Right By One Pixel", "Control+Windows+Numpad 6", "^#{Numpad6}"], ["Move Active Window Down By One Pixel", "Control+Windows+Numpad 2", "^#{Numpad2}"], ["Move Active Window Left By One Pixel", "Control+Windows+Numpad 4", "^#{Numpad4}"], 0, ["Move Active Window Up By 10 Pixels", "Control+Windows+Alt+Numpad 8", "^#!{Numpad8}"], ["Move Active Window Right By 10 Pixels", "Control+Windows+Alt+Numpad 6", "^#!{Numpad6}"], ["Move Active Window Down By 10 Pixels", "Control+Windows+Alt+Numpad 2", "^#!{Numpad2}"], ["Move Active Window Left By 10 Pixels", "Control+Windows+Alt+Numpad 4", "^#!{Numpad4}"], -1)
 scripthotkeys["Windows"].push("Move Window to the Screen's Edge", ["Move Active Window To the Top of the Screen", "Control+Windows+Numpad Div", "^#{NumpadDiv}"], ["Move Active Window To the Right Side of the Screen", "Control+Windows+Numpad 9", "^#{Numpad9}"], ["Move Active Window To the Bottom of the Screen", "Control+Windows+Numpad 5", "^#{Numpad5}"], ["Move Active Window To the Left Side of the Screen", "Control+Windows+Numpad 7", "^#{Numpad7}"], ["Move Active Window to the Bottom of the Screen Ignoring the Taskbar", "Control+Windows+Numpad 0", "^#{Numpad0}"], -1)
 scripthotkeys["Windows"].push("Affect the Active Window", ["Toggle Active Window Always On Top", "Control+Windows+A", "^#a"], ["Set Active Window Always On Bottom & Hide From Taskbar", "Control+Windows+Shift+A", "^#+a"], ["Set Active Window Parent to the Desktop (Remove From Always On Bottom)", "Control+Windows+Alt+A", "^#!a"], ["Toggle Active Window Borderless Mode", "Control+Windows+B", "^#b"], ["Toggle Active Window Borderless Fullscreen", "Control+Windows+Alt+B", "^#!b"], ["Toggle Window Transparency (50%)", "Control+Windows+T", "^#t"], ["Toggle Window Transparency (Custom)", "Control+Windows+Alt+T", "^#!t"], ["Set Window Transparency Color", "Control+Windows+Shift+T", "^#+t"], -1, ["Minimize Active Window to System Tray", "Windows+Backspace", "#{Backspace}"], ["Suspend or Resume Active Window Process", "Control+Windows+Backspace", "^#{Backspace}"], 0)
 scripthotkeys["Windows"].push(["Toggle Display Projection Mode (PC screen only or Duplicate)", "Control+Windows+P", "^#9"], 0)
 scripthotkeys["Windows"].push(["Toggle Theatre Mode", "Control+Windows+Forward Slash", "^#/"], ["Toggle Soft Theatre Mode", "Control+Windows+Alt+Forward Slash", "^#!/"])
 scripthotkeys["Windows"].push("When Theatre Mode is Active", ["Disable Theatre Mode", "Delete", "{Delete}"], ["Hide Active Window (Excluding Soft Theatre Mode)", "Pause", "{Pause}"], ["Toggle Light Mode", "Backquote", "``"], -1, 0)
 scripthotkeys["Windows"].push("Adjust Volume", ["Set Volume to 0%", "Control+0 or Control+Numpad 0", "^0"], ["Set Volume to 10%", "Control+1 or Control+Numpad 1", "^1"], ["Set Volume to 20%", "Control+2 or Control+Numpad 2", "^2"], ["Set Volume to 30%", "Control+3 or Control+Numpad 3", "^3"], ["Set Volume to 40%", "Control+4 or Control+Numpad 4", "^4"], ["Set Volume to 50%", "Control+5 or Control+Numpad 5", "^5"], ["Set Volume to 60%", "Control+6 or Control+Numpad 6", "^6"], ["Set Volume to 70%", "Control+7 or Control+Numpad 7", "^7"], ["Set Volume to 80%", "Control+8 or Control+Numpad 8", "^8"], ["Set Volume to 90%", "Control+9 or Control+Numpad 9", "^9"], ["Set Volume to 100%", "Control+/ or Control+Numpad *", "^/"], ["Increase Volume by 2%", "Control+= or Control+Numpad +", "^="], ["Decrease Volume by 2%", "Control+- or Control+Numpad -", "^-"], -1, 0)
 scripthotkeys["Windows"].push(["Right Windows Key", "Apps Key", "{AppsKey}"])
scripthotkeys["Miscellaneous"] := []
 scripthotkeys["Miscellaneous"].push("Borderlands 3", ["Throw Grenade", "F13", "{F13}"], ["Switch Weapon Modes", "F14", "{F14}"], ["Primary Weapon Fire", "F15", "{F15}"], ["Action Skill", "F16", "{F16}"], -1)
 scripthotkeys["Miscellaneous"].push("Citra", ["Go Home", "Controller Home", "{vk07}"], -1)
 scripthotkeys["Miscellaneous"].push("Fortnite", ["Augment", "F13", "{F13}"], ["Show Emote Menu", "F14", "{F14}"], -1)
 scripthotkeys["Miscellaneous"].push("Hades", ["Special", "MButton", "{MButton}"], ["Dash", "F13", "{F13}"], ["Interact", "F14", "{F14}"], ["Call", "F15", "{F15}"], ["Reload", "F16", "{F16}"], ["Summon", "F17", "{F17}"], ["Boon Info", "F18", "{F18}"], ["Open Codex", "F19", "{F19}"], -1)
 scripthotkeys["Miscellaneous"].push("Minecraft", ["Swing Sword and Eat Food", "Alt+1", "!1"], ["Hold Shift", "Alt+Shift", "!{Shift}"], -1)
 scripthotkeys["Miscellaneous"].push("Sonic Adventure DX", ["Forward", "W", "w"], ["Left", "A", "a"], ["Backward", "S", "s"], ["Right", "D", "d"], ["Jump", "Space", "{Space}"], ["Camera Left", "Left Arrow", "{Left}"], ["Camera Right", "Right Arrow", "{Right}"], ["Action", "E or Down", "e"], ["Look Around", "Up", "{Up}"], ["Back", "Backspace", "{Backspace}"], ["Pause", "Escape or Enter", "{Escape}"], -1)
 scripthotkeys["Miscellaneous"].push("Terraria", ["Map", "F13", "{F13}"], ["Duplicate Honey", "Alt+1", "!1"], ["Duplicate Lava", "Alt+2", "!2"], -1)
 scripthotkeys["Miscellaneous"].push("The Escapists 2", ["Train Strength", "Alt+1", "!1"], -1)
 scripthotkeys["Miscellaneous"].push("ARK: Survival Evolved", ["Select Hotbar Slot 1", "F13", "1"], ["Show Whistle Menu", "F14", "``"], ["Emote 1", "F15", "["], ["Select Hotbar Slot 2", "F16", "0"], ["Drop Inventory Item", "F17", "o"], ["Unequip Hotbar Item", "F18", "q"], ["Emote 2", "F19", "]"], -1, 0)
 scripthotkeys["Miscellaneous"].push("Notepad", ["Undo", "Control+Shift+Z", "^+z"], -1)
 scripthotkeys["Miscellaneous"].push("paint.net", ["Undo", "Control+Shift+Z", "^+z"], -1)

menus.clip.Add("Modify Text", (z*) => modifyClipboard())
menus.clip.Add()
menus.clip.Add("Remove Quotation Marks", (z*) => clipboardReplace('"'))
menus.clip.Add("Replace Line Breaks with Commas", (z*) => clipboardReplace("`n", ","))

menus.hotkeys.Add("&.Hotkeys.ahk", menus.tray)
menus.hotkeys.Default := "1&"
menus.hotkeys.Add("&Customize", (z*) => Run('Notepad.exe "' A_AppData '\.Hotkeys\settings"'))
menus.hotkeys.Add()
menus.hotkeys.Add("Windows &Troubleshooters", menus.trouble)
menus.hotkeys.Add("&Network and Internet", (z*) => runWindowsTroubleshooter("NetworkAndInternetTroubleshooter"))
menus.hotkeys.Add()
menus.hotkeys.Add("Script &Hotkeys", menus.scriptlist)
menus.hotkeys.Add("&Modify Clipboard", menus.clip)
menus.hotkeys.Add("Toggle &Reticle", (z*) => toggleReticle())
menus.hotkeys.Add("Stop &Active Thread", (z*) => SendHotkey("Pause"))
menus.hotkeys.Add()
menus.hotkeys.Add("&Start Script", menus.start)
menus.hotkeys.Add("Sto&p Script", menus.stop)
menus.hotkeys.Add("&Edit Script", menus.edits)

menus.tray.Add()
menus.tray.Add("Open Hotkey &Folder", (z*) => openFolder())
menus.tray.Add("Hotkey &Menu", (z*) => showMenu())

reticle := 0x0
locursor := 0x0

begin() {
 global
 SetSetting(defaultsettings,, false)

 for(i, item in all) {
  if(item = 0) {
   menus.start.Add()
   menus.stop.Add()
   menus.edits.Add()
  } else {
   menus.start.Add(item, ((z*) => startScript(z[1])).bind(item))
   menus.stop.Add(item, ((z*) => stopScript(z[1])).bind(item))
   menus.edits.Add(item, ((z*) => editScript(z[1])).bind(item))
   if(i > 1) {
    startScript(item)
   } else {
    menus.start.Default := "1&"
    menus.stop.Default := "1&"
    menus.edits.Default := "1&"
   }
  }
 }
 menus.stop.Add()
 menus.stop.Add("List All Running Scripts", (z*) => stopListAll())
 
 for(script in all) {
  if(script == 0) {
   menus.scriptlist.Add()
  } else if(scripthotkeys.has(script)) {
   menus.scripts[script] := Menu()
   i := [1]
   Loop(2) {
    n := A_Index
    scriptmenu := [script]
    subbreak := false
    try {
     for(l, item in scripthotkeys[script]) {
      if(item == -1) {
       scriptmenu.RemoveAt(1)
       i.RemoveAt(1)
      } else if(item == 0) {
       menus.scripts[scriptmenu[1]].Insert(i[1]++ "&")
       if(i.Length > 1)
        menus.scripts[scriptmenu[1] "+"]++
      } else if(Type(item) = "string") {
       try {
        Type(menus.scripts[script l])
        subbreak := true
       } catch {
        menus.scripts[script l] := Menu()
        menus.scripts[script l "+"] := 1 
       }
       menus.scripts[script].Insert(i[1]++ "&", n == 1 ? item : "-", n == 1 ? menus.scripts[script l] : (z*) => {}, (n == 2 && l == 1 ? "+Break" : ""))
       scriptmenu.InsertAt(1, script l)
       i.InsertAt(1, menus.scripts[script l "+"])
      } else {
       menus.scripts[scriptmenu[1]].Insert(i[1]++ "&", item[n], ((z*) => sendHotkey(z[1])).bind(item[3]), ((n == 2 && l == 1) || subbreak ? "+Break" : ""))
       subbreak := false
       if(i.Length > 1)
        menus.scripts[scriptmenu[1] "+"]++
      }
     }
    }
   }
   menus.scriptlist.Add(script (script == ".Hotkeys" ? ".ahk" : ""), menus.scripts[script])
  } else {
   menus.scriptlist.Add(script, (z*) => {})
  }
 }
 loaded := true
}

begin()



; Hotkeys

!9::Run(".Hotkeys\Hold_Left_Mouse_Button.ahk")
!0::Run(".Hotkeys\Hold_Right_Mouse_Button.ahk")
!+9::Run(".Hotkeys\Repeat_Left_Mouse_Button.ahk")
!+0::Run(".Hotkeys\Repeat_Right_Mouse_Button.ahk")
!+Backspace::Run(".Hotkeys\Move_Constantly.ahk")

; Using DllCall is more reliable in games.
!Up::DllCall("mouse_event", "UInt", 0x01, "UInt", 0, "UInt", -1)
!Down::DllCall("mouse_event", "UInt", 0x01, "UInt", 0, "UInt", 1)
!Left::DllCall("mouse_event", "UInt", 0x01, "UInt", -1, "UInt", 0)
!Right::DllCall("mouse_event", "UInt", 0x01, "UInt", 1, "UInt", 0)
;!Up::MouseMove(0, -1, 0, "R")
;!Down::MouseMove(0, 1, 0, "R")
;!Left::MouseMove(-1, 0, 0, "R")
;!Right::MouseMove(1, 0, 0, "R")
![:: {
 Click("Down")
 KeyWait("LButton")
}
![ Up::Click("Up")
!]:: {
 Click("Right Down")
 KeyWait("RButton")
}
!] Up::Click("Right Up")
#RButton up::showMenu()
#AppsKey::showMenu()

!Insert::toggleReticle()
!PrintScreen::{
 try {
  global locursor
  WinExist(locursor.Hwnd)
  SetTimer(locursorUI, 0)
  locursor.Destroy()
 } catch {
  SetTimer(locursorUI, 7)
 }
}

Pause:
 Send("{Pause}")
return



; Additional Functions

modifyClipboard() {
 If(MsgBox("This will convert your clipboard to text. Would you like to continue?", "Edit Clipboard?", "4") == "Yes") {
  clipmod := InputBox("Modify the clipboard contents below and submit!", "Modify Clipboard", "w600 h200")
  if(clipmod.Result := "OK")
   A_Clipboard := clipmod.Value
 }
}

clipboardReplace(that, with:="") {
 try A_Clipboard := StrReplace(A_Clipboard, that, with)
}

toggleReticle() {
 global reticle
 try {
  WinExist(reticle.Hwnd)
  reticle.Destroy()
 } catch {
  reticle := Gui("+AlwaysOnTop +ToolWindow -Caption -Disabled +E0x20 +LastFound", ".Hotkeys.ahk Reticle")
  reticle.BackColor := "100100"
  WinSetTransColor("100100", reticle.Hwnd)
  reticle.Add("Progress", "w6 h12 x" ((A_ScreenWidth / 2) -  3) " y" ((A_ScreenHeight / 2) - 16) " background000000")
  reticle.Add("Progress", "w12 h6 x" ((A_ScreenWidth / 2) +  4) " y" ((A_ScreenHeight / 2) -  3) " background000000")
  reticle.Add("Progress", "w6 h12 x" ((A_ScreenWidth / 2) -  3) " y" ((A_ScreenHeight / 2) +  4) " background000000")
  reticle.Add("Progress", "w12 h6 x" ((A_ScreenWidth / 2) - 16) " y" ((A_ScreenHeight / 2) -  3) " background000000")
  reticle.Add("Progress", "w4 h10 x" ((A_ScreenWidth / 2) -  2) " y" ((A_ScreenHeight / 2) - 15) " backgroundFFFFFF")
  reticle.Add("Progress", "w10 h4 x" ((A_ScreenWidth / 2) +  5) " y" ((A_ScreenHeight / 2) -  2) " backgroundFFFFFF")
  reticle.Add("Progress", "w4 h10 x" ((A_ScreenWidth / 2) -  2) " y" ((A_ScreenHeight / 2) +  5) " backgroundFFFFFF")
  reticle.Add("Progress", "w10 h4 x" ((A_ScreenWidth / 2) - 15) " y" ((A_ScreenHeight / 2) -  2) " backgroundFFFFFF")
  reticle.Show("x0 y0 w" A_ScreenWidth "  h" A_ScreenHeight " NoActivate")
 }
}

locursorUI() {
 MouseGetPos &x, &y
 global locursor
 p := 32
 try {
  WinExist(locursor.Hwnd)
  locursor.Move(x - p, y - p)
 } catch {
  locursor := Gui("+AlwaysOnTop +ToolWindow -Caption -Disabled +E0x20 +LastFound -DPIScale", ".Hotkeys.ahk Locursor")
  locursor.BackColor := "FF2222"
  WinSetTransColor("100100 200", locursor.Hwnd)
  s := 128
  locursor.Add("Picture", "x0 y0 w" s " h" s, ".Hotkeys\Locursor.png")
  locursor.Show("x" (x - p) " y" (y - p) " w" s " h" s " NoActivate")
 }
}