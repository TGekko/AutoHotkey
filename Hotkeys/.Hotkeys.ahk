#SingleInstance Force
SetTitleMatchMode 2
DetectHiddenWindows true
SetNumLockState "AlwaysOn"
loaded := false
reticle := 0x0

all := [".Hotkeys", 0, "Magicka", "Risk of Rain 2", "Valheim", 0, "Internet", "Voicemeeter", "Windows", 0, "Miscellaneous"]
menus := {
 hotkeys: Menu(),
 start: Menu(),
 stop: Menu(),
 edits: Menu(),
 trouble: Menu(),
 list: Menu(),
 scriptlist: Menu(),
 scripts: Map(),
 tray: A_TrayMenu,
 call: menus_call
}
menus_call(function:="", parameters:="__", menuvariables*) {
 if(function == "")
  return
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
 global loaded
 if(loaded) {
  global all
  for i, item in all {
   if(item != 0) {
    path := A_WorkingDir "\" item ".ahk"
    if(WinExist(path)) {
     menus.stop.Enable(item)
    } else {
     menus.stop.Disable(item)
    }
   }
  }
  menus.hotkeys.Show
 }
}
startScript(name) {
 Run "*RunAs " name ".ahk"
}
stopScript(name) {
 path := A_ScriptDir "\" name ".ahk"
 try WinClose path " ahk_class AutoHotkey"
}
editScript(name) {
 Run '"C:\Windows\Notepad.exe" "' A_WorkingDir '\' name '.ahk"'
}
openFolder() {
 Run A_WorkingDir
}
runWindowsTroubleshooter(troubleshooter) {
 Run "*RunAs " A_ComSpec "/c msdt.exe /id " troubleshooter,, "Hide"
}
sendHotkey(value) {
 SendLevel 1
 SendInput value
 SendLevel 0
}
exitAll(exitreason, exitcode) {
 global all
 for i, item in all {
  if(!(item = 0 || item = ".Hotkeys")) {
   stopScript(item)
  }
 }
}
OnExit exitAll

for i, item in all {
 if(item = 0) {
  menus.start.Add()
  menus.stop.Add()
  menus.edits.Add()
 } else {
  menus.start.Add(item, menus.call.bind(startScript, item))
  menus.stop.Add(item, menus.call.bind(stopScript, item))
  menus.edits.Add(item, menus.call.bind(editScript, item))
  if(i > 1) {
   startScript(item)
  } else {
   menus.start.Default := "1&"
   menus.stop.Default := "1&"
   menus.edits.Default := "1&"
  }
 }
}

troubleshooters := [["&Internet Connection", "NetworkDiagnosticsWeb"], ["&Hardware and Devices", "DeviceDiagnostic"], ["Incoming &Connections", "NetworkDiagnosticsInbound"], ["&Microphone", "AudioRecordingDiagnostic"], ["&Network Adapter", "NetworkDiagnosticsNetworkAdapter"], ["&Playing Audio", "AudioPlaybackDiagnostic"], ["&Search and Indexing", "SearchDiagnostic"], ["&Windows Update", "WindowsUpdateDiagnostic"]]
for i, troubleshooter in troubleshooters {
 menus.trouble.Add(troubleshooter[1], menus.call.bind(runWindowsTroubleshooter, troubleshooter[2]))
 if(i = 1) {
  menus.trouble.Default := "1&"
  menus.trouble.Add()
 }
}

scripthotkeys := Map()

scripthotkeys[".Hotkeys"] := [["Show Menu", "Win+Right Click", "#RButton"], 0, ["Hold Left Click", "Alt+9", "!9"], ["Hold Right Click", "Alt+0", "!0"], ["Repeat Left Click", "Alt+Shift+9", "!+9"], ["Repeat Right Click", "Alt+Shift+0", "!+0"], 0, ["Stop Running Hotkey", "Pause or End", "Pause"], 0, ["Move Mouse Up", "Alt+Up", "!Up"], ["Mouse Mouse Down", "Alt+Down", "!Down"], ["Mouse Mouse Left", "Alt+Left", "!Left"], ["Mouse Mouse Right", "Alt+Right", "!Right"], ["Left Click", "Alt+[", "![["], ["Right Click", "Alt+]", "!]]"], 0, ["Toggle Reticle", "Alt+Insert", "!Insert"], 0]

