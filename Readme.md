`Amalgamation.keylayout` is a keyboard layout that is based on Dvorak and mixes
in Qwerty, dead keys and other remaps.

- [Features](#features)
    - [Dvorak-like layout](#dvorak-like-layout)
    - [Qwerty-⌘ mapping](#qwerty--mapping)
    - [Symbols through Dead Key](#symbols-through-dead-key)
    - [More Symbols through Option](#more-symbols-through-option)
- [Features by means of Karabiner Elements](#features-by-means-of-karabiner-elements)
    - [Right Shift-Numpad](#right-shift-numpad)
    - [General Remaps](#general-remaps)
    - [App-specific Remaps](#app-specific-remaps)
    - [Hotkeys](#hotkeys)
- [Installation](#installation)
- [Caveats](#caveats)
- [Windows Port](#windows-port)

Most of it is specified in an xml file. The format is [.keylayout](https://developer.apple.com/library/archive/technotes/tn2056/_index.html)
which is native to macOS.

For features that are natively not possible, [Karabiner Elements](https://github.com/pqrs-org/Karabiner-Elements)
is used.

### [Features](Amalgamation.keylayout)

#### Dvorak-like layout
The main layout is mostly taken from Dvorak and US Qwerty with the number row
stripped down and a few other changes.

Regular
```
     §  ◌  +  *  <  ◌  ◌  ◌  >  (  )  -  =  Back
   Tab   .  ;  ,  p  y  f  g  c  r  l  [  ] Return
  Caps   a  o  e  i  u  d  h  t  n  s  !  \
  Shift `  •  q  j  k  x  b  m  w  v  z     Shift
  Fn  Ctrl  Opt  Cmd   Space    Cmd  Opt     Ctrl
```

Shifted
```
     ±  ◌  ◌  ◌  ◌  ◌  ◌  ◌  ◌  |  &  _  +  Back
   Tab   ?  ^  `  P  Y  F  G  C  R  L  {  } Return
  Caps   A  O  E  I  U  D  H  T  N  S  ß  |
  Shift ~  ´  Q  J  K  X  B  M  W  V  Z     Shift
  Fn  Ctrl  Opt  Cmd   Space    Cmd  Opt     Ctrl
```

The Ctrl layer mostly maps to Dvorak, except for some additional control
character remappings that might be handy for the terminal or vim. Namely
- `.` is mapped to `⌃@`
- `;` is mapped to `⌃^`
- `,` is mapped to `⌃\`
- `!` is mapped to `⌃_`

```
     °   !  \22  §   $   %  \26  /   (   )   =  \1f  `   Back
   Tab   \00 \1e \1c  p   y   f   g   c   r   l  \1b \1d Return
  Caps    a   o   e   i   u   d   h   t   n   s  \1f \1c
  Shift \3e  ◌   q   j   k   x   b   m   w   v   z      Shift
  Fn  Ctrl  Opt  Cmd   Space    Cmd  Opt     Ctrl
```

#### Qwerty-⌘ mapping
The Cmd layer reverts back to Qwerty, mostly because shortcuts like
`⌘c`, `⌘v`, `⌘t` and `⌘w` would need two hands, while only one hand is needed
for the Qwerty combinations which is handy when using a mouse.

Note: `y` and `z` are switched like in Qwertz.

#### Symbols through Dead Key
The comma in between of `;` and `p` acts as a dead key and introduces a small
new layer that consists of various symbols. So upon pressing `,`, a second key
can be pressed to result in a different key instead. If any non-mapped key
follows the dead key, both a comma and that non-mapped key is output.

```
     ◌  ◌  ◌  ◌  ◌  ◌  ◌  ◌  ◌  ◌  ◌  ◌  ◌  Back
   Tab   ◌  '  ,  "  #  ◌  _  [  ]  ~  ◌  ◌ Return
  Caps   ä  ö  ü  =  \  $  -  {  }  /  ◌  ◌
  Shift ◌  ◌  ◌  ◌  %  ◌  @  :  ◌  ◌  ◌     Shift
  Fn  Ctrl  Opt  Cmd   Space    Cmd  Opt     Ctrl
```

#### More Symbols through Option
`⌥fbhd` are not mapped to symbols but actions, see
[General Remaps](#general-remaps).

Option
```
     →  ¹  ²  ³  ⁴  ⁵  ⁶  ⁷  ⁸  ⁹  ⁰  –  ≠  Back
   Tab   …  ^  `  π  ¥  ◌  ◌  ©  ®  ¡  «  » Return
  Caps   å  ø  €  ƒ  ∂  ◌  ◌  ™  ◌  ∫  ¡  „
  Shift ◦  ∙  ◌  ◌  ◌  ✗  ◌  𐄂  ☐  ✔︎  Ω     Shift
  Fn  Ctrl  Opt  Cmd   Space    Cmd  Opt     Ctrl
```
`^` and ``` ` ``` are dead keys. Combinators are `aoeiu`.

Shifted Option
```
     ⟶  ◌  ½  ⅓  ¼  ⅔  ¾  ◌  ◌  ◌  ◌  —  ±  Back
   Tab   ¿  ◌  ´  ∏  ◌  ◌  ◌  ç  √  ◌  «  » Return
  Caps   Å  Ø  £  ◌  ∆  ◌  ◌  †  ◌  Σ  ◌  “
  Shift ⦾  ⦿  ◌  ◌  ◌  ☒  ◌  µ  ₩  ☑  ◌     Shift
  Fn  Ctrl  Opt  Cmd   Space    Cmd  Opt     Ctrl
```
`´` is a dead key. Combinators are like above, plus `y`.

### [Features by means of Karabiner Elements](karabiner-rules.json)

#### Right Shift-Numpad
```
     ◌  ◌  -  /  ◌  ◌  ◌  ◌  ◌  ◌  ◌  ◌  ◌  Back
   Tab   .  7  8  9  ◌  ◌  ◌  ◌  ◌  ◌  ◌  ◌ Return
  Caps   ◌  4  5  6  ◌  ◌  ◌  ◌  ◌  ◌  ◌  ◌
  Shift ◌  ◌  1  2  3  ◌  ◌  ◌  ◌  ◌  ◌     Shift
  Fn  Ctrl  Opt  Cmd     0      Cmd  Opt     Ctrl
```

#### General Remaps

- Capslock is remapped to Ctrl, `⌃c` is remapped to `Esc`, while `⌃[` is
  remapped to original `⌃c`
- `§` shows the desktop (`F11`)
- `⌥f` is remapped to `⌥→` (_forward-word_), `⌥b` to `⌥←` (_backward-word_),
  both combinable with Shift
- `⌥h` is remapped to `⌥BS` (_backward-kill-word_), `⌥d` to `⌥Del` (_kill-word_)

#### App-specific Remaps

Finder:
- `⌃p` is remapped to `↑`, `⌃n` to `↓`
- `⌃b` is remapped to `←`, `⌃o` to `→`
- `⌃z`, `⌃e`, `⌃v`, `⌃a`, `⌃g` is remapped to `⌃⇧⌘F1`-`⌃⇧⌘F5`, respectively
- `⌘r` is remapped to AppleScript `tell Finder to update every item`

`⌃⇧⌘F1`-`⌃⇧⌘F5` can be assigned to services under
`Settings ⟶ Keyboard ⟶ Shortcuts ⟶ Services ⟶ Files and Folders`.

Dash:
- `⌃p` is remapped to `↑`, `⌃n` to `↓`
- `⌃b` is remapped to `←`, `⌃o` to `→`
- `⌃k` is remapped to `⌥↑`, `⌃j` to `⌥↓`

Activity Monitor:
- `⌃p` is remapped to `↑`, `⌃n` to `↓`
- `⌃b` is remapped to `←`, `⌃o` to `→`
- `BS` is remapped to `⌥⌘q` (kill process)

GitUp, MacPass, Activity Monitor, Adress Book, Sketch:
- `⌃p` is remapped to `↑`, `⌃n` to `↓`

#### Hotkeys
When holding down the right Cmd-key a list of apps can be launched.

- `⌘a` launches _Android Studio_, if Shifted then _Activity Monitor_
- `⌘d` launches _Dash_
- `⌘g` launches _Goland_, if Shifted then _GitUp_
- `⌘t` launches _iTerm_
- `⌘m` launches _Mail_, if Shifted then _MacPass_
- `⌘n` launches _Messages_, if Shifted then _Notes_
- `⌘e` launches _Neovim_
- `⌘o` launches _Opera_

- `⌘p` opens Finder (and presses `⌥F11`)
- `⌘c` opens Mission Control (by pressing `⌃F11`)
- `Shift-⌘c` opens App Exposé (by pressing `⌃⌘F11`)

For mapping _Mission Control_ and _App Exposé_ see
`Settings ⟶ Keyboard ⟶ Shortcuts ⟶ Mission Control`.
To map _Finder_'s `Bring All to Front` to `⌥F11` see _App-Shortcuts_ or execute
```
defaults write com.apple.finder NSUserKeyEquivalents -dict-add "Bring All to Front" "~\\Uf70e"`
 ```

### Installation
```sh
# Copy the keylayout file to make it appear as input source in keyboard settings.
cp Amalgamation.keylayout "$HOME/Library/Keyboard Layouts/Amalgamation.keylayout" # for the current user
sudo cp Amalgamation.keylayout "/Library/Keyboard Layouts/Amalgamation.keylayout" # or for every user

# Copy the karabiner mappings to make them appear under karabiner's complex modifications.
mkdir -p "$HOME/.config/karabiner/assets/complex_modifications' && cp karabiner-rules.json "$_/Amalgamation.json"
```

### Caveats
There are differents methods and APIs for reading the input queue so some apps
might incorrectly handle shortcuts. The more exotic (Java, Electron, GTK) the
more likely. Examples are
1. IntelliJ doesn't recognize the Qwerty-⌘ mappings, so effectively it's
Dvorak-⌘. Also, the comma is interpreted immediately, even though it is dead
key.
2. Meld also has Dvorak-⌘ mappings.
3. Opera works for almost everything fine but ⌘, which would normally open the
settings but instead closes the tab (only on Speed Deal tabs the settings are
opened).

### Windows Port
Similarly, various aspects of the layout are feasible by using _Microsoft
Keyboard Layout Creator_ and editing the resulting klc file to change eg the
virtual keys. However, since resorting to _AutoHotkey_ is still necessary for
emitting special keys or creating custom modifiers¹ , it's more comfortable to
have the complete layout as a single ahk script.

It tries to mimic the behaviour on macOS as closely as possible, see
[amalgamation.ahk](windows).

¹ It's actually possible to specify own modifiers in the data structs that a
compiled keylayout dll has to export. Internally the modifier keys are
hardcoded in Windows, though, so there would be no effect.

