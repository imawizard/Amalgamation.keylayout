#Requires AutoHotkey v2
#SingleInstance force
#WinActivateForce
A_MaxHotkeysPerInterval := 1000
KeyHistory(0), ListLines(false), ProcessSetPriority("H")
A_IconTip := "Amalgamation.keylayout"

#include funcs.ahk

SetStoreCapsLockMode(false)
SetCapsLockState("AlwaysOff")
SetWorkingDir(EnvGet("USERPROFILE"))

scrollInverted := MonitorGetCount() > 1
toggleScroll(*) {
    global scrollInverted := !scrollInverted
    tray.ToggleCheck("Invert Scrolling")
}
tray := A_TrayMenu
tray.Delete()
tray.Add("- Toggle layout with Pause-key -", (*) =>)
tray.Disable("1&")
tray.Add("Invert Scrolling", toggleScroll)
tray.Add()
tray.AddStandard()
TrayTip("Layout turned ON", A_IconTip)

#SuspendExempt true
Pause::{
    Suspend()
    if A_IsSuspended {
        TrayTip("Layout turned OFF", A_IconTip)
    } else {
        Reload()
    }
}
#SuspendExempt false

#HotIf scrollInverted
WheelDown::WheelUp
WheelUp::WheelDown

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
;  Ctrl Win  Alt       Space      AltGr  Win  Ctrl      <-  v  ->   0  .
;    1d 15b  38          39        138   15c   11d    14b 150 14d  52 53
;
; ThinkPad E14:
;  - instead of RWin there's PrintScreen (sc137)
; Dell Precision 5560:
;  - there's no RWin, to the right of AltGr is RCtrl
; Filco Majestouch 2:
;  - to the right of RWin there's AppsKey (sc15d)
;
; For ahk's Send:
;   ^ Ctrl
;   + Shift
;   ! Alt
;   # Win
;
; For windows shortcuts see
;   https://docs.microsoft.com/en-us/archive/blogs/sebastianklenk/windows-10-keyboard-shortcuts-at-a-glance
;   https://support.microsoft.com/en-us/windows/keyboard-shortcuts-in-windows-dcc61a57-8ff0-cffe-9796-cb9706c75eec

mod_none  := 0
mod_cmd   := 1 << 0
mod_shift := 1 << 1
mod_ctrl  := 1 << 2
mod_opt   := 1 << 3
mod_ralt  := 1 << 4

modifiers() {
    flags := mod_none
    if GetKeyState("LAlt", "P") {
        flags := flags | mod_cmd
    }
    if GetKeyState("Shift", "P") {
        flags := flags | mod_shift
    }
    if GetKeyState("Capslock", "P")
        || (GetKeyState("LCtrl", "P") && !GetKeyState("RAlt", "P")) {
        flags := flags | mod_ctrl
    }
    if GetKeyState("LWin", "P")
        || GetKeyState("RWin", "P")
        || GetKeyState("sc137", "P")
        || GetKeyState("sc11d", "P") {
        flags := flags | mod_opt
    }
    if GetKeyState("RAlt", "P") {
        flags := flags | mod_ralt
    }
    return flags
}

; The following group makes Alt-Shift-[ and -] map to Page Up and Page Down
GroupAdd("REMAP_BRACKETS_TO_PGUP_PGDN", "ahk_exe WindowsTerminal.exe")
GroupAdd("REMAP_BRACKETS_TO_PGUP_PGDN", "ahk_exe opera.exe")

; Globally Alt is remapped to Ctrl and Alt-Shift to Ctrl-Shift, however,
; the following group makes Alt result in Ctrl-Shift and Alt-Shift in Ctrl-Shift
;GroupAdd("DISTINGUISH_CTRL_FROM_CMD", "ahk_exe WindowsTerminal.exe")
;GroupAdd("DISTINGUISH_CTRL_FROM_CMD", "ahk_exe nvim-qt.exe")
;GroupAdd("DISTINGUISH_CTRL_FROM_CMD", "ahk_exe code.exe")
;GroupAdd("DISTINGUISH_CTRL_FROM_CMD", "ahk_exe wezterm-gui.exe")

; Globally the Windows-key is remapped to special symbols like currency signs,
; Umlaute etc. and Emacs-bindings like forward-word, kill-word etc. however,
; the following group makes the Windows-key result in Alt-combinations
GroupAdd("REMAP_ALT_TO_META_INSTEAD_OF_CMD", "ahk_exe WindowsTerminal.exe")
GroupAdd("REMAP_ALT_TO_META_INSTEAD_OF_CMD", "ahk_exe wezterm-gui.exe")
GroupAdd("REMAP_ALT_TO_META_INSTEAD_OF_CMD", "ahk_exe code.exe")

; The Readline-bindings C-h, -d, -f, -b, -p and -n are globally active with the
; following group containing the exclusions
GroupAdd("DONT_DO_EMACS_REMAPS", "ahk_exe WindowsTerminal.exe")
GroupAdd("DONT_DO_EMACS_REMAPS", "ahk_exe cmd.exe")
GroupAdd("DONT_DO_EMACS_REMAPS", "ahk_exe nvim-qt.exe")
GroupAdd("DONT_DO_EMACS_REMAPS", "ahk_exe nvim.exe")
GroupAdd("DONT_DO_EMACS_REMAPS", "ahk_exe Emacs.exe")
GroupAdd("DONT_DO_EMACS_REMAPS", "ahk_exe code.exe")
GroupAdd("DONT_DO_EMACS_REMAPS", "ahk_exe goneovim.exe")
GroupAdd("DONT_DO_EMACS_REMAPS", "ahk_exe wezterm-gui.exe")

