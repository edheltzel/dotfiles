import fs from "fs";
import { KarabinerRules } from "./types";
import { createHyperSubLayers, app, open, rectangle, shell } from "./utils";

const rules: KarabinerRules[] = [
  // Hyper key it set with QMK/VIA
  // caps_lock = hyper & enter = hyper when held enter when tapped
  {
    description: "Hyper Navigation",
    manipulators: [
      {
        description: "h = left",
        from: {
          key_code: "h",
          modifiers: {
            mandatory: [
              "right_command",
              "right_control",
              "right_shift",
              "right_option",
            ],
          },
        },
        to: [{ key_code: "left_arrow" }],
        type: "basic",
      },
      {
        description: "k = up",
        from: {
          key_code: "k",
          modifiers: {
            mandatory: [
              "right_command",
              "right_control",
              "right_shift",
              "right_option",
            ],
          },
        },
        to: [{ key_code: "up_arrow" }],
        type: "basic",
      },
      {
        description: "j = down",
        from: {
          key_code: "j",
          modifiers: {
            mandatory: [
              "right_command",
              "right_control",
              "right_shift",
              "right_option",
            ],
          },
        },
        to: [{ key_code: "down_arrow" }],
        type: "basic",
      },
      {
        description: "l = right",
        from: {
          key_code: "j",
          modifiers: {
            mandatory: [
              "right_command",
              "right_control",
              "right_shift",
              "right_option",
            ],
          },
        },
        to: [{ key_code: "right_arrow" }],
        type: "basic",
      },
      {
        description: "u = page_up",
        from: {
          key_code: "u",
          modifiers: {
            mandatory: [
              "right_command",
              "right_control",
              "right_shift",
              "right_option",
            ],
          },
        },
        to: [{ key_code: "page_up" }],
        type: "basic",
      },
      {
        description: "i = page_down",
        from: {
          key_code: "i",
          modifiers: {
            mandatory: [
              "right_command",
              "right_control",
              "right_shift",
              "right_option",
            ],
          },
        },
        to: [{ key_code: "page_down" }],
        type: "basic",
      },
    ],
  },
  ...createHyperSubLayers({
    // Open Scripts/Links -> cording hyper + alt + key
    left_alt:{
      c: open("https://app.clickup.com/2308619/home"),
      d: open("raycast://script-commands/edit-dotfiles"), // Macro 2
      t: open("raycast://script-commands/run-topgrade"), // Macro 1
      m: app("Mail"),
    },
    // Open Apps -> cording hyper + cmd + key
    left_command: {
      d: app("Adobe InDesign 2025"),
      f: app("Invoice Ninja"),
      i: app("Adobe Illustrator"),
      m: app("Microsoft Teams"),
      r: app("Spotify"),
      v: app("Via"),
      y: app("Zen Browser"),
      z: app("Zed"),
    },
    // o = "Open" applications
    o: {
      d: app("Discord"),
      1: app("1Password"),
      g: app("Google Chrome"),
      c: app("Notion Calendar"),
      s: app("Slack"),
      e: app("Superhuman"),
      n: app("Notion"),
      t: app("Terminal"),
      h: open(
        "notion://www.notion.so/stellatehq/7b33b924746647499d906c55f89d5026"
      ),
      z: app("zoom.us"),
      m: app("Reflect"),
      r: app("Reflect"),
      f: app("Finder"),
      // "i"Message
      i: app("Texts"),
      p: app("Spotify"),
      a: app("iA Presenter"),
      // "W"hatsApp has been replaced by Texts
      w: open("Texts"),
      l: open(
        "raycast://extensions/stellate/mxstbr-commands/open-mxs-is-shortlink"
      ),
    },

    // w = "Window" via rectangle.app
    w: {
      semicolon: {
        description: "Window: Hide",
        to: [
          {
            key_code: "h",
            modifiers: ["right_command"],
          },
        ],
      },
      y: rectangle("previous-display"),
      o: rectangle("next-display"),
      k: rectangle("top-half"),
      j: rectangle("bottom-half"),
      h: rectangle("left-half"),
      l: rectangle("right-half"),
      f: rectangle("maximize"),
      u: {
        description: "Window: Previous Tab",
        to: [
          {
            key_code: "tab",
            modifiers: ["right_control", "right_shift"],
          },
        ],
      },
      i: {
        description: "Window: Next Tab",
        to: [
          {
            key_code: "tab",
            modifiers: ["right_control"],
          },
        ],
      },
      n: {
        description: "Window: Next Window",
        to: [
          {
            key_code: "grave_accent_and_tilde",
            modifiers: ["right_command"],
          },
        ],
      },
      b: {
        description: "Window: Back",
        to: [
          {
            key_code: "open_bracket",
            modifiers: ["right_command"],
          },
        ],
      },
      // Note: No literal connection. Both f and n are already taken.
      m: {
        description: "Window: Forward",
        to: [
          {
            key_code: "close_bracket",
            modifiers: ["right_command"],
          },
        ],
      },
    },

    // s = "System"
    s: {
      u: {
        to: [
          {
            key_code: "volume_increment",
          },
        ],
      },
      j: {
        to: [
          {
            key_code: "volume_decrement",
          },
        ],
      },
      i: {
        to: [
          {
            key_code: "display_brightness_increment",
          },
        ],
      },
      k: {
        to: [
          {
            key_code: "display_brightness_decrement",
          },
        ],
      },
      l: {
        to: [
          {
            key_code: "q",
            modifiers: ["right_control", "right_command"],
          },
        ],
      },
      p: {
        to: [
          {
            key_code: "play_or_pause",
          },
        ],
      },
      semicolon: {
        to: [
          {
            key_code: "fastforward",
          },
        ],
      },
      e: open(
        `raycast://extensions/thomas/elgato-key-light/toggle?launchType=background`
      ),
      // "D"o not disturb toggle
      d: open(
        `raycast://extensions/yakitrak/do-not-disturb/toggle?launchType=background`
      ),
      // "T"heme
      t: open(`raycast://extensions/raycast/system/toggle-system-appearance`),
      c: open("raycast://extensions/raycast/system/open-camera"),
      // 'v'oice
      v: {
        to: [
          {
            key_code: "spacebar",
            modifiers: ["left_option"],
          },
        ],
      },
    },

    // v = "moVe" which isn't "m" because we want it to be on the left hand
    // so that hjkl work like they do in vim
    v: {
      h: {
        to: [{ key_code: "left_arrow" }],
      },
      j: {
        to: [{ key_code: "down_arrow" }],
      },
      k: {
        to: [{ key_code: "up_arrow" }],
      },
      l: {
        to: [{ key_code: "right_arrow" }],
      },
      // Magicmove via homerow.app
      m: {
        to: [{ key_code: "f", modifiers: ["right_control"] }],
        // TODO: Trigger Vim Easymotion when VSCode is focused
      },
      // Scroll mode via homerow.app
      s: {
        to: [{ key_code: "j", modifiers: ["right_control"] }],
      },
      d: {
        to: [{ key_code: "d", modifiers: ["right_shift", "right_command"] }],
      },
      u: {
        to: [{ key_code: "page_down" }],
      },
      i: {
        to: [{ key_code: "page_up" }],
      },
    },

    // c = Musi*c* which isn't "m" because we want it to be on the left hand
    c: {
      p: {
        to: [{ key_code: "play_or_pause" }],
      },
      n: {
        to: [{ key_code: "fastforward" }],
      },
      b: {
        to: [{ key_code: "rewind" }],
      },
    },

    // r = "Raycast"
    r: {
      c: open("raycast://extensions/thomas/color-picker/pick-color"),
      n: open("raycast://script-commands/dismiss-notifications"),
      l: open(
        "raycast://extensions/stellate/mxstbr-commands/create-mxs-is-shortlink"
      ),
      e: open(
        "raycast://extensions/raycast/emoji-symbols/search-emoji-symbols"
      ),
      p: open("raycast://extensions/raycast/raycast/confetti"),
      a: open("raycast://extensions/raycast/raycast-ai/ai-chat"),
      s: open("raycast://extensions/peduarte/silent-mention/index"),
      h: open(
        "raycast://extensions/raycast/clipboard-history/clipboard-history"
      ),
      1: open(
        "raycast://extensions/VladCuciureanu/toothpick/connect-favorite-device-1"
      ),
      2: open(
        "raycast://extensions/VladCuciureanu/toothpick/connect-favorite-device-2"
      ),
    },
  }),
  {
    description: "Change Backspace to Spacebar when Minecraft is focused",
    manipulators: [
      {
        type: "basic",
        from: {
          key_code: "delete_or_backspace",
        },
        to: [
          {
            key_code: "spacebar",
          },
        ],
        conditions: [
          {
            type: "frontmost_application_if",
            file_paths: [
              "^/Users/mxstbr/Library/Application Support/minecraft/runtime/java-runtime-gamma/mac-os-arm64/java-runtime-gamma/jre.bundle/Contents/Home/bin/java$",
            ],
          },
        ],
      },
    ],
  },
];

fs.writeFileSync(
  "karabiner.json",
  JSON.stringify(
    {
      global: {
        show_in_menu_bar: false,
      },
      profiles: [
        {
          name: "Default",
          complex_modifications: {
            rules,
          },
        },
      ],
    },
    null,
    2
  )
);
