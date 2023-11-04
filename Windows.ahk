#SingleInstance Force
#NoTrayIcon
SetTitleMatchMode(2)
#include "Common.ahk"
GroupAdd("browsers", "ahk_exe chrome.exe")
GroupAdd("browsers", "ahk_exe msedge.exe")
GroupAdd("browsers", "ahk_exe firefox.exe")

; This accounts for Windows Aero invisible borders
margin := [7, 4]

; This will contain the styles of windows toggled as borderless
borderless := Map()

; This contains a boolean value which indicates which display mode was toggled last (true == "PC screen only", false == "Duplicate")
displaymode := true

; This stores the file path which leads to the Window Profiles .ini file in the variable inipath -- creating the file if it does not exist
if(!DirExist(A_AppData '\.Hotkeys'))
 DirCreate(A_AppData '\.Hotkeys')
inipath := A_AppData '\.Hotkeys\WindowProfiles.ini'
if(!FileExist(inipath))
 FileAppend(FileRead('Windows\WindowProfiles.ini'), inipath)

; A custom object used to store menues and apply custom functions to menus
menus := {
 tray: A_TrayMenu,
 call: menus_call
}
; Use menus.%name%.Add("Item", menus.call.bind(function, [parameters])) to add a custom function to an item
;  If there is only one desired parameter that is not an array, it can be passed directly instead of being passed in an array
;  If there are no desired parameters, you must pass "__" in the place of the parameters
;  If there is no desired function, pass an empty string in place of the function
menus_call(function:="", parameters:="__", menuvariables*) {
 if(function == "")
  return
 if(parameters == "__") {
  function()
  return
 }
 if(Type(parameters) != "Array") {
  parameters := [parameters]
 }
 function(parameters*)
}

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

; Saves the open window's positions and focus order as a Window Profile
;  name - The desired name of the new window profile
;         If the <name> is already in use, the profile with that name will be rewritten
;         If <name> is not provided, the user will be prompted for a name
saveWindowProfile(name:="") {
 if(Type(name) != "String" || !name) {
  userinput := InputBox("Please input the name of the new Window Profile.", "Save Window Profile")
  if(userinput.result != "OK")
   return
  name := userinput.Value
  if(!name)
   return
 }
 IniDelete(inipath, name)
 for(i, window in WinGetList()) {
  value := "ahk_id " window
  title := WinGetTitle(value)
  exe := "ahk_exe " WinGetProcessName(value)
  if(title) {
   WinGetPos(&x, &y, &w, &h, value)
   value := 
   IniWrite(title " " exe ",, " x ",, " y ",, " w ",, " h, inipath, name, StrReplace(title, "=", "-"))
  }
 }
}

; Opens a menu allowing the removal of saved Window Profiles or specific windows within them
;  x - The x coordinate to place the menu
;  y - The y coordinate to place the menu
;      Both <x> and <y> must be present for either to be used
manageWindowProfiles(x:="", y:="") {
 global menus
 if(!(x && y)) {
  MouseGetPos(&x, &y)
 }
 menus.windowprofiles := Menu()
 menus.windowprofiles.Add()
 menus.windowprofiles.Delete()
 menus.windowprofiles.Add("Window Profiles", menus.call.bind(""))
 menus.windowprofiles.Default := "1&"
 menus.windowprofiles.Add("Open WindowProfiles.ini", menus.call.bind(openWindowProfiles, "__"))
 menus.windowprofiles.Add("Save new Window Profile", menus.call.bind(saveWindowProfile, "__"))
 menus.windowprofiles.Add()
 ini := IniReadObject(inipath)
 for(section, keys in ini) {
  i := A_Index
  menus.windowprofiles%i% := Menu()
  menus.windowprofiles%i%.Add()
  menus.windowprofiles%i%.Delete()
  menus.windowprofiles%i%.Add("Activate Profile", menus.call.bind(activateWindowProfile, section))
  menus.windowprofiles%i%.Default := "1&"
  menus.windowprofiles%i%.Add("Delete Profile", menus.call.bind(removeWindowProfileContents, [section,, true, x, y]))
  menus.windowprofiles%i%.Add("Click any value below to delete it from the profile", menus.call.bind(""))
  menus.windowprofiles%i%.Add()
  for(key, value in keys) {
   menus.windowprofiles%i%.Add(key, menus.call.bind(removeWindowProfileContents, [section, key, true, x, y]))
  }
  menus.windowprofiles.Add(section, menus.windowprofiles%i%)
 }
 menus.windowprofiles.Show(x, y)
}