#Hotif ; ..................................................................{{{1

; Disable Capslock if pressed alone
*sc3a::return

; Disable Alt if pressed alone
*sc38::return
*sc38 Up::{
    global lalt_down
    if lalt_down ?? false == true {
        Send("{LAlt up}")
        lalt_down := false
    }
    return
}

; Disable WinKey if pressed alone
*sc15b::return
*sc15c::return

*sc137::return ; Disable PrintScreen
*sc15d::return ; Disable AppsKey

; ..........................................................................}}}

#Hotif WinActive("ahk_exe onenote.exe") ; .................................{{{1
    && modifiers() == mod_cmd | mod_shift
*sc1a::Send("^+{Tab}")
*sc1b::Send("^{Tab}")

#Hotif WinActive("ahk_exe onenote.exe") && modifiers() == mod_cmd
*sc1a::Send("^{PgUp}")
*sc1b::Send("^{PgDn}")

#Hotif WinActive("ahk_exe onenote.exe") && modifiers() == mod_ctrl
*sc13::Send("^{Up}")
*sc26::Send("^{Down}")

; ..........................................................................}}}

#Hotif WinActive("ahk_exe explorer.exe") ; ................................{{{1
    && modifiers() == mod_none
*sc1c::ExplorerRename()

#HotIf modifiers() == mod_ctrl && WinActive("ahk_exe explorer.exe")
*sc13::ExplorerPreviousItem()
*sc15::ExplorerOneLevelDown()
*sc16::ExplorerOpenInGitGui()
*sc26::ExplorerNextItem()
*sc31::ExplorerOneLevelUp()
*sc34::ExplorerOpenInEditor()
*sc35::ExplorerOpenInTerminal()
*sc33::Send("^+{Left}{Backspace}")

#HotIf modifiers() == mod_cmd && WinActive("ahk_exe explorer.exe")
*sc14::Send("^n")                    ; New window (no native tabs yet...)
*sc18::Send("{Enter}")               ; Open file
*sc0e::Send("^d")                    ; Delete file

#HotIf modifiers() == mod_cmd | mod_ctrl && WinActive("ahk_exe explorer.exe")
*sc34::ExplorerOpenInCode()

#HotIf modifiers() == mod_cmd | mod_shift && WinActive("ahk_exe explorer.exe")
*sc17::ExplorerNavigate("shell:MyComputerFolder")
*sc19::ExplorerNavigate("shell:Libraries")
*sc1e::ExplorerNavigate("shell:AppsFolder")
*sc1f::ExplorerNavigate("shell:DocumentsLibrary")
*sc21::ExplorerNavigate("shell:OneDrive")
*sc22::ExplorerNavigate("shell:Administrative Tools")
*sc23::ExplorerNavigate("shell:Desktop")
*sc24::ExplorerNavigate("shell:Profile")
*sc2f::ExplorerNavigate("shell:NetworkPlacesFolder")

#HotIf modifiers() == mod_cmd | mod_opt && WinActive("ahk_exe explorer.exe")
*sc19::ExplorerNavigate("shell:Downloads")
*sc2e::ExplorerCopyFilepath()
*sc31::ExplorerCreateNewTextfile()

; ..........................................................................}}}

#HotIf WinActive("ahk_group REMAP_BRACKETS_TO_PGUP_PGDN") ; ...............{{{1
    && modifiers() == mod_cmd | mod_shift
*sc1a::Send("^{PgUp}")
*sc1b::Send("^{PgDn}")

; ..........................................................................}}}

#HotIf WinActive("ahk_group DISTINGUISH_CTRL_FROM_CMD") ; .................{{{1
    && modifiers() == mod_cmd

; Don't map {Alt} to {Ctrl}, but to {Ctrl-Shift} so that {Alt} acts as Cmd- and
; Capslock as Ctrl-layer. Shortcuts must be remapped in the particular apps,
; like ctrl-shift-f for find etc.

