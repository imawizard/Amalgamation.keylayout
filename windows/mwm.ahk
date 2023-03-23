#Requires AutoHotkey v2
#SingleInstance force
#WinActivateForce
A_MaxHotkeysPerInterval := 1000
KeyHistory(0), ListLines(false), ProcessSetPriority("H")
A_IconTip := "「 Miguru Window Manager 」"

#include ..\..\MiguruWM\lib\miguru\miguru.ahk
#include funcs.ahk

GroupAdd("MIGURU_AUTOFLOAT", "Microsoft Teams-Benachrichtigung ahk_exe Teams.exe")
GroupAdd("MIGURU_AUTOFLOAT", "Microsoft Teams-Notification ahk_exe Teams.exe")
GroupAdd("MIGURU_AUTOFLOAT", "ahk_exe QuickLook.exe")
GroupAdd("MIGURU_AUTOFLOAT", "ahk_class MsoSplash ahk_exe outlook.exe")
GroupAdd("MIGURU_AUTOFLOAT", "ahk_class OperationStatusWindow ahk_exe explorer.exe")

mwm := MiguruWM({
    layout: "tall",
    masterSize: 0.5,
    masterCount: 1,
    padding: 0,
    spacing: 0,

    tilingMinWidth: 100,
    tilingMinHeight: 100,
    tilingInsertion: "before-mru",
    floatingAlwaysOnTop: true,
    nativeMaximize: true,
})

; Disable Right-Alt if pressed alone
*sc138::return

#HotIf GetKeyState("RAlt", "P") && !GetKeyState("Shift", "P") ; ...........{{{1

;; §  1  2  3  4  5  6  7  8  9  0  -  =
*sc29::ShowDesktop()
*sc02::mwm.Set("layout", { value: "Floating" })
*sc03::mwm.Set("layout", { value: "Wide" })
*sc04::mwm.Set("layout", { value: "Tall" })
*sc05::mwm.Set("layout", { value: "Fullscreen" })
*sc06::return
*sc07::return
*sc08::return
*sc09::return
*sc0a::return
*sc0b::return
*sc0c::return
*sc0d::return
;; q  w  e  r  t  y  u  i  o  p  [  ]
*sc10::Reload()
*sc11::mwm.Do("focus-monitor", { monitor: 1 })
*sc12::mwm.Do("focus-monitor", { monitor: 2 })
*sc13::mwm.Do("focus-monitor", { monitor: 3 })
*sc14::return
*sc15::return
*sc16::return
*sc17::OpenTaskView()
*sc18::return
*sc19::mwm.Set("master-size", { delta: 0.01 })
*sc1a::return
*sc1b::return
;; a  s  d  f  g  h  j  k  l  ;  '  \
*sc1e::mwm.VD.FocusDesktop(1)
*sc1f::mwm.VD.FocusDesktop(2)
*sc20::mwm.VD.FocusDesktop(3)
*sc21::mwm.VD.FocusDesktop(4)
*sc22::mwm.VD.FocusDesktop(5)
*sc23::WinMinimize("A")
*sc24::mwm.Set("master-size", { delta: -0.01 })
*sc25::mwm.Do("float-window", { hwnd: WinExist("A"), value: "toggle" })
*sc26::return
*sc27::return
*sc28::return
*sc2b::return
;; `  z  x  c  v  b  n  m  ,  .  /
*sc56::SwitchToNextWindow()
*sc2c::return
*sc2d::return
*sc2e::mwm.Do("focus-window", { target: "next" })
*sc2f::mwm.Do("focus-window", { target: "previous" })
*sc30::return
*sc31::return
*sc32::mwm.Do("focus-window", { target: "master" })
*sc33::mwm.Set("master-count", { delta: 1 })
*sc34::mwm.Set("master-count", { delta: -1 })
*sc35::return
;; Special
*sc1c::mwm.Do("swap-window", { with: "master" })
*sc39::OpenSearch()

*F1::SendInput("!{Esc}")

; ..........................................................................}}}

#HotIf GetKeyState("RAlt", "P") && GetKeyState("Shift", "P") ; ............{{{1

;; §  1  2  3  4  5  6  7  8  9  0  -  =
*sc29::return
*sc02::return
*sc03::return
*sc04::return
*sc05::return
*sc06::return
*sc07::return
*sc08::return
*sc09::return
*sc0a::return
*sc0b::return
*sc0c::return
*sc0d::return
;; q  w  e  r  t  y  u  i  o  p  [  ]
*sc10::ExitApp()
*sc11::mwm.Do("send-to-monitor", { monitor: 1, follow: true })
*sc12::mwm.Do("send-to-monitor", { monitor: 2, follow: true })
*sc13::mwm.Do("send-to-monitor", { monitor: 3, follow: true })
*sc14::return
*sc15::return
*sc16::return
*sc17::WinClose("A")
*sc18::return
*sc19::return
*sc1a::return
*sc1b::return
;; a  s  d  f  g  h  j  k  l  ;  '  \
*sc1e::mwm.VD.SendWindowToDesktop(WinExist("A"), 1), mwm.VD.FocusDesktop(1)
*sc1f::mwm.VD.SendWindowToDesktop(WinExist("A"), 2), mwm.VD.FocusDesktop(2)
*sc20::mwm.VD.SendWindowToDesktop(WinExist("A"), 3), mwm.VD.FocusDesktop(3)
*sc21::mwm.VD.SendWindowToDesktop(WinExist("A"), 4), mwm.VD.FocusDesktop(4)
*sc22::mwm.VD.SendWindowToDesktop(WinExist("A"), 5), mwm.VD.FocusDesktop(5)
*sc23::return
*sc24::return
*sc25::return
*sc26::return
*sc27::return
*sc28::return
*sc2b::return
;; `  z  x  c  v  b  n  m  ,  .  /
*sc56::return
*sc2c::return
*sc2d::return
*sc2e::mwm.Do("swap-window", { with: "next" })
*sc2f::mwm.Do("swap-window", { with: "previous" })
*sc30::return
*sc31::return
*sc32::return
*sc33::return
*sc34::return
*sc35::return
;; Special
*sc1c::OpenTerminal()
*sc39::ResetLayout()
*F1::mwm.Get("workspace-info")
*F2::mwm.Get("monitor-info")

