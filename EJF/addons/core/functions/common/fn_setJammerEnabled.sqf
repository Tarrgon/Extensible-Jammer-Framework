#include "..\..\script_component.hpp"

params [["_idOrJammer", -1, [0, createHashMap]], ["_enabled", true, [true]]];

if (!isServer) exitWith {
	if (!(_idOrJammer isEqualType 0)) exitWith {
		ERROR("Must use ID when calling setters over network (setJammerEnabled)");
		false;
	};

	[_idOrJammer, _enabled] remoteExecCall ["EJF_fnc_setJammerEnabled", 2];
};

if (_idOrJammer isEqualTo -1) exitWith {
	ERROR("Attempted to call setJammerEnabled without an id or jammer.");
	false;
};

private _jammerData = _idOrJammer call EJF_fnc_getJammerData;

if (_jammerData isEqualTo objNull) exitWith {
	ERROR_1("setJammerEnabled called with a non-existent ID: %1.", _idOrJammer);
	false;
};

_jammerData set ["enabled", _enabled];

if (_enabled) then {
	_jammerData set ["_forceUpdate", true];
} else {
	_jammerData call EJF_fnc_removeJammedDrones;
};

EJF_jammerHashMapDirty = true;

true;