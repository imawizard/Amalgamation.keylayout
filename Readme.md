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

# Motivation
Out of frustration with the typing habits I formed over the period of using a computer (with qwerty),
I switched to dvorak to practice touch typing from scratch.
As I use the mouse with my right hand, but dvorak has the most common shortcuts like Cmd-c, Cmd-v, Cmd-t, Cmd-w and Cmd-f
on the right side, I switched the Cmd-layer to qwerty like in macOS's [Dvorak-QWERTY ⌘](https://support.apple.com/guide/mac-help/use-dvorak-keyboard-layouts-mh27976/mac) (at the time I actually used [MSKLC](https://www.microsoft.com/en-us/download/details.aspx?id=102134), [here](https://gist.github.com/imawizard/52bf461f92a146d39455ecf61ce05c09) is an old klc-file for that and [here](https://gist.github.com/imawizard/388fda54cad2c09ff4736c675202d40e) is an old linux port that works by grabbing the input device).

In addition, I can't seem to hit the number row's leftmost key, 5, 6, 7 and its
rightmost key accurately without looking (maybe my fingers are too short?),
which is why I don't bind them at all and relocate the number-row to a custom numpad accessible through modifiers.

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

## Resources
### Layout analysis and letter frequency
* [carpalx - keyboard layout optimizer](http://mkweb.bcgsc.ca/carpalx)
* [Xah Lee - Keyboard Layout Design](http://xahlee.info/kbd/keyboard_layout_keybinding.html)
* [Xah Lee - Computer Languages Characters Frequency](http://xahlee.info/comp/computer_language_char_distribution.html)
* [Michael Dickens - letter frequency graph](https://mdickens.me/typing/letter_frequency.html)
### Tools and platform specifics
* [Keyboard creation — multiplatform technical — what I've learned](https://forum.colemak.com/topic/1658-keyboard-creation-multiplatform-technical-what-ive-learned/)
### Linux grabbing input device
* [Dvorak-Qwerty for Linux](https://github.com/tbocek/dvorak)
### Linux XKB
* [Xorg/Keyboard configuration](https://wiki.archlinux.org/title/Xorg/Keyboard_configuration)
* [Custom keyboard layout definitions](https://help.ubuntu.com/community/Custom%20keyboard%20layout%20definitions)
* [Changing Keyboard Layouts with XKB](https://hack.org/mc/writings/xkb.html)
* [A simple, humble but comprehensive guide to XKB for linux](https://medium.com/@damko/a-simple-humble-but-comprehensive-guide-to-xkb-for-linux-6f1ad5e13450)