; ..........................................................................}}}

#HotIf GetKeyState("LWin", "P") ; .........................................{{{1

*vk01::{
    MouseGetPos(, , &hwnd)
    if !hwnd {
        return
    }
    mwm.Do("float-window", { hwnd: hwnd })
    PostMessage(WM_SYSCOMMAND, SC_MOVE, , , "ahk_id" hwnd)
    PostMessage(WM_KEYDOWN, VK_LEFT, , , "ahk_id" hwnd)
    PostMessage(WM_KEYUP, VK_LEFT, , , "ahk_id" hwnd)
    PostMessage(WM_KEYDOWN, VK_RIGHT, , , "ahk_id" hwnd)
    PostMessage(WM_KEYUP, VK_RIGHT, , , "ahk_id" hwnd)
    KeyWait("vk01")
    Send("{vk01 Up}")
}

*vk02::{
    MouseGetPos(, , &hwnd)
    if !hwnd {
        return
    }
    mwm.Do("float-window", { hwnd: hwnd })
    PostMessage(WM_SYSCOMMAND, SC_SIZE, , , "ahk_id" hwnd)
    PostMessage(WM_KEYDOWN, VK_DOWN, , , "ahk_id" hwnd)
    PostMessage(WM_KEYUP, VK_DOWN, , , "ahk_id" hwnd)
    PostMessage(WM_KEYDOWN, VK_RIGHT, , , "ahk_id" hwnd)
    PostMessage(WM_KEYUP, VK_RIGHT, , , "ahk_id" hwnd)
    KeyWait("vk02")
    Send("{vk01 Up}")
}

CycleLayouts() {
    cycle := [
        "tall",
        "wide",
        "fullscreen",
        "floating",
    ]

    m := Map()
    for i, l in cycle {
        m[l] := i
    }

    current := mwm.Get("layout")
    next := cycle[Mod(m[current], cycle.Length) + 1]

    mwm.Set("layout", { value: next })
}

ResetLayout() {
    defaults := mwm.Options

    mwm.Set("layout", { value: defaults.layout })
    mwm.Set("master-size", { value: defaults.masterSize })
    mwm.Set("master-count", { value: defaults.masterCount })
    mwm.Set("padding", { value: defaults.padding })
    mwm.Set("spacing", { value: defaults.spacing })
}
