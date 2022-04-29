*~Up::DllCall("mouse_event", "UInt", 0x01, "UInt", 0, "UInt", -1)
*~Down::DllCall("mouse_event", "UInt", 0x01, "UInt", 0, "UInt", 1)
*~Left::DllCall("mouse_event", "UInt", 0x01, "UInt", -1, "UInt", 0)
*~Right::DllCall("mouse_event", "UInt", 0x01, "UInt", 1, "UInt", 0)