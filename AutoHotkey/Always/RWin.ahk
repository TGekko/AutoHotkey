AppsKey::
Send {RWin Down}
KeyWait, AppsKey
Send {RWin Up}
Return

^AppsKey::
Send {Control Down}
Send {RWin Down}
KeyWait, AppsKey
Send {RWin Up}
KeyWait, Control
Send {Control Up}
Return