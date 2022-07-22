#SingleInstance force
#UseHook on
#MaxHotkeysPerInterval 1000
#WinActivateForce

#NoEnv
#KeyHistory 0
ListLines, Off
SetBatchLines, -1
Process, Priority, , H

title = Amalgamation.keylayout

SetStoreCapsLockMode, Off
SetCapsLockState, AlwaysOff

; Settings ...............................................................{{{1

; Env vars
EnvGet, HOME, HOME
EnvGet, HOMEDRIVE, HOMEDRIVE

SetWorkingDir, % HOME

; Map Alt to Ctrl-Shift
GroupAdd, MASK_CMD_LAYER_INCLUDES, ahk_exe WindowsTerminal.exe
GroupAdd, MASK_CMD_LAYER_INCLUDES, ahk_exe nvim-qt.exe
GroupAdd, MASK_CMD_LAYER_INCLUDES, ahk_exe code.exe

; Exclusions when remapping C-h to Backspace etc
GroupAdd, CONTROL_CHARS_EXCLUDES, ahk_exe WindowsTerminal.exe
GroupAdd, CONTROL_CHARS_EXCLUDES, ahk_exe cmd.exe
GroupAdd, CONTROL_CHARS_EXCLUDES, ahk_exe nvim-qt.exe
GroupAdd, CONTROL_CHARS_EXCLUDES, ahk_exe nvim.exe
GroupAdd, CONTROL_CHARS_EXCLUDES, ahk_exe Emacs.exe
;GroupAdd, CONTROL_CHARS_EXCLUDES, ahk_exe code.exe
GroupAdd, CONTROL_CHARS_EXCLUDES, ahk_exe goneovim.exe

; Apps to launch
Global EXPLORER_WIN     := "ahk_class CabinetWClass"
Global EXPLORER_RUN     := "explorer.exe"
Global EDITOR_WIN       := "ahk_exe nvim-qt.exe"
Global EDITOR_RUN       := HOME . "scoop\apps\neovim\current\bin\nvim-qt.exe"
Global CODE_WIN         := "ahk_exe Code.exe"
Global CODE_RUN         := HOME . "AppData\Local\Programs\Microsoft VS Code\Code.exe"
Global TERMINAL_WIN     := "ahk_exe WindowsTerminal.exe"
Global TERMINAL_RUN     := "wt.exe"
Global WEB_BROWSER_WIN  := "ahk_exe opera.exe"
Global WEB_BROWSER_RUN  := HOMEDRIVE . "Program Files\Opera\launcher.exe"
Global TASK_MANAGER_WIN := "ahk_exe ProcessHacker.exe"
Global TASK_MANAGER_RUN := "taskmgr.exe"
Global GIT_GUI_WIN      := "ahk_exe gitextensions.exe"
Global GIT_GUI_RUN      := HOME . "scoop\apps\gitextensions\current\GitExtensions.exe"
Global MAIL_WIN         := "ahk_exe outlook.exe"
Global MAIL_RUN         := "outlook.exe"
Global DOCSETS_WIN      := "ahk_exe zeal.exe"
Global DOCSETS_RUN      := HOME . "scoop\apps\zeal\current\zeal.exe"

Global mod_none  := 0
Global mod_cmd   := 1 << 0
Global mod_shift := 1 << 1
Global mod_ctrl  := 1 << 2
Global mod_opt   := 1 << 3

modifiers() {
    flags := mod_none
    if GetKeyState("LAlt", "P") {
        flags := flags | mod_cmd
    }
    if GetKeyState("Shift", "P") {
        flags := flags | mod_shift
    }
    if GetKeyState("Capslock", "P")
        || (GetKeyState("Ctrl", "P") && !GetKeyState("RAlt", "P")) {
        flags := flags | mod_ctrl
    }
    if GetKeyState("LWin", "P") || GetKeyState("RWin", "P") {
        flags := flags | mod_opt
    }
    if GetKeyState("sc137", "P") {
        flags := flags | mod_opt
    }
    Return flags
}

Global EXPLORER_CONTENT := "DirectUIHWND2"
Global EXPLORER_SIDEBAR := "SysTreeView321"
Global EXPLORER_DESKTOP := "SysListView321"

; .........................................................................}}}

; tray and toggle ........................................................{{{1

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

; .........................................................................}}}

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
;  Ctrl Win  Alt       Space      AltGr  Prt  Ctrl      <-  v  ->   0  .
;    1d 15b  38          39        138   137   11d    14b 150 14d  52 53
;                                        15d
;                                        15c
; For ahk's Send:
;   ^ Ctrl
;   + Shift
;   ! Alt
;   # Win
;
; For windows shortcuts see
;   https://docs.microsoft.com/en-us/archive/blogs/sebastianklenk/windows-10-keyboard-shortcuts-at-a-glance
;   https://support.microsoft.com/en-us/windows/keyboard-shortcuts-in-windows-dcc61a57-8ff0-cffe-9796-cb9706c75eec

#if

; Disable Capslock if pressed alone
*sc3a::Return

; Disable Alt if pressed alone
*sc38::
    Return
*sc38 Up::
    if (lalt_down == true) {
        Send, {LAlt up}
        lalt_down := false
    }
    Return

; Disable WinKey if pressed alone
*sc15b::Return
*sc15c::Return

; Disable PrintScreen if pressed alone
*sc137::Return
*sc15d::Return

#if WinActive("ahk_exe explorer.exe") and modifiers() == mod_none
;*f1::MsgBox, Explorer, No modifiers ; ...................................{{{1

;; §  1  2  3  4  5  6  7  8  9  0  -  =
;*sc29::
;*sc02::
;*sc03::
;*sc04::
;*sc05::
;*sc06::
;*sc07::
;*sc08::
;*sc09::
;*sc0a::
;*sc0b::
;*sc0c::
;*sc0d::
;; q  w  e  r  t  y  u  i  o  p  [  ]
;*sc10::
;*sc11::
;*sc12::
;*sc13::
;*sc14::
;*sc15::
;*sc16::
;*sc17::
;*sc18::
;*sc19::
;*sc1a::
;*sc1b::
;; a  s  d  f  g  h  j  k  l  ;  '  \
;*sc1e::
;*sc1f::
;*sc20::
;*sc21::
;*sc22::
;*sc23::
;*sc24::
;*sc25::
;*sc26::
;*sc27::
;*sc28::
;*sc2b::
;; `  z  x  c  v  b  n  m  ,  .  /
;*sc56::
;*sc2c::
;*sc2d::
;*sc2e::
;*sc2f::
;*sc30::
;*sc31::
;*sc32::
;*sc33::
;*sc34::
;*sc35::
;; Special
*sc1c::ExplorerRename()

; .........................................................................}}}

#if WinActive("ahk_exe explorer.exe") and modifiers() == mod_ctrl
;*f1::MsgBox, Explorer, Modifiers: Ctrl ; ................................{{{1

;; §  1  2  3  4  5  6  7  8  9  0  -  =
;*sc29::
;*sc02::
;*sc03::
;*sc04::
;*sc05::
;*sc06::
;*sc07::
;*sc08::
;*sc09::
;*sc0a::
;*sc0b::
;*sc0c::
;*sc0d::
;; q  w  e  r  t  y  u  i  o  p  [  ]
;*sc10::
;*sc11::
;*sc12::
*sc13::ExplorerPreviousItem()
;*sc14::
*sc15::ExplorerOneLevelDown()
*sc16::ExplorerOpenInGitGui()
;*sc17::
;*sc18::
;*sc19::
;*sc1a::
;*sc1b::
;; a  s  d  f  g  h  j  k  l  ;  '  \
;*sc1e::
;*sc1f::
;*sc20::
;*sc21::
;*sc22::
;*sc23::
;*sc24::
;*sc25::
*sc26::ExplorerNextItem()
;*sc27::
;*sc28::
;*sc2b::
;; `  z  x  c  v  b  n  m  ,  .  /
;*sc56::
;*sc2c::
;*sc2d::
;*sc2e::
;*sc2f::
;*sc30::
*sc31::ExplorerOneLevelUp()
;*sc32::
;*sc33::
*sc34::ExplorerOpenInEditor()
*sc35::ExplorerOpenInTerminal()

; .........................................................................}}}

