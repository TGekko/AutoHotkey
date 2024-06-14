#SingleInstance Force
#NoTrayIcon

;sendHotkey(value) {
; SendLevel 1
; SendInput value
; SendLevel 0
;}

; Borderlands 3
#HotIf WinActive("ahk_exe Borderlands3.exe")
 F13::g ; Throw Grenade
 F14::c ; Switch Weapon Modes
 F15::v ; Primary Weapon Fire
 F16::f ; Action Skill

; Citra
#HotIf WinActive("ahk_exe citra-qt.exe")
 vk07::Home ; Go Home

; Fortnite
#HotIf WinActive("ahk_exe FortniteClient-Win64-Shipping.exe")
 +Up::DllCall("mouse_event", "UInt", 0x01, "UInt", 0, "UInt", -1)
 +Down::DllCall("mouse_event", "UInt", 0x01, "UInt", 0, "UInt", 1)
 +Left::DllCall("mouse_event", "UInt", 0x01, "UInt", -1, "UInt", 0)
 +Right::DllCall("mouse_event", "UInt", 0x01, "UInt", 1, "UInt", 0)
 *[::LButton
 *]::RButton
 F13::7 ; Augment
 F14::b ; Show Emote Menu
 +=::Send("{w down}")
 !1::Run("Miscellaneous\Minecraft\Sword_and_Food.ahk")

; Hades
#HotIf WinActive("ahk_exe Hades.exe")
 MButton::q ; Special
 F13::Space ; Dash
 F14::e     ; Interact
 F15::f     ; Call
 F16::r     ; Reload
 F17::1     ; Summon
 F18::b     ; Boon Info
 F19::c     ; Open Codex
 
; Helldivers 2
#HotIf WinActive("ahk_exe helldivers2.exe")
 F13::LControl ; Open Strategem Menu
 F14::g        ; Throw Grenade
 F15::b        ; Emote
 F16::v        ; Use Stim

; Hogwarts Legacy
#HotIf WinActive("ahk_exe HogwartsLegacy.exe")
 F13::2 ; Spell Hotbar Slot 2
 F14::3 ; Spell Hotbar Slot 3
 F15::4 ; Spell Hotbar Slot 4
 F16::1 ; Spell Hotbar Slot 1

; Lethal Company
#HotIf WinActive("ahk_exe Lethal Company.exe")
 Numpad0::Send("Switch{Enter}")
 Numpad1::Send("Scan{Enter}")
 Numpad2::Send("Moons{Enter}")
 Numpad3::Send("Store{Enter}")
 NumpadAdd::Send("Deny{Enter}")
 NumpadEnter::Send("Confirm{Enter}")
 NumpadDot::Send("View Monitor{Enter}")

; Minecraft
#HotIf WinActive("Minecraft")
 F14::F1                                                    ; Toggle Perspective
 F16::Send("{F3 down}b{F3 up}")                             ; Toggle Hitboxes
 F17::F3                                                    ; View Information
 F18::Send("{F3 down}g{F3 up}")                             ; Toggle Chunk Borders
 !1::Run("Miscellaneous\Minecraft\Sword_and_Food.ahk")      ; Swing Sword and Eat Food
 !2::Run("Miscellaneous\Minecraft\Attack_and_Food.ahk")     ; Eat food and automatically attack when the attack icon appears
 !3::Run("Miscellaneous\Minecraft\Slow_Sword_and_Food.ahk") ; Swing Sword and Eat Food less quickly
 !Control::Run("Miscellaneous\Minecraft\Hold_Shift.ahk")    ; Hold Shift

 ; Palworld
 #HotIf WinActive("ahk_exe Palworld-Win64-Shipping.exe")
  F13::o
  g::Send('{f up}{f down}')
  f:: {
   Send('{f up}{f down}')
   KeyWait('f')
   Send('{f up}')
  }

 ; Sonic Adventure DX
#HotIf WinActive("ahk_exe Sonic Adventure DX.exe")
w::Up         ; Forward
a::Left       ; Left
s::Down       ; Backward
d::Right      ; Right
Space::s      ; Jump
Left::q       ; Camera Left
Right::e      ; Camera Right
e::a          ; Action
Down::a       ; Action
Up::w         ; Look Around
Backspace::d  ; Back
Escape::Enter ; Pause

; Terraria
#HotIf WinActive("Terraria")
 F13::m                                             ; Map
 !1::Run("Miscellaneous\Terraria\Honey.ahk")        ; Duplicate Honey
 !2::Run("Miscellaneous\Terraria\Lava.ahk")         ; Duplicate Lava
 ~Up::   MouseMove(0, -A_ScreenHeight / 66, 0, "R") ; Move Cursor one square up
 ~Down:: MouseMove(0, A_ScreenHeight / 66, 0, "R")  ; Move Cursor one square down
 ~Left:: MouseMove(-A_ScreenHeight / 66, 0, 0, "R") ; Move Cursor one square left
 ~Right::MouseMove(A_ScreenHeight / 66, 0, 0, "R")  ; Move Cursor one square right
 ~Numpad0::LButton                                  ; Left Click
 ~Numpad1::RButton                                  ; Right Click

; The Escapists 2
#HotIf WinActive("ahk_exe TheEscapists2.exe")
 !1::Run("Miscellaneous\The Escapists 2\Strength.ahk") ; Train Strength

; ARK: Survival Evolved
#HotIf WinActive("ARK: Survival Evolved")
 F13::1 ; Select Hotbar Slot 1
 F14::' ; Show Whistle Menu
 F15::[ ; Emote 1
 F16::0 ; Select Hotbar Slot 10
 F17::o ; Drop Inventory Item
 F18::q ; Unequip Hotbar Item
 F19::] ; Emote 2

; Notepad
#HotIf WinActive("ahk_exe Notepad.exe")
 ^+z::^y ; Undo

; paint.net
#HotIf WinActive("ahk_exe paintdotnet.exe")
 ^+z::^y ; Undo
 ~Backspace::^+Del

#HotIf