; Opens the WindowProfiles.ini file
openWindowProfiles() {
 Run('Notepad.exe "' inipath '"')
}

; Removes a section or key of WindowProfiles.ini
;  section     - The section to remove if no <key> is provided
;  key         - The key to remove from <section>
;  edit        - A boolean value indicating whether or not to call manageWindowProfiles()
;  x           - The x coordinate to pass to manageWindowProfiles()
;  y           - The y coordinate to pass to manageWindowProfiles()
;                Both <x> and <y> must be present for either to be used
removeWindowProfileContents(section:="", key:="", edit:=false, x:="", y:="") {
 if(key) {
  IniDelete(inipath, section, key)
 } else if(section) {
  IniDelete(inipath, section)
 }
 if(edit) {
  manageWindowProfiles(x, y)
 }
}

; Activates a given Window Profile.
;  profile - The name of the desired Window Profile to load.
activateWindowProfile(profile) {
 ini := IniReadObject(inipath)
 for(key, value in ini[profile]) {
  value := StrSplit(value, ",, ")
  id := value[1]
  x := value[2]
  y := value[3]
  width := value[4]
  height := value[5]
  try WinMove(x, y, width, height, id)
 }
}

; Returns the bounds of the monitor which contains the active window.
;  full   - A boolean value. If true, the full size of the monitor, including the taskbar, will be used.
;           (Default == false)
;  return - An array containing the bounds of the monitor containing the active window.
;           The resulting array will have the following configuration: [x, y, width, height]
activeWindowMonitorBounds(full:=false) {
 WinGetPos(&x, &y, &width, &height, "A")
 x += width/2
 y += height/2
 monitorcount := MonitorGetCount()
 monitor := 0
 if(monitorcount = 1) {
  monitor := 1
 } else {
  Loop(monitorcount) {
   MonitorGet(A_index, &bleft, &btop, &bright, &bbottom)
   if(x >= bleft && x <= bright && y >= btop && y <= bbottom) {
    monitor := A_index
    break
   }
  }
  if(monitor = 0) {
   MouseGetPos &x, &y
   Loop(monitorcount) {
    MonitorGet(A_index, &bleft, &btop, &bright, &bbottom)
    if(x >= bleft && x <= bright && y >= btop && y <= bbottom) {
     monitor := A_index
     break
    }
   }
  }
  if(monitor = 0) {
   monitor := MonitorGetPrimary()
  }
 }
 bleft := 0
 btop := 0
 bright := 0
 btop := 0
 if(full) {
  MonitorGet(monitor, &bleft, &btop, &bright, &bbottom)
 } else {
  MonitorGetWorkArea(A_index, &bleft, &btop, &bright, &bbottom)
 }
 monitor := [bleft, btop, bright-bleft, bbottom-btop]
 return monitor
}

