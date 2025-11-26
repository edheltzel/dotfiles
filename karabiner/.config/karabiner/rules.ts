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

  // ------------------------------------------------------------------------
  // Vim-style navigation with Hyper key
  // Maps h,j,k,l to arrow keys
  // Additional mappings for page navigation (u,i,o,p)
  // ------------------------------------------------------------------------
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

  // ------------------------------------------------------------------------
  // Mouse button configuration for Safari, Vivaldi, and Zen
  // Maps mouse buttons 4 and 5 to back/forward navigation
  // ------------------------------------------------------------------------
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

  // ------------------------------------------------------------------------
  // Cording the Hyper Key with other modifiers & keys
  // ------------------------------------------------------------------------
  ...createHyperSubLayers({

    // ------------------------------------------------------------------------
    //      Hyper + left_command
    // ------------------------------------------------------------------------
    left_command: {
      8: open("'raycast://extensions/rishabswift/word-search/word-spell'"),
      comma: app("System Settings"),
      equal_sign: open("'raycast://extensions/doist/todoist/create-task'"),
      f: open(
        "'raycast://extensions/raycast/raycast-focus/toggle-focus-session'",
      ),
      // QMK Macros
      t: open("'raycast://script-commands/run-topgrade'"), // M1
      d: open("'raycast://script-commands/edit-dotfiles'"), // M2
      p: open("'raycast://extensions/jomifepe/bitwarden/search'"), // M3
      o: open("'raycast://extensions/jomifepe/bitwarden/authenticator'"), // M4

    },

    // ------------------------------------------------------------------------
    //      Hyper + a (app)
    // ------------------------------------------------------------------------
    // a: {
    //   0: app("Passwords"),
    //   3: app("Autodesk Fusion"),
    //   b: app("BambuStudio"),
    //   d: app("Affinity"),
    //   f: app("Figma"),
    //   i: app("Adobe Illustrator"),
    //   l: app("Affinity"),
    //   n: app("Obsidian"),
    //   m: app("Messages"),
    //   o: app("OrcaSlicer"),
    //   p: app("Adobe Photoshop 2026"),
    //   r: app("Reminders"),
    //   s: app("Shapr3D"),
    //   t: app("Todoist"),
    //   x: app("xTool Studio"),
    // },

    // ------------------------------------------------------------------------
    //      Hyper + d (directory)
    // ------------------------------------------------------------------------
    // d: {
    //   y: open("~/Documents/3D-CAD"),
    //   u: open(
    //     "'/Users/ed/Library/CloudStorage/GoogleDrive-ed@rainyday.media/Shared drives/Clients'",
    //   ),
    //   i: open("~/Documents"),
    //   o: open("~/Downloads"),
    //   p: open("~/Desktop"),
    //   h: open("~/"),
    //   j: open(
    //     "'/Users/ed/Library/CloudStorage/GoogleDrive-ed@rainyday.media/My Drive'",
    //   ),
    //   k: open("~/Developer/"),
    //   l: open("~/Sites/"),
    //   semicolon: open(
    //     "'/Users/ed/Library/Mobile Documents/com~apple~CloudDocs'",
    //   ),
    // },
  }),


  // ------------------------------------------------------------------------
  // Modifier tap rules - define multiple modifier keys with tap actions
  // ------------------------------------------------------------------------
  ...createModifierTapRules({
    // Right CMD => alt+backspace when tapped (delete last word)
    // right_command: {
    //   key_code: "delete_or_backspace",
    //   modifiers: ["right_alt"],
    //   description: "Delete Last Word",
    // },
  }),

  // ------------------------------------------------------------------------
  //  Double-tap rules - define multiple keys with double-tap actions
  // ------------------------------------------------------------------------
  ...createDoubleTapRules({
    // Double-tap Tab => triggers Homerow app
    // home: {
    //   modifiers: ["right_command"],
    //   key_code: "f8",
    //   description: "Trigger SuperWhisper",
    //   delayMs: 250,
    // },
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
                // Dygma Defy keyboard
                is_keyboard: true,
                product_id: 18,
                vendor_id: 13807,
              },
              manipulate_caps_lock_led: false,
              treat_as_built_in_keyboard: true,
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
            {
              identifiers: {
                // Dygma Defy keyboard + pointing device (trackball)
                is_keyboard: true,
                is_pointing_device: true,
                product_id: 18,
                vendor_id: 13807,
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
