; ahk-wff - AutoHotKey tool for Windows10 Find & Focus windows across virtual desktops.
; Source:  https://github.com/deryb/ahk-wff

#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%


$F1:: AltTab()
!$F1:: AltTabMenu()
+!$F1:: FFMenu()
!`::WinClose, A  ; Alt-` = close window

; AltTab-replacement for Windows 8:
; deryb: source unknown, did not find it !?!
AltTab(){
    list := ""
    WinGet, id, list
    Loop, %id%
    {
        this_ID := id%A_Index%
        IfWinActive, ahk_id %this_ID%
            continue    
        WinGetTitle, title, ahk_id %this_ID%
        If (title = "")
            continue
        If (!IsWindow(WinExist("ahk_id" . this_ID))) 
            continue
        WinActivate, ahk_id %this_ID%, ,2
            break
    }
}

; AltTabMenu-replacement for Windows 8:
; deryb:  source unknown, did not find it !?!
AltTabMenu(){
    list := ""
    Menu, windows, Add
    Menu, windows, deleteAll
    WinGet, id, list
    Loop, %id%
    {
        this_ID := id%A_Index%
        WinGetTitle, title, ahk_id %this_ID%
        If (title = "")
            continue            
        If (!IsWindow(WinExist("ahk_id" . this_ID))) 
            continue
        Menu, windows, Add, %title%, ActivateTitle      
        WinGet, Path, ProcessPath, ahk_id %this_ID%
        Try 
            Menu, windows, Icon, %title%, %Path%,, 0
        Catch 
            Menu, windows, Icon, %title%, %A_WinDir%\System32\SHELL32.dll, 3, 0 
    }
    CoordMode, Mouse, Screen
    MouseMove, (0.4*A_ScreenWidth), (0.35*A_ScreenHeight)
    CoordMode, Menu, Screen
    Xm := (0.25*A_ScreenWidth)
    Ym := (0.25*A_ScreenHeight)
    Menu, windows, Show, %Xm%, %Ym%
}

; SOURCE:  https://stackoverflow.com/questions/35971452/what-is-the-right-way-to-send-alt-tab-in-ahk/36008086#36008086

FFMenu(){
    InputBox, UserInput, Find and focus running windows, Type part of a window title to display a menu with all possible matches.., , 300, 140
    if ErrorLevel
    {
    ;    MsgBox, CANCEL was pressed.
        return
    }   
    else
    {
        DetectHiddenWindows, On
        list := ""
        Menu, windows, Add
        Menu, windows, deleteAll
        WinGet, id, list
        Loop, %id%
        {
            this_ID := id%A_Index%
            WinGetTitle, title, ahk_id %this_ID%
            If (title = "")
                continue            
            If (!IsWindow(WinExist("ahk_id" . this_ID))) 
                continue
            If !InStr(title, UserInput)
                continue
            Menu, windows, Add, %title%, ActivateWindow 
            WinGet, Path, ProcessPath, ahk_id %this_ID%
            Try 
                Menu, windows, Icon, %title%, %Path%,, 0
            Catch 
                Menu, windows, Icon, %title%, %A_WinDir%\System32\SHELL32.dll, 3, 0 
        }
        CoordMode, Mouse, Screen
        MouseMove, (0.4*A_ScreenWidth), (0.35*A_ScreenHeight)
        CoordMode, Menu, Screen
        Xm := (0.25*A_ScreenWidth)
        Ym := (0.25*A_ScreenHeight)
        Menu, windows, Show, %Xm%, %Ym%
    }
}

ActivateTitle:
DetectHiddenWindows, On
SetTitleMatchMode 3
WinActivate, %A_ThisMenuItem%
return


;-----------------------------------------------------------------
; Check whether the target window is activation target
;-----------------------------------------------------------------
IsWindow(hWnd){
    WinGet, dwStyle, Style, ahk_id %hWnd%
    if ((dwStyle&0x08000000) || !(dwStyle&0x10000000)) {
        return false
    }
    WinGet, dwExStyle, ExStyle, ahk_id %hWnd%
    if (dwExStyle & 0x00000080) {
        return false
    }
    WinGetClass, szClass, ahk_id %hWnd%
    if (szClass = "TApplication") {
        return false
    }
    return true
}