;; §  1  2  3  4  5  6  7  8  9  0  -  =
*sc29::return
*sc02::Send("+^1")
*sc03::Send("+^2")
*sc04::Send("+^3")
*sc05::Send("+^4")
*sc06::Send("+^5")
*sc07::Send("+^6")
*sc08::Send("+^7")
*sc09::Send("+^8")
*sc0a::Send("+^9")
*sc0b::Send("+^0")
*sc0c::Send("+^-")
*sc0d::Send("+^{+}")
;; q  w  e  r  t  y  u  i  o  p  [  ]
;*sc10::Send("+^q")                  ; Don't shadow Cmd-q
*sc11::Send("+^w")
*sc12::Send("+^e")
*sc13::Send("+^r")
*sc14::Send("+^t")
*sc15::Send("+^y")
*sc16::Send("+^u")
*sc17::Send("+^i")
*sc18::Send("+^o")
*sc19::Send("+^p")
*sc1a::Send("+^[")
*sc1b::Send("+^]")
;; a  s  d  f  g  h  j  k  l  ;  '  \
*sc1e::Send("+^a")
*sc1f::Send("+^s")
*sc20::Send("+^d")
*sc21::Send("+^f")
*sc22::Send("+^g")
;*sc23::Send("+^h")                  ; Don't shadow Cmd-h
*sc24::Send("+^j")
*sc25::Send("+^k")
*sc26::Send("+^l")
*sc27::Send("+^;")
*sc28::Send("+^'")
*sc2b::Send("+^\")
;; `  z  x  c  v  b  n  m  ,  .  /
;*sc56::Send("+^{sc56}")             ; Don't shadow Cmd-`
*sc2c::Send("+^z")
*sc2d::Send("+^x")
*sc2e::Send("+^c")
*sc2f::Send("+^v")
*sc30::Send("+^b")
*sc31::Send("+^n")
*sc32::Send("+^m")
*sc33::Send("+^,")
*sc34::Send("+^.")
*sc35::Send("+^/")
;; F-keys
*F1::Send("+^{F1}")
*F2::Send("+^{F2}")
*F3::Send("+^{F3}")
*F4::Send("+^{F4}")
*F5::Send("+^{F5}")
*F6::Send("+^{F6}")
*F7::Send("+^{F7}")
*F8::Send("+^{F8}")
*F9::Send("+^{F9}")
*F10::Send("+^{F10}")
*F11::Send("+^{F11}")
*F12::Send("+^{F12}")

#HotIf modifiers() == mod_cmd | mod_shift && WinActive("ahk_group DISTINGUISH_CTRL_FROM_CMD")

; Don't map {Alt-Shift} to {Ctrl-Shift}, but keep it as {Alt-Shift}, because the
; former is already taken due to masking the Cmd-layer above.

;; §  1  2  3  4  5  6  7  8  9  0  -  =
;*sc29::
*sc02::Send("+!1")
*sc03::Send("+!2")
;*sc04::Send("+!3")                  ; Don't shadow Cmd-Shift-3
;*sc05::Send("+!4")                  ; Don't shadow Cmd-Shift-4
*sc06::Send("+!5")
*sc07::Send("+!6")
*sc08::Send("+!7")
*sc09::Send("+!8")
*sc0a::Send("+!9")
*sc0b::Send("+!0")
*sc0c::Send("+!-")
*sc0d::Send("+!{+}")
;; q  w  e  r  t  y  u  i  o  p  [  ]
*sc10::Send("+!q")
*sc11::Send("+!w")
*sc12::Send("+!e")
*sc13::Send("+!r")
*sc14::Send("+!t")
*sc15::Send("+!y")
*sc16::Send("+!u")
*sc17::Send("+!i")
*sc18::Send("+!o")
*sc19::Send("+!p")
*sc1a::Send("+![")
*sc1b::Send("+!]")
;; a  s  d  f  g  h  j  k  l  ;  '  \
*sc1e::Send("+!a")
*sc1f::Send("+!s")
*sc20::Send("+!d")
*sc21::Send("+!f")
*sc22::Send("+!g")
*sc23::Send("+!h")
*sc24::Send("+!j")
*sc25::Send("+!k")
*sc26::Send("+!l")
*sc27::Send("+!;")
*sc28::Send("+!'")
*sc2b::Send("+!\")
;; `  z  x  c  v  b  n  m  ,  .  /
;*sc56::Send("+!{sc56}")
*sc2c::Send("+!z")
*sc2d::Send("+!x")
*sc2e::Send("+!c")
*sc2f::Send("+!v")
*sc30::Send("+!b")
*sc31::Send("+!n")
*sc32::Send("+!m")
*sc33::Send("+!,")
*sc34::Send("+!.")
*sc35::Send("+!/")
;; F-keys
*F1::Send("+!{F1}")
*F2::Send("+!{F2}")
*F3::Send("+!{F3}")
*F4::Send("+!{F4}")
*F5::Send("+!{F5}")
*F6::Send("+!{F6}")
*F7::Send("+!{F7}")
*F8::Send("+!{F8}")
*F9::Send("+!{F9}")
*F10::Send("+!{F10}")
*F11::Send("+!{F11}")
*F12::Send("+!{F12}")
;; Special
*sc14b::Send("+!{Left}")
*sc14d::Send("+!{Right}")
*sc148::Send("+!{Up}")
*sc150::Send("+!{Down}")

; ..........................................................................}}}

#HotIf WinActive("ahk_group REMAP_ALT_TO_META_INSTEAD_OF_CMD") ; ..........{{{1
    && modifiers() == mod_cmd

;; §  1  2  3  4  5  6  7  8  9  0  -  =
*sc29::return
*sc02::Send("!1")
*sc03::Send("!<")
;*sc04::Send("!>")                   ; Don't shadow Cmd-Shift-3
;*sc05::Send("!=")                   ; Don't shadow Cmd-Shift-4
*sc06::Send("!5")
*sc07::Send("!6")
*sc08::Send("!``")
*sc09::Send("!+")
*sc0a::Send("!(")
*sc0b::Send("!)")
*sc0c::Send("!\")
*sc0d::return
;; q  w  e  r  t  y  u  i  o  p  [  ]
*sc10::Send("!;")
*sc11::Send("!,")
*sc12::Send("!.")
*sc13::Send("!p")
*sc14::Send("!y")
*sc15::Send("!f")
*sc16::Send("!g")
*sc17::Send("!c")
*sc18::Send("!r")
*sc19::Send("!l")
*sc1a::Send("![")
*sc1b::Send("!]")
;; a  s  d  f  g  h  j  k  l  ;  '  \
*sc1e::Send("!a")
*sc1f::Send("!o")
*sc20::Send("!e")
*sc21::Send("!i")
*sc22::Send("!u")
*sc23::Send("!d")
*sc24::Send("!h")
*sc25::Send("!t")
*sc26::Send("!n")
*sc27::Send("!s")
*sc28::Send("!-")
*sc2b::Send("!`"")
;; `  z  x  c  v  b  n  m  ,  .  /
*sc56::return
*sc2c::Send("!%")
*sc2d::Send("!q")
*sc2e::Send("!j")
*sc2f::Send("!k")
*sc30::Send("!x")
*sc31::Send("!b")
*sc32::Send("!m")
*sc33::Send("!w")
*sc34::Send("!v")
*sc35::Send("!z")
;; F-keys
*F1::Send("!{F1}")
*F2::Send("!{F2}")
*F3::Send("!{F3}")
*F4::Send("!{F4}")
*F5::Send("!{F5}")
*F6::Send("!{F6}")
*F7::Send("!{F7}")
*F8::Send("!{F8}")
*F9::Send("!{F9}")
*F10::Send("!{F10}")
*F11::Send("!{F11}")
*F12::Send("!{F12}")
;; Special
*sc1c::Send("!{Enter}")
*sc0e::Send("!{Backspace}")
*vk01::Send("!{LButton}")

#HotIf modifiers() == mod_cmd | mod_shift && WinActive("ahk_group REMAP_ALT_TO_META_INSTEAD_OF_CMD")

;; §  1  2  3  4  5  6  7  8  9  0  -  =
*sc29::return
*sc02::return
*sc03::Send("!@")
*sc04::Send("!#")
*sc05::Send("!$")
*sc06::return
*sc07::return
*sc08::Send("!~")
*sc09::Send("!*")
*sc0a::Send("!/")
*sc0b::Send("!&")
*sc0c::Send("!|")
*sc0d::return
;; q  w  e  r  t  y  u  i  o  p  [  ]
*sc10::Send("!?")
*sc11::Send("!{!}")
*sc12::Send("!:")
*sc13::Send("+!p")
*sc14::Send("+!y")
*sc15::Send("+!f")
*sc16::Send("+!g")
*sc17::Send("+!c")
*sc18::Send("+!r")
*sc19::Send("+!l")
*sc1a::Send("+![")
*sc1b::Send("+!]")
;; a  s  d  f  g  h  j  k  l  ;  '  \
*sc1e::Send("+!a")
*sc1f::Send("+!o")
*sc20::Send("+!e")
*sc21::Send("+!i")
*sc22::Send("+!u")
*sc23::Send("+!d")
*sc24::Send("+!h")
*sc25::Send("+!t")
*sc26::Send("+!n")
*sc27::Send("+!s")
*sc28::Send("!_")
*sc2b::Send("!'")
;; `  z  x  c  v  b  n  m  ,  .  /
*sc56::return
*sc2c::Send("!^")
*sc2d::Send("+!q")
*sc2e::Send("+!j")
*sc2f::Send("+!k")
*sc30::Send("+!x")
*sc31::Send("+!b")
*sc32::Send("+!m")
*sc33::Send("+!w")
*sc34::Send("+!v")
*sc35::Send("+!z")
;; F-keys
*F1::Send("+!{F1}")
*F2::Send("+!{F2}")
*F3::Send("+!{F3}")
*F4::Send("+!{F4}")
*F5::Send("+!{F5}")
*F6::Send("+!{F6}")
*F7::Send("+!{F7}")
*F8::Send("+!{F8}")
*F9::Send("+!{F9}")
*F10::Send("+!{F10}")
*F11::Send("+!{F11}")
*F12::Send("+!{F12}")
;; Special
*sc1c::Send("+!{Enter}")
*sc0e::Send("+!{Backspace}")
*vk01::Send("+!{LButton}")

; ..........................................................................}}}

