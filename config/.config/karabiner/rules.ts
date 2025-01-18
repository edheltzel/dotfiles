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
			f: app("Invoice Ninja"), // f - finance
			// QMK Macros
			v: app("Via"), // M0
			t: open("raycast://script-commands/run-topgrade"), // M1
			d: open("raycast://script-commands/edit-dotfiles"), // M2
			n: open("'raycast://customWindowManagementCommand?&name=-FieldNotes'"), // M3
		},
		// Second layer: Hyper + left_command shortcuts
		left_command: {
			f: app("Figma"),
			d: app("Adobe InDesign 2025"),
			i: app("Adobe Illustrator 2025"),
			p: app("Adobe Photoshop 2025"),
			m: app("Microsoft Teams"),
			k: app("KiCad"),
			o: app("Obsidian"),
			s: app("Safari"),
			comma: app("System Settings"),
		},
		a: {
			0: open(
				"'raycast://extensions/raycast/raycast-focus/toggle-focus-session'",
			),
			slash: open("raycast://extensions/raycast/raycast-ai/ai-chat"),
			b: app("BambuStudio"),
			c: app("OpenSCAD-2021.01"),
			d: open("~/Downloads"),
			f: app("Autodesk Fusion"),
			g: app("Ghostty"),
			k: app("kitty"),
			m: app("Messages"), // m - Apple Messages
			n: app("Notes"),
			o: app("OrcaSlicer"),
			r: app("Reminders"),
			s: app("Spotify"),
			v: app("Via"),
			y: app("Brave Browser Beta"),
		},
		m: {
			k: app("Mail"),
		},
	}),
	// RightCMD => alt+backspace
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
	// Enables keyboard-driven UI navigation using homerow keys
	{
		description: "Homerow Trigger",
		manipulators: [
			{
				description: "Right Control => Homerow",
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
								// ProtoArc EM01 NL trackball
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
