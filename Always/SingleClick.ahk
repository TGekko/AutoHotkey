LButton::
If (A_TimeSincePriorHotkey < 100)
Return
Send {LButton Down}
KeyWait, LButton
Send {LButton Up}
Return

MButton::
If (A_TimeSincePriorHotkey < 200)
Return
Send {MButton Down}
KeyWait, MButton
Send {MButton Up}
Return

RButton::
If (A_TimeSincePriorHotkey < 100)
Return
Send {RButton Down}
KeyWait, RButton
Send {RButton Up}
Return