#HotIf !WinActive("ahk_group DONT_DO_EMACS_REMAPS") ; .....................{{{1
    && modifiers() == mod_ctrl

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
*sc13::Send("{Up}")
;*sc14::
*sc15::Send("{Right}")
;*sc16::
;*sc17::
;*sc18::
;*sc19::
;*sc1a::
;*sc1b::
;; a  s  d  f  g  h  j  k  l  ;  '  \
*sc1e::Send("{Home}")
;*sc1f::
*sc20::Send("{End}")
;*sc21::
;*sc22::
*sc23::Send("{Delete}")
*sc24::Send("{Backspace}")
;*sc25::
*sc26::Send("{Down}")
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
*sc31::Send("{Left}")
;*sc32::
*sc33::Send("^{Backspace}")
;*sc34::
;*sc35::

#HotIf modifiers() == mod_ctrl | mod_shift && !WinActive("ahk_group DONT_DO_EMACS_REMAPS")

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
*sc13::Send("+{Up}")
;*sc14::
*sc15::Send("+{Right}")
;*sc16::
;*sc17::
;*sc18::
;*sc19::
;*sc1a::
;*sc1b::
;; a  s  d  f  g  h  j  k  l  ;  '  \
*sc1e::Send("+{Home}")
;*sc1f::
*sc20::Send("+{End}")
;*sc21::
;*sc22::
;*sc23::
;*sc24::
;*sc25::
*sc26::Send("+{Down}")
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
*sc31::Send("+{Left}")
;*sc32::
;*sc33::
;*sc34::
;*sc35::

; ..........................................................................}}}

#HotIf modifiers() == mod_none ; ..........................................{{{1

