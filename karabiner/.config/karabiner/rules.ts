// cSpell: disable
import * as fs from "fs";
import {
  BROWSER_BUNDLES,
  createDoubleTapRule,
  createDoubleTapRules,
  createHyperKeyRule,
  createHyperNavigationRule,
  createModifierTapRule,
  createModifierTapRules,
  createMouseButtonRule,
  createMouseNavigationRules,
  type KarabinerRules,
  MouseButtonAction,
} from "./types";
import { app, createHyperSubLayers, open, shell } from "./utils";

// Array of Karabiner configuration rules
const rules: KarabinerRules[] = [
  // see types.ts to configure Hyper key
  createHyperKeyRule(),
  // Vim-style navigation with Hyper key
  // Maps h,j,k,l to arrow keys
  // Additional mappings for page navigation (u,i,o,p)
  createHyperNavigationRule({
    h: "left_arrow",
    j: "down_arrow",
    k: "up_arrow",
    l: "right_arrow",
    u: "page_up",
    i: "page_down",
    // d: "page_down", // more vim-like navigation
    o: "home",
    p: "end",
  }),
  // Mouse button configuration for Safari, Vivaldi, and Zen
  // Maps mouse buttons 4 and 5 to back/forward navigation
  ...createMouseNavigationRules(
    [
      {
        button: "button4",
        key_code: "left_arrow",
        description: "Mouse 4 => Back",
      },
      {
        button: "button5",
        key_code: "right_arrow",
        description: "Mouse 5 => Forward",
      },
    ],
    [BROWSER_BUNDLES.SAFARI, BROWSER_BUNDLES.VIVALDI, BROWSER_BUNDLES.ZEN],
  ),
  // Type-safe mouse button 3 configuration for Zen browser
  // Maps button 3 to button 1 + left alt (Glance feature)
  createMouseButtonRule({
    fromButton: "button3",
    toButton: "button1",
    modifiers: ["left_alt"],
    description: "Mouse Button 3 => Button 1 + Left Alt (Zen browser Glance)",
    bundleIdentifiers: [BROWSER_BUNDLES.ZEN],
  }),
  // Cording the Hyper Key with other modifiers
  ...createHyperSubLayers({
    //---  Hyper + left_command shortcuts
    left_command: {
      comma: app("System Settings"),
      hyphen: open("'raycast://extensions/rishabswift/word-search/word-spell'"),
      equal_sign: open("'raycast://extensions/doist/todoist/create-task'"),
      home: open("'raycast://extensions/doist/todoist/home'"),
      // QMK Macros
      0: open(
        "'raycast://extensions/raycast/raycast-focus/toggle-focus-session'",
      ),
      t: open("'raycast://script-commands/run-topgrade'"), // M1
      d: open("'raycast://script-commands/edit-dotfiles'"), // M2
      p: open("'raycast://extensions/jomifepe/bitwarden/search'"), // M7
      o: open("'raycast://extensions/jomifepe/bitwarden/authenticator'"), // M8
      // Raycast Window Management
      m: open("'raycast://extensions/raycast/window-management/maximize'"),
      n: app("Notes"),

    },
    // Hyper + left_alt shortcuts
    left_alt: {
      i: app("Invoice Ninja"),
      c: app("Visual Studio Code"),
      e: app("Zed"),
      k: app("kitty"),
      w: app("Warp"),
      t: app("WezTerm"),
      n: app("Obsidian"),
      m: app("Typora"),
      b: app("Brave Browser"),
      g: app("Google Chrome"),
      f: app("Firefox"),
      p: app("Safari Technology Preview"),
      s: app("Safari"),
      v: app("Vivaldi"),
      z: app("Zen"),
    },
    // Hyper + a (app) shortcuts
    a: {
      0: app("Passwords"),
      3: app("Autodesk Fusion"),
      b: app("BambuStudio"),
      d: app("Affinity"),
      f: app("Figma"),
      i: app("Adobe Illustrator"),
      l: app("Affinity"),
      n: app("Obsidian"),
      m: app("Messages"),
      o: app("OrcaSlicer"),
      p: app("Adobe Photoshop 2025"),
      r: app("Reminders"),
      s: app("Shapr3D"),
      t: app("Todoist"),
      x: app("xTool Studio"),
    },
    // Hyper + d (directory) shortcuts
    d: {
      y: open("~/Documents/3D-CAD"),
      u: open(
        "'/Users/ed/Library/CloudStorage/GoogleDrive-ed@rainyday.media/Shared drives/Clients'",
      ),
      i: open("~/Documents"),
      o: open("~/Downloads"),
      p: open("~/Desktop"),
      h: open("~/"),
      j: open(
        "'/Users/ed/Library/CloudStorage/GoogleDrive-ed@rainyday.media/My Drive'",
      ),
      k: open("~/Developer/"),
      l: open("~/Sites/"),
      semicolon: open(
        "'/Users/ed/Library/Mobile Documents/com~apple~CloudDocs'",
      ),
    },
    // Hyper + m (Microsoft) shortcuts
    m: {
      w: app("Microsoft Word"),
      e: app("Microsoft Excel"),
      p: app("Microsoft PowerPoint"),
      t: app("Microsoft Teams"),
      o: app("Microsoft Outlook"),
    },
  }),
  // Modifier tap rules - define multiple modifier keys with tap actions
  ...createModifierTapRules({
    // Right CMD => alt+backspace when tapped (delete last word)
    right_command: {
      key_code: "delete_or_backspace",
      modifiers: ["right_alt"],
      description: "Delete Last Word",
    },
    // right_control: {
    // 	key_code: "spacebar",
    // 	modifiers: ["right_command"],
    // 	description: "Trigger Raycast",
    //  },
    // Add more modifier tap rules here as needed
  }),
  //  Double-tap rules - define multiple keys with double-tap actions
  ...createDoubleTapRules({
    // Double-tap Tab => triggers Homerow app
    // home: {
    // 	key_code: "spacebar",
    // 	modifiers: [
    // 		"right_command",
    // 		"right_option",
    // 		"right_shift",
    // 		"right_control",
    // 	],
    // 	description: "Trigger Homerow",
    // 	delayMs: 250,
    // },
    home: {
      key_code: "f9",
      modifiers: ["right_command"],
      description: "Trigger VoiceInk",
      delayMs: 250,
    },
    page_down: {
      key_code: "f8",
      modifiers: ["right_command"],
      description: "Trigger VoiceInk",
      delayMs: 250,
    },
    // Add more double-tap rules here as needed
  }),
];

// trigger karabiner profiles based on hardware device
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
          virtual_hid_keyboard: {
            keyboard_type_v2: "ansi",
          },
          devices: [
            {
              identifiers: {
                // Keychron Q11 keyboard
                is_keyboard: true,
                product_id: 480,
                vendor_id: 13364,
              },
              manipulate_caps_lock_led: false,
            },
            {
              identifiers: {
                // ProtoArc EM01 NL trackball - currently not using this but leaving it in place
                is_pointing_device: true,
                product_id: 64160,
                vendor_id: 9639,
              },
              ignore: false,
            },
            // {
            //   identifiers: {
            //     // Elecom EX-G PRO trackball
            //     is_pointing_device: true,
            //     product_id: 304,
            //     vendor_id: 1390,
            //   },
            //   ignore: false,
            // },
          ],
          complex_modifications: {
            rules,
          },
        },
      ],
    },
    null,
    2,
  ),
);
