export interface KarabinerRules {
  description?: string;
  manipulators?: Manipulator[];
}

export interface Manipulator {
  description?: string;
  type: "basic";
  from: From;
  to?: To[];
  to_after_key_up?: To[];
  to_if_alone?: To[];
  to_delayed_action?: ToDelayedAction;
  parameters?: Parameters;
  conditions?: Conditions[];
}

export interface ToDelayedAction {
  to_if_invoked?: To[];
  to_if_canceled?: To[];
}

export interface Parameters {
  "basic.simultaneous_threshold_milliseconds"?: number;
  "basic.to_delayed_action_delay_milliseconds"?: number;
}

// Add new Mouse Navigation types and utilities
export type MouseNavigationMapping = {
  button: string;
  key_code: KeyCode;
  description: string;
};

export function createMouseNavigationRules(
  mappings: MouseNavigationMapping[],
  appBundleId: string
): KarabinerRules[] {
  return mappings.map(mapping => ({
    description: mapping.description,
    manipulators: [
      {
        conditions: [
          {
            bundle_identifiers: [appBundleId],
            type: "frontmost_application_if"
          }
        ],
        from: { pointing_button: mapping.button },
        to: [
          {
            key_code: mapping.key_code,
            modifiers: ["left_command"],
            repeat: false
          }
        ],
        type: "basic"
      }
    ]
  }));
}

type Conditions =
  | FrontMostApplicationCondition
  | DeviceCondition
  | KeyboardTypeCondition
  | InputSourceCondition
  | VaribaleCondition
  | EventChangedCondition;

type FrontMostApplicationCondition = {
  type: "frontmost_application_if" | "frontmost_application_unless";
  bundle_identifiers?: string[];
  file_paths?: string[];
  description?: string;
};

type DeviceCondition = {
  type:
    | "device_if"
    | "device_unless"
    | "device_exists_if"
    | "device_exists_unless";
  identifiers: Identifiers;
  description?: string;
};

interface Identifiers {
  vendor_id?: number;
  product_id?: number;
  location_id?: number;
  is_keyboard?: boolean;
  is_pointing_device?: boolean;
  is_touch_bar?: boolean;
  is_built_in_keyboard?: boolean;
}

type KeyboardTypeCondition = {
  type: "keyboard_type_if" | "keyboard_type_unless";
  keyboard_types: string[];
  description?: string;
};

type InputSourceCondition = {
  type: "input_source_if" | "input_source_unless";
  input_sources: InputSource[];
  description?: string;
};

interface InputSource {
  language?: string;
  input_source_id?: string;
  input_mode_id?: string;
}

type VaribaleCondition = {
  type: "variable_if" | "variable_unless";
  name: string | number | boolean;
  value: string | number;
  description?: string;
};

type EventChangedCondition = {
  type: "event_changed_if" | "event_changed_unless";
  value: boolean;
  description?: string;
};

export interface SimultaneousFrom {
  key_code: KeyCode;
}

export interface SimultaneousOptions {
  key_down_order?: "insensitive" | "strict" | "strict_inverse";
  detect_key_down_uninterruptedly?: boolean;
}

type ModifiersKeys =
  | "caps_lock"
  | "left_command"
  | "left_control"
  | "left_option"
  | "left_shift"
  | "right_command"
  | "right_control"
  | "right_option"
  | "right_shift"
  | "fn"
  | "command"
  | "control"
  | "option"
  | "shift"
  | "left_alt"
  | "left_gui"
  | "right_alt"
  | "right_gui"
  | "any";

export interface From {
  key_code?: KeyCode;
  pointing_button?: string;  // Added this for mouse button support
  simultaneous?: SimultaneousFrom[];
  simultaneous_options?: SimultaneousOptions;
  modifiers?: Modifiers;
}

export interface Modifiers {
  optional?: ModifiersKeys[];
  mandatory?: ModifiersKeys[];
}