;; §  1  2  3  4  5  6  7  8  9  0  -  =
*sc29::return
*sc02::return
*sc03::Send("<")
*sc04::Send(">")
*sc05::Send("=")
*sc06::return
*sc07::return
*sc08::Send("``")
*sc09::Send("{+}")
*sc0a::Send("(")
*sc0b::Send(")")
*sc0c::Send("\")
*sc0d::return
;; q  w  e  r  t  y  u  i  o  p  [  ]
*sc10::Send("{;}")
*sc11::Send(",")
*sc12::Send(".")
*sc13::Send("p")
*sc14::Send("y")
*sc15::Send("f")
*sc16::Send("g")
*sc17::Send("c")
*sc18::Send("r")
*sc19::Send("l")
*sc1a::Send("[")
*sc1b::Send("]")
;; a  s  d  f  g  h  j  k  l  ;  '  \
*sc1e::Send("a")
*sc1f::Send("o")
*sc20::Send("e")
*sc21::Send("i")
*sc22::Send("u")
*sc23::Send("d")
*sc24::Send("h")
*sc25::Send("t")
*sc26::Send("n")
*sc27::Send("s")
*sc28::Send("-")
*sc2b::Send("`"")
;; `  z  x  c  v  b  n  m  ,  .  /
*sc56::return
*sc2c::Send("`%")
*sc2d::Send("q")
*sc2e::Send("j")
*sc2f::Send("k")
*sc30::Send("x")
*sc31::Send("b")
*sc32::Send("m")
*sc33::Send("w")
*sc34::Send("v")
*sc35::Send("z")
;; Special
*sc1c::Send("{Enter}")
*sc39::Send("{Space}")
*F12::Send("#a")

; ..........................................................................}}}

#HotIf modifiers() == mod_shift ; .........................................{{{1

;; §  1  2  3  4  5  6  7  8  9  0  -  =
*sc29::return
*sc02::return
*sc03::Send("@")
*sc04::Send("{#}")
*sc05::Send("$")
*sc06::return
*sc07::return
*sc08::Send("~")
*sc09::Send("*")
*sc0a::Send("/")
*sc0b::Send("&")
*sc0c::Send("|")
*sc0d::return
;; q  w  e  r  t  y  u  i  o  p  [  ]
*sc10::Send("?")
*sc11::Send("{!}")
*sc12::Send(":")
*sc13::Send("P")
*sc14::Send("Y")
*sc15::Send("F")
*sc16::Send("G")
*sc17::Send("C")
*sc18::Send("R")
*sc19::Send("L")
*sc1a::Send("{{}")
*sc1b::Send("{}}")
;; a  s  d  f  g  h  j  k  l  ;  '  \
*sc1e::Send("A")
*sc1f::Send("O")
*sc20::Send("E")
*sc21::Send("I")
*sc22::Send("U")
*sc23::Send("D")
*sc24::Send("H")
*sc25::Send("T")
*sc26::Send("N")
*sc27::Send("S")
*sc28::Send("_")
*sc2b::Send("'")
;; `  z  x  c  v  b  n  m  ,  .  /
*sc56::return
*sc2c::Send("{Text}^")
*sc2d::Send("Q")
*sc2e::Send("J")
*sc2f::Send("K")
*sc30::Send("X")
*sc31::Send("B")
*sc32::Send("M")
*sc33::Send("W")
*sc34::Send("V")
*sc35::Send("Z")
;; Special
*sc1c::Send("+{Enter}")
*sc0e::Send("+{Backspace}")
*WheelUp::Send("+{WheelUp}")
*WheelDown::Send("+{WheelDown}")

; ..........................................................................}}}

#HotIf modifiers() == mod_cmd ; ...........................................{{{1

;; §  1  2  3  4  5  6  7  8  9  0  -  =
*sc29::ShowDesktop()
*sc02::Send("^1")
*sc03::Send("^2")
*sc04::Send("^3")
*sc05::Send("^4")
*sc06::Send("^5")
*sc07::Send("^6")
*sc08::Send("^7")
*sc09::Send("^8")
*sc0a::Send("^9")
*sc0b::Send("^0")
*sc0c::Send("^-")
*sc0d::Send("^{+}")
;; q  w  e  r  t  y  u  i  o  p  [  ]
*sc10::Send("!{F4}")                 ; Quit active application
                                     ; (^{F4} or !{Space}S work as well, latter one
                                     ; doesn't work for eg Opera, though)
*sc11::Send("^w")
*sc12::Send("^e")
*sc13::Send("^r")
*sc14::Send("^t")
*sc15::Send("^y")
*sc16::Send("^u")
*sc17::Send("^i")
*sc18::Send("^o")
*sc19::Send("^p")
*sc1a::Send("^[")
*sc1b::Send("^]")
;; a  s  d  f  g  h  j  k  l  ;  '  \
*sc1e::Send("^a")
*sc1f::Send("^s")
*sc20::Send("^d")
*sc21::Send("^f")
*sc22::Send("^g")
*sc23::WinMinimize("A")              ; Hide active window
*sc24::Send("^j")
*sc25::Send("^k")
*sc26::Send("^l")
*sc27::Send("^;")
*sc28::Send("^'")
*sc2b::Send("^\")
;; `  z  x  c  v  b  n  m  ,  .  /
*sc56::SwitchToNextWindow()
*sc2c::Send("^z")
*sc2d::Send("^x")
*sc2e::Send("^c")
*sc2f::Send("^v")
*sc30::Send("^b")
*sc31::Send("^n")
*sc32::Send("^m")
*sc33::Send("^,")
*sc34::Send("^.")
*sc35::Send("^/")
;; F-keys
*F1::Send("^{F1}")
*F2::Send("^{F2}")
*F3::Send("^{F3}")
*F4::Send("^{F4}")
*F5::Send("^{F5}")
*F6::Send("^{F6}")
*F7::Send("^{F7}")
*F8::Send("^{F8}")
*F9::Send("^{F9}")
*F10::Send("^{F10}")
*F11::Send("^{F11}")
*F12::Send("^{F12}")
;; Special
*sc0e::Send("^{Backspace}")
 vk01::Send("^{LButton}")            ; NOTE: using * breaks Cmd-Tab.
