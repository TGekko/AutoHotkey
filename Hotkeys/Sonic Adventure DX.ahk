#SingleInstance Force
#NoTrayIcon

; Forward	W
; Left		A
; Backward	S
; Right		D
; Jump		Space
; Camera Left	Left
; Campera Right Right
; Action	E / Down
; Look Around	Up
; Back		Backspace
; Pause		Escape / Enter

; Sonic Adventure DX
; ahk_class Sonic Adventure DX
; ahk_exe Sonic Adventure DX.exe
; ahk_pid 16688

#IfWinActive ahk_exe Sonic Adventure DX.exe
 w::Up
 a::Left
 s::Down
 d::Right
 Space::s
 Left::q
 Right::e
 e::a
 Down::a
 Up::w
 Backspace::d
 Escape::Enter
 q::
#IfWinActive