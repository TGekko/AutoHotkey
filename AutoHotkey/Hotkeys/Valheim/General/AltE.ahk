!e::
 if (temp = -1) {
  temp := 0
  while (temp < 10) {
   Send e
   KeyWait, e, T1
   Sleep, 75
   temp := temp + 1
  }
  temp := -1
 }
return