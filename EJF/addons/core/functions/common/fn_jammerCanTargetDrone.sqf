#include "..\..\script_component.hpp"

params [["_idOrJammer", -1, [0, createHashMap]], ["_drone", objNull, [objNull]]];

if (_idOrJammer isEqualTo -1) exitWith {
	ERROR("Attempted to call jammerCanTargetDrone without an id or jammer.");
	true;
};

if (isNull _drone) exitWith {
	ERROR("Attempted to call jammerCanTargetDrone without a drone.");
	true;
};

private _jammerData = _idOrJammer call EJF_fnc_getJammerData;

if (_jammerData isEqualTo objNull) exitWith {
	ERROR_1("getJammerSide called with a non-existent ID: %1.", _idOrJammer);
	true;
};

/*
	JAMMING LOGIC:
	0 - Smart
	1 - All
	2 - Enemy only
*/

private _jammingLogic = _jammerData call EJF_fnc_getJammingLogic;

if (_jammingLogic == 1) exitWith {
	true;
};

private _droneSide = side _drone;
private _jammerSide = _jammerData call EJF_fnc_getJammerSide;

if (_jammerSide isEqualTo sideUnknown) exitWith {
	true;
};

if (_jammerSide isEqualTo Civilian) exitWith {
	false;
};

private _isEnemy = if (_jammerSide isEqualTo Civilian) then { false } else { (_droneSide getFriend _jammerSide) < 0.6 };

// The disabling of allied drones in smart mode is handled by
// common/fn_enteredInnerRange.sqf
_isEnemy;