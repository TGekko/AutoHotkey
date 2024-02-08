; Gets a setting or all settings in the settings file -- stored in A_AppData as .Hotkeys\settings
;  which = *the name of the setting
;  split = a boolean value indicating whether the retreived value of the desired setting should be split by commas into an array using StrSplit(value, ',', ' ')
; returns the value of the desired setting
;
;  GetSetting("Setting")
; *If [which] is an empty string, all settings are returned as a Map
;  GetSetting()
GetSetting(which := '', split := false) {
 contents := FileExist(A_AppData '\.Hotkeys\settings') = '' ? [''] : StrSplit(FileRead(A_AppData '\.Hotkeys\settings'), '`n')
 settings := Map()
 for(setting in contents) {
  setting := StrSplit(setting, ':', ' ', 2)
  if(setting.Length > 0)
   settings[setting[1]] := setting.Length < 2 ? '' : setting[2]
 }
 if(which = '')
  return settings
 if(split) {
  try return StrSplit(settings[which], ',', ' ')
 } else
  try return settings[which]
 return ''
}

; Sets a setting in the settings file -- stored in A_Temp as .Hotkeys.settings
;  which = *the name of the setting
;  to = what to set the setting to
;  overwrite = a boolean value indicating whether to overwrite the value if it already exists
; returns true if any value was overwritten; false otherwise
;
;  SetSetting("Setting", "Value")
; *[which] may be an array of arrays containing setting names and values, in which case, [to] is ignored
;  SetSetting([["Setting1", "Value1"], ["Setting2", "Value2"]...],, false)
;  *In the case that [which] is an array of arrays of settings and values, if one of the arrays of settings and values has a third value, the user will be prompted to input a value with the third item in the array being the default value presented
;   SetSetting([["Setting",, ""]]) or SetSetting([["Setting",, "Value"]])
; *If [which] is a singular array of setting names, each of those settings will be prompted to the user with their current value presented as their default value
;  SetSetting(["Setting1", "Setting2"...])
SetSetting(which := '', to := '', overwrite := true) {
 overwritten := 0
 settings := GetSetting()
 if(Type(which) != 'Array')
  which := [[which, to]]
 else if(Type(which[1] != 'Array')) {
  for(i, item in which) {
   for(setting, content in settings) {
    if(setting = item) {
     which[i] := [setting,, content]
     break
 }}}}
 for(setting in which) {
  if((overwrite || !settings.Has(setting[1])) && Type(setting = 'Array')) {
   if(setting.Length = 3) {
    setting[2] := InputBox("Please set the following setting:`n`n     " setting[1], ".Hotkeys.ahk - Settings",, setting[3])
    if(setting[2].Result = 'OK')
     setting[2] := setting[2].Value
    else
     setting[2] := setting[3]
   }
   settings[setting[1]] := setting[2]
   overwritten++
  }
 }
 if(!DirExist(A_AppData '\.Hotkeys'))
  DirCreate(A_AppData '\.Hotkeys')
 try FileDelete(A_AppData '\.Hotkeys\settings')
 for(setting, content in settings)
  FileAppend(setting ': ' content '`n', A_AppData '\.Hotkeys\settings')
 if(overwritten > 0)
  return true
 return false
}

; Returns
;  The location of the first found value if [any] [values] are in [array]
;  The location of the first found value if [any] [title] in [array] returns a window id that matches an id in [values].
;  0 if no value is found.
; [values] can be a single, non-array item if desired.
includes(array, values, any:=true, title:=false) {
 if(Type(values) != "Array")
  values := [values]
 first := 0
 matches := 0
 for(i, avalue in array) {
  for(vvalue in values) {
   try {
    if(avalue == vvalue || (title && WinGetID(avalue) = vvalue)) {
     if(first = 0)
      first := i
     matches++
     if(any || matches == values.Length)
      return first
     break
    }
   }
  }
 }
 return 0
}

; Combines an [array] into a string with a given [delimiter]
join(array, delimiter:='') {
 result := ''
 for(i, item in array) {
  result.= item (i = array.Length ? '' : delimiter)
 }
 return result
}