; Moves the active window to a given position within the monitor which it resides. The window is kept within the monitor.
; Microsoft Edge, Google Chrome, and Firefox are adjusted with an arbitrary margin adjustment unless explicitly stated using the [margins] parameter.
;     --Old version-- Windows without the following style ignore arbitrary margin adjustment:
;     --Old version-- > 0xC00000 - WS_CAPTION  (title bar)
;  x       - A value *between 0 and 1* which represents a percentage of the monitor's width.
;            The center of the active window will be at this position.
;             A value of 0.5 will move the window to the center of the monitor.
;             * If a value outside of 0-1 is given, the window will not be moved on this axis.
;            (Default == -1)
;  y       - A value between 0 and 1 which represents a percentage of the monitor's height.
;            See the notes for <x> for more information.
;            (Default == -1)
;  width   - A value *between 0 and 1* which represents a percentage of the monitor's width.
;            The active window will be resized using this value.
;             A value of 0.5 would resize the active window to 50% of the monitor's width.
;             * If a value ouside of 0-1 is given, the window will not be resized.
;            (Default == -1)
;  height  - A value *between 0 and 1* which represents a percentage of the monitor's height.
;            The active window will be resized using this value.
;             A value of 0.5 would resize the active window to 50% of the monitor's height.
;             * If a value ouside of 0-1 is given, the window will not be resized.
;            (Default == -1)
;  full    - A boolean value indicating whether or not to include the Taskbar when resizing the window.
;            A value of true will include the height of the Taskbar in the size of the monitor.
;            A value of false will exclude the height of the Taskbar in the size of the monitor.
;            (Default == false)
;  margins - A boolean value indicating whether or not to apply an arbitrary margin adjustment to web browsers when resizing the window.
;            (Default == true)
activeMoveTo(x:=-1, y:=-1, width:=-1, height:=-1, full:=false, margins:=true) {
 global margin
 WinGetPos(&winx, &winy, &winwidth, &winheight, "A")
 bounds := 0
 if(full) {
  bounds := activeWindowMonitorBounds(true)
 } else {
  bounds := activeWindowMonitorBounds()
 }
 winx+= winwidth/2
 winy+= winheight/2
 if(width >= 0 && width <= 1) {
  winwidth := bounds[3]*width
  if(WinActive("ahk_group browsers") && margins) {
   winwidth += margin[1]
  }
 }
 if(height >= 0 && height <= 1) {
  winheight := bounds[4]*height
  if(WinActive("ahk_group browsers") && margins) {
   winheight += margin[2]
  }
 }
 if(x >= 0 && x <= 1) {
  winx := bounds[1]+(bounds[3]*x)
  winx := Min(winx, bounds[3]-winwidth/2)
  winx := Max(winx, bounds[1]+winwidth/2)
 }
 if(y >= 0 && y <= 1) {
  winy := bounds[2]+(bounds[4]*y)
  winy := Min(winy, bounds[4]-winheight/2)
  winy := Max(winy, bounds[2]+winheight/2)
 }
 winx-= winwidth/2
 winy-= winheight/2
 WinMove(winx, winy, winwidth, winheight, "A")
}

; Moves the active window by a specified amount of pixels.
;  x - The amount of pixels to move the window horizontally.
;      (Default = 0)
;  y - The amount of pixels to move the window vertically.
;      (Default = 0)
activeMoveBy(x:=0, y:=0) {
 WinGetPos(&winx, &winy,,, "A")
 winx+= x
 winy+= y
 WinMove(winx, winy,,, "A")
}

; Resizes the active window by a specified amount.
;  width      - *The amount of pixels* to add to the width of the window.
;                * If <percentage> = true, This should be a decimal value representing a percentage (-0.1 = -10%, 1.2 = 120%).
;                  A value of 0.05 would decrease the active window's size by 5% of its current size.
;               (Default = 0)
;  height     - *The amount of pixels* to add to the height of the window.
;                * See note <width>*
;               (Default = 0)
;  percentage - A boolean value determining if width and height should be a percentage of the window's size.
;               (Default = false)
;  screen     - A boolean value determining if the percentage given should be a percentage of the screen rather than the window.
;               This does nothing if <percentage> is false.
;               (Default = false)
activeSizeBy(width:=0, height:=0, percent:=false, screen:=false) {
 WinGetPos(&x, &y, &winwidth, &winheight, "A")
 if(percent) {
  if(screen) {
   bounds := activeWindowMonitorBounds()
   width := width*bounds[3]
   height := height*bounds[4]
  } else {
   width := winwidth*width
   height := winheight*height
  }
 } else {
  width := width
  height := height
 }
 x -= width/2
 y -= height/2
 winwidth += width
 winheight += height
 WinMove(x, y, winwidth, winheight, "A")
}

; Toggles Borderless Mode for the active window
activeToggleBorderless() {
 global borderless
 id := WinGetID("A")
 if(borderless[id]) {
  style := borderless[id]
  WinSetStyle(style, "A")
  borderless.Delete(id)
 } else {
  style := WinGetStyle("A")
  borderless[id] := style
  WinSetStyle("-0xC00000", "A") ; WS_CAPTION  (title bar)
  WinSetStyle("-0x800000", "A") ; WS_BORDER   (thin-line border)
  WinSetStyle("-0x400000", "A") ; WS_DLGFRAME (dialog box border)
  WinSetStyle("-0x40000", "A")  ; WS_SIZEBOX  (sizing border)
 }
}

