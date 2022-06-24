#SingleInstance Force
#NoTrayIcon

; Window Profiles
; Add to this array to create additional profiles.
; Additional Hotkeys may need to be added to activate custom profiles.
; To activate a profile use the following -- replacing the 1 with the desired profile:
;  windowProfile(windowprofiles[1])
; Use the following layout for additional profiles:
;  [["WinTitle 1", x, y, width, height], ["WinTitle 2", x, y, width, height], ...]
windowprofiles := [[["Steam ahk_exe steam.exe", 0, 0, 1694, 2112], ["Friends List ahk_exe steamwebhelper.exe", 1694, 0, 226, 2112], ["ahk_exe Discord.exe", 1920, 0, 1920, 2112]]]

; This accounts for Windows Aero invisible borders
margin := [7, 4]

; This will contain the styles of windows toggled as borderless
borderless := {}

; This contains a boolean value which indicates which display mode was toggled last (true == "PC screen only", false == "Duplicate")
displaymode := true

; Activates a given Window Profile.
; profile - A *Window Profile*
;            *An array containing one or more of the following array: ["WinTitle", x, y, width, height]
windowProfile(profile) {
 for i, window in profile {
  title := window[1]
  x := window[2]
  y := window[3]
  width := window[4]
  height := window[5]
  WinMove, %title%,, x, y, width, height
 }
}

; Returns the bounds of the monitor which contains the active window.
;  full   - A boolean value. If true, the full size of the monitor, including the taskbar, will be used.
;           (Default == false)
;  return - An array containing the bounds of the monitor containing the active window.
;           The resulting array will have the following configuration: [x, y, width, height]
activeWindowMonitorBounds(full:=false) {
 WinGetPos, x, y, width, height, A
 x += width/2
 y += height/2
 SysGet, monitorcount, MonitorCount
 monitor := 0
 if(monitorcount = 1) {
  monitor := 1
 } else {
  Loop %monitorcount% {
   SysGet bounds, Monitor, %A_Index%
   if(x >= boundsLeft && x <= boundsRight && y >= boundsTop && y <= boundsBottom) {
    monitor := A_index
    break
   }
  }
  if(monitor = 0) {
   MouseGetPos, x, y
   Loop %monitorcount% {
    SysGet bounds, Monitor, %A_Index%
    if(x >= boundsLeft && x <= boundsRight && y >= boundsTop && y <= boundsBottom) {
     monitor := A_index
     break
    }
   }
  }
  if(monitor = 0) {
   SysGet, monitor, MonitorPrimary
  }
 }
 if(full) {
  SysGet, bounds, Monitor, %monitor%
 } else {
  SysGet, bounds, MonitorWorkArea, %monitor%
 }
 monitor := [boundsLeft, boundsTop, boundsRight-boundsLeft, boundsBottom-boundsTop]
 return %monitor%
}

; Moves the active window to a given position within the monitor which it resides.
; Windows without the following style ignore arbitrary margin adjustment:
; > 0xC00000 - WS_CAPTION  (title bar)
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
;  full    - A boolean value indicating whether or not to ignore an automatic arbitrary margin adjustment when resizing the window.
;            A value of true will ignore the arbitrary margin adjustment.
;            A value of false will allow the arbitrary margin adjustment.
;            (Default == false)
;  margins - A boolean value indicating whether or not to apply an arbitrary margin adjustment when resizing the window.
activeMoveTo(x:=-1, y:=-1, width:=-1, height:=-1, full:=false, margins:=true) {
 global margin
 WinGetPos, winx, winy, winwidth, winheight, A
 bounds := 0
 if(full) {
  bounds := activeWindowMonitorBounds(true)
 } else {
  bounds := activeWindowMonitorBounds()
 }
 WinGet, style, Style, A
 winx+= winwidth/2
 winy+= winheight/2
 if(width >= 0 && width <= 1) {
  winwidth := bounds[3]*width
  if((style & 0xC00000) && margins) {
   winwidth += margin[1]*2
  }
 }
 if(height >= 0 && height <= 1) {
  winheight := bounds[4]*height
  if((style & 0xC00000) && margins) {
   winheight += margin[2]*2
  }
 }
 if(x >= 0 && x <= 1) {
  winx := bounds[1]+(bounds[3]*x)
 }
 if(y >= 0 && y <= 1) {
  winy := bounds[2]+(bounds[4]*y)
 }
 winx-= winwidth/2
 winy-= winheight/2
 WinMove, A,, winx, winy, winwidth, winheight
}

; Moves the active window by a specified amount of pixels.
;  x - The amount of pixels to move the window horizontally.
;      (Default = 0)
;  y - The amount of pixels to move the window vertically.
;      (Default = 0)
activeMoveBy(x:=0, y:=0) {
 WinGetPos, winx, winy,,, A
 winx+= x
 winy+= y
 WinMove, A,, winx, winy
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
 WinGetPos, x, y, winwidth, winheight, A
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
 WinMove, A,, x, y, winwidth, winheight
}

; Toggles Borderless Mode for the active window
activeToggleBorderless() {
 global borderless
 WinGet, id, ID, A
 if(borderless[id]) {
  style := borderless[id]
  WinSet, Style, %style%, A
  borderless.Delete(id)
 } else {
  WinGet, style, Style, A
  borderless[id] := style
  WinSet, Style, -0xC00000, A ; WS_CAPTION  (title bar)
  WinSet, Style, -0x800000, A ; WS_BORDER   (thin-line border)
  WinSet, Style, -0x400000, A ; WS_DLGFRAME (dialog box border)
  WinSet, Style, -0x40000, A  ; WS_SIZEBOX  (sizing border)
 }
}

