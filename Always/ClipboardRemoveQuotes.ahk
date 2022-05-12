~Pause & Delete::
ClipWait, 2
if (ErrorLevel = 0)
{
 StringReplace, clipboard, clipboard, `", , All
}
Return