#include "..\..\script_component.hpp"

params [["_idOrJammer", -1, [0, createHashMap]], ["_hasCustomAction", [], [[]]]];

if (!isServer) exitWith {
	ERROR("setHasCustomAction cannot be executed on the client.");
	false;
};

if (_idOrJammer isEqualTo -1) exitWith {
	ERROR("Attempted to call setHasCustomAction without an id or jammer.");
	false;
};

private _jammerData = _idOrJammer call EJF_fnc_getJammerData;

if (_jammerData isEqualTo objNull) exitWith {
	ERROR_1("setHasCustomAction called with a non-existent ID: %1.", _idOrJammer);
	false;
};

_jammerData set ["hasCustomAction", _hasCustomAction];
_jammerData set ["_forceUpdate", true];

EJF_jammerHashMapDirty = true;

true;