*WheelUp::Send("^{WheelUp}")
*WheelDown::Send("^{WheelDown}")
*sc39::OpenSearch()
*sc0f::{
    global lalt_down := true
    Send("{LAlt down}{Tab}")
    return
}
*sc2a::Send("{LCtrl down}{LShift}{LCtrl up}") ; Switch keyboard layout

; ..........................................................................}}}

#HotIf modifiers() == mod_cmd | mod_shift ; ...............................{{{1

;; §  1  2  3  4  5  6  7  8  9  0  -  =
*sc29::return
*sc02::Send("+^1")
*sc03::Send("+^2")
*sc04::Send("{PrintScreen}")         ; Take a screenshot
*sc05::OpenSnipAndSketch()
*sc06::Send("+^5")
*sc07::Send("+^6")
*sc08::Send("+^7")
*sc09::Send("+^8")
*sc0a::Send("+^9")
*sc0b::Send("+^0")
*sc0c::Send("+^-")
*sc0d::Send("+^{+}")
;; q  w  e  r  t  y  u  i  o  p  [  ]
*sc10::Send("+^q")
*sc11::Send("+^w")
*sc12::Send("+^e")
*sc13::Send("+^r")
*sc14::Send("+^t")
*sc15::Send("+^y")
*sc16::Send("+^u")
*sc17::Send("+^i")
*sc18::Send("+^o")
*sc19::Send("+^p")
*sc1a::Send("+^[")
*sc1b::Send("+^]")
;; a  s  d  f  g  h  j  k  l  ;  '  \
*sc1e::Send("+^a")
*sc1f::Send("+^s")
*sc20::Send("+^d")
*sc21::Send("+^f")
*sc22::Send("+^g")
*sc23::Send("+^h")
*sc24::Send("+^j")
*sc25::Send("+^k")
*sc26::Send("+^l")
*sc27::Send("+^;")
*sc28::Send("+^'")
*sc2b::Send("+^\")
;; `  z  x  c  v  b  n  m  ,  .  /
;*sc56::
*sc2c::Send("+^z")
*sc2d::Send("+^x")
*sc2e::Send("+^c")
*sc2f::Send("+^v")
*sc30::Send("+^b")
*sc31::Send("+^n")
*sc32::Send("+^m")
*sc33::Send("+^,")
*sc34::Send("+^.")
*sc35::Send("+^/")
;; Special
*vk01::Send("^{LButton}")

; ..........................................................................}}}

#HotIf modifiers() == mod_cmd | mod_opt ; .................................{{{1

;; §  1  2  3  4  5  6  7  8  9  0  -  =
;*sc29::Send("^!{sc29}")
*sc02::Send("^!1")
*sc03::Send("^!2")
*sc04::Send("^!3")
*sc05::Send("^!4")
*sc06::Send("^!5")
*sc07::Send("^!6")
*sc08::Send("^!7")
*sc09::Send("^!8")
*sc0a::Send("^!9")
*sc0b::Send("^!0")
;*sc0c::Send("^!{sc0c}")
;*sc0d::Send("^!{sc0d}")
;; q  w  e  r  t  y  u  i  o  p  [  ]
*sc10::Send("^!q")
*sc11::Send("^!w")
*sc12::Send("^!e")
*sc13::Send("^!r")
*sc14::Send("^!t")
*sc15::Send("^!y")
*sc16::Send("^!u")
*sc17::Send("^!i")
*sc18::Send("^!o")
*sc19::Send("^!p")
*sc1a::Send("^![")
*sc1b::Send("^!]")
;; a  s  d  f  g  h  j  k  l  ;  '  \
*sc1e::Send("^!a")
*sc1f::Send("^!s")
*sc20::Send("^!d")
*sc21::Send("^!f")
*sc22::Send("^!g")
*sc23::Send("^!h")
*sc24::Send("^!j")
*sc25::Send("^!k")
*sc26::Send("^!l")
*sc27::Send("^!;")
*sc28::Send("^!'")
*sc2b::Send("^!\")
;; `  z  x  c  v  b  n  m  ,  .  /
;*sc56::Send("!{sc56}")
*sc2c::Send("^!z")
*sc2d::Send("^!x")
*sc2e::Send("^!c")
*sc2f::Send("^!v")
*sc30::Send("^!b")
*sc31::Send("^!n")
*sc32::Send("^!m")
*sc33::Send("^!,")
*sc34::Send("^!.")
*sc35::Send("^!/")

; ..........................................................................}}}

#HotIf modifiers() == mod_opt ; ...........................................{{{1
    || modifiers() == mod_opt | mod_shift | mod_ctrl | mod_cmd ; Office key

