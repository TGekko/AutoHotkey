#SingleInstance Force

battery := Gui("+AlwaysOnTop +ToolWindow -Caption -Disabled +E0x20 +LastFound -DPIScale", "AutoHotkey :: BatteryOverlay.ahk > GUI:Battery")
battery.BackColor := "100100"
WinSetTransColor("100100 170", battery.Hwnd)
battery.Add("Progress", "x0 y0 w28 h18 background000000", 0)
battery.Add("Progress", "x0 y6 w30 h8 background000000", 0)
battery.Add("Progress", "x1 y1 w26 h16 backgroundFFFFFF", 0)
battery.Add("Progress", "x1 y7 w28 h6 backgroundFFFFFF", 0)
battery.Add("Progress", "x3 y3 w22 h12 background000000", 0)
battery.Add("Progress", "x4 y4 w20 h10 cFFFFFF background000000 vprogress", 0)
low := Gui("+AlwaysOnTop +ToolWindow -Caption -Disabled +E0x20 +LastFound -DPIScale", "AutoHotkey :: BatteryOverlay.ahk > GUI:Low")
low.BackColor := "FF5555"
WinSetTransColor("100100 170", low.Hwnd)
low.Add("Progress", "x5 y5 w" (A_ScreenWidth - 10) " h" (A_ScreenHeight - 10) " backgroundFFFFFF", 0)
low.Add("Progress", "x6 y6 w" (A_ScreenWidth - 12) " h" (A_ScreenHeight - 12) " background000000", 0)
low.Add("Progress", "x7 y7 w" (A_ScreenWidth - 14) " h" (A_ScreenHeight - 14) " background100100", 0)

inquiry := Buffer(12)
charging := false
state := 100
update() {
 global inquiry
 DllCall("GetSystemPowerStatus", "Ptr", inquiry)
 status := [NumGet(inquiry, 2, "UChar"), NumGet(inquiry, 1, "UChar")]
 charging := (state = status[1] ? charging : state < status[1])
 state := status[1]
 battery["progress"].Value := status[1]
 battery["progress"].Opt("c" (status[2] == 8 ? "66FF55" : (status[1] < 20 ? "FF5555" : "FFFFFF")))
 if(status[1] <= 50) {
  battery.Show("x" (A_ScreenWidth - 34) " y" (A_ScreenHeight - 22) " NoActivate")
 else {
  battery.Hide()
 }
 if(status[1] < 15 && status[2] != 8 && !charging) {
  low.Show("x0 y0 w" A_ScreenWidth " h" A_ScreenHeight " NoActivate")
 } else {
  low.Hide()
 }
}

update()
SetTimer(update, 60000)