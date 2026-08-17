#include "..\..\script_component.hpp"

params [["_idOrJammer", -1, [0, createHashMap]], ["_owner", "", [""]]];

if (!isServer) exitWith {
	if (!(_idOrJammer isEqualType 0)) exitWith {
		ERROR("Must use ID when calling setters over network (setJammerPreviousOwner)");
		false;
	};

	[_idOrJammer, _owner] remoteExecCall ["EJF_fnc_setJammerPreviousOwner", 2];
};

if (_idOrJammer isEqualTo -1) exitWith {
	ERROR("Attempted to call setJammerPreviousOwner without an id or jammer.");
	false;
};

private _jammerData = _idOrJammer call EJF_fnc_getJammerData;

if (_jammerData isEqualTo objNull) exitWith {
	ERROR_1("setJammerPreviousOwner called with a non-existent ID: %1.", _idOrJammer);
	false;
};

_jammerData set ["vehiclePreviousOwner", _owner];
_jammerData set ["_forceUpdate", true];

EJF_jammerHashMapDirty = true;

true;