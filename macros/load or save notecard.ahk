^l::


; uses cntl-s and cntl-l to save or load the contents of a notecard
; to or from a text file

; select all
Send, ^a
Sleep,100

FileSelectFile, Filename
if (Filename = "")
    return
file := FileOpen(Filename, "r")
if !IsObject(file)
{
    MsgBox Can't open "%FileName%"
    return
}

FileRead, clipboard, %Filename%
Sleep,1000

; this is enough of the title to find the Firestorm main window, not its console window.
; TODO: How to get the right one if multiple instances are open?
WinActivate Firestorm-Release
Sleep, 1000

Send, ^v
return



^s::
; select all and copy
Send, ^a
Send, ^c
Sleep,100
ClipWait, 1, 1

FileSelectFile, Filename, S24
if (Filename = "")
    return
file := FileOpen(Filename, "w")
if !IsObject(file)
{
    MsgBox Can't open "%FileName%" for writing.
    return
}

file.Write(clipboard)
file.Close()

return
