#SingleInstance Ignore

Loop {
 Send("{LButton}")
 Sleep(700)
 Send("{LButton}")
 Sleep(700)
 Send("{LButton}")
 Sleep(2900)
}

~*Pause::
~*End::{
 ExitApp
}