; Toggles Transparency for the active window
;  prompt - A boolean value indicating whether the user should (true) or should not (false) be prompted for a custom transparency percentage
activeToggleTransparency(prompt:=false) {
 id := WinGetID("A")
 transparency := WinGetTransparent(id)
 if(transparency != "" && transparency < 255) {
  WinSetTransparent(255, id)
  WinSetTransparent("Off", id)
 } else {
  if(prompt) {
   transparency := InputBox("Input a number from 0 to 100 to set the percentage of opacity.", "Set Window Transparency", "w300 h150", 85)
   if(transparency.Result != "OK")
    return
   transparency := transparency.Value
  } else {
   transparency := 85
  }
  if(transparency >= 0 && transparency <= 100) {
   transparency := Round((transparency/100)*255)
   WinSetTransparent(transparency, id)
  }
 }
}

; Toggles Theatre Mode
; When active, everything except the active window will be hidden behind an entirely black GUI
;  soft - A boolean value indicating whether or not to enable Soft Theatre Mode
;         Soft Theatre Mode allows multiple windows to be in front of the generated GUI
dark := { Hwnd: 0 }
light := false
toggleTheatreMode(soft:=false) {
 global dark
 global margin
 if (!destroyGUI(dark)) {
  if(soft) {
   dark := Gui("+ToolWindow -Caption +LastFound", "AutoHotkey :: Windows.ahk > GUI > Theatre Mode")
  } else {
   dark := Gui("+AlwaysOnTop +ToolWindow -Caption +LastFound", "AutoHotkey :: Windows.ahk > GUI > Theatre Mode")
   WinSetTransColor("100100", dark.Hwnd)
   WinGetPos(&x, &y, &width, &height, "A")
   x += margin[1]
   y += margin[2]
   width -= margin[1]*2
   height -= margin[2]*2
   dark.Add("Progress", "x" x " y" y " w" width " h" height " c100100 background100100 vwindow", 100)
  }
  dark.BackColor := "000000"
  dark.Show("x0 y0 w" A_ScreenWidth " h" A_ScreenHeight " NoActivate")
 }
}

; If the given gui exists, the gui is destroyed.
;  ui      - The gui to destroy.
;  returns - A boolean value indicating whether the given gui was (true) or was not (false) destroyed.
destroyGUI(ui) {
 try {
  WinExist(ui.Hwnd)
  ui.Destroy()
  return true
 }
 return false
}

timedark := 0

toTray(win := 'A') {
 Run('Windows\ToTray.ahk "' win '"')
}

ProcessToggle(wintitle := 'A') {
 if(ProcessIsSuspended(wintitle))
  ProcessResume(wintitle)
 else
  ProcessSuspend(wintitle)
}
ProcessIsSuspended(wintitle := 'A') {
 for(thread in ComObjGet("winmgmts:").ExecQuery("Select * from Win32_Thread WHERE ProcessHandle = " WinGetPID(wintitle)))
  if(thread.ThreadWaitReason != 5)
   return false
 return true
}
ProcessSuspend(wintitle := 'A') {
 process := DllCall("OpenProcess", "uInt", 0x1F0FFF, "Int", 0, "Int", WinGetPID(wintitle))
 if(process) {
  DllCall("ntdll.dll\NtSuspendProcess", "Int", process)
  DllCall("CloseHandle", "Int", process)
 }
}
ProcessResume(wintitle := 'A') {
 process := DllCall("OpenProcess", "uInt", 0x1F0FFF, "Int", 0, "Int", WinGetPID(wintitle))
 if(process) {
  DllCall("ntdll.dll\NtResumeProcess", "Int", process)
  DllCall("CloseHandle", "Int", process)
 }
}


; Hotkeys

; Manage Window Profiles
^#\::manageWindowProfiles()
; Activate Window Profile: Default
^#,::activateWindowProfile("Default")

