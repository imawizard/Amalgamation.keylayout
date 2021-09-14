#SingleInstance force
#UseHook on
#MaxHotkeysPerInterval 1000

title = Amalgamation.keylayout

; Apps to launch.
EXPLORER_WIN     := "ahk_class CabinetWClass"
EXPLORER_RUN      = explorer.exe
EDITOR_WIN       := "ahk_exe nvim-qt.exe"
EDITOR_RUN        = %HOME%\scoop\apps\neovim\current\bin\nvim-qt.exe
TERMINAL_WIN     := "ahk_exe WindowsTerminal.exe"
TERMINAL_RUN      = explorer.exe shell:appsFolder\Microsoft.WindowsTerminal_8wekyb3d8bbwe!App
WEB_BROWSER_WIN  := "ahk_exe opera.exe"
WEB_BROWSER_RUN   = %HOMEDRIVE%\Program Files\Opera\launcher.exe
TASK_MANAGER_WIN := "ahk_exe ProcessHacker.exe"
TASK_MANAGER_RUN  = taskmgr.exe
GIT_GUI_WIN      := "ahk_exe gitextensions.exe"
GIT_GUI_RUN       = %HOME%\scoop\apps\gitextensions\current\GitExtensions.exe
MAIL_WIN         := "ahk_exe outlook.exe"
MAIL_RUN          = outlook.exe ; explorer.exe shell:appsFolder\microsoft.windowscommunicationsapps_8wekyb3d8bbwe!microsoft.windowslive.mail
DOCSETS_WIN      := "ahk_exe zeal.exe"
DOCSETS_RUN       = %HOME%\scoop\apps\zeal\current\zeal.exe

; Adjust the tray menu.
Menu Tray, Tip, %title%
Menu, Tray, Add, - Toggle layout with Pause-key -, DoNothing
DoNothing:
Menu, Tray, Disable, 1&
Menu, Tray, Add

; Re-add standard tray menu items.
Menu, Tray, NoStandard
Menu, Tray, Standard

; Global toggle.
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

; Macro for launching apps.
launch(win, prog) {
    if WinActive(win) {
        WinMinimize
    } else if WinExist(win) {
        WinActivate
        ControlFocus, , win
    } else {
        Run %prog%
    }
}

