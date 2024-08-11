; This script is a modified version of the script found here: https://gist.githubusercontent.com/dcragusa/f3ab67ba1ed692cb628d1ef45dc9fac1/raw/aa2537e71b699985915651aa236aefe30a3fea14/voicemeeter.ahk
#SingleInstance Force
#NoTrayIcon
DetectHiddenWindows true

WinWait "ahk_exe voicemeeter8.exe"  ; wait for voicemeeter

DllLoad := DllCall("LoadLibrary", "Str", "C:\Program Files (x86)\VB\Voicemeeter\VoicemeeterRemote64.dll")

VMLogin()
OnExit(VMLogout)

VMLogin() {
 Login := DllCall("VoicemeeterRemote64\VBVMR_Login")
}

VMLogout(ExitReason, ExitCode) {
 Logout := DllCall("VoicemeeterRemote64\VBVMR_Logout")
}

clamp(min, value, max) {
 if(min > value) {
  value := min
 } else if(max < value) {
  value := max
 }
 return value
}

ApplyVolume(volume, mod:=0) {
 current := 0.0
 get := Buffer(8)
 DllCall("VoicemeeterRemote64\VBVMR_IsParametersDirty")
 if(mod = 2) {
  DllCall("VoicemeeterRemote64\VBVMR_GetParameterFloat", "AStr", "Strip[5].Gain", "Ptr", get)
  current := clamp(-60.0, NumGet(get, 0, "Float")+volume, 12.0)
  DllCall("VoicemeeterRemote64\VBVMR_SetParameterFloat", "AStr", "Strip[5].Gain", "Float", current)
 } else {
  Loop {
   bus := A_Index-1
   if(mod = 0) {
    current := volume
    DllCall("VoicemeeterRemote64\VBVMR_SetParameterFloat", "AStr", "Strip[5].Gain", "Float", 0.0)
   } else {
    DllCall("VoicemeeterRemote64\VBVMR_GetParameterFloat", "AStr", "Bus[" bus "].Gain", "Ptr", get)
    current := clamp(-60.0, NumGet(get, 0, "Float")+volume, 12.0)
   }
   DllCall("VoicemeeterRemote64\VBVMR_SetParameterFloat", "AStr", "Bus[" bus "].Gain", "Float", current)   
  } Until(A_Index = 5)
 }
 DllCall("VoicemeeterRemote64\VBVMR_IsParametersDirty")
}

solo := true
toggleSolo() {
 global solo
 if(solo) {
  DllCall("VoicemeeterRemote64\VBVMR_SetParameterFloat", "AStr", "Bus[0].Mute", "Float", 0.0)
  DllCall("VoicemeeterRemote64\VBVMR_SetParameterFloat", "AStr", "Bus[1].Mute", "Float", 0.0)
  DllCall("VoicemeeterRemote64\VBVMR_SetParameterFloat", "AStr", "Bus[2].Mute", "Float", 0.0)
  DllCall("VoicemeeterRemote64\VBVMR_SetParameterFloat", "AStr", "Bus[3].Mute", "Float", 0.0)
  DllCall("VoicemeeterRemote64\VBVMR_SetParameterFloat", "AStr", "Bus[4].Mute", "Float", 1.0)
  solo := false
 } else {
  DllCall("VoicemeeterRemote64\VBVMR_SetParameterFloat", "AStr", "Bus[0].Mute", "Float", 1.0)
  DllCall("VoicemeeterRemote64\VBVMR_SetParameterFloat", "AStr", "Bus[1].Mute", "Float", 1.0)
  DllCall("VoicemeeterRemote64\VBVMR_SetParameterFloat", "AStr", "Bus[2].Mute", "Float", 1.0)
  DllCall("VoicemeeterRemote64\VBVMR_SetParameterFloat", "AStr", "Bus[3].Mute", "Float", 1.0)
  DllCall("VoicemeeterRemote64\VBVMR_SetParameterFloat", "AStr", "Bus[4].Mute", "Float", 0.0)
  solo := true
 }
 if(GetKeyState("Shift")) {
  if(solo) {
   MsgBox("Solo: Enabled")
  } else {
   MsgBox("Solo: Disabled")
  }
 }
}
toggleSolo()

#HotIf WinExist("ahk_exe voicemeeter8.exe")
 ^Backspace::
 ^NumpadDot::{
  DllCall("VoicemeeterRemote64\VBVMR_SetParameterFloat", "AStr", "Command.Restart", "Float", 1.0)
 }
 ^NumpadAdd::ApplyVolume(1.44, 1)
 ^=::ApplyVolume(1.44, 1)
 ^NumpadSub::ApplyVolume(-1.44, 1)
 ^-::ApplyVolume(-1.44, 1)
 ^+NumpadAdd::ApplyVolume(1, 2)
 ^+=::ApplyVolume(1, 2)
 ^+NumpadSub::ApplyVolume(-1, 2)
 ^+-::ApplyVolume(-1, 2)
 ^Numpad0::ApplyVolume(-60.0)
 ^`::ApplyVolume(-60.0)
 ^Numpad1::ApplyVolume(-52.8)
 ^1::ApplyVolume(-52.8)
 ^Numpad2::ApplyVolume(-45.6)
 ^2::ApplyVolume(-45.6)
 ^Numpad3::ApplyVolume(-38.4)
 ^3::ApplyVolume(-38.4)
 ^Numpad4::ApplyVolume(-31.2)
 ^4::ApplyVolume(-31.2)
 ^Numpad5::ApplyVolume(-24.0)
 ^5::ApplyVolume(-24.0)
 ^Numpad6::ApplyVolume(-16.8)
 ^6::ApplyVolume(-16.8)
 ^Numpad7::ApplyVolume(-9.6)
 ^7::ApplyVolume(-9.6)
 ^Numpad8::ApplyVolume(-2.4)
 ^8::ApplyVolume(-2.4)
 ^Numpad9::ApplyVolume(4.8)
 ^9::ApplyVolume(4.8)
 ^NumpadMult::ApplyVolume(12.0)
 ^0::ApplyVolume(12.0)
 ^NumpadDiv::toggleSolo()
 ^+NumpadDiv::toggleSolo()
#HotIf