; Adjust Volume
^0::SoundSetVolume(0)
^1::SoundSetVolume(10)
^2::SoundSetVolume(20)
^3::SoundSetVolume(30)
^4::SoundSetVolume(40)
^5::SoundSetVolume(50)
^6::SoundSetVolume(60)
^7::SoundSetVolume(70)
^8::SoundSetVolume(80)
^9::SoundSetVolume(90)
^\::SoundSetVolume(100)
^=::SoundSetVolume("+2")
^-::SoundSetVolume("-2")
^Numpad0::SoundSetVolume(0)
^Numpad1::SoundSetVolume(10)
^Numpad2::SoundSetVolume(20)
^Numpad3::SoundSetVolume(30)
^Numpad4::SoundSetVolume(40)
^Numpad5::SoundSetVolume(50)
^Numpad6::SoundSetVolume(60)
^Numpad7::SoundSetVolume(70)
^Numpad8::SoundSetVolume(80)
^Numpad9::SoundSetVolume(90)
^NumpadMult::SoundSetVolume(100)
^NumpadAdd::SoundSetVolume("+2")
^NumpadSub::SoundSetVolume("-2")

; Center active window horizontally
#Numpad0::activeMoveTo(0.5)
; Center active window
#NumpadDot::activeMoveTo(0.5, 0.5)
; Center active window vertically
#NumpadEnter::activeMoveTo(, 0.5)
; Expand Active Window to Fill Screen Horizontally
#!Numpad0::activeMoveTo(0.5,, 1)
; Expand Active Window to Fill Screen Vertically
#!NumpadEnter::activeMoveTo(, 0.5,, 1)

; Move window to numpad key position on the screen and scale to half of the screen size
; [Numpad5] represents the center of the screen
#Numpad1::activeMoveTo(0.25, 0.75, 0.5, 0.5)
#Numpad2::activeMoveTo(0.5, 0.75, 0.5, 0.5)
#Numpad3::activeMoveTo(0.75, 0.75, 0.5, 0.5)
#Numpad4::activeMoveTo(0.25, 0.5, 0.5, 0.5)
#Numpad5::activeMoveTo(0.5, 0.5, 0.5, 0.5)
#Numpad6::activeMoveTo(0.75, 0.5, 0.5, 0.5)
#Numpad7::activeMoveTo(0.25, 0.25, 0.5, 0.5)
#Numpad8::activeMoveTo(0.5, 0.25, 0.5, 0.5)
#Numpad9::activeMoveTo(0.75, 0.25, 0.5, 0.5)
; Move window to numpad key position on the screen and scale to one third of the screen size
; [Numpad5] represents the center of the screen
#!Numpad1::activeMoveTo((1 / 6), (5 / 6), (1 / 3), (1 / 3))
#!Numpad2::activeMoveTo((3 / 6), (5 / 6), (1 / 3), (1 / 3))
#!Numpad3::activeMoveTo((5 / 6), (5 / 6), (1 / 3), (1 / 3))
#!Numpad4::activeMoveTo((1 / 6), (3 / 6), (1 / 3), (1 / 3))
#!Numpad5::activeMoveTo((3 / 6), (3 / 6), (1 / 3), (1 / 3))
#!Numpad6::activeMoveTo((5 / 6), (3 / 6), (1 / 3), (1 / 3))
#!Numpad7::activeMoveTo((1 / 6), (1 / 6), (1 / 3), (1 / 3))
#!Numpad8::activeMoveTo((3 / 6), (1 / 6), (1 / 3), (1 / 3))
#!Numpad9::activeMoveTo((5 / 6), (1 / 6), (1 / 3), (1 / 3))

; Resize active window by +5% of the monitor size
#NumpadMult::activeSizeBy(0.05, 0.05, true)
; Resize active window by -5% of the monitor size
#NumpadDiv::activeSizeBy(-0.05, -0.05, true)

; Move window by one pixel in the direction of the numpad key with relation to [Numpad5]
^#Numpad8::activeMoveBy(, -1)
^#Numpad6::activeMoveBy(1)
^#Numpad2::activeMoveBy(, 1)
^#Numpad4::activeMoveBy(-1)
; Move window to the screen's edge in the direction of the numpad key with relation to [Numpad8]
^#NumpadDiv::activeMoveTo(, 0)
^#Numpad9::activeMoveTo(1)
^#Numpad5::activeMoveTo(, 1)
^#Numpad7::activeMoveTo(0)
; Move the window to the bottom of the screen's edge ignoring the taskbar
^#Numpad0::activeMoveTo(, 1,,,true)

