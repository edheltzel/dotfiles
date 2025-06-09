import * as fs from "fs";
import {
  KarabinerRules,
  createHyperNavigationRule,
  createMouseNavigationRules,
} from "./types";
import { createHyperSubLayers, app, open, shell } from "./utils";

// Array of Karabiner configuration rules
const rules: KarabinerRules[] = [
  // Main Hyper Key Configuration
  // Transforms Caps Lock into a powerful modifier key combination (Control + Option + Shift + Command)
  // When pressed alone, it acts as Escape
  // Uses right modifiers to allow for combinations with left modifiers
  {
    description: "Hyper Key (⌃⌥⇧⌘)",
    manipulators: [
      {
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
            modifiers: ["right_control", "right_command", "right_option"],
          },
        ],
        to_if_alone: [
          {
            key_code: "escape",
          },
        ],
        type: "basic",
      },
    ],
  },
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
  // Mouse button configuration for Safari
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
    "^com\\.apple\\.Safari$",
  ),
  // App launching shortcuts using Hyper key combinations - see Raycast settings for Hyper+non_modifier_key shortcuts
  // Two layers of shortcuts:
  // 1. Hyper + left_alt: Primary application shortcuts
  // 2. Hyper + left_command: Secondary application shortcuts
  ...createHyperSubLayers({
    // First layer: Hyper + left_alt shortcuts
    left_alt: {
      0: open(
        "'raycast://extensions/raycast/raycast-focus/toggle-focus-session'",
      ),
      p: app("Passwords"),
      y: app("Brave Browser Beta"),

      // QMK Macros
      v: app("Via"), // M0
      l: app("Vial"), // M4
      t: open("raycast://script-commands/run-topgrade"), // M1
      d: open("raycast://script-commands/edit-dotfiles"), // M2
      n: open("'raycast://customWindowManagementCommand?&name=-FieldNotes'"), // M3
      q: open("https://launcher.keychron.com/#/keymap"), // M5
    },
    // Second layer: Hyper + left_command shortcuts
    left_command: {
      f: app("Finder"),
      m: app("Microsoft Teams"),
      p: open("raycast://extensions/jomifepe/bitwarden/search"),
      r: open("'raycast://extensions/raycast/apple-reminders/create-reminder'"),
      t: app("Toggl Track"),
      y: app("Zen"),
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
      t: app("WezTerm"),
      // 3D modeling, slicing & laser cutting
      1: app("FreeCAD"),
      b: app("BambuStudio"),
      e: app("ElegooSlicer"),
      o: app("OrcaSlicer"),
      s: app("Shapr3D"),
      c: app("Autodesk Fusion"),
      h: open("https://cad.onshape.com/signin"),
      x: app("xTool Creative Space"),
    },
    // Fourth layer: Hyper + f (Finder) shortcuts
    f: {
      y: open("~/Documents/3D-CAD"),
      u: open("'/Users/ed/Library/CloudStorage/GoogleDrive-ed@rainyday.media/Shared drives/Clients'",),
      i: open("~/Documents"),
      o: open("~/Downloads"),
      p: open("~/Desktop"),
      h: open("~/"),
      j: open("'/Users/ed/Library/CloudStorage/GoogleDrive-ed@rainyday.media/My Drive'",),
      k: open("'/Users/ed/RDM Dropbox'",),
    },
  }),
  // RightCMD => alt+backspace
  // Right CMD if held - alt+backspace if tapped
  // quickly deletes the last word with a single tap
{
    description: "Delete Last Word",
    manipulators: [
      {
        description: "Right CMD => Alt+Backspace",
        from: {
          key_code: "right_command",
        },
        to: [
          {
            key_code: "right_command",
          },
        ],
        to_if_alone: [
          {
            key_code: "delete_or_backspace",
            modifiers: ["right_alt"],
          },
        ],
        type: "basic",
      },
    ],
  },
  // Homerow Configuration
  // Enables keyboard-driven arrow navigation using homerow keys (←h,↓j,↑k,l→)
  {
    description: "Homerow Trigger",
    manipulators: [
      {
        description: "Right Control => Homerow App",
        from: {
          key_code: "right_control",
        },
        to: [
          {
            key_code: "right_control",
          },
        ],
        to_if_alone: [
          {
            key_code: "spacebar",
            modifiers: [
              "right_command",
              "right_option",
              "right_shift",
              "right_control",
            ],
          },
        ],
        type: "basic",
      },
    ],
  },
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
