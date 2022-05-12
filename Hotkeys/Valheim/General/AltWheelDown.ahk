!WheelDown::
 activetool := activetool + 1
 if (activetool > 8) {
  activetool := 1
 }
 Send {%activetool%}{WheelUp}
return