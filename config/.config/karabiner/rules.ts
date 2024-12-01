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
    spacebar: open(
      "raycast://extensions/stellate/mxstbr-commands/create-notion-todo"
    ),
    b: {
      t: open("https://twitter.com"),
      // Quarterly "P"lan
      p: open("https://mxstbr.com/cal"),
      y: open("https://news.ycombinator.com"),
      f: open("https://facebook.com"),
      r: open("https://reddit.com"),
      h: open("https://hashnode.com/draft"),
    },
    // o = "Open" applications
    o: {
      1: app("1Password"),
      g: app("Google Chrome"),
      c: app("Notion Calendar"),
      v: app("Zed"),
      d: app("Discord"),
      s: app("Slack"),
      e: app("Superhuman"),
      n: app("Notion"),
      t: app("Terminal"),
      // Open todo list managed via *H*ypersonic
      h: open(
        "notion://www.notion.so/stellatehq/7b33b924746647499d906c55f89d5026"
      ),
      z: app("zoom.us"),
      // "M"arkdown (Reflect.app)
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
