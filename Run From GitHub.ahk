#SingleInstance Ignore

;
; Run From GitHub.ahk
;
; This is a template for a file which has the ability to load an AutoHotkey script directly from GitHub.
; Please note:
;  - This script does not support scripts which refer to external files.
;  - This script must be run as an administrator, unless "*RunAs " is removed from the Run command within.
;
; Simply replace the value in %raw% with the raw link to the github script you want to load.
;

raw := "https://raw.githubusercontent.com/TGekko/AutoHotkey/main/Utilities/General.ahk"

RegExMatch(raw, "([^/]*.ahk)", &name)
if(IsObject(name)) {
 name := name[1]
} else ExitApp
WebObj := ComObject("WinHttp.WinHttpRequest.5.1")
WebObj.Open("GET", raw)
WebObj.Send()
script := WebObj.ResponseText
exists := FileExist(name) != ""
if(exists) {
 stored := FileRead(name)
 FileDelete name
}
FileAppend script, name
try Run "*RunAs " name
WinWait name,, 5
FileDelete name
if(exists) {
 FileAppend stored, name
}

