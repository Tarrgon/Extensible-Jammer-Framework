#include "..\..\script_component.hpp"

params [["_idOrJammer", -1, [0, createHashMap]], ["_side", 0, [sideUnknown, 0]]];

if (!isServer) exitWith {
	if (!(_idOrJammer isEqualType 0)) exitWith {
		ERROR("Must use ID when calling setters over network (setJammerSide)");
		false;
	};

	[_idOrJammer, _side] remoteExecCall ["EJF_fnc_setJammerSide", 2];
};

if (_idOrJammer isEqualTo -1) exitWith {
	ERROR("Attempted to call setJammerSide without an id or jammer.");
	false;
};

private _jammerData = _idOrJammer call EJF_fnc_getJammerData;

if (_jammerData isEqualTo objNull) exitWith {
	ERROR_1("setJammerSide called with a non-existent ID: %1.", _idOrJammer);
	false;
};

_jammerData set ["side", _side];
_jammerData set ["_forceUpdate", true];

EJF_jammerHashMapDirty = true;

true;