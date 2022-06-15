; This script is a modified version of the script found here: https://gist.githubusercontent.com/dcragusa/f3ab67ba1ed692cb628d1ef45dc9fac1/raw/aa2537e71b699985915651aa236aefe30a3fea14/voicemeeter.ahk
#SingleInstance Force
#NoTrayIcon
DetectHiddenWindows, On

WinWait, ahk_exe voicemeeter8.exe  ; wait for voicemeeter

DllLoad := DllCall("LoadLibrary", "Str", "C:\Program Files (x86)\VB\Voicemeeter\VoicemeeterRemote64.dll")

VMLogin()
OnExit("VMLogout")

VMLogin() {
 Login := DllCall("VoicemeeterRemote64\VBVMR_Login")
}

VMLogout() {
 Logout := DllCall("VoicemeeterRemote64\VBVMR_Logout")
}

ApplyVolume(vol_lvl, mod:=0) {
 if(mod = 1 || mod = 2) {
  DllCall("VoicemeeterRemote64\VBVMR_IsParametersDirty")
  current_vol_lvl := 0.0
  if(mod = 1) {
   DllCall("VoicemeeterRemote64\VBVMR_GetParameterFloat", "AStr", "Strip[5].Gain", "Ptr", &current_vol_lvl)
  } else {
   DllCall("VoicemeeterRemote64\VBVMR_GetParameterFloat", "AStr", "Strip[6].Gain", "Ptr", &current_vol_lvl)
  }
  current_vol_lvl := NumGet(current_vol_lvl, 0, "Float")
  vol_lvl := % current_vol_lvl + vol_lvl
 }
 if (vol_lvl > 12.0){
  vol_lvl = 12.0
 } else if (vol_lvl < -60.0) {
  vol_lvl = -60.0
 }
 if(mod = 0 || mod = 1) {
  DllCall("VoicemeeterRemote64\VBVMR_SetParameterFloat", "AStr", "Strip[5].Gain", "Float", vol_lvl)
  DllCall("VoicemeeterRemote64\VBVMR_SetParameterFloat", "AStr", "Strip[7].Gain", "Float", vol_lvl)
 }
 DllCall("VoicemeeterRemote64\VBVMR_SetParameterFloat", "AStr", "Strip[6].Gain", "Float", vol_lvl)
 DllCall("VoicemeeterRemote64\VBVMR_IsParametersDirty")
}

solo := true
Gosub, ^NumpadDiv

#IfWinExist ahk_exe voicemeeter8.exe
 ^NumpadDot::DllCall("VoicemeeterRemote64\VBVMR_SetParameterFloat", "AStr", "Command.Restart", "Float", 1.0)
 ^NumpadAdd::ApplyVolume(1.44, 1)
 ^NumpadSub::ApplyVolume(-1.44, 1)
 NumpadMult & NumpadAdd::ApplyVolume(1, 2)
 NumpadMult & NumpadSub::ApplyVolume(-1, 2)
 ^Numpad0::ApplyVolume(-60.0)
 ^Numpad1::ApplyVolume(-52.8)
 ^Numpad2::ApplyVolume(-45.6)
 ^Numpad3::ApplyVolume(-38.4)
 ^Numpad4::ApplyVolume(-31.2)
 ^Numpad5::ApplyVolume(-24.0)
 ^Numpad6::ApplyVolume(-16.8)
 ^Numpad7::ApplyVolume(-9.6)
 ^Numpad8::ApplyVolume(-2.4)
 ^Numpad9::ApplyVolume(4.8)
 ^NumpadMult::ApplyVolume(12.0)
 ^NumpadDiv::
 ^+NumpadDiv::
  if(solo) {
   DllCall("VoicemeeterRemote64\VBVMR_SetParameterFloat", "AStr", "Bus[0].Mute", "Float", 0.0)
   DllCall("VoicemeeterRemote64\VBVMR_SetParameterFloat", "AStr", "Bus[1].Mute", "Float", 0.0)
   DllCall("VoicemeeterRemote64\VBVMR_SetParameterFloat", "AStr", "Bus[2].Mute", "Float", 1.0)
   DllCall("VoicemeeterRemote64\VBVMR_SetParameterFloat", "AStr", "Bus[3].Mute", "Float", 0.0)
   DllCall("VoicemeeterRemote64\VBVMR_SetParameterFloat", "AStr", "Bus[4].Mute", "Float", 0.0)
   solo := false
  } else {
   DllCall("VoicemeeterRemote64\VBVMR_SetParameterFloat", "AStr", "Bus[0].Mute", "Float", 1.0)
   DllCall("VoicemeeterRemote64\VBVMR_SetParameterFloat", "AStr", "Bus[1].Mute", "Float", 1.0)
   DllCall("VoicemeeterRemote64\VBVMR_SetParameterFloat", "AStr", "Bus[2].Mute", "Float", 0.0)
   DllCall("VoicemeeterRemote64\VBVMR_SetParameterFloat", "AStr", "Bus[3].Mute", "Float", 1.0)
   DllCall("VoicemeeterRemote64\VBVMR_SetParameterFloat", "AStr", "Bus[4].Mute", "Float", 1.0)
   solo := true
  }
  if(GetKeyState("Shift") = 1) {
   if(solo) {
    MsgBox Solo: Enabled
   } else {
    MsgBox Solo: Disabled
   }
  }
 return
#IfWinExist