scripthotkeys["Magicka"] := [["Show Spell Menu", "Alt+Right Click", "!{RButton}"], 0, ["Cast Charm", "Numpad 0", "{Numpad0}"], ["Cast Conflagration", "Numpad 1", "{Numpad1}"], ["Cast Confuse", "Numpad 2", "{Numpad2}"], ["Cast Corporealize", "Numpad 3", "{Numpad3}"], ["Cast Crash to Desktop", "Numpad 4", "{Numpad4}"], ["Cast Fear", "Numpad 5", "{Numpad5}"], ["Cast Invisibility", "Numpad 6", "{Numpad6}"], ["Cast Meteor Storm", "Numpad 7", "{Numpad7}"], ["Cast Raise Dead", "Numpad 8", "{Numpad8}"], ["Cast Summon Death", "Numpad 9", "{Numpad9}"], ["Cast Summon Elemental", "Numpad Add", "{NumpadAdd}"], ["Cast Thunder Storm", "Numpad Dot", "{NumpadDot}"], ["Cast Vortex", "Numpad Subtract", "{NumpadSub}"]]

scripthotkeys["Risk of Rain 2"] := [["Show Item Reference", "Left Control", "{LControl}"], ["Show Help", "Right Control", "{RControl}"]]

scripthotkeys["Valheim"] := [["Press E 10 times", "Alt+E", "!e"], ["Scroll Through Hotbar", "Alt+Scroll", ""], ["Move Mouse", "Arrow Keys", ""], ["Left Click", "Backslash", "\"], 0, ["Train Bow", "Alt+1", "!1"], ["Train Jump", "Alt+2", "!2"], ["Train Run", "Alt+3", "!3"], ["Train Sneak", "Alt+4", "!4"], ["Train Sword", "Alt+5", "!5"]]

scripthotkeys["Internet"] := [["Skip Forward 17 times", "Control+Right", "^{Right}"], ["Skip Backward 17 times", "Control+Left", "^{Left}"], ["Toggle Browser Theatre Mode", "Control+Shift+Windows+Forward Slash", "^!#/"], 0, ["Theatre - Disable Theatre Mode", "Delete", "{Delete}"], ["Theatre - Toggle Light Mode", "Backquote", "``"], ["Theatre - Hide Browser", "Pause", "{Pause}"]]

scripthotkeys["Voicemeeter"] := [["Restart Audio Engine", "Control+Numpad Dot", "^{NumpadDot}"], 0, ["Increase Volume by 2%", "Control+Numpad Add", "^{NumpadAdd}"], ["Decrease Volume by 2%", "Control+Numpad Subtract", "^{NumpadSub}"], ["Increase Non-Auxiliary Volume by 2%", "Control+Shift+Numpad Add", "^+{NumpadAdd}"], ["Decrease Non-Auxiliary Volume by 2%", "Control+Shift+Numpad Subtract", "^!{NumpadSub}"], 0, ["Mute", "Control+Numpad 0", "^{Numpad0}"], ["Set Volume to 10%", "Control+Numpad 1", "^{Numpad1}"], ["Set Volume to 20%", "Control+Numpad 2", "^{Numpad2}"], ["Set Volume to 30%", "Control+Numpad 3", "^{Numpad3}"], ["Set Volume to 40%", "Control+Numpad 4", "^{Numpad4}"], ["Set Volume to 50%", "Control+Numpad 5", "^{Numpad5}"], ["Set Volume to 60%", "Control+Numpad 6", "^{Numpad6}"], ["Set Volume to 70%", "Control+Numpad 7", "^{Numpad7}"], ["Set Volume to 80%", "Control+Numpad 8", "^{Numpad8}"], ["Set Volume to 90%", "Control+Numpad 9", "^{Numpad9}"], ["Set Volume to 100%", "Control+Numpad Multiply", "^{NumpadMult}"], 0, ["Toggle Solo Mode", "Control+Numpad Divide", "^{NumpadDiv}"], ["Toggle Solo Mode With Message", "Control+Shift+Numpad Divide", "^!{NumpadDiv}"]]

scripthotkeys["Windows"] := []
 scripthotkeys["Windows"].push(["Manage Window Profiles", "Control+Windows+\", "^#\"], ["Activate Window Profile: Default", "Control+Windows+Comma", "^#,"], 0)
 scripthotkeys["Windows"].push(["Center Active Window Horizontally", "Windows+Numpad 0", "#{Numpad0}"], ["Center Active Window", "Windows+Numpad Dot", "#{NumpadDot}"], ["Center Active Window Vertically", "Windows+Numpad Enter", "#{NumpadEnter}"], ["Expand Active Window to Fill Screen Horizontally", "Windows+Alt+Numpad 0", "#!{Numpad0}"], ["Expand Active Window to Fill Screen Vertically", "Windows+Alt+Numpad Enter", "#!{NumpadEnter}"], 0)
 scripthotkeys["Windows"].push(["Move Active Window and Size to 50% of the Screen", "-", ""], ["Bottom Left", "Windows+Numpad 1", "#{Numpad1}"], ["Bottom Center", "Windows+Numpad 2", "#{Numpad2}"], ["Bottom Right", "Windows+Numpad 3", "#{Numpad3}"], ["Center Left", "Windows+Numpad 4", "#{Numpad4}"], ["Center", "Windows+Numpad 5", "#{Numpad5}"], ["Center Right", "Windows+Numpad 6", "#{Numpad6}"], ["Top Left", "Windows+Numpad 7", "#{Numpad7}"], ["Top Center", "Windows+Numpad 8", "#{Numpad8}"], ["Top Right", "Windows+Numpad 9", "#{Numpad9}"], 0)
 scripthotkeys["Windows"].push(["Resize Active Window by +5% of the Screen", "Windows+Numpad Multiply", "#{NumpadMult}"], ["Resize Active Window by -5% of the Screen", "Windows+Numpad Divide", "#{NumpadDiv}"], ["Resize Active Window to Fill the Screen", "Windows+Numpad Subtract", "#{NumpadSub}"], ["Resize Active Window to Fill Screen && Taskbar", "Windows+Alt+Numpad Subtract", "#!{NumpadSub}"], 0)
 scripthotkeys["Windows"].push(["Move Active Window Up", "Control+Windows+Numpad 8", "^#{Numpad8}"], ["Move Active Window Right", "Control+Windows+Numpad 6", "^#{Numpad6}"], ["Move Active Window Down", "Control+Windows+Numpad 2", "^#{Numpad2}"], ["Move Active Window Left", "Control+Windows+Numpad 4", "^#{Numpad4}"], 0)
 scripthotkeys["Windows"].push(["Move Active Window To the Top of the Screen", "Control+Windows+Numpad Div", "^#{NumpadDiv}"], ["Move Active Window To the Right Side of the Screen", "Control+Windows+Numpad 9", "^#{Numpad9}"], ["Move Active Window To the Bottom of the Screen", "Control+Windows+Numpad 5", "^#{Numpad5}"], ["Move Active Window To the Left Side of the Screen", "Control+Windows+Numpad 7", "^#{Numpad7}"], ["Move Active Window to the Bottom of the Screen Ignoring the Taskbar", "Control+Windows+Numpad 0", "^#{Numpad0}"], 0)
 scripthotkeys["Windows"].push(["Toggle Active Window Always On Top", "Control+Windows+A", "^#a"], ["Toggle Active Window Borderless Mode", "Control+Windows+B", "^#b"], ["Toggle Active Window Borderless Fullscreen", "Control+Windows+Alt+B", "^#!b"], 0)
 scripthotkeys["Windows"].push(["Toggle Window Transparency (50%)", "Control+Windows+T", "^#t"], ["Toggle Window Transparency (Custom)", "Control+Windows+Alt+T", "^#!t"], 0)
 scripthotkeys["Windows"].push(["Toggle Display Projection Mode (PC screen only or Duplicate)", "Control+Windows+P", "^#9"], 0)
 scripthotkeys["Windows"].push(["Toggle Theatre Mode", "Control+Windows+Forward Slash", "^#/"], ["Toggle Soft Theatre Mode", "Control+Windows+Alt+Forward Slash", "^#!/"], 0)
 scripthotkeys["Windows"].push(["When Theatre Mode is Active", "- ", ""], ["Disable Theatre Mode", "Delete", "{Delete}"], ["Hide Active Window (Excluding Soft Theatre Mode)", "Pause", "{Pause}"], ["Toggle Light Mode", "Backquote", "``"])

scripthotkeys["Miscellaneous"] := []
 scripthotkeys["Miscellaneous"].push(["Games", "-", ""], 0)
 scripthotkeys["Miscellaneous"].push(["Borderlands 3", "-", ""], ["Throw Grenade", "F13", "{F13}"], ["Switch Weapon Modes", "F14", "{F14}"], ["Primary Weapon Fire", "F15", "{F15}"], ["Action Skill", "F16", "{F16}"], 0)
 scripthotkeys["Miscellaneous"].push(["Citra", "-", ""], ["Go Home", "Controller Home", "{vk07}"], 0)
 scripthotkeys["Miscellaneous"].push(["Fortnite", "-", ""], ["Augment", "F13", "{F13}"], ["Show Emote Menu", "F14", "{F14}"], 0)
 scripthotkeys["Miscellaneous"].push(["Hades", "-", ""], ["Special", "MButton", "{MButton}"], ["Dash", "F13", "{F13}"], ["Interact", "F14", "{F14}"], ["Call", "F15", "{F15}"], ["Reload", "F16", "{F16}"], ["Summon", "F17", "{F17}"], ["Boon Info", "F18", "{F18}"], ["Open Codex", "F19", "{F19}"], 0)
 scripthotkeys["Miscellaneous"].push(["Minecraft", "-", ""], ["Swing Sword and Eat Food", "Alt+1", "!1"], ["Hold Shift", "Alt+Shift", "!{Shift}"], 0)
 scripthotkeys["Miscellaneous"].push(["Sonic Adventure DX", "-", ""], ["Forward", "W", "w"], ["Left", "A", "a"], ["Backward", "S", "s"], ["Right", "D", "d"], ["Jump", "Space", "{Space}"], ["Camera Left", "Left Arrow", "{Left}"], ["Camera Right", "Right Arrow", "{Right}"], ["Action", "E or Down", "e"], ["Look Around", "Up", "{Up}"], ["Back", "Backspace", "{Backspace}"], ["Pause", "Escape or Enter", "{Escape}"], 0)
 scripthotkeys["Miscellaneous"].push(["Terraria", "-", ""], ["Map", "F13", "{F13}"], ["Duplicate Honey", "Alt+1", "!1"], ["Duplicate Lava", "Alt+2", "!2"], 0)
 scripthotkeys["Miscellaneous"].push(["The Escapists 2", "-", ""], ["Train Strength", "Alt+1", "!1"], 0)
 scripthotkeys["Miscellaneous"].push(["ARK: Survival Evolved", "-", ""], ["Select Hotbar Slot 1", "F13", "1"], ["Show Whistle Menu", "F14", "``"], ["Emote 1", "F15", "["], ["Select Hotbar Slot 2", "F16", "0"], ["Drop Inventory Item", "F17", "o"], ["Unequip Hotbar Item", "F18", "q"], ["Emote 2", "F19", "]"], 0)
 scripthotkeys["Miscellaneous"].push(["Applications", "-", ""], 0)
 scripthotkeys["Miscellaneous"].push(["paint.net", "-", ""], ["Undo", "Control+Shift+Z", "^+z"])

for script in all {
 if(script == 0) {
  menus.scriptlist.Add()
 } else {
  menus.scripts[script] := Menu()
  i := 1
  Loop 2 {
   n := A_Index
   for l, item in scripthotkeys[script] {
    if(item == 0) {
     menus.scripts[script].Insert(i++ "&")
    } else {
     menus.scripts[script].Insert(i++ "&", item[n], menus.call.bind(sendHotkey, item[3]), (n == 2 && l == 1 ? "+Break" : ""))
    }
   }
  }
  menus.scriptlist.Add(script (script == ".Hotkeys" ? ".ahk" : ""), menus.scripts[script])
 }
}

menus.hotkeys.Add("&.Hotkeys.ahk", menus.tray)
menus.hotkeys.Default := "1&"
menus.hotkeys.Add()
menus.hotkeys.Add("Windows &Troubleshooters", menus.trouble)
menus.hotkeys.Add("&Network Adapter", menus.call.bind(runWindowsTroubleshooter, "NetworkDiagnosticsNetworkAdapter"))
menus.hotkeys.Add()
menus.hotkeys.Add("Script &Hotkeys", menus.scriptlist)
menus.hotkeys.Add("Modify &Clipboard", menus.call.bind(modifyClipboard, "__"))
menus.hotkeys.Add("Toggle &Reticle", menus.call.bind(toggleReticle, "__"))
menus.hotkeys.Add()
menus.hotkeys.Add("&Start Script", menus.start)
menus.hotkeys.Add("Sto&p Script", menus.stop)
menus.hotkeys.Add("&Edit Script", menus.edits)

menus.tray.Add()
menus.tray.Add("Open Hotkey &Folder", menus.call.bind(openFolder, "__"))
menus.tray.Add("Hotkey &Menu", menus.call.bind(showMenu, "__"))

loaded := true



; Hotkeys

!9::Run ".Hotkeys\Hold_Left_Mouse_Button.ahk"
!0::Run ".Hotkeys\Hold_Right_Mouse_Button.ahk"
!+9::Run ".Hotkeys\Repeat_Left_Mouse_Button.ahk"
!+0::Run ".Hotkeys\Repeat_Right_Mouse_Button.ahk"

;!Up::DllCall("mouse_event", "UInt", 0x01, "UInt", 0, "UInt", -1)
;!Down::DllCall("mouse_event", "UInt", 0x01, "UInt", 0, "UInt", 1)
;!Left::DllCall("mouse_event", "UInt", 0x01, "UInt", -1, "UInt", 0)
;!Right::DllCall("mouse_event", "UInt", 0x01, "UInt", 1, "UInt", 0)
!Up::MouseMove 0, -1, 0, "R"
!Down::MouseMove 0, 1, 0, "R"
!Left::MouseMove -1, 0, 0, "R"
!Right::MouseMove 1, 0, 0, "R"
![:: {
 Click "Down"
 KeyWait "LButton"
}
![ Up::Click "Up"
!]:: {
 Click "Right Down"
 KeyWait "RButton"
}
!] Up::Click "Right Up"
#RButton::showMenu()

!Insert::toggleReticle()

Pause:
 Send "{Pause}"
return



; Additional Functions

modifyClipboard() {
 If(MsgBox("This will convert your clipboard to text. Would you like to continue?", "Edit Clipboard?", "4") == "Yes") {
  clipmod := InputBox("Modify the clipboard contents below and submit!", "Modify Clipboard", "w600 h200")
  if(clipmod.Result := "OK")
   A_Clipboard := clipmod.Value
 }
}

toggleReticle() {
 global reticle
 if(WinExist(reticle.Hwnd)) {
  reticle.Destroy()
 } else {
  reticle := Gui("+AlwaysOnTop +ToolWindow -Caption -Disabled +E0x20 +LastFound", ".Hotkeys.ahk Reticle")
  reticle.BackColor("100100")
  WinSetTransColor "100100", reticle.Hwnd
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
