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