;; §  1  2  3  4  5  6  7  8  9  0  -  =
;*sc29::Send("!{sc29}")
*sc02::Send("¹")
*sc03::Send("²")
*sc04::Send("³")
*sc05::Send("⁴")
*sc06::Send("⁵")
*sc07::Send("⁶")
*sc08::Send("⁷")
*sc09::Send("⁸")
*sc0a::Send("⁹")
*sc0b::Send("⁰")
;*sc0c::Send("!{sc0c}")
;*sc0d::Send("!{sc0d}")
;; q  w  e  r  t  y  u  i  o  p  [  ]
*sc10::Send("!;")
*sc11::Send("!,")
*sc12::Send("…")
*sc13::Send("£")
*sc14::Send("¥")
*sc15::Send("^{Right}")              ; forward-word
*sc16::Send("!g")
*sc17::Send("!c")
*sc18::Send("!r")
*sc19::Send("!l")
*sc1a::Send("![")
*sc1b::Send("!]")
;; a  s  d  f  g  h  j  k  l  ;  '  \
*sc1e::Send("ä")
*sc1f::Send("ö")
*sc20::Send("€")
*sc21::Send("!i")
*sc22::Send("ü")
*sc23::Send("^{Delete}")             ; kill-word
*sc24::Send("^{Backspace}")          ; backward-kill-word
*sc25::Send("!t")
*sc26::Send("!n")
*sc27::Send("ß")
*sc28::Send("–")
*sc2b::Send("!`"")
;; `  z  x  c  v  b  n  m  ,  .  /
;*sc56::Send("!{sc56}")
*sc2c::Send("!q")
*sc2d::Send("!j")
*sc2e::Send("!k")
*sc2f::Send("#{sc2f}")               ; Open clipboard with {Win-v}
*sc30::Send("✗")
*sc31::Send("^{Left}")               ; backward-word
*sc32::Send("!m")
*sc33::Send("₩")
*sc34::Send("✔")
*sc35::Send("!z")
;; F-keys
*F1::Send("!{F1}")
*F2::Send("!{F2}")
*F3::Send("!{F3}")
*F4::Send("!{F4}")
*F5::Send("!{F5}")
*F6::Send("!{F6}")
*F7::Send("!{F7}")
*F8::Send("!{F8}")
*F9::Send("!{F9}")
*F10::Send("!{F10}")
*F11::Send("!{F11}")
*F12::Send("!{F12}")
;; Special
*sc1c::Send("!{Enter}")
*sc0e::Send("!{Backspace}")
*vk01::Send("!{LButton}")

; ..........................................................................}}}

#HotIf modifiers() == mod_opt | mod_shift ; ...............................{{{1

;; §  1  2  3  4  5  6  7  8  9  0  -  =
;*sc29::Send("+!{sc29}")
*sc02::Send("+!1")
*sc03::Send("+!2")
*sc04::Send("+!3")
*sc05::Send("+!4")
*sc06::Send("+!5")
*sc07::Send("+!6")
*sc08::Send("+!7")
*sc09::Send("+!8")
*sc0a::Send("+!9")
*sc0b::Send("+!0")
;*sc0c::Send("+!{sc0c}")
;*sc0d::Send("+!{sc0d}")
;; q  w  e  r  t  y  u  i  o  p  [  ]
*sc10::Send("+!;")
*sc11::Send("+!,")
*sc12::Send("+!.")
*sc13::Send("+!p")
*sc14::Send("+!y")
*sc15::Send("+^{Right}")
*sc16::Send("+!g")
*sc17::Send("+!c")
*sc18::Send("+!r")
*sc19::Send("+!l")
*sc1a::Send("+![")
*sc1b::Send("+!]")
;; a  s  d  f  g  h  j  k  l  ;  '  \
*sc1e::Send("Ä")
*sc1f::Send("Ö")
*sc20::Send("+!e")
*sc21::Send("+!i")
*sc22::Send("Ü")
*sc23::Send("+!d")
*sc24::Send("+!h")
*sc25::Send("+!t")
*sc26::Send("+!n")
*sc27::Send("+!s")
*sc28::Send("—")
*sc2b::Send("+!`"")
;; `  z  x  c  v  b  n  m  ,  .  /
;*sc56::Send("+!{sc56}")
;*sc2c::Send("+!{sc2c}")
*sc2d::Send("+!q")
*sc2e::Send("+!j")
*sc2f::Send("+!k")
*sc30::Send("+!x")
*sc31::Send("+^{Left}")
*sc32::Send("+!m")
*sc33::Send("+!w")
*sc34::Send("+!v")
*sc35::Send("+!z")
;; F-keys
*F1::Send("+!{F1}")
*F2::Send("+!{F2}")
*F3::Send("+!{F3}")
*F4::Send("+!{F4}")
*F5::Send("+!{F5}")
*F6::Send("+!{F6}")
*F7::Send("+!{F7}")
*F8::Send("+!{F8}")
*F9::Send("+!{F9}")
*F10::Send("+!{F10}")
*F11::Send("+!{F11}")
*F12::Send("+!{F12}")
;; Special
*sc1c::Send("+!{Enter}")
*sc0e::Send("+!{Backspace}")
*vk01::Send("+!{LButton}")

; ..........................................................................}}}

#HotIf modifiers() == mod_ctrl ; ..........................................{{{1

;; §  1  2  3  4  5  6  7  8  9  0  -  =
*sc29::return
*sc02::Send("^1")
*sc03::Send("^2")
*sc04::Send("^3")
*sc05::Send("^4")
*sc06::Send("^5")
*sc07::Send("^6")
*sc08::Send("^7")
*sc09::Send("^8")
*sc0a::Send("^9")
*sc0b::Send("^0")
*sc0c::return
*sc0d::return
;; q  w  e  r  t  y  u  i  o  p  [  ]
*sc10::Send("^{u+0040}")             ; C-@
*sc11::Send("^{u+005e}")             ; C-^
*sc12::return
*sc13::Send("^p")
*sc14::Send("^y")
*sc15::Send("^f")
*sc16::Send("^g")
*sc17::Send("{Escape}")              ; Map to ⎋ (instead of C-c)
*sc18::Send("^r")
*sc19::Send("^l")
*sc1a::Send("^c")                    ; Map to C-c (instead of C-[)
*sc1b::Send("^{u+005d}")             ; C-]
;; a  s  d  f  g  h  j  k  l  ;  '  \
*sc1e::Send("^a")
*sc1f::Send("^o")
*sc20::Send("^e")
*sc21::Send("^i")
*sc22::Send("^u")
*sc23::Send("^d")
*sc24::Send("^h")
*sc25::Send("^t")
*sc26::Send("^n")
*sc27::Send("^s")
*sc28::Send("^{u+005f}")             ; C-_
*sc2b::Send("^{u+005c}")             ; C-\
;; `  z  x  c  v  b  n  m  ,  .  /
*sc56::return
*sc2c::return
*sc2d::Send("^q")
*sc2e::Send("^j")
*sc2f::Send("^k")
*sc30::Send("^x")
*sc31::Send("^b")
*sc32::Send("^m")
*sc33::Send("^w")
*sc34::Send("^v")
*sc35::Send("^z")
;; F-keys
*F1::Send("^{F1}")
*F2::Send("^{F2}")
*F3::Send("^{F3}")
*F4::Send("^{F4}")
*F5::Send("^{F5}")
*F6::Send("^{F6}")
*F7::Send("^{F7}")
*F8::Send("^{F8}")
*F9::Send("^{F9}")
*F10::Send("^{F10}")
*F11::Send("^{F11}")
*F12::Send("^{F12}")
;; Special
;*sc39::Send("^{Space}")             ; Remap {Ctrl-Space} to {Alt-;} instead
*sc39::Send("!{u+003b}")             ; because Hunt-and-Peck's hotkey is hardcoded.

