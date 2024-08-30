#SingleInstance Off
DetectHiddenWindows(true)
Persistent(true)

; Saves the user's defined title and icon for this window
saveTray(delete := false) {
 global icon
 global title
 global section
 IniDelete(inipath, section)
 if(!delete) {
  IniWrite(title, inipath, section, 'title')
  IniWrite(icon, inipath, section, 'icon')
 }
}

setTitle() {
 global title
 newtitle := InputBox("Please input a new title.", "Change Tray Title: " A_IconTip,, A_IconTip)
 if(newtitle.Result = 'OK') {
  title := newtitle.Value
  A_IconTip := title
  saveTray()
  setTray()
 }
}
setIcon() {
 global icon
 file := FileSelect(1,, "Select Tray Icon: " A_IconTip, "*.ico; *.exe; *.jpg; *.png; *.dll; *.cpl; *.cur; *.ani; *.scr")
 if(file != '') {
  icon := file
  saveTray()
  try TraySetIcon(icon,, true)
 }
}
setTray() {
 submenu := Menu()
 submenu.Add("Change Tray Title", (z*) => setTitle())
 submenu.Add("Change Tray Icon", (z*) => setIcon())
 submenu.Add()
 submenu.Add("Reset Tray", (z*) => resetTray())
 submenu.Add("View Saved Applications", (z*) => openIni())
 A_TrayMenu.Delete()
 A_TrayMenu.Add(A_IconTip, submenu)
 A_TrayMenu.Add()
 A_TrayMenu.Add("Show Window", (z*) => WinClose(A_ScriptHwnd))
 A_TrayMenu.Default:= "Show Window"
 A_TrayMenu.Add("Hide Menu", (z*) => {})
 A_TrayMenu.Add()
 A_TrayMenu.Add("Exit", (z*) => (
  OnExit((z*) => WinClose(id)),
  WinClose(A_ScriptHwnd)
 ))
}
resetTray() {
 global icon
 global title
 icon := WinGetProcessPath(id)
 title := WinGetTitle(id)
 try TraySetIcon(icon,, true)
 A_IconTip := title
 saveTray(true)
 setTray()
}

beforeExit(z*) {
 global
 if(WinExist(id)) {
  WinShow(id)
  WinActivate(id)
 }
}
OnExit(beforeExit)

setTray()
id := 0
if(A_Args.Length < 1)
 id := "ahk_id " WinGetID('A')
else {
 if(A_Args.length > 1) {
  if(InStr(A_Args[2], 'wait'))
   WinWait(A_Args[1])
 }
 id := "ahk_id " WinGetID(A_Args[1])
}
if(!WinExist(id))
 ExitApp
SetTimer(() => (WinWaitClose(id), ExitApp), -1000)

inipath := A_AppData '\.Hotkeys\ToTray.ini'
#Include "Windows.ini.ahk"

icon := WinGetProcessPath(id)
title := WinGetTitle(id)
section := title " ahk_exe " WinGetProcessName(id)
ini := IniReadObject(inipath)
if(ini.Has(section)) {
 title := ini[section]['title']
 icon := ini[section]['icon']
}
ini := 0
try TraySetIcon(icon,, true)
A_IconTip := title

setTray()

WinHide(id)