export interface To {
  key_code?: KeyCode;
  modifiers?: ModifiersKeys[];
  shell_command?: string;
  set_variable?: {
    name: string;
    value: boolean | number | string;
  };
  mouse_key?: MouseKey;
  pointing_button?: string;
  repeat?: boolean;  // Added this for repeat support
  /**
   * Power Management plugin
   * @example: sleep system
   * @see: {@link https://karabiner-elements.pqrs.org/docs/json/complex-modifications-manipulator-definition/to/software_function/iokit_power_management_sleep_system/}
   */
  software_function?: SoftwareFunction;
}

export interface MouseKey {
  y?: number;
  x?: number;
  speed_multiplier?: number;
  vertical_wheel?: number;
  horizontal_wheel?: number;
}

export interface SoftwareFunction {
  iokit_power_management_sleep_system?: {};
}

// Add new Hyper Navigation types and utilities
export const hyperModifiers: ModifiersKeys[] = [
  "right_command",
  "right_control",
  "right_shift",
  "right_option"
];

export type HyperNavigationMapping = Record<string, KeyCode>;

export interface HyperNavigationRule extends KarabinerRules {
  description: string;
  manipulators: Manipulator[];
}

export function createHyperNavigationRule(mappings: HyperNavigationMapping): HyperNavigationRule {
  return {
    description: "Hyper Navigation",
    manipulators: Object.entries(mappings).map(([from_key, to_key]) => ({
      description: `${from_key} = ${to_key}`,
      from: {
        key_code: from_key as KeyCode,
        modifiers: {
          mandatory: hyperModifiers
        }
      },
      to: [{ key_code: to_key }],
      type: "basic",
      conditions: [
        {
          type: "variable_unless",
          name: "in_sublayer",
          value: 1
        }
      ]
    }))
  };
}

// Helper function to create the main Hyper Key rule (Caps Lock -> Hyper Key = Control + Option + Shift + Command)
export function createHyperKeyRule(): KarabinerRules {
  return {
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
  };
}

// Helper function to create a modifier key with tap-to-action behavior
export function createModifierTapRule(
  fromKey: KeyCode,
  tapAction: { key_code: KeyCode; modifiers?: ModifiersKeys[] },
  description: string
): KarabinerRules {
  return {
    description,
    manipulators: [
      {
        description: `${fromKey} => ${tapAction.key_code}${tapAction.modifiers ? ` + ${tapAction.modifiers.join('+')}` : ''}`,
        from: {
          key_code: fromKey,
        },
        to: [
          {
            key_code: fromKey,
          },
        ],
        to_if_alone: [
          {
            key_code: tapAction.key_code,
            modifiers: tapAction.modifiers,
          },
        ],
        type: "basic",
      },
    ],
  };
}

// Type for defining multiple modifier tap rules at once
export type ModifierTapMapping = {
  [key in KeyCode]?: {
    key_code: KeyCode;
    modifiers?: ModifiersKeys[];
    description?: string;
  };
};

// Helper function to create multiple modifier tap rules at once
export function createModifierTapRules(
  mappings: ModifierTapMapping
): KarabinerRules[] {
  return Object.entries(mappings).map(([fromKey, tapAction]) => ({
    description: tapAction.description || `${fromKey} Tap Rule`,
    manipulators: [
      {
        description: `${fromKey} => ${tapAction.key_code}${tapAction.modifiers ? ` + ${tapAction.modifiers.join('+')}` : ''}`,
        from: {
          key_code: fromKey as KeyCode,
        },
        to: [
          {
            key_code: fromKey as KeyCode,
          },
        ],
        to_if_alone: [
          {
            key_code: tapAction.key_code,
            modifiers: tapAction.modifiers,
          },
        ],
        type: "basic",
      },
    ],
  }));
}