#if WinActive("ahk_exe explorer.exe") and modifiers() == mod_cmd
;*f1::MsgBox, Explorer, Modifiers: Cmd ; .................................{{{1

;; §  1  2  3  4  5  6  7  8  9  0  -  =
;*sc29::
;*sc02::
;*sc03::
;*sc04::
;*sc05::
;*sc06::
;*sc07::
;*sc08::
;*sc09::
;*sc0a::
;*sc0b::
;*sc0c::
;*sc0d::
;; q  w  e  r  t  y  u  i  o  p  [  ]
;*sc10::
;*sc11::
;*sc12::
;*sc13::
*sc14::Send, ^n                      ; New window (no native tabs yet...)
;*sc15::
;*sc16::
;*sc17::
*sc18::Send, {Enter}                 ; Open file
;*sc19::
;*sc1a::
;*sc1b::
;; a  s  d  f  g  h  j  k  l  ;  '  \
;*sc1e::
;*sc1f::
;*sc20::
;*sc21::
;*sc22::
;*sc23::
;*sc24::
;*sc25::
;*sc26::
;*sc27::
;*sc28::
;*sc2b::
;; `  z  x  c  v  b  n  m  ,  .  /
;*sc56::
;*sc2c::
;*sc2d::
;*sc2e::
;*sc2f::
;*sc30::
;*sc31::
;*sc32::
;*sc33::
;*sc34::
;*sc35::
;; Special
*sc0e::Send, ^d                      ; Delete file

; .........................................................................}}}

#if WinActive("ahk_exe explorer.exe") and modifiers() == mod_cmd | mod_shift
;*f1::MsgBox, Explorer, Modifiers: Cmd+Shift ; ...........................{{{1

;; §  1  2  3  4  5  6  7  8  9  0  -  =
;*sc29::
;*sc02::
;*sc03::
;*sc04::
;*sc05::
;*sc06::
;*sc07::
;*sc08::
;*sc09::
;*sc0a::
;*sc0b::
;*sc0c::
;*sc0d::
;; q  w  e  r  t  y  u  i  o  p  [  ]
;*sc10::
;*sc11::
;*sc12::
;*sc13::
;*sc14::
;*sc15::
;*sc16::
*sc17::ExplorerNavigate("shell:MyComputerFolder")
;*sc18::
*sc19::ExplorerNavigate("shell:Libraries")
;*sc1a::
;*sc1b::
;; a  s  d  f  g  h  j  k  l  ;  '  \
*sc1e::ExplorerNavigate("shell:AppsFolder")
*sc1f::ExplorerNavigate("shell:DocumentsLibrary")
;*sc20::
*sc21::ExplorerNavigate("shell:OneDrive")
*sc22::ExplorerNavigate("shell:Administrative Tools")
*sc23::ExplorerNavigate("shell:Desktop")
*sc24::ExplorerNavigate("shell:Profile")
;*sc25::
;*sc26::
;*sc27::
;*sc28::
;*sc2b::
;; `  z  x  c  v  b  n  m  ,  .  /
;*sc56::
;*sc2c::
;*sc2d::
;*sc2e::
*sc2f::ExplorerNavigate("shell:NetworkPlacesFolder")
;*sc30::
;*sc31::
;*sc32::
;*sc33::
;*sc34::
;*sc35::

; .........................................................................}}}

#if WinActive("ahk_exe explorer.exe") and modifiers() == mod_cmd | mod_opt
;*f1::MsgBox, Explorer, Modifiers: Cmd+Opt ; .............................{{{1

;; §  1  2  3  4  5  6  7  8  9  0  -  =
;*sc29::
;*sc02::
;*sc03::
;*sc04::
;*sc05::
;*sc06::
;*sc07::
;*sc08::
;*sc09::
;*sc0a::
;*sc0b::
;*sc0c::
;*sc0d::
;; q  w  e  r  t  y  u  i  o  p  [  ]
;*sc10::
;*sc11::
;*sc12::
;*sc13::
;*sc14::
;*sc15::
;*sc16::
;*sc17::
;*sc18::
*sc19::ExplorerNavigate("shell:Downloads")
;*sc1a::
;*sc1b::
;; a  s  d  f  g  h  j  k  l  ;  '  \
;*sc1e::
;*sc1f::
;*sc20::
;*sc21::
;*sc22::
;*sc23::
;*sc24::
;*sc25::
;*sc26::
;*sc27::
;*sc28::
;*sc2b::
;; `  z  x  c  v  b  n  m  ,  .  /
;*sc56::
;*sc2c::
;*sc2d::
*sc2e::ExplorerCopyFilepath()
;*sc2f::
;*sc30::
*sc31::ExplorerCreateNewTextfile()
;*sc32::
;*sc33::
;*sc34::
;*sc35::

; .........................................................................}}}

#if WinActive("ahk_group MASK_CMD_LAYER_INCLUDES") and modifiers() == mod_cmd
;*f1::MsgBox, Mask Cmd ; .................................................{{{1

; Don't map {Alt} to {Ctrl}, but to {Ctrl-Shift} so that {Alt} acts as Cmd- and
; Capslock as Ctrl-layer. Shortcuts must be remapped in the particular apps,
; like ctrl-shift-f for find etc.

;; §  1  2  3  4  5  6  7  8  9  0  -  =
;*sc29::
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
;; q  w  e  r  t  y  u  i  o  p  [  ]
;*sc10::Send, +^q                    ; Don't shadow Cmd-q
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
;; a  s  d  f  g  h  j  k  l  ;  '  \
*sc1e::Send, +^a
*sc1f::Send, +^s
*sc20::Send, +^d
*sc21::Send, +^f
*sc22::Send, +^g
;*sc23::Send, +^h                    ; Don't shadow Cmd-h
*sc24::Send, +^j
*sc25::Send, +^k
*sc26::Send, +^l
*sc27::Send, +^;
*sc28::Send, +^'
*sc2b::Send, +^\
;; `  z  x  c  v  b  n  m  ,  .  /
;*sc56::Send, +^{sc56}               ; Don't shadow Cmd-`
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

; .........................................................................}}}