; ..........................................................................}}}

#HotIf modifiers() == mod_ctrl | mod_cmd ; ................................{{{1

;; §  1  2  3  4  5  6  7  8  9  0  -  =
;*sc29::
;*sc02::
;*sc03::
;*sc04::
;*sc05::
;*sc06::
;*sc07::
*sc08::Send("7")
*sc09::Send("8")
*sc0a::Send("9")
*sc0b::Send("*")
;*sc0c::
;*sc0d::
;; q  w  e  r  t  y  u  i  o  p  [  ]
;*sc10::
;*sc11::
;*sc12::
;*sc13::
;*sc14::
;*sc15::
*sc16::Send("4")
*sc17::Send("5")
*sc18::Send("6")
*sc19::Send("{+}")
;*sc1a::
;*sc1b::
;; a  s  d  f  g  h  j  k  l  ;  '  \
;*sc1e::
;*sc1f::
;*sc20::
;*sc21::
;*sc22::
;*sc23::
*sc24::Send("1")
*sc25::Send("2")
*sc26::Send("3")
*sc27::Send("-")
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
*sc32::Send("0")
*sc33::Send(",")
*sc34::Send(".")
*sc35::Send("/")
;; Special
*sc39::Send("#.")                    ; Open emoji list

; ..........................................................................}}}

#HotIf modifiers() == mod_ctrl | mod_opt ; ................................{{{1

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
*sc0a::Send("#{Left}")               ; Pin window to the left side
*sc0b::Send("#{Right}")              ; Pin window to the right side
*sc0c::ResizeWindow("smaller")       ; Make window smaller
*sc0d::ResizeWindow("larger")        ; Make window bigger
;; q  w  e  r  t  y  u  i  o  p  [  ]
;*sc10::
;*sc11::
;*sc12::
;*sc13::
;*sc14::
;*sc15::
*sc15::WinMaximize("A")              ; Maximize window
;*sc16::
*sc17::CenterWindow()                ; Center window
;*sc18::
*sc19::Send("^#{Right}")             ; Switch to next virtual desktop
*sc1a::Send("#+{Left}")              ; Move to left monitor
*sc1b::Send("#+{Right}")             ; Move to right monitor
;; a  s  d  f  g  h  j  k  l  ;  '  \
;*sc1e::
;*sc1f::
;*sc20::
;*sc21::
;*sc22::
;*sc23::
*sc24::Send("^#{Left}")              ; Switch to previous virtual desktop
;*sc25::
;*sc26::
;*sc27::
;*sc28::
;*sc2b::
;; `  z  x  c  v  b  n  m  ,  .  /
;*sc56::
;*sc2c::
;*sc2d::
*sc2e::Send("#{Up}")                 ; Pin window to the top side
*sc2f::Send("#{Down}")               ; Pin window to the bottom side
;*sc30::
;*sc31::
;*sc32::
;*sc33::
;*sc34::
;*sc35::
;; Special
*sc0e::Send("!{Space}W")             ; Restore window
*sc39::Send("{LAlt down}{LShift}{LAlt up}")

; ..........................................................................}}}
