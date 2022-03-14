## Making Alacritty use macOS keybinding like Iterm2 

`last update: 03-14-2022`
The Alacritty configuration is pulled from, [Fatih Arslan's Alacritty integration with Tmux](https://arslan.io/2018/02/05/gpu-accelerated-terminal-alacritty/), the article is from 2018 but is still very relevant for 2022 and works well with Intel and ARM based Macs.

      # ====================================================
      # ===   Mental Notes for my personal workflow     ===
      # ====================================================
      # Everything below is not for related to any kind of TMUX config - but are crucial
      # for my productivity. Setting them up is REALLY painful, and they are being added
      # here so I don't forget them.

      # ===========================================
      # ===   iTerm + Tmux key integration     ===
      # ==========================================
      # First of all, iTerm can send hex codes for shortcuts you define. So for
      # example you can send a hex code for the shortcut "c-f v" which in my case
      # opens a vertical pane (see setting above). The hex code for this combination
      # is: 0x06 0x76. There are many cases to find it out. One of them is the tool
      # 'xxd'

      # If you run "xxd -psd" and hit "c-f v" and then enter and finally c-c to exit
      # , it outputs the following:
      #
      # 	$ xxd -psd
      # 	^Fv
      # 	06760a^C
      #
      # What matters is the sequence  06760a^C where:
      #
      # 	06 -> c-f
      # 	76 -> v
      # 	0a -> return
      #	^C -> c-c
      #
      # From here, we know that 0x06 0x76 corresponds to "c-f v".
      #
      # Finally, inside the iTerm2 Key settings, I'm adding just various shortcuts,
      # such as cmd-j, cmd-left, etc.. , select the option "send hex code" and the
      # enter the hex code which I want to be executed, hence the tmux sequence. So
      # when I press CMD + d in iterm, I send the sequence 0x06 0x76,
      # which tmux interprets it as opening a new pane.
      # ============================================================================

      # ==============================================
      # ===   Alacritty + Tmux key integration    ===
      # =============================================
      # First of all, Alacritty can send hex codes for shortcuts you define. So for
      # example you can send a hex code for the shortcut "c-f v" which in my case
      # opens a vertical pane (see setting above). The hex code for this combination
      # is: 0x06 0x76. There are many cases to find it out. One of them is the tool
      # 'xxd'

      # If you run "xxd -psd" and hit "c-f v" and then enter and finally c-c to exit
      # , it outputs the following:
      #
      # 	$ xxd -psd
      # 	^Fv
      # 	06760a^C
      #
      # What matters is the sequence  06760a^C where:
      #
      # 	06 -> c-f
      # 	76 -> v
      # 	0a -> return
      #	^C -> c-c
      #
      # From here, we know that 0x06 0x76 corresponds to "c-f v".
      #
      # Next step is to add a line to 'key_binding' setting in Alacritty:
      #
      #   - { key: D,        mods: Command,       chars: "\x06\x76"  }
      #
      # That's it! The followings are the ones that I'm using:
      #
      #   key_bindings:
      #     - { key: D,        mods: Command,       chars: "\x06\x76" }
      #     - { key: D,        mods: Command|Shift, chars: "\x06\x73" }
      #     - { key: W,        mods: Command,       chars: "\x06\x78" }
      #     - { key: H,        mods: Command,       chars: "\x06\x68" }
      #     - { key: J,        mods: Command,       chars: "\x06\x6a" }
      #     - { key: K,        mods: Command,       chars: "\x06\x6b" }
      #     - { key: L,        mods: Command,       chars: "\x06\x6c" }
      #     - { key: T,        mods: Command,       chars: "\x06\x63" }
      #     - { key: Key1,     mods: Command,       chars: "\x06\x31" }
      #     - { key: Key2,     mods: Command,       chars: "\x06\x32" }
      #     - { key: Key3,     mods: Command,       chars: "\x06\x33" }
      #     - { key: Key4,     mods: Command,       chars: "\x06\x34" }
      #     - { key: Key5,     mods: Command,       chars: "\x06\x35" }
      #     - { key: Key6,     mods: Command,       chars: "\x06\x36" }
      #     - { key: Key7,     mods: Command,       chars: "\x06\x37" }
      #     - { key: Key8,     mods: Command,       chars: "\x06\x38" }
      #     - { key: Key9,     mods: Command,       chars: "\x06\x39" }
      #     - { key: Left,     mods: Command,       chars: "\x06\x48" }
      #     - { key: Down,     mods: Command,       chars: "\x06\x4a" }
      #     - { key: Up,       mods: Command,       chars: "\x06\x4b" }
      #     - { key: Right,    mods: Command,       chars: "\x06\x4c" }
      #
      # Finally, inside the iTerm2 Key settings, I'm adding just various shortcuts,
      # such as cmd-j, cmd-left, etc.. , select the option "send hex code" and the
      # enter the hex code which I want to be executed, hence the tmux sequence. So
      # when I press CMD + d in iterm, I send the sequence 0x06 0x76,
      # which tmux inteprets it as opening a new pane.
      # ===========================================================================
https://arslan.io/2018/02/05/gpu-accelerated-terminal-alacritty/
