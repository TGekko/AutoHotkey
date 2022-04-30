#SingleInstance Ignore

;
; Run From GitHub.ahk
;
; This is a template for a file which has the ability to load an AutoHotkey script directly from GitHub.
; Please note:
;  - This script does not support scripts which refer to external files.
;  - This script can be renamed anything as long as it is not exactly the same as the script being loaded.
;  - If you desire for it to be named similarly to the script being loaded, consider adding another period:
;     - "Script.ahk" would become "Script..ahk"
;
; Simply replace the value in %raw% with the raw link to the github script you want to load.
;

raw := "https://raw.githubusercontent.com/TGekko/AutoHotkey/main/AutoHotkey/Utilities/General.ahk"

RegExMatch(raw, "([^/]*.ahk)", file)
WebObj := ComObjCreate("WinHttp.WinHttpRequest.5.1")
WebObj.Open("GET", raw)
WebObj.Send()
script := WebObj.ResponseText
exists := % (FileExist(file) != "")
if(exists) {
 FileRead, stored, %file%
}
FileDelete %file%
FileAppend, %script%, %file%
Run *RunAs "%file%"
FileDelete %file%
if(exists) {
 FileAppend, %stored%, %file%
}

