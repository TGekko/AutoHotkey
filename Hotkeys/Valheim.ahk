#SingleInstance Force
#NoTrayIcon
temp := -1
activetool := 0

#IfWinActive Valheim
 #Include Valheim\General\AltE.ahk
 #Include Valheim\General\AltWheelDown.ahk
 #Include Valheim\General\AltWheelUp.ahk
 #Include Valheim\General\ArrowKeys.ahk
 *~/::Send {Blind}{LButton}

 !1::Run, Valheim\Skills\Bows.ahk
 !2::Run, Valheim\Skills\Jump.ahk
 !3::Run, Valheim\Skills\Run.ahk
 !4::Run, Valheim\Skills\Sneak.ahk
 !5::Run, Valheim\Skills\Swords.ahk

 ~1::activetool := 1
 ~2::activetool := 2
 ~3::activetool := 3
 ~4::activetool := 4
 ~5::activetool := 5
 ~6::activetool := 6
 ~7::activetool := 7
 ~8::activetool := 8
#IfWinActive