; Global hotkeys .........................................................{{{1
#if

; Disable Capslock if pressed alone.
*sc3a::Return

; Disable Alt if pressed alone.
*sc38::
    Return
*sc38 Up::
    if (lalt_down = true) {
        Send, {LAlt up}
        lalt_down := false
    }
    Return

; Disable WinKey if pressed alone.
*sc15b::Return

; Specific mappings for explorer.exe .....................................{{{1
#if WinActive("ahk_exe explorer.exe")
    and GetKeyState("LAlt", "P")
    and !(GetKeyState("Capslock", "P") or GetKeyState("Ctrl", "P"))
    and !GetKeyState("Shift", "P")
*F11::MsgBox, - Alt (explorer.exe) -

; Open (Alt-o).
*sc18::Send, {Enter}

; New window (Alt-t).
*sc14::Send, ^n

; Delete (Alt-Backspace).
*sc0e::Send, ^d

; Rename (Alt-Return).
*sc1c::Send, {F2}

#if WinActive("ahk_exe explorer.exe")
    and (GetKeyState("Capslock", "P") or GetKeyState("Ctrl", "P"))
    and !GetKeyState("Alt", "P")
    and !GetKeyState("Shift", "P")
*F11::MsgBox, - Ctrl (explorer.exe) -

; Back (Ctrl-b).
*sc31::
    ControlGetFocus, c
    if (c = "SysTreeView321") {
        Send, {Left}{Enter}
    } else if (c = "DirectUIHWND2") {
        Send, !{Up}
    } else {
        Send, {Left}
    }
    Return

; Open (Ctrl-o).
*sc1f::
    ControlGetFocus, c
    if (c = "SysTreeView321") {
        Send, {Right}{Enter}
    } else if (c = "DirectUIHWND2") {
        Send, {Enter}
    } else {
        Send, {Right}
    }
    Return

; Previous (Ctrl-p).
*sc13::
    ControlGetFocus, c
    if (c = "SysTreeView321") {
        Send, {Up}{Enter}
    } else if (c = "DirectUIHWND2") {
        Send, {Up}
    } else {
        Send, {Up}
    }
    Return

; Next (Ctrl-n).
*sc26::
    ControlGetFocus, c
    if (c = "SysTreeView321") {
        Send, {Down}{Enter}
    } else if (c = "DirectUIHWND2") {
        Send, {Down}
    } else {
        Send, {Down}
    }
    Return

; Specific mappings for WindowsTerminal.exe ..............................{{{1
; Map Alt to Ctrl-Shift (instead of only Ctrl) to distinguish it from Capslock.
#if (WinActive("ahk_exe WindowsTerminal.exe")
        or WinActive("ahk_exe nvim-qt.exe"))
    and GetKeyState("LAlt", "P")
    and !(GetKeyState("Capslock", "P") or GetKeyState("Ctrl", "P"))
    and !GetKeyState("Shift", "P")
*F11::MsgBox, - Alt (WindowsTerminal.exe) -

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
*sc15::Send, +^z
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
*sc2c::Send, +^y
*sc2d::Send, +^x
*sc2e::Send, +^c
*sc2f::Send, +^v
*sc30::Send, +^b
*sc31::Send, +^n
*sc32::Send, +^m
*sc33::Send, +^,
*sc34::Send, +^.
*sc35::Send, +^/

; Since Alt-Shift now can't map to Ctrl-Shift, make it map to Alt-Shift.
#if (WinActive("ahk_exe WindowsTerminal.exe")
        or WinActive("ahk_exe nvim-qt.exe"))
    and GetKeyState("LAlt", "P")
    and GetKeyState("Shift", "P")
    and !(GetKeyState("Capslock", "P") or GetKeyState("Ctrl", "P"))
*F11::MsgBox, - Alt-Shift (WindowsTerminal.exe) -

;  1  2  3  4  5  6  7  8  9  0  -  =
*sc02::Send, +!1
*sc03::Send, +!2
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
*sc10::Send, +!q
*sc11::Send, +!w
*sc12::Send, +!e
*sc13::Send, +!r
*sc14::Send, +!t
*sc15::Send, +!z
*sc16::Send, +!u
*sc17::Send, +!i
*sc18::Send, +!o
*sc19::Send, +!p
*sc1a::Send, !p ; WindowsTerminal doesn't seem to recognize +![ and +!].
*sc1b::Send, !n
; a  s  d  f  g  h  j  k  l  ;  '  \
*sc1e::Send, +!a
*sc1f::Send, +!s
*sc20::Send, +!d
*sc21::Send, +!f
*sc22::Send, +!g
*sc23::Send, +!h
*sc24::Send, +!j
*sc25::Send, +!k
*sc26::Send, +!l
*sc27::Send, +!;
*sc28::Send, +!'
*sc2b::Send, +!\
; z  x  c  v  b  n  m  ,  .  /
*sc2c::Send, +!y
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

#if (WinActive("ahk_exe WindowsTerminal.exe")
        or WinActive("ahk_exe nvim-qt.exe"))
    and (GetKeyState("LWin", "P") or GetKeyState("RWin", "P"))
    and !(GetKeyState("Capslock", "P") or GetKeyState("Ctrl", "P"))
    and !GetKeyState("Alt", "P")
    and !GetKeyState("Shift", "P")
*F11::MsgBox, - WinKey (WindowsTerminal.exe) -

; Delete word (h).
*sc24::Send, !{Backspace}

; Mappings for AltGr .....................................................{{{1
#if GetKeyState("RAlt", "P")
    and !GetKeyState("Shift", "P")
*F11::MsgBox, - AltGr -

; Open web browser (o).
*sc1f::launch(WEB_BROWSER_WIN, WEB_BROWSER_RUN)

; Open terminal (t).
*sc25::launch(TERMINAL_WIN, TERMINAL_RUN)

; Open editor (e).
*sc20::launch(EDITOR_WIN, EDITOR_RUN)

; Open mail (m).
*sc32::launch(MAIL_WIN, MAIL_RUN)

; Open docsets (d).
*sc23::launch(DOCSETS_WIN, DOCSETS_RUN)

; Open explorer (p).
*sc13::
    if WinExist(EXPLORER_WIN) {
        WinActivate
    } else {
        Run %EXPLORER_RUN%
    }
    Return

; Open Windows' search (Space).
*sc39::Send, #{sc1f}

; Open fugly Task View (c).
*sc17::Send, #{Tab}

; Mappings for Shift-AltGr ...............................................{{{1
#if GetKeyState("RAlt", "P")
    and GetKeyState("LShift", "P")
*F11::MsgBox, - Shift-AltGr -

; Open task manager (a).
*sc1e::launch(TASK_MANAGER_WIN, TASK_MANAGER_RUN)

; Open git gui (g).
*sc16::launch(GIT_GUI_WIN, GIT_GUI_RUN)

; Mappings for WinKey ....................................................{{{1
#if (GetKeyState("LWin", "P") or GetKeyState("RWin", "P"))
    and !(GetKeyState("Capslock", "P") or GetKeyState("Ctrl", "P"))
    and !GetKeyState("Alt", "P")
    and !GetKeyState("Shift", "P")
*F11::MsgBox, - WinKey -

; §  1  2  3  4  5  6  7  8  9  0  -  =
*sc29::emit("→")
*sc02::emit("¹")
*sc03::emit("²")
*sc04::emit("³")
*sc05::emit("⁴")
*sc06::emit("⁵")
*sc07::emit("⁶")
*sc08::emit("⁷")
*sc09::emit("⁸")
*sc0a::emit("⁹")
*sc0b::emit("⁰")
*sc0c::emit("–")
*sc0d::emit("≠")
; q  w  e  r  t  y  u  i  o  p  [  ]
*sc10::emit("…")
*sc11::dead_or_emit("circumflex", "{Text}^", , , , "{Text}^^")
*sc12::dead_or_emit("grave", "{Text}``", , , "{Text}````")
*sc13::emit("π")
*sc14::emit("¥")
*sc15::Send, ^{Right}
*sc16::Return
*sc17::emit("©")
*sc18::emit("®")
*sc19::Return
*sc1a::emit("‹")
*sc1b::emit("›")
; a  s  d  f  g  h  j  k  l  ;  '  \
*sc1e::emit("å")
*sc1f::emit("ø")
*sc20::emit("€")
*sc21::emit("ƒ")
*sc22::emit("∂")
*sc23::Send, ^{Delete}
*sc24::Send, ^{Backspace}
*sc25::emit("™")
*sc26::Return
*sc27::emit("∫")
*sc28::emit("¡")
*sc2b::emit("„")
; `  z  x  c  v  b  n  m  ,  .  /
*sc56::emit("◦")
*sc2c::emit("∙")
*sc2d::Return
*sc2e::Return
*sc2f::Return
*sc30::emit("✗")
*sc31::Send, ^{Left}
*sc32::emit("𐄂")
*sc33::emit("☐")
*sc34::emit("✔")
*sc35::emit("Ω")
; Special
*sc1c::Send, !{Enter}
*vk01::Send, !{LButton}

; Mappings for Shift-WinKey ..............................................{{{1
#if (GetKeyState("LWin", "P") or GetKeyState("RWin", "P"))
    and GetKeyState("Shift", "P")
    and !GetKeyState("Alt", "P")
*F11::MsgBox, - Shift-WinKey -

; §  1  2  3  4  5  6  7  8  9  0  -  =
*sc29::emit("⟶")
*sc02::Return
*sc03::emit("½")
*sc04::emit("⅓")
*sc05::emit("¼")
*sc06::emit("⅔")
*sc07::emit("¾")
*sc08::Return
*sc09::Return
*sc0a::Return
*sc0b::Return
*sc0c::emit("—")
*sc0d::emit("±")
; q  w  e  r  t  y  u  i  o  p  [  ]
*sc10::emit("¿")
*sc11::Return
*sc12::dead_or_emit("acute", "{Text}´", , "{Text}´´")
*sc13::emit("∏")
*sc14::Return
*sc15::Send, +^{Right}
*sc16::Return
*sc17::emit("ç")
*sc18::emit("√")
*sc19::Return
*sc1a::emit("«")
*sc1b::emit("»")
; a  s  d  f  g  h  j  k  l  ;  '  \
*sc1e::emit("Å")
*sc1f::emit("Ø")
*sc20::emit("£")
*sc21::Return
*sc22::emit("∆")
*sc23::Send, ^{Delete}
*sc24::Send, ^{Backspace}
*sc25::emit("†")
*sc26::Return
*sc27::emit("Σ")
*sc28::Return
*sc2b::emit("“")
; `  z  x  c  v  b  n  m  ,  .  /
*sc56::emit("⦾")
*sc2c::emit("⦿")
*sc2d::Return
*sc2e::Return
*sc2f::Return
*sc30::emit("☒")
*sc31::Send, +^{Left}
*sc32::emit("µ")
*sc33::emit("₩")
*sc34::emit("☑")
*sc35::Return
; Special
*sc1c::Send, +!{Enter}
*vk01::Send, +!{LButton}

; Mappings for Ctrl-WinKey ...............................................{{{1
#if (GetKeyState("LWin", "P") or GetKeyState("RWin", "P"))
    and (GetKeyState("Capslock", "P") or GetKeyState("Ctrl", "P"))
    and !GetKeyState("Alt", "P")
    and !GetKeyState("Shift", "P")
*F11::MsgBox, - Ctrl-WinKey -

; Move to left monitor ([).
*sc1a::Send, #+{Left}

; Move to right monitor (]).
*sc1b::Send, #+{Right}


; Mappings for Alt .......................................................{{{1
#if GetKeyState("Alt", "P")
    and !(GetKeyState("Capslock", "P") or GetKeyState("Ctrl", "P"))
    and !GetKeyState("Shift", "P")
*F11::MsgBox, - Alt -

*sc0f::
    lalt_down := true
    Send, {LAlt down}{Tab}
    Return

; §  1  2  3  4  5  6  7  8  9  0  -  =
*sc29::Return
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
*sc15::Send, ^z
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
*sc56::                       ; Switch between an app's windows
    WinGetClass, ActiveClass, A
    WinGet, n, Count, ahk_class %ActiveClass%
    if (n = 1) {
        Return
    }
    WinSet, Bottom, , A
    WinActivate, ahk_class %ActiveClass%
    Return
*sc2c::Send, ^y
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
*sc39::Send, #{sc1f}          ; Open Windows' search.
vk01::Send, ^{LButton}        ; Wildcard remap breaks left click for Alt-Tab.

; Mappings for Alt-Shift .................................................{{{1
#if GetKeyState("Alt", "P")
    and GetKeyState("Shift", "P")
*F11::MsgBox, - Alt-Shift -

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
*sc15::Send, +^z
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
*sc2c::Send, +^y
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
*F12::SendMessage, 0x0112, 0xf170, 2, , Program Manager

; Mappings for Ctrl ......................................................{{{1
#if (GetKeyState("Capslock", "P") or GetKeyState("Ctrl",  "P"))
    and !GetKeyState("Alt",  "P")
    and !WinActive("ahk_exe WindowsTerminal.exe")
    and !WinActive("ahk_exe cmd.exe")
    and !WinActive("ahk_exe nvim-qt.exe")
    and !WinActive("ahk_exe nvim.exe")
    and !WinActive("ahk_exe Emacs.exe")
    and !WinActive("ahk_exe code.exe")
    and !WinActive("ahk_exe goneovim.exe")
*sc31::Send, {Left}
*sc15::Send, {Right}
*sc13::Send, {Up}
*sc26::Send, {Down}
*sc20::Send, {End}
*sc1e::Send, {Home}
*sc24::Send, {Backspace}
*sc23::Send, {Delete}

#if (GetKeyState("Capslock", "P") or GetKeyState("Ctrl",  "P"))
    and !GetKeyState("Alt",  "P")
*F11::MsgBox, - Ctrl -

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
*sc10::Send, ^q                      ; Replace C-. with C-@
*sc11::Send, ^{vkdc}                 ; Replace C-; with C-^
*sc12::Send, ^{vkbf}                 ; Replace C-, with C-\
*sc13::Send, ^p
*sc14::Send, ^y
*sc15::Send, ^f
*sc16::Send, ^g
*sc17::Send, {Escape}                ; Replace C-c with ⎋
*sc18::Send, ^r
*sc19::Send, ^l
*sc1a::Send, ^c                      ; Replace C-[ with C-c
*sc1b::Send, ^a
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
*sc28::Send, ^_                      ; Replace C-! with C-_
*sc2b::Send, ^\
; `  z  x  c  v  b  n  m  ,  .  /
*sc56::Send, ^`
*sc2c::Send, ^•
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
*sc39::Send, !{vk00ba}               ; Remap C-SPC to Alt-; instead of ^{Space}
                                     ; for Hunt-and-Peck

; Mappings for Ctrl-Alt ..................................................{{{1
#if (GetKeyState("Capslock", "P") or GetKeyState("Ctrl", "P"))
    and GetKeyState("Alt", "P")
*F11::MsgBox, - Ctrl-Alt -

; Open emoji list (Space).
*sc39::Send, #.

; Restore window (Backspace).
*sc0e::Send, !{Space}W

; Maximize window (f).
*sc15::WinMaximize A

; Pin window to the left side ([).
*sc1a::Send, #{Left}

; Pin window to the right side (]).
*sc1b::Send, #{Right}

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

; Mappings for Right Shift ...............................................{{{1
#if GetKeyState("RShift", "P")
*F11::MsgBox, - Right Shift -

*sc2d::emit("1")
*sc2e::emit("2")
*sc2f::emit("3")
*sc1f::emit("4")
*sc20::emit("5")
*sc21::emit("6")
*sc11::emit("7")
*sc12::emit("8")
*sc13::emit("9")
*sc39::emit("0")
*sc10::emit(".")
*sc03::emit("-")
*sc04::emit("/")

; Mappings for Shift .....................................................{{{1
#if GetKeyState("Shift")
*F11::MsgBox, - Shift -

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
*sc0a::emit("|")
*sc0b::emit("&")
*sc0c::emit("_")
*sc0d::emit("{+}")
; q  w  e  r  t  y  u  i  o  p  [  ]
*sc10::emit("?")
*sc11::emit("{Text}^")
*sc12::emit("{Text}``")
*sc13::emit("P")
*sc14::emit("Y",    , "Ý")
*sc15::emit("F")
*sc16::emit("G")
*sc17::emit("C")
*sc18::emit("R")
*sc19::emit("L")
*sc1a::emit("{")
*sc1b::emit("}")
; a  s  d  f  g  h  j  k  l  ;  '  \
*sc1e::emit("A", "Ä", "Á", "À", "Â")
*sc1f::emit("O", "Ö", "Ó", "Ò", "Ô")
*sc20::emit("E", "Ü", "É", "È", "Ê")
*sc21::emit("I",    , "Í", "Ì", "Î")
*sc22::emit("U",    , "Ú", "Ù", "Û")
*sc23::emit("D")
*sc24::emit("H")
*sc25::emit("T")
*sc26::emit("N")
*sc27::emit("S")
*sc28::emit("ß")
*sc2b::emit("|")
; `  z  x  c  v  b  n  m  ,  .  /
*sc56::emit("~")
*sc2c::emit("{Text}´")
*sc2d::emit("Q")
*sc2e::emit("J")
*sc2f::emit("K")
*sc30::emit("X")
*sc31::emit("B")
*sc32::emit("M")
*sc33::emit("W")
*sc34::emit("V")
*sc35::emit("Z")

; Regular mappings........................................................{{{1
#if
*F11::MsgBox, - No modifiers -

; §  1  2  3  4  5  6  7  8  9  0  -  =
*sc29::Send, #{sc20}
*sc02::Return
*sc03::emit("{+}")
*sc04::emit("*")
*sc05::Return
*sc06::Return
*sc07::Return
*sc08::Return
*sc09::emit(">")
*sc0a::emit("(")
*sc0b::emit(")")
*sc0c::emit("-")
*sc0d::emit("=")
; q  w  e  r  t  y  u  i  o  p  [  ]
*sc10::emit(".")
*sc11::emit(";", "'")
*sc12::dead_or_emit("comma", ",", ",")
*sc13::emit("p", """")
*sc14::emit("y", "{#}", "ý")
*sc15::emit("f")
*sc16::emit("g", "_")
*sc17::emit("c", "[")
*sc18::emit("r", "]")
*sc19::emit("l", "~")
*sc1a::emit("[")
*sc1b::emit("]")
; a  s  d  f  g  h  j  k  l  ;  '  \
*sc1e::emit("a", "ä", "á", "à", "â")
*sc1f::emit("o", "ö", "ó", "ò", "ô")
*sc20::emit("e", "ü", "é", "è", "ê")
*sc21::emit("i", "=", "í", "ì", "î")
*sc22::emit("u", "\", "ú", "ù", "û")
*sc23::emit("d", "$")
*sc24::emit("h", "-")
*sc25::emit("t", "{{}")
*sc26::emit("n", "{}}")
*sc27::emit("s", "/")
*sc28::emit("{!}")
*sc2b::emit("\")
; `  z  x  c  v  b  n  m  ,  .  /
*sc56::emit("{Text}``")
*sc2c::emit("•")
*sc2d::emit("q")
*sc2e::emit("j")
*sc2f::emit("k", "%")
*sc30::emit("x")
*sc31::emit("b", "@")
*sc32::emit("m", ":")
*sc33::emit("w", "<")
*sc34::emit("v")
*sc35::emit("z")
; Special
*sc1c::emit("{Enter}")
*sc39::emit("{Space}", , "{Text}´", "{Text}``", "{Text}^")
*F12::Send, #a

; emit function ..........................................................{{{1
emit(key := "", comb1 := "", comb2 := "", comb3 := "", comb4 := "") {
    Global deadstate

    if deadstate {
        if (deadstate = "comma") {
            dead := ","
            comb := comb1
        } else if (deadstate = "acute") {
            dead := "´"
            comb := comb2
        } else if (deadstate = "grave") {
            dead := "``"
            comb := comb3
        } else {
            dead := "^"
            comb := comb4
        }
        deadstate := false
        if comb {
            Send, %comb%
            Return
        }
        Send, %dead%
    }
    Send, %key%
}

dead_or_emit(state, key := "", comb1 := "", comb2 := ""
                             , comb3 := "", comb4 := "") {
    Global deadstate

    if !deadstate {
        deadstate := state
    } else {
        emit(key, comb1, comb2, comb3, comb4)
    }
}

; Scan codes:
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
;  Ctrl      Alt       Space      AltGr       Ctrl      <-  v  ->   0  .
;    1d      38          39         40         11d    14b 150 14d  52 53
;
; For ahk's Send:
;   ^ Ctrl
;   + Shift
;   ! Alt
;   # Win
;
; For windows shortcuts see
;   https://docs.microsoft.com/de-de/archive/blogs/sebastianklenk/windows-10-keyboard-shortcuts-at-a-glance
;   https://support.microsoft.com/de-de/windows/tastenkombinationen-in-windows-dcc61a57-8ff0-cffe-9796-cb9706c75eec

