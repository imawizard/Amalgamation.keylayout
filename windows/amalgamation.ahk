#SingleInstance force
#UseHook on
#MaxHotkeysPerInterval 1000

title = Amalgamation.keylayout

; Map Alt to Ctrl-Shift
GroupAdd, MASK_CMD_LAYER_INCLUDES, ahk_exe WindowsTerminal.exe
GroupAdd, MASK_CMD_LAYER_INCLUDES, ahk_exe nvim-qt.exe

; Exclusions when remapping C-h to Backspace etc
GroupAdd, CONTROL_CHARS_EXCLUDES, ahk_exe WindowsTerminal.exe
GroupAdd, CONTROL_CHARS_EXCLUDES, ahk_exe cmd.exe
GroupAdd, CONTROL_CHARS_EXCLUDES, ahk_exe nvim-qt.exe
GroupAdd, CONTROL_CHARS_EXCLUDES, ahk_exe nvim.exe
GroupAdd, CONTROL_CHARS_EXCLUDES, ahk_exe Emacs.exe
GroupAdd, CONTROL_CHARS_EXCLUDES, ahk_exe code.exe
GroupAdd, CONTROL_CHARS_EXCLUDES, ahk_exe goneovim.exe

; Apps to launch
EXPLORER_WIN     := "ahk_class CabinetWClass"
EXPLORER_RUN      = explorer.exe
EDITOR_WIN       := "ahk_exe nvim-qt.exe"
EDITOR_RUN        = %HOME%\scoop\apps\neovim\current\bin\nvim-qt.exe
TERMINAL_WIN     := "ahk_exe WindowsTerminal.exe"
TERMINAL_RUN      = wt.exe
WEB_BROWSER_WIN  := "ahk_exe opera.exe"
WEB_BROWSER_RUN   = %HOMEDRIVE%\Program Files\Opera\launcher.exe
TASK_MANAGER_WIN := "ahk_exe ProcessHacker.exe"
TASK_MANAGER_RUN  = taskmgr.exe
GIT_GUI_WIN      := "ahk_exe gitextensions.exe"
GIT_GUI_RUN       = %HOME%\scoop\apps\gitextensions\current\GitExtensions.exe
MAIL_WIN         := "ahk_exe outlook.exe"
MAIL_RUN          = outlook.exe
DOCSETS_WIN      := "ahk_exe zeal.exe"
DOCSETS_RUN       = %HOME%\scoop\apps\zeal\current\zeal.exe

; Explorer window controls
EXPLORER_CONTENT := "DirectUIHWND2"
EXPLORER_SIDEBAR := "SysTreeView321"
EXPLORER_DESKTOP := "SysListView321"

; Adjust the tray menu
Menu, Tray, Tip, %title%
Menu, Tray, Add, - Toggle layout with Pause-key -, DoNothing
DoNothing:
Menu, Tray, Disable, 1&
Menu, Tray, Add

; Re-add standard tray menu items
Menu, Tray, NoStandard
Menu, Tray, Standard

; Global toggle
TrayTip, %title%, Layout turned ON

Pause::
    Suspend
    if (A_IsSuspended) {
        TrayTip, %title%, Layout turned OFF
    } else {
        Reload
    }
    Return

SetCapsLockState, AlwaysOff

