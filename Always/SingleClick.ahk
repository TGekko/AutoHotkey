LButton:: {
 If (A_TimeSincePriorHotkey < 100)
  return
 Send "{LButton Down}"
 KeyWait "LButton"
 Send "{LButton Up}"
}

MButton:: {
 If (A_TimeSincePriorHotkey < 200)
  return
 Send "{MButton Down}"
 KeyWait "MButton"
 Send "{MButton Up}"
}

RButton:: {
 If (A_TimeSincePriorHotkey < 100)
  return
 Send "{RButton Down}"
 KeyWait "RButton"
 Send "{RButton Up}"
}