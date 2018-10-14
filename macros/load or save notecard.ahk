^l::
Send, ^a
Sleep,100
SetTitleMatchMode, 2 
  ; "A window's title can contain WinTitle anywhere inside it to be a match. "
  ; 3 means match exactly
WinActivate Notepad++
Sleep,1000
Send, ^n
Sleep,100

Send, ^o
WinWaitActive Open
Sleep,3000
WinWaitNotActive Open
Send, ^a
Send, ^c
Sleep,500
 ; this gets the Firestorm main window, not its console window. But how to get the right one if multiple
 ; instances are open?
WinActivate Firestorm-Release
Sleep, 1000
Send, ^v
return



^s::
Send, ^a
Send, ^c
Sleep,100
SetTitleMatchMode, 2
WinActivate Notepad++
Sleep,1000
Send, ^n
Send, ^v
Sleep, 500
Send, ^!s
return