#if WinActive("ahk_group MASK_CMD_LAYER_INCLUDES") and modifiers() == mod_cmd | mod_shift
;*f1::MsgBox, Mask Cmd+Shift ; ...........................................{{{1

; Don't map {Alt-Shift} to {Ctrl-Shift}, but keep it as {Alt-Shift}, because the
; former is already taken due to masking the Cmd-layer above.

;; §  1  2  3  4  5  6  7  8  9  0  -  =
;*sc29::
*sc02::Send, +!1
*sc03::Send, +!2
;*sc04::Send, +!3                    ; Don't shadow Cmd-Shift-3
*sc05::Send, +!4
*sc06::Send, +!5
*sc07::Send, +!6
*sc08::Send, +!7
*sc09::Send, +!8
*sc0a::Send, +!9
*sc0b::Send, +!0
*sc0c::Send, +!-
*sc0d::Send, +!=
;; q  w  e  r  t  y  u  i  o  p  [  ]
*sc10::Send, +!q
*sc11::Send, +!w
*sc12::Send, +!e
*sc13::Send, +!r
*sc14::Send, +!t
*sc15::Send, +!y
*sc16::Send, +!u
*sc17::Send, +!i
*sc18::Send, +!o
*sc19::Send, +!p
*sc1a::Send, +![
*sc1b::Send, +!]
;; a  s  d  f  g  h  j  k  l  ;  '  \
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
;; `  z  x  c  v  b  n  m  ,  .  /
*sc56::Send, +!{sc56}
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
;; Special
*sc14b::Send, +!{Left}
*sc14d::Send, +!{Right}
*sc148::Send, +!{Up}
*sc150::Send, +!{Down}

; WindowsTerminal doesn't seem to recognize +![ and +!], so use alt-p/alt-n
; instead. Map prevTab/nextTab accordingly in settings.json.
#if WinActive("ahk_exe WindowsTerminal") and modifiers() == mod_cmd | mod_shift

*sc1a::Send, !p
*sc1b::Send, !n

; .........................................................................}}}

#if (WinActive("ahk_exe WindowsTerminal.exe") or WinActive("ahk_exe nvim-qt.exe")) and modifiers() == mod_opt
;*f1::MsgBox, Backspace ; ................................................{{{1

; Delete word with Opt-h
*sc24::Send, !{Backspace} ; ^{Backspace} doesn't work neither in WindowsTerminal
                          ; nor in nvim-qt.

; .........................................................................}}}

#if GetKeyState("RAlt", "P") and !GetKeyState("Shift", "P")
;*f1::MsgBox, Quick Launcher ; ...........................................{{{1

;; §  1  2  3  4  5  6  7  8  9  0  -  =
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
;; q  w  e  r  t  y  u  i  o  p  [  ]
*sc10::Return
*sc11::Return
*sc12::Return
*sc13::LaunchExplorer()
*sc14::Return
*sc15::Return
*sc16::Launch(CODE_WIN, CODE_RUN)
*sc17::Send, #{Tab}                  ; Open fugly Task View with RCmd-c
*sc18::Return
*sc19::Return
*sc1a::Return
*sc1b::Return
;; a  s  d  f  g  h  j  k  l  ;  '  \
*sc1e::Return
*sc1f::Launch(WEB_BROWSER_WIN, WEB_BROWSER_RUN)
*sc20::Launch(EDITOR_WIN, EDITOR_RUN)
*sc21::Return
*sc22::Return
*sc23::Launch(DOCSETS_WIN, DOCSETS_RUN)
*sc24::Return
*sc25::Launch(TERMINAL_WIN, TERMINAL_RUN)
*sc26::Return
*sc27::Return
*sc28::Return
*sc2b::Return
;; `  z  x  c  v  b  n  m  ,  .  /
*sc56::Return
*sc2c::Return
*sc2d::Return
*sc2e::CycleVisibleWindows("next")
*sc2f::CycleVisibleWindows("previous")
*sc30::Return
*sc31::Return
*sc32::Launch(MAIL_WIN, MAIL_RUN)
*sc33::Send, ^,                      ; Open app settings
*sc34::Return
*sc35::Return

; .........................................................................}}}

#if GetKeyState("RAlt", "P") and GetKeyState("Shift", "P")
;*f1::MsgBox, Quick Launcher (Shift) ; ...................................{{{1

;; §  1  2  3  4  5  6  7  8  9  0  -  =
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
;; q  w  e  r  t  y  u  i  o  p  [  ]
*sc10::Return
*sc11::Return
*sc12::Return
*sc13::Return
*sc14::Return
*sc15::Return
*sc16::Launch(GIT_GUI_WIN, GIT_GUI_RUN) ; Open git gui
*sc17::Return
*sc18::Return
*sc19::Return
*sc1a::Return
*sc1b::Return
;; a  s  d  f  g  h  j  k  l  ;  '  \
*sc1e::Launch(TASK_MANAGER_WIN, TASK_MANAGER_RUN) ; Open task manager
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
;; `  z  x  c  v  b  n  m  ,  .  /
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

; .........................................................................}}}

#if modifiers() == mod_ctrl | mod_opt
;*f1::MsgBox, Spectacle-like shortcuts (Ctrl+Opt) ; ......................{{{1

;; §  1  2  3  4  5  6  7  8  9  0  -  =
;*sc29::
;*sc02::
;*sc03::
;*sc04::
;*sc05::
;*sc06::
;*sc07::
;*sc08::
;*sc09::
*sc0a::Send, #{Left}                 ; Pin window to the left side
*sc0b::Send, #{Right}                ; Pin window to the right side
*sc0c::ResizeWindow("smaller")       ; Make window smaller
*sc0d::ResizeWindow("larger")        ; Make window bigger
;; q  w  e  r  t  y  u  i  o  p  [  ]
;*sc10::
;*sc11::
;*sc12::
;*sc13::
;*sc14::
;*sc15::
*sc15::WinMaximize A                 ; Maximize window
;*sc16::
*sc17::CenterWindow()                ; Center window
;*sc18::
*sc19::Send, ^#{Right}               ; Switch to next virtual desktop
*sc1a::Send, #+{Left}                ; Move to left monitor
*sc1b::Send, #+{Right}               ; Move to right monitor
;; a  s  d  f  g  h  j  k  l  ;  '  \
;*sc1e::
;*sc1f::
;*sc20::
;*sc21::
;*sc22::
;*sc23::
*sc24::Send, ^#{Left}                ; Switch to previous virtual desktop
;*sc25::
;*sc26::
;*sc27::
;*sc28::
;*sc2b::
;; `  z  x  c  v  b  n  m  ,  .  /
;*sc56::
;*sc2c::
;*sc2d::
*sc2e::Send, #{Up}                   ; Pin window to the top side
*sc2f::Send, #{Down}                 ; Pin window to the bottom side
;*sc30::
;*sc31::
;*sc32::
;*sc33::
;*sc34::
;*sc35::
;; Special
*sc0e::Send, !{Space}W               ; Restore window

; .........................................................................}}}

