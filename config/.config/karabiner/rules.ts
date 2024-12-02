import * as fs from "fs";
import {
  KarabinerRules,
  createHyperNavigationRule,
  createMouseNavigationRules
} from "./types";
import { createHyperSubLayers, app, open, shell } from "./utils";

const rules: KarabinerRules[] = [
  // Define the Hyper key itself
  {
    description: "Hyper Key (⌃⌥⇧⌘)",
    manipulators: [{
      description: "Caps Lock -> Hyper Key",
      from: {
        key_code: "caps_lock",
        modifiers: {
          optional: ["any"],
        },
      },
      to: [
        {
          key_code: "right_shift",
          modifiers: [
            "right_control",
            "right_command",
            "right_option"
          ]
        }
      ],
      to_if_alone: [
        {
          key_code: "escape",
        },
      ],
      type: "basic",
    }],
  },
  createHyperNavigationRule({
    h: "left_arrow",
    j: "down_arrow",
    k: "up_arrow",
    l: "right_arrow",
    u: "page_up",
    i: "page_down",
    o: "home",
    p: "end"
  }),
  ...createMouseNavigationRules([
    // Mouse navigation for Safari
    {
      button: "button4",
      key_code: "left_arrow",
      description: "Mouse 4 => Back"
    },
    {
      button: "button5",
      key_code: "right_arrow",
      description: "Mouse 5 => Forward"
    }
  ], "^com\\.apple\\.Safari$"),
  ...createHyperSubLayers({
    // hyper + left_alt
    left_alt: {
      e: app("Cursor"), // e - editor
      s: app("Spotify"),
      t: open("raycast://script-commands/run-topgrade"),
      f: app("Invoice Ninja"), // f - finance
      g: app("Adobe InDesign 2025"), // g - graphic design
      n: app("Obsidian"),
      m: app("Messages"),
      y: app("Brave Browser Beta"),
    },
    // hyper + left_command
    left_command: {
      c: app("ClickUp"),
      d: open("raycast://script-commands/edit-dotfiles"),
      e: app("Zed"), // e - editor
      f: app("Figma"),
      g: app("Adobe Illustrator 2025"), // g - graphic design
      m: app("Microsoft Teams"),
      n: open("'raycast://customWindowManagementCommand?&name=-FieldNotes'"),
      t: app("kitty"),
      v: app("Via"),
      y: app("Zen Browser"),
    },
  }),
  {
    description: "Shortcat (homerow) Trigger",
    manipulators: [
      {
        description: "Right Control => Shortcat",
        from: {
          key_code: "right_control",
        },
        to: [
          {
            key_code: "right_control"
          },
        ],
        to_if_alone: [
          {
            key_code: "spacebar",
            modifiers: [
              "right_command",
              "right_option",
              "right_shift",
              "right_control"
            ]
          },
        ],
        type: "basic",
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
          devices: [
            {
              identifiers: {
                is_keyboard: true,
                product_id: 480,
                vendor_id: 13364
              },
              manipulate_caps_lock_led: false
            },
            {
              identifiers: {
                is_pointing_device: true,
                product_id: 64160,
                vendor_id: 9639
              },
              ignore: false
            }
          ],
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
