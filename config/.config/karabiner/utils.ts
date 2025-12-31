import type { KarabinerRules, KeyCode, Manipulator, To } from "./types";

/**
 * Custom way to describe a command in a layer
 */
export interface LayerCommand {
	to: To[];
	description?: string;
}

type HyperKeySublayer = {
	// The ? is necessary, otherwise we'd have to define something for _every_ key code
	[key_code in KeyCode]?: LayerCommand;
};

/**
 * Create a Hyper Key sublayer, where every command is prefixed with a key
 * e.g. Hyper + O ("Open") is the "open applications" layer, I can press
 * e.g. Hyper + O + G ("Google Chrome") to open Chrome
 */
export function createHyperSubLayer(
	sublayer_key: KeyCode,
	commands: HyperKeySublayer,
	_allSubLayerVariables: string[],
): Manipulator[] {
	return [
		// Define the individual commands that are meant to trigger in the sublayer
		...(Object.keys(commands) as (keyof typeof commands)[]).map(
			(command_key): Manipulator => ({
				...commands[command_key],
				type: "basic",
				from: {
					key_code: command_key,
					modifiers: {
						mandatory: [
							"right_control",
							"right_command",
							"right_option",
							"right_shift",
						],
					},
				},
				conditions: [
					{
						type: "variable_if",
						name: generateSubLayerVariableName(sublayer_key),
						value: 1,
					},
				],
			}),
		),
	];
}

/**
 * Create all hyper sublayers. This needs to be a single function, as well need to
 * have all the hyper variable names in order to filter them and make sure only one
 * activates at a time
 */
export function createHyperSubLayers(
	subLayers: {
		[key_code in KeyCode]?: HyperKeySublayer | LayerCommand;
	},
): KarabinerRules[] {
	return Object.entries(subLayers).map(([key, value]) =>
		"to" in value
			? {
					description: `Hyper Key + ${key}`,
					manipulators: [
						{
							...value,
							type: "basic",
							from: {
								key_code: key as KeyCode,
								modifiers: {
									mandatory: [
										"right_control",
										"right_command",
										"right_option",
										"right_shift",
									],
								},
							},
						},
					],
				}
			: {
					description: `Hyper Key sublayer "${key}"`,
					manipulators: [
						// Add the sublayer activator
						{
							type: "basic",
							from: {
								key_code: key as KeyCode,
								modifiers: {
									mandatory: [
										"right_control",
										"right_command",
										"right_option",
										"right_shift",
									],
								},
							},
							to: [
								{
									set_variable: {
										name: generateSubLayerVariableName(key as KeyCode),
										value: 1,
									},
								},
								{
									set_variable: {
										name: "in_sublayer",
										value: 1,
									},
								},
							],
							to_after_key_up: [
								{
									set_variable: {
										name: generateSubLayerVariableName(key as KeyCode),
										value: 0,
									},
								},
								{
									set_variable: {
										name: "in_sublayer",
										value: 0,
									},
								},
							],
						},
						// Add the sublayer commands
						...createHyperSubLayer(key as KeyCode, value, []),
					],
				},
	);
}

function generateSubLayerVariableName(key: KeyCode) {
	return `hyper_sublayer_${key}`;
}

/**
 * Shortcut for "open" shell command
 */
export function open(...what: string[]): LayerCommand {
	return {
		to: what.map((w) => ({
			shell_command: `open ${w}`,
		})),
		description: `Open ${what.join(" & ")}`,
	};
}

/**
 * Utility function to create a LayerCommand from a tagged template literal
 * where each line is a shell command to be executed.
 */
export function shell(
	strings: TemplateStringsArray,
	...values: any[]
): LayerCommand {
	const commands = strings.reduce((acc, str, i) => {
		const value = i < values.length ? values[i] : "";
		const lines = (str + value)
			.split("\n")
			.filter((line) => line.trim() !== "");
		acc.push(...lines);
		return acc;
	}, [] as string[]);

	return {
		to: commands.map((command) => ({
			shell_command: command.trim(),
		})),
		description: commands.join(" && "),
	};
}

/**
 * Shortcut for "Open an app" command (of which there are a bunch)
 */
export function app(name: string): LayerCommand {
	return open(`-a '${name}.app'`);
}