#if modifiers() == mod_ctrl | mod_cmd
;*f1::msgbox, Numpad (Cmd+Ctrl) ; ........................................{{{1

;; §  1  2  3  4  5  6  7  8  9  0  -  =
;*sc29::
;*sc02::
;*sc03::
;*sc04::
;*sc05::
;*sc06::
;*sc07::
;*sc08::
*sc09::Send, 7
*sc0a::Send, 8
*sc0b::Send, 9
*sc0c::Send, *
;*sc0d::
;; q  w  e  r  t  y  u  i  o  p  [  ]
;*sc10::
;*sc11::
;*sc12::
;*sc13::
;*sc14::
;*sc15::
*sc16::Send, 4
*sc17::Send, 5
*sc18::Send, 6
*sc19::Send, {+}
;*sc1a::
;*sc1b::
;; a  s  d  f  g  h  j  k  l  ;  '  \
;*sc1e::
;*sc1f::
;*sc20::
;*sc21::
;*sc22::
;*sc23::
*sc24::Send, 1
*sc25::Send, 2
*sc26::Send, 3
*sc27::Send, -
;*sc28::
;*sc2b::
;; `  z  x  c  v  b  n  m  ,  .  /
;*sc56::
;*sc2c::
;*sc2d::
;*sc2e::
;*sc2f::
;*sc30::
;*sc31::
*sc32::Send, 0
*sc33::Send, ,
*sc34::Send, .
*sc35::Send, /
;; Special
*sc39::Send, #.                      ; Open emoji list

; .........................................................................}}}

#if modifiers() == mod_cmd
;*f1::MsgBox, Cmd ; ......................................................{{{1

;; §  1  2  3  4  5  6  7  8  9  0  -  =
*sc29::Send, #{sc20}                 ; Show desktop
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
;; q  w  e  r  t  y  u  i  o  p  [  ]
*sc10::Send, !{F4}                   ; Quit active application
                                     ; (^{F4} or !{Space}S work as well, latter one
                                     ; doesn't work for eg Opera, though)
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
;; a  s  d  f  g  h  j  k  l  ;  '  \
*sc1e::Send, ^a
*sc1f::Send, ^s
*sc20::Send, ^d
*sc21::Send, ^f
*sc22::Send, ^g
*sc23::WinMinimize A                 ; Hide active window
*sc24::Send, ^j
*sc25::Send, ^k
*sc26::Send, ^l
*sc27::Send, ^;
*sc28::Send, ^'
*sc2b::Send, ^\
;; `  z  x  c  v  b  n  m  ,  .  /
*sc56::SwitchToNextWindow()
*sc2c::Send, ^z
*sc2d::Send, ^x
*sc2e::Send, ^c
*sc2f::Send, ^v
*sc30::Send, ^b
*sc31::Send, ^n
*sc32::Send, ^m
*sc33::Send, ^,
*sc34::Send, ^.
*sc35::Send, ^/
;; Special
*sc0e::Send, ^{Backspace}
 vk01::Send, ^{LButton}              ; NOTE: using * breaks Cmd-Tab.
*WheelUp::Send, ^{WheelUp}
*WheelDown::Send, ^{WheelDown}

*sc0f::
    lalt_down := true
    Send, {LAlt down}{Tab}
    Return

*sc39::Send, #{sc1f}                 ; Spotlight with {LAlt}
#if GetKeyState("RAlt", "P") and !GetKeyState("Shift", "P")
*sc39::Send, #{sc1f}                 ; Spotlight with {RAlt}

; .........................................................................}}}

#if modifiers() == mod_cmd | mod_shift
;*f1::MsgBox, Modifiers: Cmd+Shift ; .....................................{{{1

;; §  1  2  3  4  5  6  7  8  9  0  -  =
*sc29::Return
*sc02::Send, +^1
*sc03::Send, +^2
*sc04::Send, {PrintScreen}           ; Take a screenshot
*sc05::Send, +^4
*sc06::Send, +^5
*sc07::Send, +^6
*sc08::Send, +^7
*sc09::Send, +^8
*sc0a::Send, +^9
*sc0b::Send, +^0
*sc0c::Send, +^-
*sc0d::Send, +^=
;; q  w  e  r  t  y  u  i  o  p  [  ]
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
;; a  s  d  f  g  h  j  k  l  ;  '  \
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
;; `  z  x  c  v  b  n  m  ,  .  /
;*sc56::
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
;; Special
*vk01::Send, ^{LButton}
*F12::LockWorkStation()

; .........................................................................}}}

#if !WinActive("ahk_group CONTROL_CHARS_EXCLUDES") and modifiers() == mod_ctrl
;*f1::MsgBox, terminal-like control characters, Modifiers: Ctrl  ; .......{{{1

;; §  1  2  3  4  5  6  7  8  9  0  -  =
;*sc29::
;*sc02::
;*sc03::
;*sc04::
;*sc05::
;*sc06::
;*sc07::
;*sc08::
;*sc09::
;*sc0a::
;*sc0b::
;*sc0c::
;*sc0d::
;; q  w  e  r  t  y  u  i  o  p  [  ]
;*sc10::
;*sc11::
;*sc12::
*sc13::Send, {Up}
;*sc14::
*sc15::Send, {Right}
;*sc16::
;*sc17::
;*sc18::
;*sc19::
;*sc1a::
;*sc1b::
;; a  s  d  f  g  h  j  k  l  ;  '  \
*sc1e::Send, {Home}
;*sc1f::
*sc20::Send, {End}
;*sc21::
;*sc22::
*sc23::Send, {Delete}
*sc24::Send, {Backspace}
;*sc25::
*sc26::Send, {Down}
;*sc27::
;*sc28::
;*sc2b::
;; `  z  x  c  v  b  n  m  ,  .  /
;*sc56::
;*sc2c::
;*sc2d::
;*sc2e::
;*sc2f::
;*sc30::
*sc31::Send, {Left}
;*sc32::
;*sc33::
;*sc34::
;*sc35::

; .........................................................................}}}

#if !WinActive("ahk_group CONTROL_CHARS_EXCLUDES") and modifiers() == mod_ctrl | mod_shift
;*f1::MsgBox, terminal-like control characters, Modifiers: Ctrl+Shift ; ..{{{1

;; §  1  2  3  4  5  6  7  8  9  0  -  =
;*sc29::
;*sc02::
;*sc03::
;*sc04::
;*sc05::
;*sc06::
;*sc07::
;*sc08::
;*sc09::
;*sc0a::
;*sc0b::
;*sc0c::
;*sc0d::
;; q  w  e  r  t  y  u  i  o  p  [  ]
;*sc10::
;*sc11::
;*sc12::
*sc13::Send, +{Up}
;*sc14::
*sc15::Send, +{Right}
;*sc16::
;*sc17::
;*sc18::
;*sc19::
;*sc1a::
;*sc1b::
;; a  s  d  f  g  h  j  k  l  ;  '  \
*sc1e::Send, +{Home}
;*sc1f::
*sc20::Send, +{End}
;*sc21::
;*sc22::
;*sc23::
;*sc24::
;*sc25::
*sc26::Send, +{Down}
;*sc27::
;*sc28::
;*sc2b::
;; `  z  x  c  v  b  n  m  ,  .  /
;*sc56::
;*sc2c::
;*sc2d::
;*sc2e::
;*sc2f::
;*sc30::
*sc31::Send, +{Left}
;*sc32::
;*sc33::
;*sc34::
;*sc35::

; .........................................................................}}}

#if modifiers() == mod_opt
;*f1::MsgBox, Modifiers: Opt ; ...........................................{{{1

;; §  1  2  3  4  5  6  7  8  9  0  -  =
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
;; q  w  e  r  t  y  u  i  o  p  [  ]
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
;; a  s  d  f  g  h  j  k  l  ;  '  \
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
;; `  z  x  c  v  b  n  m  ,  .  /
*sc56::Send, !{sc56}
*sc2c::Send, !{sc2c}
*sc2d::Send, !{sc2d}
*sc2e::Send, !{sc2e}
*sc2f::Send, #{sc2f}                 ; Open clipboard with {Win-v}
*sc30::Send, ✗
*sc31::Send, ^{Left}
*sc32::Send, !{sc32}
*sc33::Send, ₩
*sc34::Send, ✔
*sc35::Send, !{sc35}
;; Special
*sc1c::Send, !{Enter}
*vk01::Send, !{LButton}

; .........................................................................}}}

