# Amalgamation.keylayout
is a mix of [dvorak](https://en.wikipedia.org/wiki/Dvorak_keyboard_layout) and [qwerty](https://en.wikipedia.org/wiki/QWERTY) for my personal needs.

## Layout

<div align="center">

![keyboard-layout](https://user-images.githubusercontent.com/1701648/232554060-96f1ba30-7e80-4e69-adb3-4ac27efb551b.png)

([KLE](http://www.keyboard-layout-editor.com/#/gists/0f4bb4993db521a2ce5288a6f3d1dc8e))

Color|Position
-----|--------
turquoise | Dvorak
green | Qwerty
yellow | custom

</div>

# Motivation

Out of frustration with the typing habits I formed over the period of using a computer (with qwerty), I switched to dvorak to practice touch typing from scratch.
As I use the mouse with my right hand, but dvorak has the most common shortcuts like Cmd-c, Cmd-v, Cmd-t, Cmd-w and Cmd-f on the right side, I switched the Cmd-layer to qwerty like in macOS's [Dvorak-QWERTY ⌘](https://support.apple.com/guide/mac-help/use-dvorak-keyboard-layouts-mh27976/mac) (at the time I actually used [MSKLC](https://www.microsoft.com/en-us/download/details.aspx?id=102134), [here](https://gist.github.com/imawizard/52bf461f92a146d39455ecf61ce05c09) is an old klc-file for that and [here](https://gist.github.com/imawizard/388fda54cad2c09ff4736c675202d40e) is an old linux port that works by grabbing the input device).

In addition, I can't seem to hit the number row's leftmost key, 5, 6, 7 and its rightmost key accurately without looking (maybe my fingers are too short?), which is why I don't bind them at all and relocate the number-row to a custom numpad accessible through modifiers.

## Changes

やっぱり、 having various applications not correctly recognizing the dead key that translates to symbols is too much trouble, especially in terminals and applications with vim mode.
[Version 1](https://github.com/imawizard/Amalgamation.keylayout/tree/v1#symbols-through-dead-key) actually had most symbols available by means of a dead key, now these are on regular keys again and dead keys have been removed altogether.

## Installation

### macOS

The keyboard layout consists of an xml file whose [format is native to macOS](https://developer.apple.com/library/archive/technotes/tn2056/_index.html), alongside some definitions for [Karabiner Elements](https://github.com/pqrs-org/Karabiner-Elements).

```sh
git clone https://github.com/imawizard/Amalgamation.keylayout layout
cd layout

# Copy the keylayout file to make it appear as input source in keyboard settings.
cp Amalgamation.keylayout "$HOME/Library/Keyboard Layouts/Amalgamation.keylayout" # for the current user
sudo cp Amalgamation.keylayout "/Library/Keyboard Layouts/Amalgamation.keylayout" # or for every user

# Copy the karabiner mappings to make them appear under karabiner's complex modifications.
curl -Lo karabiner-rules.json https://raw.githubusercontent.com/imawizard/dotfiles/master/karabiner/.config/karabiner/assets/complex_modifications/Amalgamation.json
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

### macOS Text Keybindings

* [Text System Defaults and Key Bindings](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/EventOverview/TextDefaultsBindings/TextDefaultsBindings.html)
* [Keybindings Commands](https://developer.apple.com/documentation/appkit/nsstandardkeybindingresponding)
* [Function-Key Unicode Values](https://developer.apple.com/documentation/appkit/1535851-function-key_unicode_values)

### Tools and platform specifics

* [Keyboard creation — multiplatform technical — what I've learned](https://forum.colemak.com/topic/1658-keyboard-creation-multiplatform-technical-what-ive-learned/)

### Linux grabbing input device

* [Dvorak-Qwerty for Linux](https://github.com/tbocek/dvorak)

### Linux XKB

* [Xorg/Keyboard configuration](https://wiki.archlinux.org/title/Xorg/Keyboard_configuration)
* [Custom keyboard layout definitions](https://help.ubuntu.com/community/Custom%20keyboard%20layout%20definitions)
* [Changing Keyboard Layouts with XKB](https://hack.org/mc/writings/xkb.html)
* [A simple, humble but comprehensive guide to XKB for linux](https://medium.com/@damko/a-simple-humble-but-comprehensive-guide-to-xkb-for-linux-6f1ad5e13450)

<!-- vim: set tw=0 wrap ts=4 sw=4 et: -->
