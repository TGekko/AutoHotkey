!WheelUp::
 activetool := activetool - 1
 if (activetool < 1) {
  activetool := 8
 }
 Send {%activetool%}{WheelDown}
return