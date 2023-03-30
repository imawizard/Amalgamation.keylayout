ScoopDir() {
    static path := Trim(CmdRet("scoop.cmd config root_path"), "`r`n") ||
        EnvGet("USERPROFILE") "\scoop"
    return path
}

RunTerminal(wd) {
    prog := ScoopDir() "\apps\wezterm-nightly\current\wezterm-gui.exe"
    ShellRun(prog, "start --cwd .", wd)
}

RunEditor(filename, wd) {
    prog := ScoopDir() "\apps\neovim-nightly\current\bin\nvim-qt.exe"
    ShellRun(prog, "`"" filename "`"", wd)
}

RunVSCode(filename, wd) {
    prog := ScoopDir() "\apps\vscode\current\Code.exe"
    ShellRun(prog, "`"" filename "`"", wd)
}

RunGitGui(wd) {
    prog := ScoopDir() "\apps\gitextensions\current\GitExtensions.exe"
    ShellRun(prog, "browse `"" wd "`"", wd)
}

OpenTerminal() {
    wd := EnvGet("USERPROFILE")
    if WinGetProcessName("A") == "explorer.exe" {
        path := GetSHAppFolderPath()
        if path && Substr(path, 1, 2) !== "::" {
            wd := path
        }
    }
    RunTerminal(wd)
}

ShowDesktop() {
    Send("#{sc20}")
}

OpenSearch() {
    Send("#{sc1f}")
}

OpenTaskView() {
    Send("#{Tab}")
}

WS_EX_APPWINDOW  := 0x40000
WS_EX_TOOLWINDOW := 0x80
GW_OWNER         := 4

WM_SYSCOMMAND   := 0x0112
SC_MONITORPOWER := 0xf170
SHUT_OFF        := 2

WTS_CURRENT_SERVER_HANDLE := 0
WTS_CURRENT_SESSION       := -1

RGN_AND       := 1
RGN_COPY      := 5
RGN_DIFF      := 4
RGN_OR        := 2
RGN_XOR       := 3
NULLREGION    := 1
SIMPLEREGION  := 2
COMPLEXREGION := 3

MONITOR_DEFAULTTONEAREST := 2

DWMWA_CLOAKED          := 14
DWM_CLOAKED_APP        := 1
DWM_CLOAKED_SHELL      := 2
DWM_CLOAKED_INHERITED  := 4

SELECT_ITEM_DESELECT         := 1 << 0
SELECT_ITEM_SELECT           := 1 << 1
SELECT_ITEM_EDIT             := 1 << 2 | SELECT_ITEM_SELECT
SELECT_ITEM_UNSELECT_OTHER   := 1 << 3
SELECT_ITEM_SCROLL_INTO_VIEW := 1 << 4
SELECT_ITEM_FOCUS            := 1 << 5
SELECT_ITEM_DEFAULT_FLAGS    := 0
                              | SELECT_ITEM_SELECT
                              | SELECT_ITEM_EDIT
                              | SELECT_ITEM_UNSELECT_OTHER
                              | SELECT_ITEM_SCROLL_INTO_VIEW
                              | SELECT_ITEM_FOCUS

SW_HIDE            := 0
SW_SHOWNORMAL      := 1
SW_SHOWMINIMIZED   := 2
SW_SHOWMAXIMIZED   := 3
SW_SHOWNOACTIVATE  := 4
SW_SHOW            := 5
SW_MINIMIZE        := 6
SW_SHOWMINNOACTIVE := 7
SW_SHOWNA          := 8
SW_RESTORE         := 9
SW_SHOWDEFAULT     := 10
SW_FORCEMINIMIZE   := 11

SWFO_NEEDDISPATCH   := 0x1
SWFO_INCLUDEPENDING := 0x2
SWFO_COOKIEPASSED   := 0x4

SWC_EXPLORER := 0
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

HANDLE_FLAG_INHERIT  := 0x00000001
STARTF_USESTDHANDLES := 0x100
CREATE_NO_WINDOW     := 0x08000000

Launch(win, cmd, forceSingleInstance := true, runAsAdmin := false, minimizeIfActive := false) {
    if forceSingleInstance {
        if WinActive(win) {
            if minimizeIfActive {
                WinMinimize
            }
            return
        } else if WinExist(win) {
            WinActivate
            ControlFocus(win)
            return
        ; } else if Miguru.VD.FocusDesktopWithWindow(win) {
        ;     return
        }
    }
    ShellRun(cmd, , , runAsAdmin ? "runas" : "")
}

; Taken from https://autohotkey.com/boards/viewtopic.php?f=76&t=84266&sid=eff012cadb7a851b2c18f5f03b68408f
CmdRet(cmd, stdin := "", callback := "", encoding := "CP0") {
    inPipeRead := 0
    inPipeWrite := 0
    DllCall(
        "CreatePipe",
        "Ptr*", inPipeRead,
        "Ptr*", inPipeWrite,
        "Ptr", 0,
        "UInt", 0,
        "Int",
    )
    DllCall(
        "SetHandleInformation",
        "Ptr", inPipeRead,
        "UInt", HANDLE_FLAG_INHERIT,
        "UInt", HANDLE_FLAG_INHERIT,
        "Int",
    )

    outPipeRead  := 0
    outPipeWrite := 0
    DllCall(
        "CreatePipe",
        "Ptr*", &outPipeRead,
        "Ptr*", &outPipeWrite,
        "Ptr", 0,
        "UInt", 0,
        "Int",
    )
    DllCall(
        "SetHandleInformation",
        "Ptr", outPipeWrite,
        "UInt", HANDLE_FLAG_INHERIT,
        "UInt", HANDLE_FLAG_INHERIT,
        "Int",
    )

    siSize := A_PtrSize*4 + 4*8 + A_PtrSize*5
    STARTUPINFO := Buffer(siSize, 0)
    NumPut("UInt",  siSize,               STARTUPINFO, 0)
    NumPut("UInt",  STARTF_USESTDHANDLES, STARTUPINFO, A_PtrSize*4 + 4*7)
    NumPut("Int64", inPipeRead,           STARTUPINFO, A_PtrSize*4 + 4*8 + A_PtrSize*2)
    NumPut("Int64", outPipeWrite,         STARTUPINFO, A_PtrSize*4 + 4*8 + A_PtrSize*3)
    NumPut("Int64", outPipeWrite,         STARTUPINFO, A_PtrSize*4 + 4*8 + A_PtrSize*4)

    PROCESS_INFORMATION := Buffer(A_PtrSize*2 + 4*2)
    ret := DllCall(
        "CreateProcess",
        "Ptr", 0,
        "Str", cmd,
        "Ptr", 0,
        "Ptr", 0,
        "UInt", true,
        "UInt", CREATE_NO_WINDOW,
        "Ptr", 0,
        "Ptr", 0,
        "Ptr", STARTUPINFO,
        "Ptr", PROCESS_INFORMATION,
        "Int",
    )

    DllCall(
        "CloseHandle",
        "Ptr", outPipeWrite,
        "Int",
    )
    DllCall(
        "CloseHandle",
        "Ptr", inPipeRead,
        "Int",
    )

    if !ret {
        DllCall(
            "CloseHandle",
            "Ptr", outPipeRead,
            "Int",
        )
        DllCall(
            "CloseHandle",
            "Ptr", inPipeWrite,
            "Int",
        )

        throw Error("CreateProcess is failed")
    }

    if stdin {
        w := FileOpen(inPipeWrite, "h")
        w.Write(stdin)
        w.Close()
    }
    DllCall(
        "CloseHandle",
        "Ptr", inPipeWrite,
        "Int",
    )

    output  := ""
    buf := Buffer(4096)
    read := 0
    while DllCall(
        "ReadFile",
        "Ptr", outPipeRead,
        "Ptr", buf,
        "UInt", buf.Size,
        "UInt*", &read,
        "UInt", 0,
        "Int",
    ) {
        text := StrGet(buf, read, encoding)
        (callback && callback.Call(text))
        output .= text
    }
    DllCall(
        "CloseHandle",
        "Ptr", outPipeRead,
        "Int",
    )

    hProcess := NumGet(PROCESS_INFORMATION, 0, "Int64")
    hThread := NumGet(PROCESS_INFORMATION, A_PtrSize, "Int64")
    DllCall(
        "CloseHandle",
        "Ptr", hProcess,
        "Int",
    )
    DllCall(
        "CloseHandle",
        "Ptr", hThread,
        "Int",
    )

    return output
}

; Taken from https://github.com/Lexikos/AutoHotkey-Release/blob/master/installer/source/Lib/ShellRun.ahk
; Also see https://devblogs.microsoft.com/oldnewthing/20131118-00/?p=2643
; and https://devblogs.microsoft.com/oldnewthing/20130318-00/?p=4933
; Operation can be one of {explorer find open print runas}
ShellRun(cmd, params := "", dir := "", operation := "open", show := SW_SHOWNORMAL) {
    windows := ComObject("Shell.Application").Windows
    hwnd := Buffer(A_PtrSize)
    hwndRef := ComValue(VT_BYREF | VT_I4, hwnd.Ptr)
    desktop := windows.FindWindowSW(0, "", SWC_DESKTOP, hwndRef, SWFO_NEEDDISPATCH)

    DllCall("AllowSetForegroundWindow", "UInt", -1, "Int")

    ; Retrieve top-level browser object.
    if ptlb := ComObjQuery(
        desktop,
        SID_STopLevelBrowser,
        IID_IShellBrowser,
    ) {
        ; IShellBrowser.QueryActiveShellView -> IShellView
        psv := 0
        res := ComCall(
            15,
            ptlb,
            "Ptr*", &psv,
            "Int",
        )
        if res == 0 {
            ; Define IID_IDispatch.
            IID_IDispatch := Buffer(16)
            NumPut(
                "Int64", 0x0000000000020400,
                "Int64", 0x46000000000000C0,
                IID_IDispatch,
            )

            ; IShellView.GetItemObject -> IDispatch (object which implements IShellFolderViewDual)
            pdisp := 0
            ComCall(
                15,
                psv,
                "UInt", 0,
                "Ptr", IID_IDispatch,
                "Ptr*", &pdisp,
                "Int",
            )

            ; Get Shell object.
            shell := ComObjFromPtr(pdisp).Application

            ; IShellDispatch2.ShellExecute
            shell.ShellExecute(cmd, params, dir, operation, show)

            ObjRelease(psv)
        }
    }
}

; Get explorer's current folder
; See https://docs.microsoft.com/en-us/windows/win32/shell/shellfolderview
; also, explore COM objects in PowerShell with:
;   $w = (New-Object -ComObject Shell.Application).Windows(0)
GetSHAppFolderPath(hwnd := 0) {
    if !hwnd {
        hwnd := WinExist("A")
    }
    res := ""
    com := ComObject("Shell.Application")
    for window in com.Windows {
        if window && window.hwnd == hwnd {
            res := window.Document.Folder.Self.Path
            break
        }
    }
    return res
}

; Get an explorer-window's selected filenames
; See https://docs.microsoft.com/en-us/windows/win32/shell/shellfolderview
; and https://docs.microsoft.com/en-us/windows/win32/shell/shellfolderview-selecteditems
GetSHAppSelectionPaths(hwnd := 0) {
    if !hwnd {
        hwnd := WinExist("A")
    }
    res := ""
    com := ComObject("Shell.Application")
    for window in com.Windows {
        if window && window.hwnd == hwnd {
            for item in window.Document.SelectedItems {
                res := res ";" item.Path
            }
            res := Substr(res, 2)
            break
        }
    }
    return res
}

; Get the desktop's selection.
GetDesktopSelectionPaths(ctrlClass) {
    selected := ListViewGetContent("Selected Col1", ctrlClass)
    filepath := ""
    loop parse selected, "`n", "`r" {
        filepath := filepath ";" A_Desktop "\" A_LoopField
    }
    if filepath {
        filepath := Substr(filepath, 2)
    } else {
        filepath := A_Desktop
    }
    return filepath
}

; Select a file within an explorer-window
; See https://docs.microsoft.com/en-us/windows/win32/shell/shellfolderview-selectitem
; and https://docs.microsoft.com/en-us/windows/win32/shell/folderitems
FocusSHAppItem(filename, flags := SELECT_ITEM_DEFAULT_FLAGS, hwnd := 0) {
    if !hwnd {
        hwnd := WinExist("A")
    }
    res := false
    com := ComObject("Shell.Application")
    for window in com.Windows {
        if window && window.hwnd == hwnd {
            item := window.Document.Folder.ParseName(filename)
            window.Document.SelectItem(item, flags)
            res := true
            break
        }
    }
    return res
}

; Navigate within an explorer-window
; Use file:/// or shell: with a folder name. For possible folder names, see
; HKLM\Software\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions
NavigateSHApp(path, hwnd := 0) {
    if !hwnd {
        hwnd := WinExist("A")
    }
    res := false
    com := ComObject("Shell.Application")
    for window in com.Windows {
        if window && window.hwnd == hwnd {
            window.Navigate(path)
            res := true
            break
        }
    }
    return res
}

; Switch between an app's windows
SwitchToNextWindow(hwnd := 0) {
    if !hwnd {
        hwnd := WinExist("A")
    }
    winclass := WinGetClass("ahk_id" hwnd)
    procname := WinGetProcessName("ahk_id" hwnd)
    windows := WinGetList("ahk_class" winclass)
    i := windows.Length + 1
    loop {
        if --i == 0 {
            break
        }
        window := windows[i]
        tmp := WinGetProcessName("ahk_id" window)
        if tmp == procname {
            WinActivate("ahk_id" window)
            break
        }
    }
}

; Taken from https://autohotkey.com/boards/viewtopic.php?t=28760#p326541
AltTabWindows() {
    old := A_DetectHiddenWindows
    DetectHiddenWindows(false)
    windows := WinGetList()
    DetectHiddenWindows(old)

    res := []
    for hwnd in windows {
        owner := hwnd
        loop {
            tmp := DllCall(
                "GetWindow",
                "Ptr", owner,
                "UInt", GW_OWNER,
                "Ptr",
            )
            if !tmp {
                break
            }
            owner := tmp
        }

        popup := DllCall(
            "GetLastActivePopup",
            "Ptr", owner,
            "Ptr",
        )
        if popup == hwnd {
            style := WinGetExStyle("ahk_id" hwnd)
            if (style & WS_EX_APPWINDOW || !(style & WS_EX_TOOLWINDOW))
                && !IsInvisibleWin10BackgroundAppWindow(hwnd) {
                res.Push(Format("0x{:x}", hwnd))
            }
        }
    }
    return res
}

IsInvisibleWin10BackgroundAppWindow(hwnd) {
    value := Buffer(A_PtrSize)
    if DllCall(
        "dwmapi.dll\DwmGetWindowAttribute",
        "Ptr", hwnd,
        "UInt", DWMWA_CLOAKED,
        "Ptr", value,
        "UInt", A_PtrSize,
        "Int",
    ) != 0 {
        return false
    }
    return NumGet(value, "UInt") != 0
}

; Predictable version of Send !{Escape}
CycleVisibleWindows(dir := "next") {
    windows := AltTabWindows()
    visible := FilterForegroundWindows(windows)
    if visible.Length() == 1 {
        visible := windows
    }
    sorted := SortWindowsByAngle(visible, dir != "next")

    loop sorted.Length()
        next := A_Index+1
    Until (WinActive("A") == sorted[A_Index])

    if next > sorted.Length() {
        next := 1
    }

    WinActivate("ahk_id" sorted[next])
}

FilterForegroundWindows(windows) {
    workAreaLeft := 0
    workAreaRight := 0
    workAreaTop := 0
    workAreaBottom := 0
    combined := DllCall(
        "CreateRectRgn",
        "Int", 0,
        "Int", 0,
        "Int", 0,
        "Int", 0,
        "Ptr",
    )

    res := []
    for i, hwnd in windows {
        if DllCall(
            "IsIconic",
            "Ptr", hwnd,
            "Int",
        ) {
            continue
        }

        WinGetPos(&x, &y, &width, &height, "ahk_id" hwnd)

        rgn := DllCall(
            "CreateRectRgn",
            "Int", Max(x, workAreaLeft),
            "Int", Max(y, workAreaTop),
            "Int", Min(x + width, workAreaRight),
            "Int", Min(y + height, workAreaBottom),
            "Ptr",
        )

        tmp := DllCall(
            "CreateRectRgn",
            "Int", 0,
            "Int", 0,
            "Int", 0,
            "Int", 0,
            "Ptr",
        )

        type := DllCall(
            "CombineRgn",
            "Ptr", tmp,
            "Ptr", rgn,
            "Ptr", combined,
            "Int", RGN_DIFF,
            "Int",
        )

        DllCall(
            "DeleteObject",
            "Ptr", tmp,
            "Int",
        )

        if type != NULLREGION {
            DllCall(
                "CombineRgn",
                "Ptr", combined,
                "Ptr", combined,
                "Ptr", rgn,
                "Int", RGN_OR,
                "Int",
            )

            res.Push(hwnd)
        }

        DllCall(
            "DeleteObject",
            "Ptr", rgn,
            "Int",
        )
    }

    DllCall(
        "DeleteObject",
        "Ptr", combined,
        "Int",
    )
    return res
}

SortWindowsByAngle(windows, reverse := false) {
    list := ""
    for i, hwnd in windows {
        list .= "`n" hwnd
    }
    list := Substr(list, 2)
    Sort(list, SortWindowsByAngleCallback)

    res := []
    loop parse list, "`n" {
        if !reverse {
            res.Push(A_LoopField)
        } else {
            res.InsertAt(1, A_LoopField)
        }
    }
    return res
}

SortWindowsByAngleCallback(a, b) {
    av := GetTopLeftAsAngle(a)
    bv := GetTopLeftAsAngle(b)

    if av > bv {
        return 1
    } else if av < bv {
        return -1
    } else {
        return a - b
    }
}

GetTopLeftAsAngle(hwnd) {
    Static xo := A_ScreenWidth / 2
    Static yo := A_ScreenHeight / 2
    Static PI := 4 * ATan(1)

    WinGetPos(&x, &y, , , "ahk_id" hwnd)
    x := x - xo
    y := y - yo

    return DllCall(
        "msvcrt.dll\atan2",
        "Double", y,
        "Double", x,
        "cdecl Double",
    ) * 180 / PI + 180
}

; Resize the active window
ResizeWindow(sizing) {
    delta := 0
    if sizing == "larger" {
        delta := 20
    } else if sizing == "smaller" {
        delta := -20
    }
    WinGetPos(&x, &y, &width, &height, "A")
    WinMove(x - delta, y - delta, width + delta * 2, height + delta * 2, "A")
}

CenterWindow(hwnd := 0) {
    if !hwnd {
        hwnd := WinExist("A")
    }
    WinGetPos(, , &width, &height)
    info := Buffer(10 * 4)
    NumPut("UInt", 10 * 4, info) ; cbSize, rcMonitor, rcWork, dwFlags
    monitor := DllCall(
        "MonitorFromWindow",
        "Ptr", hwnd,
        "UInt", MONITOR_DEFAULTTONEAREST,
        "Ptr",
    )
    DllCall(
        "GetMonitorInfo",
        "Ptr", monitor,
        "Ptr", info,
        "Int",
    )
    rcWorkLeft   := NumGet(info, 5 * 4, "Int")
    rcWorkTop    := NumGet(info, 6 * 4, "Int")
    rcWorkRight  := NumGet(info, 7 * 4, "Int")
    rcWorkBottom := NumGet(info, 8 * 4, "Int")
    x := (rcWorkRight - width) / 2
    y := (rcWorkBottom - height) / 2
    WinMove(x, y, , , "A")
}

LockWorkStation() {
    disabled := RegRead("HKEY_CURRENT_USER\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System", "DisableLockWorkstation", false)
    if !disabled {
        DllCall("LockWorkStation")
        return
    }

    DllCall(
        "wtsapi32.dll\WTSDisconnectSession",
        "Ptr", WTS_CURRENT_SERVER_HANDLE,
        "UInt", WTS_CURRENT_SESSION,
        "Int", 1,
        "Int",
    )
}

PowerOffMonitor() {
    SendMessage(WM_SYSCOMMAND, SC_MONITORPOWER, SHUT_OFF, , "Program Manager")
}

EXPLORER_CONTENT := "DirectUIHWND2"
EXPLORER_SIDEBAR := "SysTreeView321"
EXPLORER_DESKTOP := "SysListView321"

; Go one level up if the active window is an explorer
ExplorerOneLevelUp() {
    try {
        c := ControlGetClassNN(ControlGetFocus("A"))
    } catch TargetError {
        return
    }
    if c == EXPLORER_SIDEBAR {
        Send("{Left}{Enter}")
    } else if c == EXPLORER_CONTENT {
        Send("!{Up}")
    } else {
        Send("{Left}")
    }
}

; Go one level down if the active window is an explorer
ExplorerOneLevelDown() {
    try {
        c := ControlGetClassNN(ControlGetFocus("A"))
    } catch TargetError {
        return
    }
    if c == EXPLORER_SIDEBAR {
        Send("{Right}{Enter}")
    } else if c == EXPLORER_CONTENT {
        Send("{Enter}")
    } else {
        Send("{Right}")
    }
}

; Select the previous item if the active window is an explorer
ExplorerPreviousItem() {
    try {
        c := ControlGetClassNN(ControlGetFocus("A"))
    } catch TargetError {
        return
    }
    if c == EXPLORER_SIDEBAR {
        Send("{Up}{Enter}")
    } else if c == EXPLORER_CONTENT {
        Send("{Up}")
    } else {
        Send("{Up}")
    }
}

; Select the next item if the active window is an explorer
ExplorerNextItem() {
    try {
        c := ControlGetClassNN(ControlGetFocus("A"))
    } catch TargetError {
        return
    }
    if c == EXPLORER_SIDEBAR {
        Send("{Down}{Enter}")
    } else if c == EXPLORER_CONTENT {
        Send("{Down}")
    } else {
        Send("{Down}")
    }
}

; Open the selected folder in the terminal if the active window is an explorer
ExplorerOpenInTerminal() {
    filepath := ""
    try {
        c := ControlGetClassNN(ControlGetFocus("A"))
    } catch TargetError {
        return
    }
    if c == EXPLORER_DESKTOP {
        filepath := GetDesktopSelectionPaths(c)
    } else {
        filepath := GetSHAppSelectionPaths()
        if !filepath {
            filepath := GetSHAppFolderPath()
        }
    }
    if filepath {
        loop parse filepath, "`;" {
            if InStr(FileExist(A_LoopField), "D") {
                RunTerminal(A_LoopField)
            } else if InStr(FileExist(A_LoopField), "A") {
                SplitPath(A_LoopField, , &dirname)
                RunTerminal(dirname)
            }
        }
    }
}

; Open the selected files in the editor if the active window is an explorer
ExplorerOpenInEditor() {
    filepath := ""
    try {
        c := ControlGetClassNN(ControlGetFocus("A"))
    } catch TargetError {
        return
    }
    if c == EXPLORER_DESKTOP {
        filepath := GetDesktopSelectionPaths(c)
    } else if c == EXPLORER_CONTENT {
        filepath := GetSHAppSelectionPaths()
    } else if c == EXPLORER_SIDEBAR {
        filepath := GetSHAppFolderPath()
    }
    if filepath {
        loop parse filepath, "`;" {
            if InStr(FileExist(A_LoopField), "D") {
                RunEditor(A_LoopField, A_LoopField)
            } else if InStr(FileExist(A_LoopField), "A") {
                SplitPath(A_LoopField, , &dirname)
                RunEditor(A_LoopField, dirname)
            }
        }
    }
}

; Open the selected files in VS Code if the active window is an explorer
ExplorerOpenInCode() {
    filepath := ""
    try {
        c := ControlGetClassNN(ControlGetFocus("A"))
    } catch TargetError {
        return
    }
    if c == EXPLORER_DESKTOP {
        filepath := GetDesktopSelectionPaths(c)
    } else if c == EXPLORER_CONTENT {
        filepath := GetSHAppSelectionPaths()
    } else if c == EXPLORER_SIDEBAR {
        filepath := GetSHAppFolderPath()
    }
    if filepath {
        loop parse filepath, "`;" {
            if InStr(FileExist(A_LoopField), "D") {
                RunVSCode(A_LoopField, A_LoopField)
            } else if InStr(FileExist(A_LoopField), "A") {
                SplitPath(A_LoopField, , &dirname)
                RunVSCode(A_LoopField, dirname)
            }
        }
    }
}

; Open the selected folder in the git gui if the active window is an explorer
ExplorerOpenInGitGui() {
    filepath := ""
    try {
        c := ControlGetClassNN(ControlGetFocus("A"))
    } catch TargetError {
        return
    }
    if c == EXPLORER_DESKTOP {
        filepath := GetDesktopSelectionPaths(c)
    } else {
        filepath := GetSHAppSelectionPaths()
        if !filepath {
            filepath := GetSHAppFolderPath()
        }
    }
    if filepath {
        loop parse filepath, "`;" {
            if InStr(FileExist(A_LoopField), "D") {
                RunGitGui(A_LoopField)
            } else if InStr(FileExist(A_LoopField), "A") {
                SplitPath(A_LoopField, , &dirname)
                RunGitGui(dirname)
            }
        }
    }
}

; Rename the selected item if the active window is an explorer
ExplorerRename() {
    try {
        c := ControlGetClassNN(ControlGetFocus("A"))
    } catch TargetError {
        return
    }
    if c == EXPLORER_CONTENT
        || c == EXPLORER_DESKTOP
        || c == EXPLORER_SIDEBAR {
        Send("{F2}")
    } else {
        Send("{Enter}")
    }
}

; Copy the selected items' paths if the active window is an explorer
ExplorerCopyFilepath() {
    filepath := ""
    try {
        c := ControlGetClassNN(ControlGetFocus("A"))
    } catch TargetError {
        return
    }
    if c == EXPLORER_CONTENT {
        filepath := GetSHAppSelectionPaths()
    } else if c == EXPLORER_SIDEBAR {
        filepath := GetSHAppFolderPath()
    }
    if filepath {
        A_Clipboard := filepath
    }
}

; Create new text file if the active window is an explorer
ExplorerCreateNewTextfile() {
    try {
        c := ControlGetClassNN(ControlGetFocus("A"))
    } catch TargetError {
        return
    }
    if c == EXPLORER_DESKTOP {
        cwd := A_Desktop
    } else {
        cwd := GetSHAppFolderPath()
    }
    if !cwd || Substr(cwd, 1, 2) == "::" {
        return
    }

    dest := cwd "\Untitled"
    ext := ".txt"
    n := 1
    loop {
        if n > 1 {
            path := dest n ext
        } else {
            path := dest ext
        }
        if !FileExist(path) {
            FileOpen(path, "w")
            SplitPath(path, &filename)
            FocusSHAppItem(filename, 1 + 4 + 8 + 16)
            return
        }
        n++
    }
}

LaunchExplorer() {
    EXPLORER_WIN := "ahk_class CabinetWClass"
    EXPLORER_RUN := "explorer.exe"

    Launch(EXPLORER_WIN, EXPLORER_RUN)
    ControlFocus(EXPLORER_CONTENT, EXPLORER_WIN)
}

ExplorerNavigate(path) {
    NavigateSHApp(path)
    Send("{Tab}{Up}{Home}")
}
