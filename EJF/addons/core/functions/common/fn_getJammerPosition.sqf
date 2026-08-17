#include "..\..\script_component.hpp"

params [["_idOrJammer", -1, [0, createHashMap]]];

if (_idOrJammer isEqualTo -1) exitWith {
	ERROR("Attempted to call getJammerPosition without an id or jammer.");
	false;
};

private _jammerData = _idOrJammer call EJF_fnc_getJammerData;

if (_jammerData isEqualTo objNull) exitWith {
	ERROR_1("getJammerPosition called with a non-existent ID: %1.", _idOrJammer);
	false;
};

private _jammer = _jammerData get "jammer";
private _isStaticLocation = (_jammerData get "type") == 1;

private _position = 0;

if (_isStaticLocation) then {
	_position = _jammer;
} else {
	_position = getPosWorld _jammer;
};

_position;