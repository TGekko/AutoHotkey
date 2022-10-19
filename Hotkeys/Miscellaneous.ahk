#SingleInstance Force
#NoTrayIcon

sendHotkey(value) {
 SendLevel 1
 SendInput %value%
 SendLevel 0
}

; Citra
#IfWinActive ahk_exe citra-qt.exe
 vk07::Home

; Fortnite
#IfWinActive ahk_exe FortniteClient-Win64-Shipping.exe
 F13::b

; Minecraft
#IfWinActive Minecraft
 F15::F1
 F19::F1
 !1::Run, Minecraft\Sword_and_Food.ahk
 !Shift::Run, Miscellaneous\Minecraft\Hold_Shift

; Terraria
#IfWinActive Terraria
 !1::Run, Miscellaneous\Terraria\Honey.ahk
 !2::Run, Miscellaneous\Terraria\Lava.ahk

; The Escapists 2
#IfWinActive ahk_exe TheEscapists2.exe
 !1::Run, Miscellaneous\The Escapists 2\Strength.ahk

#IfWinActive ahk_exe paintdotnet.exe
 ^+z::SendHotkey("^y")

#IfWinActive