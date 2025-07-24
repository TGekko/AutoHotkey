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

inipath := A_AppData '\.Hotkeys\WindowProfiles.ini'
#Include "Windows\Windows.ini.ahk"

; Calls all functions passed to it
call(functions*) {
 for(item in functions)
  if(Type(item) = "Func" || Type(item) = "BoundFunc")
   item()
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
 if(!(x && y)) {
  MouseGetPos(&x, &y)
 }
 windowprofiles := Menu()
 windowprofiles.Add()
 windowprofiles.Delete()
 windowprofiles.Add("Window Profiles", (z*) => {})
 windowprofiles.Default := "1&"
 windowprofiles.Add("Open WindowProfiles.ini", (z*) => openIni())
 windowprofiles.Add("Save new Window Profile", (z*) => saveWindowProfile())
 windowprofiles.Add()
 ini := IniReadObject(inipath)
 for(section, keys in ini) {
  i := A_Index
  windowprofile := Menu()
  windowprofile.Add()
  windowprofile.Delete()
  windowprofile.Add("Activate Profile", ((z*) => activateWindowProfile(z[1])).bind(section))
  windowprofile.Default := "1&"
  windowprofile.Add("Delete Profile", ((z*) => call(removeIniContents(z[1]), manageWindowProfiles(z[2], z[3]))).bind(section, x, y))
  windowprofile.Add("Click any value below to delete it from the profile", (z*) => {})
  windowprofile.Add()
  for(key, value in keys) {
   windowprofile.Add(key, ((z*) => call(removeIniContents(z[1], z[2]), manageWindowProfiles(z[3], z[4]))).bind(section, key, x, y))
  }
  windowprofiles.Add(section, windowprofile)
 }
 windowprofiles.Show(x, y)
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

; Returns the number of the monitor which contains the active window.
;  return - The number of the monitor which contains the active window.
activeWindowMonitor() {
 WinGetPos(&x, &y, &w, &h, "A")
 count := MonitorGetCount()
 if(count = 1)
  return 1
 monitor := 1
 topscore := 0
 Loop(count) {
  MonitorGet(A_Index, &l, &t, &r, &b)
  score := Max(0, Min(x+w, r)-Max(x, l))*Max(0, Min(y+h, b)-Max(y, t))
  if(score > topscore) {
   monitor := A_Index
   topscore := score
  }
 }
 return monitor
}

; Returns the bounds of the monitor which contains the active window.
;  full   - A boolean value. If true, the full size of the monitor, including the taskbar, will be used.
;           (Default == false)
;  return - An array containing the bounds of the monitor containing the active window.
;           The resulting array will have the following configuration: [x, y, width, height]
activeWindowMonitorBounds(full:=false) {
 monitor := activeWindowMonitor()
 bleft := 0
 btop := 0
 bright := 0
 btop := 0
 if(full) {
  MonitorGet(monitor, &bleft, &btop, &bright, &bbottom)
 } else {
  MonitorGetWorkArea(monitor, &bleft, &btop, &bright, &bbottom)
 }
 monitor := [bleft, btop, bright-bleft, bbottom-btop]
 return monitor
}

; Moves the active window to another monitor.
;  monitor  - The desired monitor (if the monitor is 0 or doesn't exist, it defaults to the monitor the window is currently on)
;  modifier - modifies the value of [monitor]. 1 adds one, -1 subtracts one, etc.
activeMoveToMonitor(monitor:= 0, modifier:= 0) {
 if(monitor < 1 || monitor > MonitorGetCount())
  monitor := activeWindowMonitor()
 monitor+= modifier
 while(monitor < 1)
  monitor+= MonitorGetCount()
 while(monitor > MonitorGetCount())
  monitor-= MonitorGetCount()
 WinGetPos(&x, &y, &width, &height, 'A')
 MonitorGetWorkArea(activeWindowMonitor(), &ax, &ay, &awidth, &aheight)
 MonitorGetWorkArea(monitor, &bx, &by, &bwidth, &bheight)
 awidth:= awidth-ax
 aheight:= aheight-ay
 bwidth:= bwidth-bx
 bheight:= bheight-by
 x:= ((x-ax)/awidth)*bwidth+bx
 y:= ((y-ay)/aheight)*bheight+by
 width := (width/awidth)*bwidth
 height := (height/aheight)*bheight
 WinMove(x, y, width, height, 'A')
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
  winx := Max(Min(bounds[1]+(bounds[3]*x), bounds[1]+bounds[3]-winwidth/2), bounds[1]+winwidth/2)
 }
 if(y >= 0 && y <= 1) {
  winy := Max(Min(bounds[2]+(bounds[4]*y), bounds[2]+bounds[4]-winheight/2), bounds[2]+winheight/2)
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
 if(borderless.Has(id)) {
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
;  prompt - A number up to 100. A positive number sets the transparency; a negative number indicates that the user should be prompted for a custom transparency percentage.
activeToggleTransparency(prompt:=85) {
 id := WinGetID("A")
 transparency := WinGetTransparent(id)
 if(transparency != "" && transparency < 255) {
  WinSetTransparent(255, id)
  WinSetTransparent("Off", id)
 } else {
  if(prompt >= 0 && prompt <= 100) {
   transparency := prompt
   prompt := false
  } else {
   transparency := InputBox("Input a number from 0 to 100 to set the percentage of opacity.", "Set Window Transparency", "w300 h150", 85)
   if(transparency.Result != "OK")
    return
   transparency := transparency.Value
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
 Run('"' A_AhkPath '" "Windows\ToTray.ahk" "' win '"')
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

; Move window to the previous or Next monitor
^#NumpadSub::activeMoveToMonitor(,-1)
^#NumpadAdd::activeMoveToMonitor(,1)

; Move window by one pixel in the direction of the numpad key with relation to [Numpad5]
^#Numpad8::activeMoveBy(, -1)
^#Numpad6::activeMoveBy(1)
^#Numpad2::activeMoveBy(, 1)
^#Numpad4::activeMoveBy(-1)
; Move window by 10 pixels in the direction of the numpad key with relation to [Numpad5]
^!#Numpad8::activeMoveBy(, -10)
^!#Numpad6::activeMoveBy(10)
^!#Numpad2::activeMoveBy(, 10)
^!#Numpad4::activeMoveBy(-10)
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
^#!t::activeToggleTransparency(-1)
; Prompt for window transparency color
^#+t:: {
 active := WinGetID("A")
 input := InputBox("Input the AutoHotkey color value for the color which should be transparent in this window (`"Off`" disables transparency).", "Set Window Transparency Color",, "000000")
 if(input.Result = "OK")
  try WinSetTransColor(input.Value, active)
}
; Toggle clickthrough
^#x::WinSetExStyle("^0x20", "A")
; Toggle always on top, clickthrough, and transparency
^#!x:: {
 WinSetAlwaysOnTop(-1, "A")
 WinSetExStyle("^0x20", "A")
 activeToggleTransparency(50)
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