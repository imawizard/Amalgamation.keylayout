# Amalgamation.keylayout
is a mix of [dvorak](https://en.wikipedia.org/wiki/Dvorak_keyboard_layout)
and [qwerty](https://en.wikipedia.org/wiki/QWERTY) for my personal needs.

## Layout
![keyboard-layout](https://user-images.githubusercontent.com/1701648/178594018-df497bcd-4537-47ea-8edf-bb126874a3ca.png)

Color|Meaning
-----|--------
turquoise | taken from dvorak
pink | taken from qwerty
yellow | custom mapping

(Image was generated with [Keyboard-Layout-Editor.com](http://www.keyboard-layout-editor.com) and [this keyboard-layout.json](https://gist.github.com/imawizard/25f131c568214d0be602718104a30a21))

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