// Helper function to create double-tap trigger rules
export function createDoubleTapRule(
  triggerKey: KeyCode,
  action: { key_code: KeyCode; modifiers?: ModifiersKeys[] },
  description: string,
  delayMs: number = 250
): KarabinerRules {
  return {
    description,
    manipulators: [
      {
        description: `Double Tap ${triggerKey} => ${action.key_code}${action.modifiers ? ` + ${action.modifiers.join('+')}` : ''}`,
        from: {
          key_code: triggerKey,
          modifiers: {
            optional: ["any"],
          },
        },
        to_delayed_action: {
          to_if_invoked: [
            {
              key_code: triggerKey,
            },
          ],
          to_if_canceled: [
            {
              key_code: action.key_code,
              modifiers: action.modifiers,
            },
          ],
        },
        parameters: {
          "basic.to_delayed_action_delay_milliseconds": delayMs,
        },
        type: "basic",
      },
    ],
  };
}

// Type for defining multiple double-tap rules at once
export type DoubleTapMapping = {
  [key in KeyCode]?: {
    key_code: KeyCode;
    modifiers?: ModifiersKeys[];
    description?: string;
    delayMs?: number;
  };
};

// Helper function to create multiple double-tap rules at once
export function createDoubleTapRules(
  mappings: DoubleTapMapping
): KarabinerRules[] {
  return Object.entries(mappings).map(([triggerKey, action]) => ({
    description: action.description || `Double Tap ${triggerKey} Rule`,
    manipulators: [
      {
        description: `Double Tap ${triggerKey} => ${action.key_code}${action.modifiers ? ` + ${action.modifiers.join('+')}` : ''}`,
        from: {
          key_code: triggerKey as KeyCode,
          modifiers: {
            optional: ["any"],
          },
        },
        to_delayed_action: {
          to_if_invoked: [
            {
              key_code: triggerKey as KeyCode,
            },
          ],
          to_if_canceled: [
            {
              key_code: action.key_code,
              modifiers: action.modifiers,
            },
          ],
        },
        parameters: {
          "basic.to_delayed_action_delay_milliseconds": action.delayMs || 250,
        },
        type: "basic",
      },
    ],
  }));
}

