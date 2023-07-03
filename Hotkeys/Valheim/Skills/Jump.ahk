#SingleInstance Ignore

Loop {
 Send "{Space down}{Space up}""
 Sleep 100
 Send "{Space down}{Space up}"
 Sleep 1600
}

~*Pause::
~*End::{
 Send "{Space up}"
 ExitApp
}