; Toggles Transparency for the active window
;  prompt - A boolean value indicating whether the user should (true) or should not (false) be prompted for a custom transparency percentage
activeToggleTransparency(prompt:=false) {
 transparency := 0
 WinGet, transparency, Transparent, A
 if(transparency) {
  WinSet, Transparent, 255, A
  WinSet, Transparent, Off, A
 } else {
  if(prompt) {
   InputBox, transparency, Set Window Transparency, Input a number from 0 to 100 to set the percentage of opacity.,, 300, 150,,, Locale,, 95
   if(ErrorLevel) {
    return
   }
  } else {
   transparency := 50
  }
  if(transparency >= 0 && transparency <= 100) {
   transparency := (transparency/100)*255
   WinSet, Transparent, %transparency%, A
  }
 }
}

; Toggles Theatre Mode
; When active, everything except the active window will be hidden behind an entirely black GUI
;  soft - A boolean value indicating whether or not to enable Soft Theatre Mode
;         Soft Theatre Mode allows multiple windows to be in front of the generated GUI
toggleTheatreMode(soft:=false) {
 global dark
 if (not destroyGUI(dark)) {
  if(soft) {
   Gui, New, +ToolWindow -Caption +LastFound +Hwnddark
  } else {
   Gui, New, +AlwaysOnTop +ToolWindow -Caption +LastFound +Hwnddark
   WinSet, TransColor, 100100
   WinGetActiveStats, title, w, h, x, y
   x += margin[1]
   y += margin[2]
   w -= margin[1]*2
   h -= margin[2]*2
   Gui, %dark%:Add, Progress, x%x% y%y% w%w% h%h% c100100 background100100 Hwnddarkwindow, 100
  }
  Gui, %dark%:Color, 000000
  Gui, %dark%:Show, x0 y0 w%A_ScreenWidth% h%A_ScreenHeight% NoActivate, AutoHotkey :: Windows.ahk > GUI > Theatre Mode
 }
}

; If the given gui exists, the gui is destroyed.
;  ui      - The gui id of the gui to destroy.
;  returns - A boolean value indicating whether the given gui was (true) or was not (false) destroyed.
destroyGUI(ui) {
 if(WinExist("ahk_id" ui)) {
  Gui, %ui%:Destroy
  WinGetActiveTitle, title
  return true
 }
 return false
}



; Hotkeys

; Activate Window Profile 1
^#,::windowProfile(windowprofiles[1])

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

; Move window to numpad key position on the screen and scale to 50% of the screen size
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

; Resize active window by +5% of the monitor size
#NumpadMult::activeSizeBy(0.05, 0.05, true)
; Resize active window by -5% of the monitor size
#NumpadDiv::activeSizeBy(-0.05, -0.05, true)

; Move window by one pixel in the direction of the numpad key with relation to [Numpad5]
^#Numpad8::activeMoveBy(, -1)
^#Numpad6::activeMoveBy(1)
^#Numpad2::activeMoveBy(, 1)
^#Numpad4::activeMoveBy(-1)

; Set window to 100% of the screen's size
#NumpadSub:: activeMoveTo(0.5, 0.5, 1, 1)
; Set window to 100% of the screen's size including the taskbar
#!NumpadSub:: activeMoveTo(0.5, 0.5, 1, 1, true, false)

; Toggle "Always On Top" for the active window
^#a::WinSet, AlwaysOnTop, Toggle, A

; Toggle Borderless Mode for the active window and set it to 100% of the screen's size including the taskbar
; Ignores arbitrary margin adjustment
^#!b::
 activeToggleBorderless()
 activeMoveTo(0.5, 0.5, 1, 1, true)
return
; Toggle Borderless Mode for the active window
^#b::activeToggleBorderless()

; Toggle window transparency
^#t::activeToggleTransparency()
; Prompt for window transparency percentage
^#!t::activeToggleTransparency(true)

; Toggle Windows display mode between "PC screen only" and "Duplicate"
^#p::
 if(displaymode) {
  Run, C:\Windows\System32\DisplaySwitch.exe /clone
  displaymode := false
 } else {
  Run, C:\Windows\System32\DisplaySwitch.exe /internal
  displaymode := true
 }
return

; Enable Theatre Mode for the active window
; This makes the rest of the screen black
^#/::toggleTheatreMode()
; Enable Soft Theatre Mode
; Any number of windows can be on top of the black screen
^#!/::toggleTheatreMode(true)

#IfWinActive AutoHotkey :: Windows.ahk > GUI > Theatre Mode
 LButton up::destroyGUI(dark)
#IfWinActive
#IfWinExist AutoHotkey :: Windows.ahk > GUI > Theatre Mode
 ~Escape::destroyGUI(dark)
 ~Pause::
  GuiControlGet, darkwindowvisible, Visible, %darkwindow%
  if(darkwindowvisible == 1) {
   GuiControl, Hide, %darkwindow%
  } else {
   GuiControl, Show, %darkwindow%
  }
  return
 ~`::
  if(light) {
   try Gui, %dark%:Color, 000000
   light := false
  } else {
   try Gui, %dark%:Color, FFFFFF
   light := true
  }
  return
#IfWinExist