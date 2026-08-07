#include "..\..\script_component.hpp"

if (!isServer) exitWith {};

EJF_ID = 0;

/*
	JammingLogicNumber is one of the following:
	- -1 - Use mission setting default.
	- 0 - Smart - Jammer will disable all allied drones in inner range only when an enemy drone enters the inner range (acts as if the jammer is disabled for allies until an enemy drone is in inner range).
	- 1 - All - Jammer will affect all drones.
	- 2 - Enemy Only - Jammer only affects enemy drones.

	CustomActionNumber are numbers that define which actions have custom actions:
	- 0 - Entered detection range
	- 1 - Entered outer range
	- 2 - Entered inner range
	- 3 - Exited detection range
	- 4 - Exited outer range
	- 5 - Exited inner range

	JammerData is a HashMap of:
	- id - Number
	- jammer - Position (Array) or object
	- enabled - Boolean
	- jammerOwner - Object - Unit who owns the jammer (or objNull if none). Use EJF_fnc_getJammerOwner to properly resolve.
	- innerRangeSqr - Number
	- outerRangeSqr - Number
	- detectionRangeSqr - Number
	- isStaticLocation - Boolean - true when Jammer is an Array
	- side - Side or 0 - Side override of the jammer, use EJF_fnc_getJammerSide to properly resolve the side of the jammer. When 0, gets the side of the unit returned with EJF_fnc_getJammerOwner. Returns sideUnknown if no owner and no override (targets all drones).
	- jammingLogicAI - JammingLogicNumber - When the jammer unit is not a player, the jamming logic to use.
	- jammingLogicPlayer - JammingLogicNumber - When the jammer unit is a player, the jamming logic to use.
	- jammingLogicStatic - JammingLogicNumber - When the jammer is a static location, the jamming logic to use.
	- hasCustomAction - Array of CustomActionNumbers. If the number is in the array, the jammer will not run any of the default actions (disabling drones in inner range, causing film grain effect in outer range, and notifying owners in detection range). Adding custom actions for only an enter or only an exit may cause issues with default logic.

	A hashmap of <number, JammerData>.

	Jammers which are objects are deleted automatically when they are removed.
	Jammers which are position arrays must be manually removed.
*/
EJF_jammerHashMap = createHashMap;
EJF_jammerHashMapDirty = true;

// Stores previous distances of jammers (server only). <JammerId, <UavNetId, Number>>
EJF_jammerPreviousDistances = createHashMap;

// Stores previous sides of jammers (server only). <JammerId, Side>
EJF_jammerPreviousSides = createHashMap;

// Stores drones which are in inner ranges of jammers (server only). <UavNetId, [JammerId]>
EJF_uavsInInnerRanges = createHashMap;

// Stores drones which were disabled by smart jamming (server only). <JammerId, [UavNetId]>
// EJF_disabledFriendlyUavs = createHashMap;

// An array of UAV net ids which are in the inner range of any jammer (for bandwidth reasons all we transmit to the players is this).
EJF_disabledUavs = [];
EJF_disabledUavsDirty = true;

// Drone waypoints to restore when exiting inner range. <UavNetId, [WaypointData]>
EJF_savedDroneWaypoints = createHashMap;
publicVariable "EJF_savedDroneWaypoints";

// For handling AI drones in outer ranges and setting their spotting skill level.
EJF_uavsInOuterRanges = createHashMap;

INFO("Initializing Server...");

call EJF_fnc_initServerEventHandlers;

publicVariable "EJF_jammerHashMap";
// publicVariable "EJF_disabledUavs"; - Manually handled by client/disabledUavsUpdated

private _ddtLoaded = (getLoadedModsInfo findIf { (_x # 0) isEqualTo "@Drongos Drone Tweaks"; }) != -1;

if (_ddtLoaded) then {
	while { isNil "DDT_fnc_DeployUAV"; } do { sleep 1; };

	INFO("Compiling all DDT scripts...");

	DDT_fnc_DeployUAV = compile preprocessFile QPATHTOFOLDER(functions\ddt\fn_deployUav.sqf);
	DDT_fnc_GuideToTargetBomber = compile preprocessFile QPATHTOFOLDER(functions\ddt\fn_guideToTargetBomber.sqf);
	DDT_fnc_GuideToTarget = compile preprocessFile QPATHTOFOLDER(functions\ddt\fn_guideToTarget.sqf);
	DDT_fnc_DRAGuideDrone = compile preprocessFile QPATHTOFOLDER(functions\ddt\fn_draGuide.sqf);
};

EJF_ready = true;