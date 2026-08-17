#include "..\..\script_component.hpp"

private _category = "Extensible Jammer Framework";

[
	"ejf_enabled",
	"CHECKBOX",
	["Enable Framework", "Enable or disable the drone jamming framework. Disabling this will disable all drone jammers that utilize this framework."],
	_category,
	true,
	1
] call CBA_fnc_addSetting;

[
	"ejf_update_interval",
	"SLIDER",
	["Update Interval", "The time, in seconds, between checking drone distances to jammers. Increase this to decrease lag, but make the system less reliable."],
	_category,
	[0.5, 10, 2, 1],
	1
] call CBA_fnc_addSetting;

[
	"ejf_default_jammer_logic_ai",
	"LIST",
	["Default Jammer Logic AI", "For jammers that don't define custom logic, the default jamming logic to use (for AI units)."],
	_category,
	[[0, 1, 2], ["Smart", "All", "Enemy Only"], 0],
	1
] call CBA_fnc_addSetting;

[
	"ejf_default_jammer_logic_player",
	"LIST",
	["Default Jammer Logic Player", "For jammers that don't define custom logic, the default jamming logic to use (for player units)."],
	_category,
	[
		[0, 1, 2],
		["Smart", "All", "Enemy Only"],
		0
	],
	1
] call CBA_fnc_addSetting;

[
	"ejf_default_jammer_logic_vehicle",
	"LIST",
	["Default Jammer Logic Vehicle", "For jammers that don't define custom logic, the default jamming logic to use (for vehicles)."],
	_category,
	[
		[0, 1, 2],
		["Smart", "All", "Enemy Only"],
		0
	],
	1
] call CBA_fnc_addSetting;

[
	"ejf_default_jammer_logic_static",
	"LIST",
	["Default Jammer Logic Static", "For jammers that don't define custom logic, the default jamming logic to use (for statically positioned jammers)."],
	_category,
	[
		[0, 1, 2],
		["Smart", "All", "Enemy Only"],
		0
	],
	1
] call CBA_fnc_addSetting;

[
	"ejf_notify_owner",
	"CHECKBOX",
	["Notify Owner in Detection Range", "Enable or disable jammers without custom actions notifying their owner when a drone enters their detection range."],
	_category,
	true,
	1
] call CBA_fnc_addSetting;