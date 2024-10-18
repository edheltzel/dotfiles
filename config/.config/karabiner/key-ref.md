# CapsLock Enhancements

> *Make CapsLock Great Again!*
>
> [OG Repo](https://github.com/Vonng/Capslock/tree/master)

------------------------

## Key Maps

- [Basic](#Basic)                 :  Press <kbd>⇪</kbd> Capslock  emit an  **<kbd>⎋</kbd> Escape**. Hold it enabling the **<kbd>✱</kbd> Hyper Modifier**.
- [Navigation](#Navigation)       :  Vim style navigation. Cursor move, text selection, switch desktop/window/tab, mouse move/wheel,etc...
- [Deletion](#Deletion)           :  Maps `BNM,` to deletion operation to perform fast char/word/line deletion without hand move.
- [Window](#window-control)       :  Close app/win/tab, Switch app/win/tab/desktop, integration with win-manager app such as Moom,Slate,Magnet
- [Application](#app-shortcuts)   :  Shortcuts for launching or switching frequently used applications
- [Shifter](#Shifter)             :  Turn some keys into common code symbols.

------------------------

## Cheat sheet

Capslock works on **ANSI** keyboards and similar layouts. It literally remaps every [**keys**](#Symbols) on the keyboard. Including 10 categories.

![keyboard](https://github.com/Vonng/Capslock/raw/master/mac_v3/images/keyboard.png)

> **[Control Planes](#Control-Planes)** are defined by combination of four extra left modifiers: <kbd>⌘</kbd><kbd>⌥</kbd><kbd>⌃</kbd><kbd>⇧</kbd>.This image shows the layout of control plane 0.

|           Category            | Color  | Description                                                  |
| :---------------------------: | :----: | :----------------------------------------------------------- |
|        [Basic](#Basic)        |  Blue  | Press <kbd>⇪</kbd> Capslock  emit an  **<kbd>⎋</kbd> Escape**. Hold it enabling the **<kbd>✱</kbd> Hyper Modifier**. |
|   [Navigation](#Navigation)   |  Pink  | Vim style navigation. Cursor move, text selection, switch desktop/window/tab, mouse move/wheel,etc... |
|     [Deletion](#Deletion)     | Brown  | Maps `BNM,` to deletion operation to perform fast char/word/line deletion without hand move. |
|   [Window](#window-control)   | Azure  | Close app/win/tab, Switch app/win/tab/desktop, intergration with win-manager app such as Moom,Slate,Magnet |
| [Application](#app-shortcuts) | Yellow | Shortcuts for launching or switching frequently used applications |
|      [Shifter](#Shifter)      | Orange | Turn some keys into common code symbols.                     |

### Basic

|           Key            |          MapsTo          | Comment                                     |
| :----------------------: | :----------------------: | ------------------------------------------- |
|    <kbd>⇪</kbd> Press    |   <kbd>⎋</kbd> Escape    | Click Capslock to emit Escape               |
|    <kbd>⇪</kbd> Hold     |   <kbd>✱</kbd>  Hyper    | Hold Capslock to enable **Hyper** modifier. |
| <kbd>✱</kbd><kbd>⎋</kbd> |  <kbd>⇪</kbd> Capslock   | Press to switch Capslock status             |
| <kbd>✱</kbd><kbd>␣</kbd> | <kbd>⌃</kbd><kbd>␣</kbd> | Switch input source, +<kbd>⌘</kbd> to emoji |

> Note that <kbd>✱</kbd> is implemented as combination of **ALL RIGHT MODIFIERS**:  <kbd>⌘</kbd><kbd>⌥</kbd><kbd>⌃</kbd><kbd>⇧</kbd>.
>
> Hold  **<kbd>✱</kbd> Hyper** to enable hyper functionalities. We will assume and omit that in subsequent document.

### Navigation

* <kbd>H</kbd>, <kbd>J</kbd>, <kbd>K</kbd>, <kbd>L</kbd>, <kbd>U</kbd>, <kbd>I</kbd>, <kbd>O</kbd>, <kbd>P</kbd> are used as **Navigators**. Maps to <kbd>←</kbd><kbd>↓</kbd><kbd>↑</kbd><kbd>→</kbd><kbd>⇞</kbd><kbd>↖</kbd><kbd>↘</kbd><kbd>⇟</kbd> by default. (pink area).
* 9 control planes has already been allocated for navigators.
* Hold additional <kbd>⌘</kbd> Command for **selection**.  (like holding <kbd>⇧</kbd>shift in normal), additional <kbd>⌥</kbd> Option for **word/para selection**.
* Hold additional <kbd>⇧</kbd> Shift for **app/win/tab switching**.  Hold additional <kbd>⌃</kbd> Control for **desktop management** .
* Hold additional <kbd>⌥</kbd> Option for 🖱️ **mouse move**.  Add <kbd>⇧</kbd>shift to **⏫ accelerate**.  (<kbd>U</kbd>, <kbd>I</kbd>, <kbd>O</kbd>, <kbd>P</kbd> maps to mouse buttons) .
* <kbd>⇧</kbd><kbd>⌥</kbd> turns navigator to **🖲️ mouse wheel**, and <kbd>⇧</kbd><kbd>⌘</kbd> is the ⏫ **accelerated** version .  `HJKL` for wheel, wihle `UIOP` for reversed wheel move.

|   Feature    |   **Move**   |  **Select**  |       **WordSel**        |  **Window**  | **Desktop**  |      🖱️       |          **🖱️⏫**          |            🖲️             |            🖲️⏫            |
| :----------: | :----------: | :----------: | :----------------------: | :----------: | :----------: | :----------: | :----------------------: | :----------------------: | :----------------------: |
|   Key\Mod    | <kbd>✱</kbd> | <kbd>⌘</kbd> | <kbd>⌘</kbd><kbd>⌥</kbd> | <kbd>⇧</kbd> | <kbd>⌃</kbd> | <kbd>⌥</kbd> | <kbd>⇧</kbd><kbd>⌥</kbd> | <kbd>⇧</kbd><kbd>⌃</kbd> | <kbd>⇧</kbd><kbd>⌘</kbd> |
| <kbd>H</kbd> |     Left     |  word left   |        word left         |   prev tab   |  prev desk   |      ⬅️       |            ⬅️⏫            |            ⬅️             |            ⬅️⏫            |
| <kbd>J</kbd> |     Down     |  line down   |       3 line down        |   next app   |    focus     |      ⬇️       |            ⬇️⏫            |            ⬇️             |            ⬇️⏫            |
| <kbd>K</kbd> |      Up      |   line up    |        3 line up         |   prev app   |  expose all  |      ⬆️       |            ⬆️⏫            |            ⬆️             |            ⬆️⏫            |
| <kbd>L</kbd> |    Right     |  word right  |        word right        |   next tab   |  next desk   |      ➡️       |            ➡️⏫            |            ➡️             |            ➡️⏫            |
| <kbd>U</kbd> |     PgUp     |  prev page   |        prev page         |    zoom-     |  fullscreen  |      🖱️L      |            🖱️L            |            ➡️             |            ➡️⏫            |
| <kbd>I</kbd> |     Home     |  line head   |         end2head         |   prev win   |     hide     |      🖱️R      |            🖱️R            |            ⬆️             |            ⬆️⏫            |
| <kbd>O</kbd> |     End      |   line end   |         head2end         |   next win   |   hide all   |      🖱️B      |            🖱️B            |            ⬇️             |            ⬇️⏫            |
| <kbd>P</kbd> |     PgDn     |  next page   |        next page         |    zoom+     |  Launchpad   |      🖱️F      |            🖱️F            |            ⬅️             |            ⬅️⏫            |

**Arrow Navigation**

* Arrows <kbd>←</kbd>↓<kbd>↑</kbd>→ to 🖱️ **mouse**  actions too. Hold <kbd>⌥</kbd> Option to ⏬ **slow down**, hold <kbd>⌘</kbd> Command  to ⏫ **speed up**.
* Hold  <kbd>⇧</kbd> Shift  turns to 🖲️ **wheel move**.  Extra <kbd>⌥</kbd> Option to ⏬ **slow down**, extra <kbd>⌘</kbd> Command  to ⏫ **speed up**.
* <kbd>↩</kbd> Return maps to left **click**.  And additional <kbd>⌘</kbd><kbd>⌥</kbd><kbd>⌃</kbd><kbd>⇧</kbd> turns into right click, middle click, backward, forward.

|                     Feature                      |      🖱️       |      🖱️⏬      |      🖱️⏫      |      🖲️       |            🖲️⏬            |            🖲️⏫            |
| :----------------------------------------------: | :----------: | :----------: | :----------: | :----------: | :----------------------: | :----------------------: |
|                   **Key\Mod**                    | <kbd>✱</kbd> | <kbd>⌥</kbd> | <kbd>⌘</kbd> | <kbd>⇧</kbd> | <kbd>⇧</kbd><kbd>⌥</kbd> | <kbd>⇧</kbd><kbd>⌘</kbd> |
| <kbd>←</kbd><kbd>↓</kbd><kbd>↑</kbd><kbd>→</kbd> | speed = 1600 |  speed ÷ 2   |  speed × 2   |  speed = 32  |        speed ÷ 2         |        speed × 2         |
|                   <kbd>↩</kbd>                   |      🖱️L      |      🖱️M      |      🖱️R      |      🖱️L      |            🖱️B            |            🖱️F            |


### Deletion

<kbd>N</kbd> <kbd>M</kbd> <kbd>,</kbd> <kbd>.</kbd>  are used as **Deletor keys**. Right below the navigators for fast access (brown area).

|   Key\Mod    |   <kbd>✱</kbd>   |    <kbd>⌘</kbd>    |    <kbd>⌥</kbd>    |
| :----------: | :--------------: | :----------------: | :----------------: |
| <kbd>N</kbd> | del a word ahead | del till line head | del the whole line |
| <kbd>M</kbd> | del a char ahead |  del a word ahead  |  move line below   |
| <kbd>,</kbd> | del a char after |  del a word after  |  move line above   |
| <kbd>.</kbd> | del a word after | del till line end  | del the whole line |
| <kbd>⌫</kbd> |     del file     |     purge file     |                    |

### Window Control


* `Tab`, <kbd>Q</kbd>, <kbd>W</kbd>, <kbd>A</kbd>, <kbd>s</kbd> used as window control keys. Focuing on close/switch applications / windows / tabs / desktops. (azure area)
* Windows management (resize, layout) leaves to external application such as [Moom](https://manytricks.com/moom/), [Magnet](https://apps.apple.com/us/app/magnet/id441258766), and [Slate](https://github.com/jigish/slate). Bind <kbd>⌃</kbd><kbd>⌥</kbd><kbd>⇧</kbd><kbd>⌘</kbd>A manually.


|   Key\Mod    | <kbd>✱</kbd> | <kbd>⌘</kbd>  |  <kbd>⌥</kbd>  | <kbd>⌃</kbd>  | <kbd>⇧</kbd> |
| :----------: | :----------: | :-----------: | :------------: | :-----------: | :----------: |
| <kbd>⇥</kbd> |   next app   |   prev app    | switch desktop |               |  switch tab  |
| <kbd>Q</kbd> |  close app   |   close app   |                |  Lock Screen  |    Logout    |
| <kbd>W</kbd> |  close tab   | close all win |                | Display Sleep |    Sleep     |
| <kbd>A</kbd> | **win app**  |  expose all   |  show desktop  |   LaunchPad   |              |
| <kbd>S</kbd> |   next tab   |   prev tab    |    next win    |   prev win    |              |


### App Shortcuts

* <kbd>E</kbd> <kbd>R</kbd> <kbd>T</kbd> <kbd>Y</kbd> <kbd>F</kbd> <kbd>G</kbd> are used as application shortcuts. (yellow area)
* Popular apps and dev tools are registed to 3 default planes: <kbd>✱</kbd>/<kbd>⌘</kbd>/<kbd>⌥</kbd>. Assign these shortcuts according to your own needs.

|   Key\Mod    |        <kbd>✱</kbd>        | <kbd>⌘</kbd>  |   <kbd>⌥</kbd>   |
| :----------: | :------------------------: | :-----------: | :--------------: |
| <kbd>E</kbd> |           Figma            |     Vscode    |     Gmail        |
| <kbd>R</kbd> |     Visual Studio Code     |      Zed      |     Spotify      |
| <kbd>T</kbd> |          WezTerm           |   Obsidian    |      Typora      |
| <kbd>Y</kbd> |        Zen Browser         | Brave Browser | Karabiner Elements |
| <kbd>F</kbd> | Raycast: Clipboard History |    Clickup    |  Invoice Ninja   |
| <kbd>G</kbd> |         Photoshop          |  Illustrator  |     InDesign     |

### Shifter

* Trivial transformation for misc characters. (orange area)
* Some special tricks for developers. Such as `;'` maps to `:=` or `!=` (<kbd>⌘</kbd>)


|    Key\Mod    |       <kbd>✱</kbd>       | <kbd>⌘</kbd> | <kbd>⌥</kbd> |
| :-----------: | :----------------------: | :----------: | :----------: |
| <kbd>-</kbd>  |       <kbd>_</kbd>       |   Zoom Out   |              |
| <kbd>=</kbd>  |       <kbd>+</kbd>       |   Zoom In    |              |
| <kbd>[</kbd>  |       <kbd>(</kbd>       | <kbd>{</kbd> | <kbd><</kbd> |
| <kbd>]</kbd>  |       <kbd>)</kbd>       | <kbd>}</kbd> | <kbd>></kbd> |
| <kbd>;</kbd>  |       <kbd>!</kbd>       | <kbd>:</kbd> |              |
| <kbd>'</kbd>  |       <kbd>=</kbd>       | <kbd>=</kbd> |              |
| <kbd>/</kbd>  | <kbd>⌘</kbd><kbd>/</kbd> |              |              |
| <kbd>\\</kbd> | <kbd>⌘</kbd><kbd>/</kbd> |              |              |

------------------------

## References

### Symbols


|                      Glyph                       |             Name             |          Glyph           |           Name           |
| :----------------------------------------------: | :--------------------------: | :----------------------: | :----------------------: |
|                   <kbd>⇪</kbd>                   |           Capslock           |       <kbd>✱</kbd>       |          Hyper           |
|                   <kbd>⎋</kbd>                   |            Escape            |       <kbd>␣</kbd>       |          Space           |
|                   <kbd>⌘</kbd>                   |        Command (Mac)         |       <kbd>⎇</kbd>       |       Alter (Win)        |
|                   <kbd>⌥</kbd>                   |         Option (Mac)         |       <kbd>⊞</kbd>       |        Win (Win)         |
|                   <kbd>⌃</kbd>                   |           Control            |       <kbd>⇧</kbd>       |          Shift           |
|                   <kbd>↩</kbd>                   |            Return            |       <kbd>⌤</kbd>       |          Enter           |
| <kbd>←</kbd><kbd>↓</kbd><kbd>↑</kbd><kbd>→</kbd> |         Arrow Cursor         | <kbd>↖</kbd><kbd>↘</kbd> |         Home/End         |
|             <kbd>⇥</kbd><kbd>⇤</kbd>             |             Tab              | <kbd>⌫</kbd><kbd>⌦</kbd> |  Delete / ForwardDelete  |
|                   <kbd>⇭</kbd>                   |           Numlock            |            ⏫⏬            |       Fast / Slow        |
|                        🖱️L                        |  Mouse Left Click (Button1)  |            🖱️B            | Mouse Backward (Button4) |
|                        🖱️R                        | Mouse Right Click (Button2)  |            🖱️F            | Mouse Forward (Button5)  |
|                        🖱️                         | Mouse Middle Click (Button3) |            🖲️             |       Mouse Wheel        |



### Control Planes

<details>
<summary>control planes</summary>


| Plane |        Modifiers         | Plane |              Modifiers               | Plane |                          Modifiers                           |
| :---: | :----------------------: | :---: | :----------------------------------: | :---: | :----------------------------------------------------------: |
| **0** |       <kbd>✱</kbd>       |   3   | <kbd>✱</kbd><kbd>⌘</kbd><kbd>⌥</kbd> |   7   |       <kbd>✱</kbd><kbd>⌘</kbd><kbd>⌥</kbd><kbd>⌃</kbd>       |
|   1   | <kbd>✱</kbd><kbd>⌘</kbd> |   5   | <kbd>✱</kbd><kbd>⌘</kbd><kbd>⌃</kbd> |  11   |       <kbd>✱</kbd><kbd>⌘</kbd><kbd>⌥</kbd><kbd>⇧</kbd>       |
|   2   | <kbd>✱</kbd><kbd>⌥</kbd> |   6   | <kbd>✱</kbd><kbd>⌥</kbd><kbd>⌃</kbd> |  13   |       <kbd>✱</kbd><kbd>⌘</kbd><kbd>⌃</kbd><kbd>⇧</kbd>       |
|   4   | <kbd>✱</kbd><kbd>⌃</kbd> |   9   | <kbd>✱</kbd><kbd>⌘</kbd><kbd>⇧</kbd> |  14   |       <kbd>✱</kbd><kbd>⌥</kbd><kbd>⌃</kbd><kbd>⇧</kbd>       |
|   8   | <kbd>✱</kbd><kbd>⇧</kbd> |  10   | <kbd>✱</kbd><kbd>⌥</kbd><kbd>⇧</kbd> |  15   | <kbd>✱</kbd><kbd>⌘</kbd><kbd>⌥</kbd><kbd>⌃</kbd><kbd>⇧</kbd> |
|       |                          |  12   | <kbd>✱</kbd><kbd>⌃</kbd><kbd>⇧</kbd> |       |                                                              |

</details>
