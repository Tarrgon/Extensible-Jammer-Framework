#include "..\..\script_component.hpp"

params [["_idOrJammer", -1, [0, createHashMap]]];

if (isNil "_idOrJammer") exitWith {
	ERROR("Attempted to call getJammerData without an id or jammer.");
	objNull;
};

if (_idOrJammer isEqualType createHashMap) exitWith {
	_idOrJammer;
};

private _hashMap = (call EJF_fnc_getJammerHashMap);

if (!(_idOrJammer in _hashMap)) exitWith {
	ERROR_1("getJammerData called with a non-existent ID: %1.", _idOrJammer);
	objNull;
};

_hashMap get _idOrJammer;