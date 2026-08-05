#include "..\..\script_component.hpp"

params [["_idOrJammer", -1, [0, createHashMap]], ["_innerRange", -1, [0]], ["_outerRange", -1, [0]], ["_detectionRange", -1, [0]]];

if (!isServer) exitWith {
	if (!(_idOrJammer isEqualType 0)) exitWith {
		ERROR("Must use ID when calling setters over network (setJammerRanges)");
		false;
	};

	[_idOrJammer, _innerRange, _outerRange, _detectionRange] remoteExecCall ["EJF_fnc_setJammerRanges", 2];
};

if (_idOrJammer isEqualTo -1) exitWith {
	ERROR("Attempted to call setJammerRanges without an id or jammer.");
	false;
};

private _jammerData = _idOrJammer call EJF_fnc_getJammerData;

if (_jammerData isEqualTo objNull) exitWith {
	ERROR_1("setJammerRanges called with a non-existent ID: %1.", _idOrJammer);
	false;
};

if (_innerRange != -1) then {
	_jammerData set ["innerRangeSqr", _innerRange * _innerRange];
};

if (_outerRange != -1) then {
	_jammerData set ["outerRangeSqr", _outerRange * _outerRange];
};

if (_detectionRange != -1) then {
	_jammerData set ["detectionRangeSqr", _detectionRange * _detectionRange];
};

_jammerData set ["_forceUpdate", true];

EJF_jammerHashMapDirty = true;

true;