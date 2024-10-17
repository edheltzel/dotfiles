// cSpell:disable
import fs from "fs";
import { KarabinerRules } from "./types";
import { createHyperSubLayers, app, open, rectangle, shell } from "./utils";

const rules: KarabinerRules[] = [
  // Define the Hyper key itself
  {
    description: "Hyper Key (⌃⌥⇧⌘)",
    "manipulators": [
      {
        "type": "basic",
        "from": {
          "key_code": "caps_lock",
          "modifiers": {
            "optional": ["any"]
          }
        },
        "to": [
          {
            "set_variable": {
              "name": "hyper",
              "value": 1
            }
          },
          {
            "key_code": "left_shift",
            "modifiers": [
              "left_command",
              "left_control",
              "left_option"
            ]
          }
        ],
        "to_after_key_up": [
          {
            "set_variable": {
              "name": "hyper",
              "value": 0
            }
          }
        ],
        "to_if_alone": [
          {
            "key_code": "escape"
          }
        ]
      }
    ]
    // manipulators: [
    //   {
    //     type: "basic",
    //     description: "Caps Lock -> Hyper Key",
    //     from: {
    //       key_code: "caps_lock",
    //       modifiers: {
    //         optional: ["any"],
    //       },
    //     },
    //     to: [
    //       {
    //         set_variable: {
    //           name: "hyper",
    //           value: 1,
    //         },
    //       },
    //     ],
    //     to_after_key_up: [
    //       {
    //         set_variable: {
    //           name: "hyper",
    //           value: 0,
    //         },
    //       },
    //     ],
    //     to_if_alone: [
    //       {
    //         key_code: "escape",
    //       },
    //     ],
    //   },
    // ],
  },
  ...createHyperSubLayers({
    // o = "Open" applications
    o: {
      s: app("Spotify"),
      b: app("Brave Browser Beta"),
      z: app("Zen Browser"),
      k: app("ClickUp"),
      c: app("Visual Studio Code"),
      t: app("WezTerm"),
      v: app("Via"),
      m: app("Typora"), // "M"arkdown (Typora.app)
      r: app("LocalSend"),
      d: app("Finder"), // Fin"d"er
      f: app("Figma"),
      i: app("Adobe InDesign 2025"),
      p: app("Adobe Photoshop 2025"),
      a: app("Adobe Illustrator 2025"),
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
      // for MacDaddy
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
      // "D"o not disturb toggle
      d: open(
        `raycast://extensions/yakitrak/do-not-disturb/toggle?launchType=background`
      ),
      // "T"heme
      t: open(`raycast://extensions/raycast/system/toggle-system-appearance`),
      c: open("raycast://extensions/raycast/system/open-camera"),
    },

    // r = "Raycast" - this is redundant with my Raycast keybindings with hyper key
    r: {
      0: open("raycast://extensions/raycast/emoji-symbols/search-emoji-symbols"), // emoji picker
      1: open("raycast://extensions/erics118/file-manager/manage-files"), // manage files - home dir
      2: open("raycast://extensions/raycast/file-search/search-files"), // search files
      3: open("raycast://extensions/raycast/raycast/search-quicklinks"), // search quicklinks
      4: open("raycast://extensions/raycast/snippets/search-snippets"), // search snippets
      5: open("raycast://extensions/GastroGeek/folder-search/search"), // search by folder
      7: open("raycast://extensions/raycast/floating-notes/toggle-floating-notes-window"), // floating notes
      8: open("raycast://extensions/erics118/change-case/change-case"), // case converter
      9: open("raycast://extensions/raycast/screenshots/search-screenshots"), // search screenshots
      n: open("raycast://script-commands/dismiss-notifications"),
      p: open("raycast://extensions/raycast/raycast/confetti"),
      a: open("raycast://extensions/raycast/raycast-ai/ai-chat"),
      w: open("raycast://extensions/mackopes/quit-applications/index"),
      h: open("raycast://extensions/raycast/clipboard-history/clipboard-history"),
    },
  }),
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
