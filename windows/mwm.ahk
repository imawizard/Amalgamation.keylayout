#Requires AutoHotkey v2.0
#SingleInstance force
#UseHook true
#WinActivateForce
A_MaxHotkeysPerInterval := 1000
KeyHistory(0), ListLines(false), ProcessSetPriority("H")
A_IconTip := "Miguru Window Manager"

#include ..\..\MiguruWM\lib\miguru\miguru.ahk

Miguru := MiguruWM({
    defaults: {
        layout: "tall",
        masterSize: 0.5,
        masterCount: 1,
        padding: 0,
        spacing: 1,
    },
})

#HotIf GetKeyState("RAlt", "P") && !GetKeyState("Shift", "P") ; ...........{{{1

;; §  1  2  3  4  5  6  7  8  9  0  -  =
*sc29::return
*sc02::Miguru.SetLayout("floating")
*sc03::Miguru.SetLayout("wide")
*sc04::Miguru.SetLayout("tall")
*sc05::Miguru.SetLayout("fullscreen")
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
*sc11::Miguru.FocusMonitor("primary", -1)
*sc12::Miguru.FocusMonitor("primary")
*sc13::Miguru.FocusMonitor("primary", +1)
*sc14::return
*sc15::return
*sc16::return
*sc17::OpenTaskView()
*sc18::return
*sc19::Miguru.SetMasterSize(, +0.01)
*sc1a::Miguru.SetMasterCount(, -1)
*sc1b::Miguru.SetMasterCount(, +1)
;; a  s  d  f  g  h  j  k  l  ;  '  \
*sc1e::Miguru.FocusWorkspace(1)
*sc1f::Miguru.FocusWorkspace(2)
*sc20::Miguru.FocusWorkspace(3)
*sc21::Miguru.FocusWorkspace(4)
*sc22::Miguru.FocusWorkspace(5)
*sc23::return
*sc24::Miguru.SetMasterSize(, -0.01)
*sc25::return
*sc26::return
*sc27::return
*sc28::return
*sc2b::return
;; `  z  x  c  v  b  n  m  ,  .  /
*sc56::return
*sc2c::return
*sc2d::return
*sc2e::Miguru.FocusWindow("next")
*sc2f::Miguru.FocusWindow("previous")
*sc30::return
*sc31::return
*sc32::Miguru.FocusWindow("master")
*sc33::Send("^,")                    ; Open app settings
*sc34::return
*sc35::return
;; Special
*sc1c::Miguru.SwapWindow("master")

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
*sc11::Miguru.SendToMonitor("primary", -1)
*sc12::Miguru.SendToMonitor("primary")
*sc13::Miguru.SendToMonitor("primary", +1)
*sc14::return
*sc15::return
*sc16::return
*sc17::WinClose("A")
*sc18::return
*sc19::return
*sc1a::return
*sc1b::return
;; a  s  d  f  g  h  j  k  l  ;  '  \
*sc1e::Miguru.SendToWorkspace(1)
*sc1f::Miguru.SendToWorkspace(2)
*sc20::Miguru.SendToWorkspace(3)
*sc21::Miguru.SendToWorkspace(4)
*sc22::Miguru.SendToWorkspace(5)
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
*sc2e::Miguru.SwapWindow("next")
*sc2f::Miguru.SwapWindow("previous")
*sc30::return
*sc31::return
*sc32::return
*sc33::return
*sc34::return
*sc35::return
;; Special
*sc39::CycleLayouts()

; ..........................................................................}}}

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

    current := Miguru.Layout()
    next := cycle[Mod(m[current], cycle.Length) + 1]

    Miguru.SetLayout(next)
}

OpenTaskView() {
    Send("#{Tab}")
}