; Scan codes .............................................................{{{1

;   Esc    F1 F2 F3 F4    F5 F6 F7 F8 F9 F10
;    01    3b 3c 3d 3e    3f 40 41 42 43 44
;     §  1  2  3  4  5  6  7  8  9  0  -  =   Back   Ins Hom PgU   /  *  -
;    29 02 03 04 05 06 07 08 09 0a 0b 0c 0d     0e   152 147 149 135 37 4a
;   Tab   q  w  e  r  t  y  u  i  o  p  [  ]  Enter  Del End PgD   7  8  9
;    0f  10 11 12 13 14 15 16 17 18 19 1a 1b    1c   153 14f 151  47 48 49
;  Caps   a  s  d  f  g  h  j  k  l  ;  '  \                       4  5  6  +
;    3a  1e 1f 20 21 22 23 24 25 26 27 28 2b                      4b 4c 4d 4e
;  Shift `  z  x  c  v  b  n  m  ,  .  /      Shift        ^       1  2  3 Enter
;    2a 56 2c 2d 2e 2f 30 31 32 33 34 35       136        148     4f 50 51 11c
;  Ctrl Win  Alt       Space      AltGr  Prt  Ctrl      <-  v  ->   0  .
;    1d 15b  38          39        138   137   11d    14b 150 14d  52 53
;                                        15d
; For ahk's Send:
;   ^ Ctrl
;   + Shift
;   ! Alt
;   # Win
;
; For windows shortcuts see
;   https://docs.microsoft.com/de-de/archive/blogs/sebastianklenk/windows-10-keyboard-shortcuts-at-a-glance
;   https://support.microsoft.com/de-de/windows/tastenkombinationen-in-windows-dcc61a57-8ff0-cffe-9796-cb9706c75eec

; Global hotkeys .........................................................{{{1
#if

; Disable Capslock if pressed alone
*sc3a::Return

; Disable Alt if pressed alone
*sc38::
    Return
*sc38 Up::
    if (lalt_down = true) {
        Send, {LAlt up}
        lalt_down := false
    }
    Return

; Disable WinKey if pressed alone
*sc15b::Return

; Disable PrintScreen if pressed alone
*sc137::Return
*sc15d::Return

; Make Explorer's shortcuts more like Finder's ...........................{{{1
#if WinActive("ahk_exe explorer.exe")
    and !GetKeyState("LAlt", "P")
    and !(GetKeyState("Capslock", "P") or GetKeyState("Ctrl", "P"))
    and !GetKeyState("Shift", "P")

; Rename with Return
*sc1c::
    ControlGetFocus, c
    if (c = EXPLORER_CONTENT
     || c = EXPLORER_DESKTOP
     || c = EXPLORER_SIDEBAR) {
        Send, {F2}
    } else {
        Send, {Enter}
    }
    Return

; As there's no column-view, make Tab switch between sidebar and content
*sc0f::
    ControlGetFocus, c
    if (c = EXPLORER_CONTENT) {
        Send, +{Tab}
    } else {
        Send, {Tab}
    }
    Return

#if WinActive("ahk_exe explorer.exe")
    and GetKeyState("LAlt", "P")
    and !(GetKeyState("Capslock", "P") or GetKeyState("Ctrl", "P"))
    and !GetKeyState("Shift", "P")

; Open with Alt-o
*sc18::Send, {Enter}

; New window (no native tabs yet...) with Alt-t
*sc14::Send, ^n

; Delete with Alt-Backspace
*sc0e::Send, ^d

#if WinActive("ahk_exe explorer.exe")
    and (GetKeyState("Capslock", "P") or GetKeyState("Ctrl", "P"))
    and !GetKeyState("Alt", "P")
    and !GetKeyState("Shift", "P")

; Go one level up with Ctrl-b
*sc31::
    ControlGetFocus, c
    if (c = EXPLORER_SIDEBAR) {
        Send, {Left}{Enter}
    } else if (c = EXPLORER_CONTENT) {
        Send, !{Up}
    } else {
        Send, {Left}
    }
    Return

; Go one level down with Ctrl-f
*sc15::
    ControlGetFocus, c
    if (c = EXPLORER_SIDEBAR) {
        Send, {Right}{Enter}
    } else if (c = EXPLORER_CONTENT) {
        Send, {Enter}
    } else {
        Send, {Right}
    }
    Return

; Previous item with Ctrl-p
*sc13::
    ControlGetFocus, c
    if (c = EXPLORER_SIDEBAR) {
        Send, {Up}{Enter}
    } else if (c = EXPLORER_CONTENT) {
        Send, {Up}
    } else {
        Send, {Up}
    }
    Return

; Next item with Ctrl-n
*sc26::
    ControlGetFocus, c
    if (c = EXPLORER_SIDEBAR) {
        Send, {Down}{Enter}
    } else if (c = EXPLORER_CONTENT) {
        Send, {Down}
    } else {
        Send, {Down}
    }
    Return

; Open selected file in editor
*sc34::
    filepath := ""
    ControlGetFocus, c
    if (c = EXPLORER_CONTENT) {
        filepath := GetSHAppSelectionPaths()
    } else if (c = EXPLORER_SIDEBAR) {
        filepath := GetSHAppFolderPath()
    }
    if filepath {
        Run, %EDITOR_RUN% "%filepath%"
    }
    Return

; Open cwd in terminal
*sc35::
    ; TODO: If selected && folder, open selected folder in terminal
    ControlGetFocus, c
    if (c = EXPLORER_DESKTOP) {
        Run, wt.exe -d ., %HOME%\Desktop
    } else {
        Run, wt.exe -d ., % GetSHAppFolderPath()
    }
    Return

; TODO: Open cwd in git gui
*sc16::
    Return

#if WinActive("ahk_exe explorer.exe")
    and !(GetKeyState("Capslock", "P") or GetKeyState("Ctrl", "P"))
    and GetKeyState("LAlt", "P")
    and (GetKeyState("LWin", "P") or GetKeyState("sc137", "P") or GetKeyState("sc15d", "P"))

; Copy file path with Alt-Win-c
*sc2e::
    filepath := ""
    ControlGetFocus, c
    if (c = EXPLORER_CONTENT) {
        filepath := GetSHAppSelectionPaths()
    } else if (c = EXPLORER_SIDEBAR) {
        filepath := GetSHAppFolderPath()
    }
    if filepath {
        Clipboard := filepath
    }
    Return

; Create new text file with Alt-Win-n
*sc31::
    cwd := GetSHAppFolderPath()
    if (!cwd && Substr(cwd, 1, 2) = "::") {
        Return
    }
    dest := cwd . "\Untitled"
    ext := ".txt"
    n := 1
    loop {
        if (n > 1) {
            path := dest . n . ext
        } else {
            path := dest . ext
        }
        if !FileExist(path) {
            FileOpen(path, "w")
            SplitPath, path, filename
            FocusSHAppItem(filename, 1 + 4 + 8 + 16)
            Return
        }
        n++
    }

; Get explorer's current folder
; See https://docs.microsoft.com/en-us/windows/win32/shell/shellfolderview
; also, explore COM objects in PowerShell with:
;   $w = (New-Object -ComObject Shell.Application).Windows(0)
GetSHAppFolderPath(wnd = 0) {
    if (!wnd) {
        wnd := WinExist("A")
    }
    res := ""
    com := ComObjCreate("Shell.Application")
    for window in com.Windows {
        if (window && window.hwnd == wnd) {
            res := window.Document.Folder.Self.Path
            break
        }
    }
    ObjRelease(com)
    return res
}

; Get explorer's selected filenames
; See https://docs.microsoft.com/en-us/windows/win32/shell/shellfolderview
; and https://docs.microsoft.com/en-us/windows/win32/shell/shellfolderview-selecteditems
GetSHAppSelectionPaths(wnd = 0) {
    if (!wnd) {
        wnd := WinExist("A")
    }
    res := ""
    com := ComObjCreate("Shell.Application")
    for window in com.Windows {
        if (window && window.hwnd == wnd) {
            for item in window.Document.SelectedItems {
                res := res . ";" . item.Path
            }
            res := Substr(res, 2)
            break
        }
    }
    ObjRelease(com)
    return res
}

; Select a file in explorer
; See https://docs.microsoft.com/en-us/windows/win32/shell/shellfolderview-selectitem
; and https://docs.microsoft.com/en-us/windows/win32/shell/folderitems
FocusSHAppItem(filename, flags = 0, wnd = 0) {
    if (!flags) {
        flags := 1 + 2 + 4 + 8 + 16
    }
    if (!wnd) {
        wnd := WinExist("A")
    }
    res := false
    com := ComObjCreate("Shell.Application")
    for window in com.Windows {
        if (window && window.hwnd == wnd) {
            item := window.Document.Folder.ParseName(filename)
            window.Document.SelectItem(item, flags)
            res := true
            break
        }
    }
    ObjRelease(com)
    return res
}

; Mask Cmd-layer to tell it apart from the Ctrl-layer in some apps .......{{{1
; Map Alt to Ctrl-Shift (instead of only Ctrl) to distinguish it from Capslock,
; has to be accounted for in terminal's mappings, like ctrl-shift-f for find.
#if WinActive("ahk_group MASK_CMD_LAYER_INCLUDES")
    and GetKeyState("LAlt", "P")
    and !(GetKeyState("Capslock", "P") or GetKeyState("Ctrl", "P"))
    and !GetKeyState("Shift", "P")

;  1  2  3  4  5  6  7  8  9  0  -  =
*sc02::Send, +^1
*sc03::Send, +^2
*sc04::Send, +^3
*sc05::Send, +^4
*sc06::Send, +^5
*sc07::Send, +^6
*sc08::Send, +^7
*sc09::Send, +^8
*sc0a::Send, +^9
*sc0b::Send, +^0
*sc0c::Send, +^-
*sc0d::Send, +^=
; q  w  e  r  t  y  u  i  o  p  [  ]
*sc11::Send, +^w
*sc12::Send, +^e
*sc13::Send, +^r
*sc14::Send, +^t
*sc15::Send, +^y
*sc16::Send, +^u
*sc17::Send, +^i
*sc18::Send, +^o
*sc19::Send, +^p
*sc1a::Send, +^[
*sc1b::Send, +^]
; a  s  d  f  g  h  j  k  l  ;  '  \
*sc1e::Send, +^a
*sc1f::Send, +^s
*sc20::Send, +^d
*sc21::Send, +^f
*sc22::Send, +^g
*sc24::Send, +^j
*sc25::Send, +^k
*sc26::Send, +^l
*sc27::Send, +^;
*sc28::Send, +^'
*sc2b::Send, +^\
; z  x  c  v  b  n  m  ,  .  /
*sc2c::Send, +^z
*sc2d::Send, +^x
*sc2e::Send, +^c
*sc2f::Send, +^v
*sc30::Send, +^b
*sc31::Send, +^n
*sc32::Send, +^m
*sc33::Send, +^,
*sc34::Send, +^.
*sc35::Send, +^/

; Since Alt-Shift now can't map to Ctrl-Shift, make it map to Alt-Shift, means
; the modifiers actually stay the same, the keys are in qwerty, though.
#if WinActive("ahk_group MASK_CMD_LAYER_INCLUDES")
    and GetKeyState("LAlt", "P")
    and GetKeyState("Shift", "P")
    and !(GetKeyState("Capslock", "P") or GetKeyState("Ctrl", "P"))

;  1  2  3  4  5  6  7  8  9  0  -  =
*sc02::Send, +!1
*sc03::Send, +!2
;*sc04::Send, +!3
*sc05::Send, +!4
*sc06::Send, +!5
*sc07::Send, +!6
*sc08::Send, +!7
*sc09::Send, +!8
*sc0a::Send, +!9
*sc0b::Send, +!0
*sc0c::Send, +!-
*sc0d::Send, +!=
; q  w  e  r  t  y  u  i  o  p  [  ]
;*sc10::Send, +!q
*sc11::Send, +!w
*sc12::Send, +!e
*sc13::Send, +!r
*sc14::Send, +!t
*sc15::Send, +!y
*sc16::Send, +!u
*sc17::Send, +!i
*sc18::Send, +!o
*sc19::Send, +!p
*sc1a::Send, !p ; WindowsTerminal doesn't seem to recognize +![ and +!]
*sc1b::Send, !n ; (NOTE: map prevTab/nextTab to alt-p/-n in settings.json)
; a  s  d  f  g  h  j  k  l  ;  '  \
*sc1e::Send, +!a
*sc1f::Send, +!s
*sc20::Send, +!d
*sc21::Send, +!f
*sc22::Send, +!g
;*sc23::Send, +!h
*sc24::Send, +!j
*sc25::Send, +!k
*sc26::Send, +!l
*sc27::Send, +!;
*sc28::Send, +!'
*sc2b::Send, +!\
; z  x  c  v  b  n  m  ,  .  /
*sc2c::Send, +!z
*sc2d::Send, +!x
*sc2e::Send, +!c
*sc2f::Send, +!v
*sc30::Send, +!b
*sc31::Send, +!n
*sc32::Send, +!m
*sc33::Send, +!,
*sc34::Send, +!.
*sc35::Send, +!/
; Special
*sc14b::Send, +!{Left}
*sc14d::Send, +!{Right}
*sc148::Send, +!{Up}
*sc150::Send, +!{Down}

#if WinActive("ahk_group MASK_CMD_LAYER_INCLUDES")
    and (GetKeyState("LWin", "P") or GetKeyState("RWin", "P"))
    and !(GetKeyState("Capslock", "P") or GetKeyState("Ctrl", "P"))
    and !GetKeyState("Alt", "P")
    and !GetKeyState("Shift", "P")

; Delete word with Win-h
*sc24::Send, !{Backspace} ; ^{Backspace} doesn't work neither in WindowsTerminal
                          ; nor in nvim-qt.

; Quick-Launcher .........................................................{{{1
#if GetKeyState("RAlt", "P")
    and !GetKeyState("Shift", "P")

; Open web browser with RAlt-o
*sc1f::launch(WEB_BROWSER_WIN, WEB_BROWSER_RUN)

; Open terminal with RAlt-t
*sc25::launch(TERMINAL_WIN, TERMINAL_RUN)

; Open editor with RAlt-e
*sc20::launch(EDITOR_WIN, EDITOR_RUN)

; Open mail with RAlt-m
*sc32::launch(MAIL_WIN, MAIL_RUN)

; Open docsets with RAlt-d
*sc23::launch(DOCSETS_WIN, DOCSETS_RUN)

; Open explorer with RAlt-p
*sc13::
    launch(EXPLORER_WIN, EXPLORER_RUN)
    ControlFocus, %EXPLORER_CONTENT%, %EXPLORER_WIN%
    Return

; Open fugly Task View with RAlt-c
*sc17::Send, #{Tab}

#if GetKeyState("RAlt", "P")
    and GetKeyState("LShift", "P")

; Open task manager with RAlt-Shift-a
*sc1e::launch(TASK_MANAGER_WIN, TASK_MANAGER_RUN)

; Open git gui with RAlt-Shift-g
*sc16::launch(GIT_GUI_WIN, GIT_GUI_RUN)

launch(win, prog) {
    if WinActive(win) {
        ;WinMinimize ; Do nothing instead
    } else if WinExist(win) {
        WinActivate
        ControlFocus, , win
    } else {
        Run, %prog%
    }
}

; Spectacle-like shortcuts ...............................................{{{1
#if (GetKeyState("LWin", "P") or GetKeyState("RWin", "P"))
    and (GetKeyState("Capslock", "P") or GetKeyState("Ctrl", "P"))
    and !GetKeyState("Alt", "P")
    and !GetKeyState("Shift", "P")

; Move to left monitor ([).
*sc1a::Send, #+{Left}

; Move to right monitor (]).
*sc1b::Send, #+{Right}

; Make window bigger (+).
*sc0d::
    delta := 20
    WinGetPos, x, y, width, height, A
    WinMove, A, , x - delta, y - delta, width + delta * 2, height + delta * 2
    Return

; Make window smaller (-).
*sc0c::
    delta := -20
    WinGetPos, x, y, width, height, A
    WinMove, A, , x - delta, y - delta, width + delta * 2, height + delta * 2
    Return

; Restore window (Backspace).
*sc0e::Send, !{Space}W

; Maximize window (f).
*sc15::WinMaximize A

; Pin window to the left side (().
*sc0a::Send, #{Left}

; Pin window to the right side ()).
*sc0b::Send, #{Right}

; Center window (c).
*sc17::
    wnd := WinExist("A")
    WinGetPos, , , width, height
    VarSetCapacity(info, 10 * 4)
    NumPut(10 * 4, info) ; cbSize, rcMonitor, rcWork, dwFlags
    monitor := DllCall("MonitorFromWindow", "uint", wnd, "uint", 0x2)
    DllCall("GetMonitorInfo", "uint", monitor, "uint", &info)
    rcWorkLeft   := NumGet(info, 5 * 4, "Int")
    rcWorkTop    := NumGet(info, 6 * 4, "Int")
    rcWorkRight  := NumGet(info, 7 * 4, "Int")
    rcWorkBottom := NumGet(info, 8 * 4, "Int")
    x := (rcWorkRight - width) / 2
    y := (rcWorkBottom - height) / 2
    WinMove, A, , x, y
    Return

; Numpad .................................................................{{{1

#if (GetKeyState("Capslock", "P") or GetKeyState("Ctrl", "P"))
    and GetKeyState("LAlt", "P")

*sc16::Send, 1
*sc17::Send, 2
*sc18::Send, 3
*sc24::Send, 4
*sc25::Send, 5
*sc26::Send, 6
*sc27::Send, 0
*sc32::Send, 7
*sc33::Send, 8
*sc34::Send, 9

; Qwerty ⌘ Cmd-layer with Alt ............................................{{{1

; Alt -> Ctrl
#if GetKeyState("Alt", "P")
    and !(GetKeyState("Capslock", "P") or GetKeyState("Ctrl", "P"))
    and !GetKeyState("Shift", "P")

*sc0f::
    lalt_down := true
    Send, {LAlt down}{Tab}
    Return

; §  1  2  3  4  5  6  7  8  9  0  -  =
*sc29::Send, #{sc20}
*sc02::Send, ^1
*sc03::Send, ^2
*sc04::Send, ^3
*sc05::Send, ^4
*sc06::Send, ^5
*sc07::Send, ^6
*sc08::Send, ^7
*sc09::Send, ^8
*sc0a::Send, ^9
*sc0b::Send, ^0
*sc0c::Send, ^-
*sc0d::Send, ^=
; q  w  e  r  t  y  u  i  o  p  [  ]
*sc10::Send, !{F4}            ; or ^{F4} or !{Space}S
                              ; (latter doesn't work for eg Opera)
*sc11::Send, ^w
*sc12::Send, ^e
*sc13::Send, ^r
*sc14::Send, ^t
*sc15::Send, ^y
*sc16::Send, ^u
*sc17::Send, ^i
*sc18::Send, ^o
*sc19::Send, ^p
*sc1a::Send, ^[
*sc1b::Send, ^]
; a  s  d  f  g  h  j  k  l  ;  '  \
*sc1e::Send, ^a
*sc1f::Send, ^s
*sc20::Send, ^d
*sc21::Send, ^f
*sc22::Send, ^g
*sc23::WinMinimize A
*sc24::Send, ^j
*sc25::Send, ^k
*sc26::Send, ^l
*sc27::Send, ^;
*sc28::Send, ^'
*sc2b::Send, ^\
; `  z  x  c  v  b  n  m  ,  .  /
*sc56::SwitchToNextWindow()
*sc2c::Send, ^z
*sc2d::Send, ^x
*sc2e::Send, ^c
*sc2f::Send, ^v
*sc30::Send, ^b
*sc31::Send, ^n
*sc32::Send, ^m               ; or !{Space}n (latter doesn't work for eg Opera)
*sc33::Send, ^,
*sc34::Send, ^.
*sc35::Send, ^/
; Special
*sc0e::Send, ^{Backspace}
vk01::Send, ^{LButton}        ; NOTE: using * breaks Alt-Tab.
*WheelUp::Send, ^{WheelUp}
*WheelDown::Send, ^{WheelDown}

; Tip: Use PowerToys Run, start it as admin, use keyboard hook and remap it to
; Win-S (#{sc1f}). Don't use !{Space}, there are annoying interactions when
; trying to remap AltGr-Space as well, also breaks Alt for opening menus.
*sc39::Send, #{sc1f}
#if GetKeyState("RAlt", "P")
    and !GetKeyState("Shift", "P")
*sc39::Send, #{sc1f}

; Alt -> Ctrl (Shift)
#if GetKeyState("Alt", "P")
    and GetKeyState("Shift", "P")

; §  1  2  3  4  5  6  7  8  9  0  -  =
*sc29::Return
*sc02::Send, +^1
*sc03::Send, +^2
*sc04::Send, {PrintScreen}
*sc05::Send, +^4
*sc06::Send, +^5
*sc07::Send, +^6
*sc08::Send, +^7
*sc09::Send, +^8
*sc0a::Send, +^9
*sc0b::Send, +^0
*sc0c::Send, +^-
*sc0d::Send, +^=
; q  w  e  r  t  y  u  i  o  p  [  ]
*sc10::Send, +^q
*sc11::Send, +^w
*sc12::Send, +^e
*sc13::Send, +^r
*sc14::Send, +^t
*sc15::Send, +^y
*sc16::Send, +^u
*sc17::Send, +^i
*sc18::Send, +^o
*sc19::Send, +^p
*sc1a::Send, +^[
*sc1b::Send, +^]
; a  s  d  f  g  h  j  k  l  ;  '  \
*sc1e::Send, +^a
*sc1f::Send, +^s
*sc20::Send, +^d
*sc21::Send, +^f
*sc22::Send, +^g
*sc23::Send, +^h
*sc24::Send, +^j
*sc25::Send, +^k
*sc26::Send, +^l
*sc27::Send, +^;
*sc28::Send, +^'
*sc2b::Send, +^\
; z  x  c  v  b  n  m  ,  .  /
*sc2c::Send, +^z
*sc2d::Send, +^x
*sc2e::Send, +^c
*sc2f::Send, +^v
*sc30::Send, +^b
*sc31::Send, +^n
*sc32::Send, +^m
*sc33::Send, +^,
*sc34::Send, +^.
*sc35::Send, +^/
; Special
*vk01::Send, ^{LButton}

; Power off monitor
;  WM_SYSCOMMAND   := 0x0112
;  SC_MONITORPOWER := 0xf170
;  SHUT_OFF        := 2
*F12::SendMessage, 0x0112, 0xf170, 2, , Program Manager

; Switch between an app's windows
SwitchToNextWindow(hwnd = 0) {
    if !hwnd {
        hwnd := WinExist("A")
    }
    WinGetClass, winclass, ahk_id %hwnd%
    WinGet, procname, ProcessName, ahk_id %hwnd%
    WinGet, windows, List, ahk_class %winclass%
    i := windows + 1
    loop {
        if (--i = 0) {
            break
        }
        window := windows%i%
        WinGet, tmp, ProcessName, ahk_id %window%
        if (tmp = procname) {
            WinActivate, ahk_id %window%
            break
        }
    }
    return
}

; Global terminal-like control characters ................................{{{1
#if (GetKeyState("Capslock", "P") or GetKeyState("Ctrl",  "P"))
    and !GetKeyState("Shift",  "P")
    and !GetKeyState("Alt",  "P")
    and !WinActive("ahk_group CONTROL_CHARS_EXCLUDES")

*sc31::Send, {Left}
*sc15::Send, {Right}
*sc13::Send, {Up}
*sc26::Send, {Down}
*sc20::Send, {End}
*sc1e::Send, {Home}
*sc24::Send, {Backspace}
*sc23::Send, {Delete}

#if (GetKeyState("Capslock", "P") or GetKeyState("Ctrl",  "P"))
    and GetKeyState("Shift",  "P")
    and !GetKeyState("Alt",  "P")
    and !WinActive("ahk_group CONTROL_CHARS_EXCLUDES")

*sc31::Send, +{Left}
*sc15::Send, +{Right}
*sc13::Send, +{Up}
*sc26::Send, +{Down}
*sc20::Send, +{End}
*sc1e::Send, +{Home}

; Other macOS-like shortcuts .............................................{{{1
#if (GetKeyState("Capslock", "P") or GetKeyState("Ctrl", "P"))
    and GetKeyState("LAlt", "P")

; Open emoji list with Ctrl-Alt-Space
*sc39::Send, #.

; Disable everything else.
*sc29::Return
*sc02::Return
*sc03::Return
*sc04::Return
*sc05::Return
*sc06::Return
*sc07::Return
*sc08::Return
*sc09::Return
*sc0a::Return
*sc0b::Return
*sc0c::Return
*sc0d::Return
*sc10::Return
*sc11::Return
*sc12::Return
*sc13::Return
*sc14::Return
*sc16::Return
*sc18::Return
*sc19::Return
*sc1e::Return
*sc1f::Return
*sc20::Return
*sc21::Return
*sc22::Return
*sc23::Return
*sc24::Return
*sc25::Return
*sc26::Return
*sc27::Return
*sc28::Return
*sc2b::Return
*sc56::Return
*sc2c::Return
*sc2d::Return
*sc2e::Return
*sc2f::Return
*sc30::Return
*sc31::Return
*sc32::Return
*sc33::Return
*sc34::Return
*sc35::Return

; Dvorak-like keyboard layout ............................................{{{1

; WinKey -> ⌥ Option
#if (GetKeyState("LWin", "P") or GetKeyState("RWin", "P") or GetKeyState("sc137", "P") or GetKeyState("sc15d", "P"))
    and !(GetKeyState("Capslock", "P") or GetKeyState("Ctrl", "P"))
    and !GetKeyState("Alt", "P")
    and !GetKeyState("Shift", "P")

; §  1  2  3  4  5  6  7  8  9  0  -  =
*sc29::Send, !{sc29}
*sc02::Send, ¹
*sc03::Send, ²
*sc04::Send, ³
*sc05::Send, ⁴
*sc06::Send, ⁵
*sc07::Send, ⁶
*sc08::Send, ⁷
*sc09::Send, ⁸
*sc0a::Send, ⁹
*sc0b::Send, ⁰
*sc0c::Send, –
*sc0d::Send, !{sc0d}
; q  w  e  r  t  y  u  i  o  p  [  ]
*sc10::Send, !{sc10}
*sc11::Send, !{sc11}
*sc12::Send, …
*sc13::Send, £
*sc14::Send, ¥
*sc15::Send, ^{Right}
*sc16::Send, !{sc16}
*sc17::Send, !{sc17}
*sc18::Send, !{sc18}
*sc19::Send, !{sc19}
*sc1a::Send, !{sc1a}
*sc1b::Send, !{sc1b}
; a  s  d  f  g  h  j  k  l  ;  '  \
*sc1e::Send, ä
*sc1f::Send, ö
*sc20::Send, €
*sc21::Send, !{sc21}
*sc22::Send, ü
*sc23::Send, ^{Delete}
*sc24::Send, ^{Backspace}
*sc25::Send, !{sc25}
*sc26::Send, !{sc26}
*sc27::Send, ß
*sc28::Send, !{sc28}
*sc2b::Send, !{sc2b}
; `  z  x  c  v  b  n  m  ,  .  /
*sc56::Send, !{sc56}
*sc2c::Send, !{sc2c}
*sc2d::Send, !{sc2d}
*sc2e::Send, !{sc2e}
*sc2f::Send, !{sc2f}
*sc30::Send, ✗
*sc31::Send, ^{Left}
*sc32::Send, !{sc32}
*sc33::Send, ₩
*sc34::Send, ✔
*sc35::Send, !{sc35}
; Special
*sc1c::Send, !{Enter}
*vk01::Send, !{LButton}

; WinKey -> ⌥ Option (Shift)
#if (GetKeyState("LWin", "P") or GetKeyState("RWin", "P"))
    and GetKeyState("Shift", "P")
    and !GetKeyState("Alt", "P")

; §  1  2  3  4  5  6  7  8  9  0  -  =
*sc29::Return
*sc02::Return
*sc03::Return
*sc04::Return
*sc05::Return
*sc06::Return
*sc07::Return
*sc08::Return
*sc09::Return
*sc0a::Return
*sc0b::Return
*sc0c::Return
*sc0d::Return
; q  w  e  r  t  y  u  i  o  p  [  ]
*sc10::Return
*sc11::Return
*sc12::Return
*sc13::Return
*sc14::Return
*sc15::Send, +^{Right}
*sc16::Return
*sc17::Return
*sc18::Return
*sc19::Return
*sc1a::Return
*sc1b::Return
; a  s  d  f  g  h  j  k  l  ;  '  \
*sc1e::Return
*sc1f::Return
*sc20::Return
*sc21::Return
*sc22::Return
*sc23::Return
*sc24::Return
*sc25::Return
*sc26::Return
*sc27::Return
*sc28::Return
*sc2b::Return
; `  z  x  c  v  b  n  m  ,  .  /
*sc56::Return
*sc2c::Return
*sc2d::Return
*sc2e::Return
*sc2f::Return
*sc30::Return
*sc31::Send, +^{Left}
*sc32::Return
*sc33::Return
*sc34::Return
*sc35::Return
; Special
*sc1c::Send, +!{Enter}
*vk01::Send, +!{LButton}

; Ctrl -> Ctrl
#if (GetKeyState("Capslock", "P") or GetKeyState("Ctrl",  "P"))
    and !GetKeyState("Alt",  "P")

; §  1  2  3  4  5  6  7  8  9  0  -  =
*sc29::Return
*sc02::Return
*sc03::Return
*sc04::Return
*sc05::Return
*sc06::Return
*sc07::Return
*sc08::Return
*sc09::Return
*sc0a::Return
*sc0b::Return
*sc0c::Return
*sc0d::Return
; q  w  e  r  t  y  u  i  o  p  [  ]
*sc10::Send, ^q                      ; Replace C-; with C-@
*sc11::Send, ^{vkdc}                 ; Map to C-^
*sc12::Return
*sc13::Send, ^p
*sc14::Send, ^y
*sc15::Send, ^f
*sc16::Send, ^g
*sc17::Send, {Escape}                ; Replace C-c with ⎋
*sc18::Send, ^r
*sc19::Send, ^l
*sc1a::Send, ^c                      ; Replace C-[ with C-c
*sc1b::Send, ^{vkdd}
; a  s  d  f  g  h  j  k  l  ;  '  \
*sc1e::Send, ^a
*sc1f::Send, ^o
*sc20::Send, ^e
*sc21::Send, ^i
*sc22::Send, ^u
*sc23::Send, ^d
*sc24::Send, ^h
*sc25::Send, ^t
*sc26::Send, ^n
*sc27::Send, ^s
*sc28::Return
*sc2b::Send, ^{vkbf}                 ; Map to C-\
; `  z  x  c  v  b  n  m  ,  .  /
*sc56::Return
*sc2c::Return
*sc2d::Send, ^q
*sc2e::Send, ^j
*sc2f::Send, ^k
*sc30::Send, ^x
*sc31::Send, ^b
*sc32::Send, ^m
*sc33::Send, ^w
*sc34::Send, ^v
*sc35::Send, ^z
; Special
;*sc39::Send, ^{Space}               ; Remap C-SPC for Hunt-and-Peck to Alt-;
*sc39::Send, !{vk00ba}               ; instead, because its hotkey is hardcoded.

; Regular (Shift)
#if GetKeyState("Shift")

; §  1  2  3  4  5  6  7  8  9  0  -  =
*sc29::Return
*sc02::Send, ~
*sc03::Send, @
*sc04::Send, {#}
*sc05::Send, $
*sc06::Return
*sc07::Return
*sc08::Return
*sc09::Send, *
*sc0a::Send, /
*sc0b::Send, {+}
*sc0c::Send, _
*sc0d::Return
; q  w  e  r  t  y  u  i  o  p  [  ]
*sc10::Send, ?
*sc11::Send, {Text}^
*sc12::Send, :
*sc13::Send, P
*sc14::Send, Y
*sc15::Send, F
*sc16::Send, G
*sc17::Send, C
*sc18::Send, R
*sc19::Send, L
*sc1a::Send, {{}
*sc1b::Send, {}}
; a  s  d  f  g  h  j  k  l  ;  '  \
*sc1e::Send, A
*sc1f::Send, O
*sc20::Send, E
*sc21::Send, I
*sc22::Send, U
*sc23::Send, D
*sc24::Send, H
*sc25::Send, T
*sc26::Send, N
*sc27::Send, S
*sc28::Send, '
*sc2b::Send, |
; `  z  x  c  v  b  n  m  ,  .  /
*sc56::Return
*sc2c::Send, &
*sc2d::Send, Q
*sc2e::Send, J
*sc2f::Send, K
*sc30::Send, X
*sc31::Send, B
*sc32::Send, M
*sc33::Send, W
*sc34::Send, V
*sc35::Send, Z
; Special
*sc1c::Send, +{Enter}
*WheelUp::Send, +{WheelUp}
*WheelDown::Send, +{WheelDown}

; Regular
#if

; §  1  2  3  4  5  6  7  8  9  0  -  =
*sc29::Send, {Text}´
*sc02::Send, {Text}``
*sc03::Send, <
*sc04::Send, >
*sc05::Send, =
*sc06::Return
*sc07::Return
*sc08::Return
*sc09::Send, {!}
*sc0a::Send, (
*sc0b::Send, )
*sc0c::Send, -
*sc0d::Return
; q  w  e  r  t  y  u  i  o  p  [  ]
*sc10::Send, {;}
*sc11::Send, ,
*sc12::Send, .
*sc13::Send, p
*sc14::Send, y
*sc15::Send, f
*sc16::Send, g
*sc17::Send, c
*sc18::Send, r
*sc19::Send, l
*sc1a::Send, [
*sc1b::Send, ]
; a  s  d  f  g  h  j  k  l  ;  '  \
*sc1e::Send, a
*sc1f::Send, o
*sc20::Send, e
*sc21::Send, i
*sc22::Send, u
*sc23::Send, d
*sc24::Send, h
*sc25::Send, t
*sc26::Send, n
*sc27::Send, s
*sc28::Send, "
*sc2b::Send, \
; `  z  x  c  v  b  n  m  ,  .  /
*sc56::Return
*sc2c::Send, `%
*sc2d::Send, q
*sc2e::Send, j
*sc2f::Send, k
*sc30::Send, x
*sc31::Send, b
*sc32::Send, m
*sc33::Send, w
*sc34::Send, v
*sc35::Send, z
; Special
*F12::Send, #a
*sc1c::Send, {Enter}
*sc39::Send, {Space}