; Set window to 100% of the screen's size
#NumpadSub:: activeMoveTo(0.5, 0.5, 1, 1)
; Set window to 100% of the screen's size including the taskbar
#!NumpadSub:: activeMoveTo(0.5, 0.5, 1, 1, true, false)

; Minimize the active window to the system tray
#Backspace::toTray()
; Suspend the process of the active window
^#Backspace::ProcessToggle()

; Toggle "Always On Top" for the active window
^#a::WinSetAlwaysOnTop(-1, "A")
NumLock:: WinSetAlwaysOnTop(-1, "A")
; Keep the active window on bottom and hide it from the taskbar
^#+a::DllCall("SetParent", "Ptr", WinGetID("A"), "Ptr", WinGetID("ahk_class WorkerW", "FolderView"))
; Set the active window's parent to the desktop -- useful for allowing windows forcibly kept on bottom to move again
^#!a::Dllcall("SetParent", "Ptr", WinGetID("A"), "Ptr", 0)

; Toggle Borderless Mode for the active window and set it to 100% of the screen's size including the taskbar
; Ignores arbitrary margin adjustment
^#!b:: {
 activeToggleBorderless()
 activeMoveTo(0.5, 0.5, 1, 1, true)
}
; Toggle Borderless Mode for the active window
^#b::activeToggleBorderless()

; Toggle window transparency
^#t::activeToggleTransparency()
; Prompt for window transparency percentage
^#!t::activeToggleTransparency(true)
; Prompt for window transparency color
^#+t:: {
 active := WinGetID("A")
 input := InputBox("Input the AutoHotkey color value for the color which should be transparent in this window (`"Off`" disables transparency).", "Set Window Transparency Color",, "000000")
 if(input.Result = "OK")
  try WinSetTransColor(input.Value, active)
}

; Toggle Windows display mode between "PC screen only" and "Duplicate"
^#p:: {
 global displaymode
 if(displaymode) {
  Run("C:\Windows\System32\DisplaySwitch.exe /clone")
  displaymode := false
 } else {
  Run("C:\Windows\System32\DisplaySwitch.exe /internal")
  displaymode := true
 }
}

; Remap the AppsKey to the Right Windows key
AppsKey:: {
 Send("{RWin Down}")
 KeyWait("AppsKey")
 Send("{RWin Up}")
}
^AppsKey:: {
 Send("{Control Down}")
 Send("{RWin Down}")
 KeyWait("AppsKey")
 Send("{RWin Up}")
 KeyWait("Control")
 Send("{Control Up}")
}

; Enable Theatre Mode for the active window
; This makes the rest of the screen black
^#/::toggleTheatreMode()
; Enable Soft Theatre Mode
; Any number of windows can be on top of the black screen
^#!/::toggleTheatreMode(true)

#HotIf WinActive("AutoHotkey :: Windows.ahk > GUI > Theatre Mode")
 LButton up::destroyGUI(dark)
#HotIf WinExist("AutoHotkey :: Windows.ahk > GUI > Theatre Mode")
 ~Delete::destroyGUI(dark)
 ~^Pause:: {
  boundsdark := activeWindowMonitorBounds()
  boundsdarkx := (boundsdark[1] + (boundsdark[3] / 2)) - 150
  boundsdarky := (boundsdark[2] + (boundsdark[4] / 2)) - 75
  timedarkinput := InputBox("Input the number of seconds that you desire to hide the window.", "Time to Hide Window", "x" boundsdarkx " y" boundsdarky " w300 h150", 10)
  if(timedarkinput.Result != "OK" || timedarkinput.Value <= 0)
   return
  timeddark := timedarkinput.Value*1000
 }
 ~Pause:: {
  dark["window"].Visible := !dark["window"].Visible
  if(timeddark > 0) {
   Sleep(timeddark)
   dark["window"].Visible := true
  }
  timeddark := 0
 }
 ~`:: {
  global light
  if(light) {
   dark.BackColor := "000000"
   light := false
  } else {
   dark.BackColor := "FFFFFF"
   light := true
  }
 }
#HotIf