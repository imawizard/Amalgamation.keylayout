# Amalgamation.keylayout
is a mix of [dvorak](https://en.wikipedia.org/wiki/Dvorak_keyboard_layout)
and [qwerty](https://en.wikipedia.org/wiki/QWERTY) for my personal needs.

## Changes
やっぱり having various applications not correctly recognizing the dead key that translates to symbols is too much trouble, especially in applications with vim mode that don't handle them sanely.
[Version 1](https://github.com/imawizard/Amalgamation.keylayout/tree/v1) actually had most symbols available by means of a dead key, now these are on regular keys again and dead keys have been removed altogether.

## Installation
### macOS
The keyboard layout consists of an xml file whose [format is native to macOS](https://developer.apple.com/library/archive/technotes/tn2056/_index.html), alongside some definitions for [Karabiner Elements](https://github.com/pqrs-org/Karabiner-Elements).

```sh
# Copy the keylayout file to make it appear as input source in keyboard settings.
cp Amalgamation.keylayout "$HOME/Library/Keyboard Layouts/Amalgamation.keylayout" # for the current user
sudo cp Amalgamation.keylayout "/Library/Keyboard Layouts/Amalgamation.keylayout" # or for every user

# Copy the karabiner mappings to make them appear under karabiner's complex modifications.
mkdir -p "$HOME/.config/karabiner/assets/complex_modifications' && cp karabiner-rules.json "$_/Amalgamation.json"
```

### Windows
The windows version is an ahk script that is to be interpreted or embedded with [AutoHotkey](https://www.autohotkey.com).
Furthermore it tries to mimic the keyboard experience on macOS by e.g. remapping the Alt-key to simulate Cmd or making the Return-key within Explorer rename files like in Finder, see [amalgamation.ahk](windows).

## Regular layout

  - letters are identical to dvorak
  - numbers are replaced by symbols
  - `[]"\` are identical to qwerty

```
      `  ´  <  >  =  ◌  ◌  ◌  &  (  )  -  ◌  Back
   Tab   ;  ,  .  p  y  f  g  c  r  l  [  ] Return
  Caps   a  o  e  i  u  d  h  t  n  s  "  \
  Shift ◌  %  q  j  k  x  b  m  w  v  z     Shift
  Fn  Ctrl  Opt  Cmd   Space    Cmd  Opt     Ctrl
```

## Shifted layout

  - letters are identical to dvorak
  - symbols on shifted number row are identical to qwerty or removed
  - `{}'|` are identical to qwerty
  - `/+` are on qwerty's `()`

```
      ~  !  @  #  $  ◌  ◌  ◌  *  /  +  _  ◌  Back
   Tab   ?  ^  :  P  Y  F  G  C  R  L  {  } Return
  Caps   A  O  E  I  U  D  H  T  N  S  '  |
  Shift ◌  ☠️  Q  J  K  X  B  M  W  V  Z     Shift
  Fn  Ctrl  Opt  Cmd   Space    Cmd  Opt     Ctrl
```

## Ctrl layout

  - letters are identical to dvorak
  - `C-;` maps to `C-@`
  - `C-,` maps to `C-^`
  - Karabiner: `C-c` maps to `Esc`
  - Karabiner: `C-[` maps to `C-c`
  - Karabiner: ansi grave accent maps to `F11`
  - remaining keys are identical to qwerty

```
    F11  !  \22  §   $   %  \26  /   (   )   =  \1f  `   Back
   Tab   \00 \1e \1c  p   y   f   g  \1b  r   l   c  \1d Return
  Caps    a   o   e   i   u   d   h   t   n   s  \1f \1c
  Shift \3e  ◌   q   j   k   x   b   m   w   v   z      Shift
  Fn   Ctrl   Opt    Cmd     Space      Cmd    Opt      Ctrl
```

## Cmd layout

  - identical to qwerty
  - iso grave accent maps to `⌘<`

```
      §  1  2  3  4  5  6  7  8  9  0  -  =  Back
   Tab   q  w  e  r  t  y  u  i  o  p  [  ] Return
  Caps   a  s  d  f  g  h  j  k  l  ;  '  \
  Shift <  z  x  c  v  b  n  m  ,  .  /     Shift
  Fn  Ctrl  Opt  Cmd   Space    Cmd  Opt     Ctrl
```

## Opt layout

  - Karabiner: `fw` is forward-word
  - Karabiner: `bw` is backward-word
  - Karabiner: `kw` is kill-word
  - Karabiner: `dw` is backward-kill-word

```
      ◌  ◌  ◌  ◌  ◌  ◌  ◌  ◌  ◌  ◌  ◌  ◌  ◌  Back
   Tab   ◌  ◌  ◌  ◌  ◌  fw ◌  ◌  ◌  ◌  ◌  ◌ Return
  Caps   ◌  ◌  ◌  ◌  ◌  kw dw ◌  ◌  ◌  ◌  ◌
  Shift ◌  ◌  ◌  ◌  ◌  ◌  bw ◌  ◌  ◌  ◌     Shift
  Fn  Ctrl  Opt  Cmd   Space    Cmd  Opt     Ctrl
```

## Ctrl-Cmd layout (Karabiner)

```
      ◌  ¹  ²  ³  ⁴  ⁵  ⁶  ⁷  ⁸  ⁹  ⁰  ◌  ◌  Back
   Tab   ◌  ◌  ◌  ◌  ◌  ◌  1  2  3  ◌  ◌  ◌ Return
  Caps   ◌  ◌  ◌  ◌  ◌  ◌  4  5  6  0  ◌  ◌
  Shift ◌  ◌  ◌  ◌  ◌  ◌  ◌  7  8  9  ◌     Shift
  Fn  Ctrl  Opt  Cmd   Space    Cmd  Opt     Ctrl
```

## Dead key ☠️ followed by Regular

```
      ◌  ◌  «  »  ◌  ◌  ◌  ◌  ◌  ◌  ◌  ⟶  ◌  Back
   Tab   ◌  ◌  •  £  ¥  ◌  ◌  ◌  ◌  ◌  ◌  ◌ Return
  Caps   ä  ö  €  ◌  ü  ◌  ◌  ◌  ◌  ß  “  ◌
  Shift ◌  ◌  ◌  ◌  ◌  ✗  ◌  ◌  ₩  ✔︎  ◌     Shift
  Fn  Ctrl  Opt  Cmd   Space    Cmd  Opt     Ctrl
```

## Dead key ☠️ followed by Shifted

```
      ◌  ¡  ◌  ◌  ◌  ◌  ◌  ◌  ◌  ◌  ◌  –  ◌  Back
   Tab   ¿  ◌  …  ◌  ◌  ◌  ◌  ◌  ◌  ◌  ◌  ◌ Return
  Caps   Ä  Ö  ◌  ◌  Ü  ◌  ◌  ◌  ◌  ◌  ”  ◌
  Shift ◌  ◌  ◌  ◌  ◌  ☒  ◌  ◌  ◌  ☑  ◌     Shift
  Fn  Ctrl  Opt  Cmd   Space    Cmd  Opt     Ctrl
```

## Karabiner remaps for specific apps

everywhere
  - Capslock maps to `Ctrl`

Finder:
  - `C-p` maps to `↑`
  - `C-n` maps to `↓`
  - `C-b` maps to `←`
  - `C-o` maps to `→`
  - `C-z`, `C-e`, `C-v`, `C-a`, `C-g` map to `⌃⇧⌘F1-⌃⇧⌘F5`, assignable under `Settings ⟶ Keyboard ⟶ Shortcuts ⟶ Services ⟶ Files and Folders`
  - `⌘r` maps to AppleScript `tell Finder to update every item`

Dash:
  - `C-p` maps to `↑`
  - `C-n` maps to `↓`
  - `C-b` maps to `←`
  - `C-o` maps to `→`
  - `C-k` maps to `⌥↑`
  - `C-j` maps to `⌥↓`

Activity Monitor:
  - `C-p` maps to `↑`
  - `C-n` maps to `↓`
  - `C-b` maps to `←`
  - `C-o` maps to `→`
  - `BS` maps to `⌥⌘q` (kill process)

GitUp, MacPass, Activity Monitor, Adress Book, Sketch:
  - `C-p` maps to `↑`
  - `C-n` maps to `↓`