#if modifiers() == mod_shift | mod_opt
;*f1::MsgBox, Modifiers: Shift+Opt ; .....................................{{{1

;; §  1  2  3  4  5  6  7  8  9  0  -  =
*sc29::Send, +!{sc29}
*sc02::Send, +!1
*sc03::Send, +!2
*sc04::Send, +!3
*sc05::Send, +!4
*sc06::Send, +!5
*sc07::Send, +!6
*sc08::Send, +!7
*sc09::Send, +!8
*sc0a::Send, +!9
*sc0b::Send, +!0
*sc0c::Send, +!{sc0c}
*sc0d::Send, +!{sc0d}
;; q  w  e  r  t  y  u  i  o  p  [  ]
*sc10::Send, +!;
*sc11::Send, +!,
*sc12::Send, +!.
*sc13::Send, +!p
*sc14::Send, +!y
*sc15::Send, +^{Right}
*sc16::Send, +!g
*sc17::Send, +!c
*sc18::Send, +!r
*sc19::Send, +!l
*sc1a::Send, +![
*sc1b::Send, +!]
;; a  s  d  f  g  h  j  k  l  ;  '  \
*sc1e::Send, Ä
*sc1f::Send, Ö
*sc20::Send, +!e
*sc21::Send, +!i
*sc22::Send, Ü
*sc23::Send, +!d
*sc24::Send, +!h
*sc25::Send, +!t
*sc26::Send, +!n
*sc27::Send, +!s
*sc28::Send, +!'
*sc2b::Send, +!\
;; `  z  x  c  v  b  n  m  ,  .  /
*sc56::Send, +!{sc56}
*sc2c::Send, +!{sc2c}
*sc2d::Send, +!q
*sc2e::Send, +!j
*sc2f::Send, +!k
*sc30::Send, +!x
*sc31::Send, +^{Left}
*sc32::Send, +!m
*sc33::Send, +!w
*sc34::Send, +!v
*sc35::Send, +!z
;; Special
*sc1c::Send, +!{Enter}
*vk01::Send, +!{LButton}

; .........................................................................}}}

#if modifiers() == mod_cmd | mod_opt
;*f1::MsgBox, Modifiers: Cmd+Opt ; .......................................{{{1

;; §  1  2  3  4  5  6  7  8  9  0  -  =
*sc29::Send, ^!{sc29}
*sc02::Send, ^!1
*sc03::Send, ^!2
*sc04::Send, ^!3
*sc05::Send, ^!4
*sc06::Send, ^!5
*sc07::Send, ^!6
*sc08::Send, ^!7
*sc09::Send, ^!8
*sc0a::Send, ^!9
*sc0b::Send, ^!0
*sc0c::Send, ^!{sc0c}
*sc0d::Send, ^!{sc0d}
;; q  w  e  r  t  y  u  i  o  p  [  ]
*sc10::Send, ^!q
*sc11::Send, ^!w
*sc12::Send, ^!e
*sc13::Send, ^!r
*sc14::Send, ^!t
*sc15::Send, ^!y
*sc16::Send, ^!u
*sc17::Send, ^!i
*sc18::Send, ^!o
*sc19::Send, ^!p
*sc1a::Send, ^![
*sc1b::Send, ^!]
;; a  s  d  f  g  h  j  k  l  ;  '  \
*sc1e::Send, ^!a
*sc1f::Send, ^!s
*sc20::Send, ^!d
*sc21::Send, ^!f
*sc22::Send, ^!g
*sc23::Send, ^!h
*sc24::Send, ^!j
*sc25::Send, ^!k
*sc26::Send, ^!l
*sc27::Send, ^!;
*sc28::Send, ^!'
*sc2b::Send, ^!\
;; `  z  x  c  v  b  n  m  ,  .  /
*sc56::Send, !{sc56}
*sc2c::Send, ^!z
*sc2d::Send, ^!x
*sc2e::Send, ^!c
*sc2f::Send, ^!v
*sc30::Send, ^!b
*sc31::Send, ^!n
*sc32::Send, ^!m
*sc33::Send, ^!,
*sc34::Send, ^!.
*sc35::Send, ^!/
; .........................................................................}}}

