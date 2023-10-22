#SingleInstance Ignore
DetectHiddenWindows(true)

; An array to contain WinTitles to minimize to the System Tray
totray := []
; An array to contain WinTitles to hide that don't hide when using the Run command
hide := []

; Run any applications and push WinTitles to [totray] and [hide]
Run("*RunAs C:\Users\TGekko\Documents\AutoHotkey\.Hotkeys.ahk", "C:\Users\TGekko\Documents\AutoHotkey")
Run("*RunAs C:\Program Files (x86)\VB\Voicemeeter\voicemeeter8.exe", "C:\Program Files (x86)\VB\Voicemeeter")
Run("*RunAs E:\Games\Steam\steam.exe", "E:\Games\Steam")
Run("*RunAs C:\Users\TGekko\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Discord Inc\Discord.lnk")
Run("*RunAs C:\Program Files\Voicemod Desktop\VoicemodDesktop.exe", "C:\Program Files\Voicemod Desktop", "Hide")
Run("*RunAs C:\Program Files\Elgato\StreamDeck\StreamDeck.exe", "C:\Program Files\Elgato\StreamDeck")
hide.push("Stream Deck ahk_exe StreamDeck.exe")
Run('*RunAs "' A_AppData '\..\Local\Microsoft\WindowsApps\wt.exe" -w 0 new-tab -d . -p "Command Prompt" "E:\Games\Steam\steamapps\common\Valheim dedicated server\server.TheEsteemed.bat"', "E:\Games\Steam\steamapps\common\Valheim dedicated server")
totray.push('The Esteemed - Valheim Server ahk_exe WindowsTerminal.exe')

; Wait for the items in [totray] to exist, then minimize them to the System Tray
for(item in totray)
 Run('C:\Users\TGekko\Documents\AutoHotkey\Windows\ToTray.ahk "' item '" "wait"')

; Wiat for the items in [hide] to exist, then hide them
for(i, item in hide) {
 path := A_Temp '\.Hotkeys.Custom_Startup.Hide.' i '.ahk'
 try FileDelete(path)
 FileAppend('
 (
  #SingleInstance Off
  #NoTrayIcon
  DetectHiddenWindows(true)
  try {
   WinHide('ahk_id ' WinWait(A_Args[1]))
   FileDelete(A_ScriptFullPath)
  }
 )', path)
 Run('"' path '" "' item '"')
}

ExitApp