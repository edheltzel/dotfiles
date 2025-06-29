import * as fs from "fs";
import {
  KarabinerRules,
  createHyperNavigationRule,
  createMouseNavigationRules,
  createHyperKeyRule,
  createModifierTapRule,
  createModifierTapRules,
  createDoubleTapRule,
  createDoubleTapRules,
} from "./types";
import { createHyperSubLayers, app, open, shell } from "./utils";

// Array of Karabiner configuration rules
const rules: KarabinerRules[] = [
  // Main Hyper Key Configuration
  createHyperKeyRule(),
  // Vim-style navigation using Hyper key
  // Maps h,j,k,l to arrow keys
  // Additional mappings for page navigation (u,i,o,p)
  createHyperNavigationRule({
    h: "left_arrow",
    j: "down_arrow",
    k: "up_arrow",
    l: "right_arrow",
    u: "page_up",
    i: "page_down",
    o: "home",
    p: "end",
  }),
  // Mouse button configuration for Safari and Vivaldi
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
    ["^com\\.apple\\.Safari$", "^com\\.vivaldi\\.Vivaldi$"],
  ),
  // Cording the Hyper Key with other modifiers
  ...createHyperSubLayers({
    // First layer: Hyper + left_alt shortcuts
    left_alt: {
      0: open(
        "'raycast://extensions/raycast/raycast-focus/toggle-focus-session'",
      ),
      p: app("Passwords"),
      // QMK Macros
      v: app("Via"), // M0
      l: open("raycast://script-commands/quit-fieldnotes"), // M4
      t: open("raycast://script-commands/run-topgrade"), // M1
      d: open("raycast://script-commands/edit-dotfiles"), // M2
      n: open("'raycast://customWindowManagementCommand?&name=FieldNotes'"), // M3
      q: open("https://launcher.keychron.com/#/keymap"), // M5
    },
    // Second layer: Hyper + left_command shortcuts
    left_command: {
      c: app("Google Chrome"), // Browser - testing
      f: app("Finder"),
      p: open("raycast://extensions/jomifepe/bitwarden/search"),
      r: open("'raycast://extensions/raycast/apple-reminders/create-reminder'"),
      t: app("Toggl Track"),
      comma: app("System Settings"),
    },
    // Third layer: Hyper + a (app) shortcuts
    a: {
      d: app("Adobe InDesign 2025"),
      f: app("Figma"),
      i: app("Adobe Illustrator"),
      m: app("Messages"),
      n: app("Invoice Ninja"),
      p: app("Adobe Photoshop 2025"),
      t: app("Ghostty"),
      b: app("BambuStudio"),
      e: app("ElegooSlicer"),
      o: app("OrcaSlicer"),
      s: app("Shapr3D"),
      c: app("Autodesk Fusion"),
      x: app("xTool Creative Space"),
    },
    // Fourth layer: Hyper + f (Finder) shortcuts
    f: {
      y: open("~/Documents/3D-CAD"),
      u: open("'/Users/ed/Library/CloudStorage/GoogleDrive-ed@rainyday.media/Shared drives/Clients'",),
      // u: open("'/Users/ed/RDM Dropbox/Clients'",),
      i: open("~/Documents"),
      o: open("~/Downloads"),
      p: open("~/Desktop"),
      h: open("~/"),
      j: open("'/Users/ed/Library/CloudStorage/GoogleDrive-ed@rainyday.media/My Drive'",),
      k: open("'/Users/ed/RDM Dropbox'",),
    },
    // Fifth layer: Hyper + m (Microsoft) shortcuts
    m: {
      w: app("Microsoft Word"),
      e: app("Microsoft Excel"),
      s: app("Microsoft PowerPoint"),
      t: app("Microsoft Teams"),
    },
    // Sixth layer: Hyper + left_control (just browsers)
    left_control:{
      s: app("Safari"),
      b: app("Brave Browser Beta"),
      c: app("Google Chrome"),
      y: app("Vivaldi"),
      z: app("Zen"),
    },
  }),
  // Modifier tap rules - define multiple modifier keys with tap actions
  ...createModifierTapRules({
    // Right CMD => alt+backspace when tapped (delete last word)
    right_command: {
      key_code: "delete_or_backspace",
      modifiers: ["right_alt"],
      description: "Delete Last Word"
    },
    right_control: {
      key_code: "spacebar",
      modifiers: ["right_command"],
      description: "Trigger Raycast",
    }
    // Add more modifier tap rules here as needed
  }),
  // Double-tap rules - define multiple keys with double-tap actions
  ...createDoubleTapRules({
    // Double-tap Tab => Homerow trigger
    // right_shift: {
    //   key_code: "spacebar",
    //   modifiers: ["right_command", "right_option", "right_shift", "right_control"],
    //   description: "Trigger Homerow",
    //   delayMs: 250
    // }
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