#if modifiers() == mod_ctrl
;*f1::MsgBox, Modifiers: Ctrl ; ..........................................{{{1

;; §  1  2  3  4  5  6  7  8  9  0  -  =
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
;; q  w  e  r  t  y  u  i  o  p  [  ]
*sc10::Send, ^q                      ; Map to C-@ (instead of C-;)
*sc11::Send, ^{vkdc}                 ; Map to C-^
*sc12::Return
*sc13::Send, ^p
*sc14::Send, ^y
*sc15::Send, ^f
*sc16::Send, ^g
*sc17::Send, {Escape}                ; Map to ⎋ (instead of C-c)
*sc18::Send, ^r
*sc19::Send, ^l
*sc1a::Send, ^c                      ; Map to C-c (instead of C-[)
*sc1b::Send, ^{vkdd}
;; a  s  d  f  g  h  j  k  l  ;  '  \
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
*sc28::Send, ^{vkbc}                 ; Map to C-_
*sc2b::Send, ^{vkbf}                 ; Map to C-\
;; `  z  x  c  v  b  n  m  ,  .  /
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
;; Special
;*sc39::Send, ^{Space}               ; Remap {Ctrl-Space} to {Alt-;} instead
*sc39::Send, !{vk00ba}               ; because Hunt-and-Peck's hotkey is hardcoded.

; .........................................................................}}}

#if modifiers() == mod_shift
;*f1::MsgBox, Modifiers: Shift ; .........................................{{{1

;; §  1  2  3  4  5  6  7  8  9  0  -  =
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
*sc0b::Send, &
*sc0c::Send, {Text}``
*sc0d::Return
;; q  w  e  r  t  y  u  i  o  p  [  ]
*sc10::Send, ?
*sc11::Send, =
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
;; a  s  d  f  g  h  j  k  l  ;  '  \
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
*sc28::Send, _
*sc2b::Send, |
;; `  z  x  c  v  b  n  m  ,  .  /
*sc56::Return
*sc2c::Send, `%
*sc2d::Send, Q
*sc2e::Send, J
*sc2f::Send, K
*sc30::Send, X
*sc31::Send, B
*sc32::Send, M
*sc33::Send, W
*sc34::Send, V
*sc35::Send, Z
;; Special
*sc1c::Send, +{Enter}
*WheelUp::Send, +{WheelUp}
*WheelDown::Send, +{WheelDown}

; .........................................................................}}}

#if
;*f1::MsgBox, No modifiers ; .............................................{{{1

;; §  1  2  3  4  5  6  7  8  9  0  -  =
*sc29::Return
*sc02::Send, {Text}^
*sc03::Send, <
*sc04::Send, >
*sc05::Send, "
*sc06::Return
*sc07::Return
*sc08::Return
*sc09::Send, {+}
*sc0a::Send, (
*sc0b::Send, )
*sc0c::Send, '
*sc0d::Return
;; q  w  e  r  t  y  u  i  o  p  [  ]
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
;; a  s  d  f  g  h  j  k  l  ;  '  \
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
*sc28::Send, -
*sc2b::Send, \
;; `  z  x  c  v  b  n  m  ,  .  /
*sc56::Return
*sc2c::Send, {!}
*sc2d::Send, q
*sc2e::Send, j
*sc2f::Send, k
*sc30::Send, x
*sc31::Send, b
*sc32::Send, m
*sc33::Send, w
*sc34::Send, v
*sc35::Send, z
;; Special
*sc1c::Send, {Enter}
*sc39::Send, {Space}
*F12::Send, #a

; .........................................................................}}}

; Functions ..............................................................{{{1

Launch(win, cmd, forceSingleInstance := true, runAsAdmin := false, minimizeIfActive := false) {
    if forceSingleInstance {
        if WinActive(win) {
            if minimizeIfActive {
                WinMinimize
            }
            Return
        } else if WinExist(win) {
            WinActivate
            ControlFocus, , win
            Return
        }
    }
    ShellRun(cmd, , , runAsAdmin ? "runas" : "")
}

; Taken from https://autohotkey.com/boards/viewtopic.php?f=76&t=84266&sid=eff012cadb7a851b2c18f5f03b68408f
CmdRet(cmd, stdin := "", callback := "", encoding := "CP0") {
    Static HANDLE_FLAG_INHERIT  := 0x00000001
    Static STARTF_USESTDHANDLES := 0x100
    Static CREATE_NO_WINDOW     := 0x08000000

    inPipeRead := 0
    inPipeWrite := 0
    DllCall("CreatePipe"
        , "PtrP", inPipeRead
        , "PtrP", inPipeWrite
        , "Ptr", 0
        , "UInt", 0
        , "Int")
    DllCall("SetHandleInformation"
        , "Ptr", inPipeRead
        , "UInt", HANDLE_FLAG_INHERIT
        , "UInt", HANDLE_FLAG_INHERIT
        , "Int")

    outPipeRead  := 0
    outPipeWrite := 0
    DllCall("CreatePipe"
        , "PtrP", outPipeRead
        , "PtrP", outPipeWrite
        , "Ptr", 0
        , "UInt", 0
        , "Int")
    DllCall("SetHandleInformation"
        , "Ptr", outPipeWrite
        , "UInt", HANDLE_FLAG_INHERIT
        , "UInt", HANDLE_FLAG_INHERIT
        , "Int")

    siSize := A_PtrSize*4 + 4*8 + A_PtrSize*5
    VarSetCapacity(STARTUPINFO, siSize, 0)
    NumPut(siSize,               STARTUPINFO, 0)
    NumPut(STARTF_USESTDHANDLES, STARTUPINFO, A_PtrSize*4 + 4*7)
    NumPut(inPipeRead,           STARTUPINFO, A_PtrSize*4 + 4*8 + A_PtrSize*2)
    NumPut(outPipeWrite,         STARTUPINFO, A_PtrSize*4 + 4*8 + A_PtrSize*3)
    NumPut(outPipeWrite,         STARTUPINFO, A_PtrSize*4 + 4*8 + A_PtrSize*4)

    VarSetCapacity(PROCESS_INFORMATION, A_PtrSize*2 + 4*2, 0)
    ret := DllCall("CreateProcess"
        , "Ptr", 0
        , "Str", cmd
        , "Ptr", 0
        , "Ptr", 0
        , "UInt", true
        , "UInt", CREATE_NO_WINDOW
        , "Ptr", 0
        , "Ptr", 0
        , "Ptr", &STARTUPINFO
        , "Ptr", &PROCESS_INFORMATION
        , "Int")

    DllCall("CloseHandle"
        , "Ptr", outPipeWrite
        , "Int")
    DllCall("CloseHandle"
        , "Ptr", inPipeRead
        , "Int")

    if !ret {
        DllCall("CloseHandle"
            , "Ptr", outPipeRead
            , "Int")
        DllCall("CloseHandle"
            , "Ptr", inPipeWrite
            , "Int")

        throw Exception("CreateProcess is failed")
    }

    if stdin {
        w := FileOpen(inPipeWrite, "h")
        w.Write(stdin)
        w.Close()
    }
    DllCall("CloseHandle"
        , "Ptr", inPipeWrite
        , "Int")

    output  := ""
    bufsize := 4096
    VarSetCapacity(buf, bufsize)
    read := 0
    while DllCall("ReadFile"
        , "Ptr", outPipeRead
        , "Ptr", &buf
        , "UInt", bufsize
        , "UIntP", read
        , "UInt", 0
        , "Int") {
        text := StrGet(&buf, read, encoding)
        (callback && callback.Call(text))
        output .= text
    }
    DllCall("CloseHandle"
        , "Ptr", outPipeRead
        , "Int")

    hProcess := NumGet(PROCESS_INFORMATION, 0)
    hThread := NumGet(PROCESS_INFORMATION, A_PtrSize)
    DllCall("CloseHandle"
        , "Ptr", hProcess
        , "Int")
    DllCall("CloseHandle"
        , "Ptr", hThread
        , "Int")

    Return output
}

Global SW_HIDE            := 0
Global SW_SHOWNORMAL      := 1
Global SW_SHOWMINIMIZED   := 2
Global SW_SHOWMAXIMIZED   := 3
Global SW_SHOWNOACTIVATE  := 4
Global SW_SHOW            := 5
Global SW_MINIMIZE        := 6
Global SW_SHOWMINNOACTIVE := 7
Global SW_SHOWNA          := 8
Global SW_RESTORE         := 9
Global SW_SHOWDEFAULT     := 10
Global SW_FORCEMINIMIZE   := 11

; Taken from https://github.com/Lexikos/AutoHotkey-Release/blob/master/installer/source/Lib/ShellRun.ahk
; Also see https://devblogs.microsoft.com/oldnewthing/20131118-00/?p=2643
; and https://devblogs.microsoft.com/oldnewthing/20130318-00/?p=4933
; Operation can be one of {explorer find open print runas}
ShellRun(cmd, params := "", dir := "", operation := "open", show := 1) {
    SWFO_NEEDDISPATCH   := 0x1
    SWFO_INCLUDEPENDING := 0x2
    SWFO_COOKIEPASSED   := 0x4

    SWC_EXPLORER := 0,
    SWC_BROWSER  := 0x1
    SWC_3RDPARTY := 0x2
    SWC_CALLBACK := 0x4
    SWC_DESKTOP  := 0x8

    VT_NULL    := 0x0001
    VT_I2      := 0x0002
    VT_I4      := 0x0003
    VT_INT     := 0x0016
    VT_BYREF   := 0x4000
    VT_INT_PTR := 0x0025

    SID_STopLevelBrowser := "{4C96BE40-915C-11CF-99D3-00AA004AE837}"
    IID_IShellBrowser    := "{000214E2-0000-0000-C000-000000000046}"

    windows := ComObjCreate("Shell.Application").Windows
    VarSetCapacity(hwnd, A_PtrSize, 0)
    hwndRef := ComObj(VT_BYREF | VT_I4, &hwnd)
    desktop := windows.FindWindowSW(0, "", SWC_DESKTOP, hwndRef, SWFO_NEEDDISPATCH)

    ; Retrieve top-level browser object.
    if ptlb := ComObjQuery(desktop
        , SID_STopLevelBrowser
        , IID_IShellBrowser) {
        ; IShellBrowser.QueryActiveShellView -> IShellView
        psv := 0
        res := DllCall(NumGet(NumGet(ptlb + 0) + 15 * A_PtrSize)
            , "Ptr", ptlb
            , "PtrP", psv
            , "Int")
        if (res == 0) {
            ; Define IID_IDispatch.
            VarSetCapacity(IID_IDispatch, 16)
            NumPut(0x46000000000000C0, NumPut(0x20400, IID_IDispatch, "Int64"), "Int64")

            ; IShellView.GetItemObject -> IDispatch (object which implements IShellFolderViewDual)
            pdisp := 0
            DllCall(NumGet(NumGet(psv+0)+15*A_PtrSize)
                , "Ptr", psv
                , "UInt", 0
                , "Ptr", &IID_IDispatch
                , "PtrP", pdisp
                , "Int")

            ; Get Shell object.
            shell := ComObj(9, pdisp, 1).Application

            ; IShellDispatch2.ShellExecute
            shell.ShellExecute(cmd, params, dir, operation, show)

            ObjRelease(psv)
        }
        ObjRelease(ptlb)
    }
}

; Get explorer's current folder
; See https://docs.microsoft.com/en-us/windows/win32/shell/shellfolderview
; also, explore COM objects in PowerShell with:
;   $w = (New-Object -ComObject Shell.Application).Windows(0)
GetSHAppFolderPath(hwnd := 0) {
    if (!hwnd) {
        hwnd := WinExist("A")
    }
    res := ""
    com := ComObjCreate("Shell.Application")
    for window in com.Windows {
        if (window && window.hwnd == hwnd) {
            res := window.Document.Folder.Self.Path
            Break
        }
    }
    ObjRelease(com)
    Return res
}

; Get an explorer-window's selected filenames
; See https://docs.microsoft.com/en-us/windows/win32/shell/shellfolderview
; and https://docs.microsoft.com/en-us/windows/win32/shell/shellfolderview-selecteditems
GetSHAppSelectionPaths(hwnd := 0) {
    if (!hwnd) {
        hwnd := WinExist("A")
    }
    res := ""
    com := ComObjCreate("Shell.Application")
    for window in com.Windows {
        if (window && window.hwnd == hwnd) {
            for item in window.Document.SelectedItems {
                res := res . ";" . item.Path
            }
            res := Substr(res, 2)
            Break
        }
    }
    ObjRelease(com)
    Return res
}

; Get the desktop's selection.
GetDesktopSelectionPaths(ctrlClass) {
    ControlGet, hwnd, Hwnd, , % ctrlClass
    ControlGet, selected, List, Selected Col1,, % "ahk_id" hwnd
    Loop, Parse, selected, `n, `r
    {
        filepath := filepath . ";" . A_Desktop . "\" . A_LoopField
    }
    if filepath {
        filepath := Substr(filepath, 2)
    } else {
        filepath := A_Desktop
    }
}

; Select a file within an explorer-window
; See https://docs.microsoft.com/en-us/windows/win32/shell/shellfolderview-selectitem
; and https://docs.microsoft.com/en-us/windows/win32/shell/folderitems
FocusSHAppItem(filename, flags := 0, hwnd := 0) {
    if (!flags) {
        flags := 1 + 2 + 4 + 8 + 16
    }
    if (!hwnd) {
        hwnd := WinExist("A")
    }
    res := false
    com := ComObjCreate("Shell.Application")
    for window in com.Windows {
        if (window && window.hwnd == hwnd) {
            item := window.Document.Folder.ParseName(filename)
            window.Document.SelectItem(item, flags)
            res := true
            Break
        }
    }
    ObjRelease(com)
    Return res
}

; Navigate within an explorer-window
; Use file:/// or shell: with a folder name. For possible folder names, see
; HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions
NavigateSHApp(path, hwnd := 0) {
    if (!hwnd) {
        hwnd := WinExist("A")
    }
    res := false
    com := ComObjCreate("Shell.Application")
    for window in com.Windows {
        if (window && window.hwnd == hwnd) {
            window.Navigate(path)
            res := true
            Break
        }
    }
    ObjRelease(com)
    Return res
}

; Switch between an app's windows
SwitchToNextWindow(hwnd := 0) {
    if !hwnd {
        hwnd := WinExist("A")
    }
    WinGetClass, winclass, % "ahk_id" hwnd
    WinGet, procname, ProcessName, % "ahk_id" hwnd
    WinGet, windows, List, % "ahk_class" winclass
    i := windows + 1
    Loop {
        if (--i == 0) {
            Break
        }
        window := windows%i%
        WinGet, tmp, ProcessName, % "ahk_id" window
        if (tmp == procname) {
            WinActivate, % "ahk_id" window
            Break
        }
    }
}

; Taken from https://autohotkey.com/boards/viewtopic.php?t=28760#p326541
AltTabWindows() {
    Static WS_EX_APPWINDOW  := 0x40000
    Static WS_EX_TOOLWINDOW := 0x80
    Static GW_OWNER         := 4

    old := A_DetectHiddenWindows
    DetectHiddenWindows, Off
    WinGet, windows, List
    DetectHiddenWindows, % old

    res := []
    Loop % windows {
        hwnd := windows%A_Index%
        owner := hwnd
        Loop {
            tmp := DllCall("GetWindow"
                , "UInt", owner
                , "UInt", GW_OWNER
                , "Int")
            if !tmp {
                Break
            }
            owner := tmp
        }

        popup := DllCall("GetLastActivePopup"
            , "UInt", owner
            , "Int")
        if (popup == hwnd) {
            WinGet, style, ExStyle, % "ahk_id" hwnd
            if ((style & WS_EX_APPWINDOW || !(style & WS_EX_TOOLWINDOW))
                && !IsInvisibleWin10BackgroundAppWindow(hwnd)) {
                res.Push(Format("0x{:x}", hwnd))
            }
        }
    }
    Return res
}

IsInvisibleWin10BackgroundAppWindow(hwnd) {
    DWMWA_CLOAKED          := 14
    ;DWM_CLOAKED_APP       := 1
    ;DWM_CLOAKED_SHELL     := 2
    ;DWM_CLOAKED_INHERITED := 4

    VarSetCapacity(value, A_PtrSize)
    if DllCall("DwmApi\DwmGetWindowAttribute"
        , "Ptr", hwnd
        , "UInt", DWMWA_CLOAKED
        , "Ptr", &value
        , "UInt", A_PtrSize
        , "Int") != 0 {
        Return false
    }
    Return NumGet(value) != 0
}

; Predictable version of Send !{Escape}
CycleVisibleWindows(dir := "next") {
    windows := AltTabWindows()
    visible := FilterForegroundWindows(windows)
    if (visible.Length() == 1) {
        visible := windows
    }
    sorted := SortWindowsByAngle(visible, dir != "next")

    Loop % sorted.Length()
        next := A_Index+1
    Until (WinActive("A") == sorted[A_Index])

    if (next > sorted.Length()) {
        next := 1
    }

    WinActivate, % "ahk_id" sorted[next]
}

FilterForegroundWindows(windows) {
    RGN_AND       := 1
    RGN_COPY      := 5
    RGN_DIFF      := 4
    RGN_OR        := 2
    RGN_XOR       := 3
    NULLREGION    := 1
    SIMPLEREGION  := 2
    COMPLEXREGION := 3

    SysGet, workArea, MonitorWorkArea
    combined := DllCall("CreateRectRgn"
        , "Int", 0
        , "Int", 0
        , "Int", 0
        , "Int", 0
        , "UInt")

    res := []
    for i, hwnd in windows {
        if DllCall("IsIconic"
            , "UInt", hwnd
            , "Int") {
            Continue
        }

        WinGetPos, x, y, width, height, % "ahk_id" hwnd

        rgn := DllCall("CreateRectRgn"
            , "Int", Max(x, workAreaLeft)
            , "Int", Max(y, workAreaTop)
            , "Int", Min(x + width, workAreaRight)
            , "Int", Min(y + height, workAreaBottom)
            , "UInt")

        tmp := DllCall("CreateRectRgn"
            , "Int", 0
            , "Int", 0
            , "Int", 0
            , "Int", 0
            , "UInt")

        type := DllCall("CombineRgn"
            , "UInt", tmp
            , "UInt", rgn
            , "UInt", combined
            , "Int", RGN_DIFF
            , "Int")

        DllCall("DeleteObject"
            , "UInt", tmp
            , "Int")

        if (type != NULLREGION) {
            DllCall("CombineRgn"
                , "UInt", combined
                , "UInt", combined
                , "UInt", rgn
                , "Int", RGN_OR
                , "Int")

            res.Push(hwnd)
        }

        DllCall("DeleteObject"
            , "UInt", rgn
            , "Int")
    }

    DllCall("DeleteObject"
        , "UInt", combined
        , "Int")
    Return res
}

SortWindowsByAngle(windows, reverse := false) {
    list := ""
    for i, hwnd in windows {
        list .= "`n" . hwnd
    }
    list := Substr(list, 2)
    Sort, list, F SortWindowsByAngleCallback

    res := []
    Loop, Parse, list, `n
    {
        if !reverse {
            res.Push(A_LoopField)
        } else {
            res.InsertAt(1, A_LoopField)
        }
    }
    Return res
}

SortWindowsByAngleCallback(a, b) {
    av := GetTopLeftAsAngle(a)
    bv := GetTopLeftAsAngle(b)

    if (av > bv) {
        Return 1
    } else if (av < bv) {
        Return -1
    } else {
        Return a - b
    }
}

GetTopLeftAsAngle(hwnd) {
    Static xo := A_ScreenWidth / 2
    Static yo := A_ScreenHeight / 2
    Static PI := 4 * ATan(1)

    WinGetPos, x, y, , , % "ahk_id" hwnd
    x := x - xo
    y := y - yo

    Return DllCall("msvcrt\atan2"
        , "Double", y
        , "Double", x
        , "cdecl Double") * 180 / PI + 180
}

; Resize the active window
ResizeWindow(sizing) {
    delta := 0
    if (sizing == "larger") {
        delta := 20
    } else if (sizing == "smaller") {
        delta := -20
    }
    WinGetPos, x, y, width, height, A
    WinMove, A, , x - delta, y - delta, width + delta * 2, height + delta * 2
}

CenterWindow(hwnd := 0) {
    if (!hwnd) {
        hwnd := WinExist("A")
    }
    WinGetPos, , , width, height
    VarSetCapacity(info, 10 * 4)
    NumPut(10 * 4, info) ; cbSize, rcMonitor, rcWork, dwFlags
    monitor := DllCall("MonitorFromWindow"
        , "UInt", hwnd
        , "UInt", 0x2
        , "Int")
    DllCall("GetMonitorInfo"
        , "UInt", monitor
        , "UInt", &info
        , "Int")
    rcWorkLeft   := NumGet(info, 5 * 4, "Int")
    rcWorkTop    := NumGet(info, 6 * 4, "Int")
    rcWorkRight  := NumGet(info, 7 * 4, "Int")
    rcWorkBottom := NumGet(info, 8 * 4, "Int")
    x := (rcWorkRight - width) / 2
    y := (rcWorkBottom - height) / 2
    WinMove, A, , x, y
}

LockWorkStation() {
    RegRead, disabled, HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System, DisableLockWorkstation
    if !disabled {
        DllCall("LockWorkStation")
        Return
    }

    WTS_CURRENT_SERVER_HANDLE := 0
    WTS_CURRENT_SESSION       := -1

    DllCall("wtsapi32.dll\WTSDisconnectSession"
        , "Ptr", WTS_CURRENT_SERVER_HANDLE
        , "UInt", WTS_CURRENT_SESSION
        , "Int", 1
        , "Int")
}

PowerOffMonitor() {
    WM_SYSCOMMAND   := 0x0112
    SC_MONITORPOWER := 0xf170
    SHUT_OFF        := 2
    SendMessage, %WM_SYSCOMMAND%, %SC_MONITORPOWER%, %SHUT_OFF%, , Program Manager
}

; Go one level up if the active window is an explorer
ExplorerOneLevelUp() {
    ControlGetFocus, c
    if (c == EXPLORER_SIDEBAR) {
        Send, {Left}{Enter}
    } else if (c == EXPLORER_CONTENT) {
        Send, !{Up}
    } else {
        Send, {Left}
    }
}

; Go one level down if the active window is an explorer
ExplorerOneLevelDown() {
    ControlGetFocus, c
    if (c == EXPLORER_SIDEBAR) {
        Send, {Right}{Enter}
    } else if (c == EXPLORER_CONTENT) {
        Send, {Enter}
    } else {
        Send, {Right}
    }
}

; Select the previous item if the active window is an explorer
ExplorerPreviousItem() {
    ControlGetFocus, c
    if (c == EXPLORER_SIDEBAR) {
        Send, {Up}{Enter}
    } else if (c == EXPLORER_CONTENT) {
        Send, {Up}
    } else {
        Send, {Up}
    }
}

; Select the next item if the active window is an explorer
ExplorerNextItem() {
    ControlGetFocus, c
    if (c == EXPLORER_SIDEBAR) {
        Send, {Down}{Enter}
    } else if (c == EXPLORER_CONTENT) {
        Send, {Down}
    } else {
        Send, {Down}
    }
}

; Open the selected files in the editor if the active window is an explorer
ExplorerOpenInEditor() {
    filepath := ""
    ControlGetFocus, c
    if (c == EXPLORER_DESKTOP) {
        filepath := GetDesktopSelectionPaths(c)
    } else if (c == EXPLORER_CONTENT) {
        filepath := GetSHAppSelectionPaths()
    } else if (c == EXPLORER_SIDEBAR) {
        filepath := GetSHAppFolderPath()
    }
    if filepath {
        Loop, Parse, filepath, `;
        {
            SplitPath, % A_LoopField, , dirname
            ShellRun(EDITOR_RUN, """" . A_LoopField . """", dirname)
        }
    }
}

; Open the selected folder in the terminal if the active window is an explorer
ExplorerOpenInTerminal() {
    filepath := ""
    ControlGetFocus, c
    if (c == EXPLORER_DESKTOP) {
        filepath := GetDesktopSelectionPaths(c)
    } else {
        filepath := GetSHAppSelectionPaths()
        if !filepath {
            filepath := GetSHAppFolderPath()
        }
    }
    if filepath {
        Loop, Parse, filepath, `;
        {
            if InStr(FileExist(A_LoopField), "D") {
                ShellRun(TERMINAL_RUN, "-d """ . A_LoopField . """")
            } else if InStr(FileExist(A_LoopField), "A") {
                SplitPath, % A_LoopField, , dirname
                ShellRun(TERMINAL_RUN, "-d """ . dirname . """")
            }
        }
    }
}

; Open the selected folder in the git gui if the active window is an explorer
ExplorerOpenInGitGui() {
    filepath := ""
    ControlGetFocus, c
    if (c == EXPLORER_DESKTOP) {
        filepath := GetDesktopSelectionPaths(c)
    } else {
        filepath := GetSHAppSelectionPaths()
        if !filepath {
            filepath := GetSHAppFolderPath()
        }
    }
    if filepath {
        Loop, Parse, filepath, `;
        {
            if InStr(FileExist(A_LoopField), "D") {
                ShellRun(GIT_GUI_RUN, "browse """ . A_LoopField . """")
            } else if InStr(FileExist(A_LoopField), "A") {
                SplitPath, % A_LoopField, , dirname
                ShellRun(GIT_GUI_RUN, "browse """ . dirname . """")
            }
        }
    }
}

; Rename the selected item if the active window is an explorer
ExplorerRename() {
    ControlGetFocus, c
    if (c == EXPLORER_CONTENT
     || c == EXPLORER_DESKTOP
     || c == EXPLORER_SIDEBAR) {
        Send, {F2}
    } else {
        Send, {Enter}
    }
}

; Copy the selected items' paths if the active window is an explorer
ExplorerCopyFilepath() {
    filepath := ""
    ControlGetFocus, c
    if (c == EXPLORER_CONTENT) {
        filepath := GetSHAppSelectionPaths()
    } else if (c == EXPLORER_SIDEBAR) {
        filepath := GetSHAppFolderPath()
    }
    if filepath {
        Clipboard := filepath
    }
}

; Create new text file if the active window is an explorer
ExplorerCreateNewTextfile() {
    ControlGetFocus, c
    if (c == EXPLORER_DESKTOP) {
        cwd := A_Desktop
    } else {
        cwd := GetSHAppFolderPath()
    }
    if (!cwd || Substr(cwd, 1, 2) == "::") {
        Return
    }

    dest := cwd . "\Untitled"
    ext := ".txt"
    n := 1
    Loop {
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
}

LaunchExplorer() {
    Launch(EXPLORER_WIN, EXPLORER_RUN)
    ControlFocus, %EXPLORER_CONTENT%, %EXPLORER_WIN%
}

ExplorerNavigate(path) {
    NavigateSHApp(path)
    Send, {Tab}{Up}{Home}
}
