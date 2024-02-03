
; Set inipath before including this script.

; This stores the file path which leads to the .ini file in the variable inipath -- creating the file if it does not exist
if(!DirExist(A_AppData '\.Hotkeys'))
 DirCreate(A_AppData '\.Hotkeys')
if(!FileExist(inipath))
 fileAppend('', inipath)

; Joins any number of strings separated by a given delimiter
;  delimiter - The string that will appear between the supplied strings
;              (Default == "")
;  strings*  - Any number of strings or numbers to be combined
;  return    - A delimited concatenation of the provided strings
concatenate(delimiter:="", strings*) {
 result := ""
 for(i, value in strings) {
  if(i > 1) {
   result .= delimiter
  }
  result .= value
 }
 return result
}

; Makes a string match the length of another string
; An ideal use for this would be to match number length:
;    StrMatchLen(4, 122, 0) == "004"
;  value  - The value to change
;  match  - The value to match the length of
;  fill   - The character to add to the start of <value> if match is longer than value
;           Only the first character of this string will be used
;  return - A string containing the contents of <value> up to the length of <match>
StrMatchLen(value, match, fill:=" ") {
 value .= ""
 match .= ""
 fill := SubStr(fill "", 1, 1)
 while(StrLen(value) < StrLen(match)) {
  value := fill . value
 }
 value := SubStr(value, 1, StrLen(match))
 return value
}

; Reads an ini file and returns it as an object
;  path    - The path to the desired ini file
;  return  - An object which matches the sections and their key value pairs in the specified ini section
;            To access a "section" and "key" in the resulting object, use the following:
;              myini := IniReadObject(mypath)
;              myvalue := myini["section"]["key"]
IniReadObject(path) {
 ini := Map()
 for(i, section in StrSplit(IniRead(path), "`n")) {
  ini[section] := Map()
  values := IniRead(path, section)
  for(n, value in StrSplit(values, "`n")) {
   ini[section][SubStr(value, 1, InStr(value, "=") - 1) ""] := SubStr(value, InStr(value, "=") +1)
  }
 }
 return ini
}

; Opens the WindowProfiles.ini file
openIni() {
 global inipath
 Run('Notepad.exe "' inipath '"')
}

; Removes a section or key of WindowProfiles.ini
;  section     - The section to remove if no <key> is provided
;  key         - The key to remove from <section>
;  edit        - A boolean value indicating whether or not to call manageWindowProfiles()
;  x           - The x coordinate to pass to manageWindowProfiles()
;  y           - The y coordinate to pass to manageWindowProfiles()
;                Both <x> and <y> must be present for either to be used
removeIniContents(section:="", key:="") {
 global inipath
 if(key) {
  IniDelete(inipath, section, key)
 } else if(section) {
  IniDelete(inipath, section)
 }
}