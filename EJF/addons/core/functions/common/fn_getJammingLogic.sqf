#include "..\..\script_component.hpp"

params [["_idOrJammer", -1, [0, createHashMap]]];

if (_idOrJammer isEqualTo -1) exitWith {
	ERROR("Attempted to call getJammingLogic without an id or jammer.");
	false;
};

private _jammerData = _idOrJammer call EJF_fnc_getJammerData;

if (_jammerData isEqualTo objNull) exitWith {
	ERROR_1("getJammerSide called with a non-existent ID: %1.", _idOrJammer);
	false;
};

/*
	JAMMING LOGIC:
	0 - Smart
	1 - All
	2 - Enemy only
*/

private _isStaticLocation = _jammerData get "isStaticLocation";
if (_isStaticLocation) exitWith {
	private _jammingLogic = _jammerData get "jammingLogicStatic";
	if (_jammingLogic == -1) then {
		_jammingLogic = missionNamespace getVariable ["ejf_default_jammer_logic_static", true];
	};

	_jammingLogic;
};

private _jammer = _jammerData get "jammer";
private _isPlayer = isPlayer _jammer;

if (_isPlayer) exitWith {
	private _jammingLogic = _jammerData get "jammingLogicPlayer";
	if (_jammingLogic == -1) then {
		_jammingLogic = missionNamespace getVariable ["ejf_default_jammer_logic_player", true];
	};

	_jammingLogic;
};

private _jammingLogic = _jammerData get "jammingLogicAI";
if (_jammingLogic == -1) then {
	_jammingLogic = missionNamespace getVariable ["ejf_default_jammer_logic_ai", true];
};

_jammingLogic;