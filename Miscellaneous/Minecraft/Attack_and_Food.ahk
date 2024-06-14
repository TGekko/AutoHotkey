#SingleInstance Ignore

MouseClick("Right",,,,, "D")
act() {
 WinGetClientPos(,, &w, &h, 'Minecraft')
 if(ImageSearch(&x, &y, w*0.4, h*0.4, w*0.6, h*0.6, '*64 *TransBlack Attack_Ready.jpg'))
  MouseClick("Left")
}
SetTimer(act, 100)

Pause::
End:: {
 MouseClick("Right",,,,, "U")
 ExitApp
}