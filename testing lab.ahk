#Requires AutoHotkey v2.0
#SingleInstance Force

; ControlSend "4{enter}s{enter}",, "[ AVAILABLE ON STEAM : @KanjiCoder's : PHO-SIMP ]"
; WinWait "[_SAVE_PHOSIMP_PNG_]"
; sleep 1000
; WinActivate "[_SAVE_PHOSIMP_PNG_]"
; sleep 500
; send "test"
; ControlSend "17",, "[ AVAILABLE ON STEAM : @KanjiCoder's : PHO-SIMP ]"
; ExitApp

Run "Notepad",, "Min", &PID  ; Run Notepad minimized.
WinWait "ahk_pid " PID  ; Wait for it to appear.
; Send the text to the inactive Notepad edit control.
; The third parameter is omitted so the last found window is used.
ControlSend "This is a line of text in the notepad window.{Enter}", "Edit1"
ControlSendText "Notice that {Enter} is not sent as an Enter keystroke with ControlSendText.", "Edit1"
ControlSend "{ctrl down}s{ctrl up}", "Edit1"
Winwait "Save As"
sleep 1000
ControlSend "yay",, "Save As"

ExitApp

;Msgbox "Press OK to activate the window to see the result."
;WinActivate "ahk_pid " PID  ; Show the result.
