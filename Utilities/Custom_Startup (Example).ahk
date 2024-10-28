#SingleInstance Ignore
DetectHiddenWindows(true)

; An array of arrays containing the parameters of the Run command
startup := [
 ['*RunAs C:\Users\TGekko\Documents\AutoHotkey\.Hotkeys.ahk', 'C:\Users\TGekko\Documents\AutoHotkey'],
 ['*RunAs C:\Program Files (x86)\VB\Voicemeeter\voicemeeter8.exe'],
 ['*RunAs G:\Steam\steam.exe'],
 ['*RunAs C:\Users\TGekko\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Discord Inc\Discord.lnk'],
 ['*RunAs C:\Program Files\Voicemod V3\Voicemod.exe',, 'Hide'],
 ['*RunAs "C:\Program Files\obs-studio\bin\64bit\obs64.exe" --startreplaybuffer', 'C:\Program Files\obs-studio\bin\64bit'],
 ['*RunAs "' A_AppData '\..\Local\Microsoft\WindowsApps\wt.exe" -w 0 new-tab -d . -p "Command Prompt" "C:\Users\TGekko\OneDrive\Save Data\Terraria\Servers\The_Lemon\The_Lemon.bat"', 'C:\Users\TGekko\OneDrive\Save Data\Terraria\Servers\The_Lemon'],
;['*RunAs "' A_AppData '\..\Local\Microsoft\WindowsApps\wt.exe" -w 0 new-tab -d . -p "Command Prompt" "C:\Users\TGekko\OneDrive\Save Data\Minecraft\server (fabric)\start-server.bat"', 'C:\Users\TGekko\OneDrive\Save Data\Minecraft\server (fabric)'],
;['*RunAs "' A_AppData '\..\Local\Microsoft\WindowsApps\wt.exe" -w 0 new-tab -d . -p "Command Prompt" "G:\Steam\steamapps\common\Valheim dedicated server\server.TheEsteemed.bat"', 'G:\Steam\steamapps\common\Valheim dedicated server'],
;['*RunAs "G:\Steam\steamapps\common\PalServer\PalServer.exe"'],
]

; An array of arrays containing an array of the parameters of the Run command and the title of the application to wait before running the desired application
startupwait := [
 [['*RunAs C:\Program Files\Elgato\StreamDeck\StreamDeck.exe'], 'ahk_exe Voicemod.exe'],
]

; An array to contain WinTitles to minimize to the System Tray
totray := [
 'Terraria Server: The Lemon ahk_exe WindowsTerminal.exe',
;'Minecraft Fabric Server ahk_exe WindowsTerminal.exe',
;'The Esteemed - Valheim Server ahk_exe WindowsTerminal.exe',
;'G:\Steam\steamapps\common\PalServer\Pal\Binaries\Win64\PalServer-Win64-Test-Cmd.exe',
]

; An array to contain WinTitles to hide that don't hide when using the Run command
hide := [

]





; Run all items in [startup]
for(item in startup)
 SetTimer((v => Run(v*)).bind(item), -1)

for(item in startupwait) {
 SetTimer((v => (WinWait(v[2]), Run(v[1]*))).bind(item), -10)
}

; Wait for the items in [totray] to exist, then minimize them to the System Tray
for(item in totray)
 Run('C:\Users\TGekko\Documents\AutoHotkey\Windows\ToTray.ahk "' item '" "wait"')

; Wait for the items in [hide] to exist, then hide them
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