export type KeyCode =
  | "caps_lock"
  | "left_control"
  | "left_shift"
  | "left_option"
  | "left_command"
  | "right_control"
  | "right_shift"
  | "right_option"
  | "right_command"
  | "fn"
  | "return_or_enter"
  | "escape"
  | "delete_or_backspace"
  | "delete_forward"
  | "tab"
  | "spacebar"
  | "hyphen"
  | "equal_sign"
  | "open_bracket"
  | "close_bracket"
  | "backslash"
  | "non_us_pound"
  | "semicolon"
  | "quote"
  | "grave_accent_and_tilde"
  | "comma"
  | "period"
  | "slash"
  | "non_us_backslash"
  | "up_arrow"
  | "down_arrow"
  | "left_arrow"
  | "right_arrow"
  | "page_up"
  | "page_down"
  | "home"
  | "end"
  | "a"
  | "b"
  | "c"
  | "d"
  | "e"
  | "f"
  | "g"
  | "h"
  | "i"
  | "j"
  | "k"
  | "l"
  | "m"
  | "n"
  | "o"
  | "p"
  | "q"
  | "r"
  | "s"
  | "t"
  | "u"
  | "v"
  | "w"
  | "x"
  | "y"
  | "z"
  | "1"
  | "2"
  | "3"
  | "4"
  | "5"
  | "6"
  | "7"
  | "8"
  | "9"
  | "0"
  | "f1"
  | "f2"
  | "f3"
  | "f4"
  | "f5"
  | "f6"
  | "f7"
  | "f8"
  | "f9"
  | "f10"
  | "f11"
  | "f12"
  | "f13"
  | "f14"
  | "f15"
  | "f16"
  | "f17"
  | "f18"
  | "f19"
  | "f20"
  | "f21"
  //   not_to: true
  | "f22"
  //   not_to: true
  | "f23"
  //   not_to: true
  | "f24"
  //   not_to: true
  | "display_brightness_decrement"
  //   not_from: true
  | "display_brightness_increment"
  //   not_from: true
  | "mission_control"
  //   not_from: true
  | "launchpad"
  //   not_from: true
  | "dashboard"
  //   not_from: true
  | "illumination_decrement"
  //   not_from: true
  | "illumination_increment"
  //   not_from: true
  | "rewind"
  //   not_from: true
  | "play_or_pause"
  //   not_from: true
  | "fastforward"
  //   not_from: true
  | "mute"
  | "volume_decrement"
  | "volume_increment"
  | "eject"
  //   not_from: true
  | "apple_display_brightness_decrement"
  //   not_from: true
  | "apple_display_brightness_increment"
  //   not_from: true
  | "apple_top_case_display_brightness_decrement"
  //   not_from: true
  | "apple_top_case_display_brightness_increment"
  //   not_from: true
  | "keypad_num_lock"
  | "keypad_slash"
  | "keypad_asterisk"
  | "keypad_hyphen"
  | "keypad_plus"
  | "keypad_enter"
  | "keypad_1"
  | "keypad_2"
  | "keypad_3"
  | "keypad_4"
  | "keypad_5"
  | "keypad_6"
  | "keypad_7"
  | "keypad_8"
  | "keypad_9"
  | "keypad_0"
  | "keypad_period"
  | "keypad_equal_sign"
  | "keypad_comma"
  | "vk_none"
  //   not_from: true
  | "print_screen"
  | "scroll_lock"
  | "pause"
  | "insert"
  | "application"
  | "help"
  | "power"
  | "execute"
  //   not_to: true
  | "menu"
  //   not_to: true
  | "select"
  //   not_to: true
  | "stop"
  //   not_to: true
  | "again"
  //   not_to: true
  | "undo"
  //   not_to: true
  | "cut"
  //   not_to: true
  | "copy"
  //   not_to: true
  | "paste"
  //   not_to: true
  | "find"
  //   not_to: true
  | "international1"
  | "international2"
  //   not_to: true
  | "international3"
  | "international4"
  //   not_to: true
  | "international5"
  //   not_to: true
  | "international6"
  //   not_to: true
  | "international7"
  //   not_to: true
  | "international8"
  //   not_to: true
  | "international9"
  //   not_to: true
  | "lang1"
  | "lang2"
  | "lang3"
  //   not_to: true
  | "lang4"
  //   not_to: true
  | "lang5"
  //   not_to: true
  | "lang6"
  //   not_to: true
  | "lang7"
  //   not_to: true
  | "lang8"
  //   not_to: true
  | "lang9"
  //   not_to: true
  | "japanese_eisuu"
  | "japanese_kana"
  | "japanese_pc_nfer"
  //   not_to: true
  | "japanese_pc_xfer"
  //   not_to: true
  | "japanese_pc_katakana"
  //   not_to: true
  | "keypad_equal_sign_as400"
  //   not_to: true
  | "locking_caps_lock"
  //   not_to: true
  | "locking_num_lock"
  //   not_to: true
  | "locking_scroll_lock"
  //   not_to: true
  | "alternate_erase"
  //   not_to: true
  | "sys_req_or_attention"
  //   not_to: true
  | "cancel"
  //   not_to: true
  | "clear"
  //   not_to: true
  | "prior"
  //   not_to: true
  | "return"
  //   not_to: true
  | "separator"
  //   not_to: true
  | "out"
  //   not_to: true
  | "oper"
  //   not_to: true
  | "clear_or_again"
  //   not_to: true
  | "cr_sel_or_props"
  //   not_to: true
  | "ex_sel"
  //   not_to: true
  | "left_alt"
  | "left_gui"
  | "right_alt"
  | "right_gui"
  | "vk_consumer_brightness_down"
  //   not_from: true
  | "vk_consumer_brightness_up"
  //   not_from: true
  | "vk_mission_control"
  //   not_from: true
  | "vk_launchpad"
  //   not_from: true
  | "vk_dashboard"
  //   not_from: true
  | "vk_consumer_illumination_down"
  //   not_from: true
  | "vk_consumer_illumination_up"
  //   not_from: true
  | "vk_consumer_previous"
  //   not_from: true
  | "vk_consumer_play"
  //   not_from: true
  | "vk_consumer_next"
  //   not_from: true
  | "volume_down"
  | "volume_up";
