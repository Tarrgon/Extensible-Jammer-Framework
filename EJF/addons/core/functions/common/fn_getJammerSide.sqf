#include "..\..\script_component.hpp"

params [["_idOrJammer", -1, [0, createHashMap]]];

if (_idOrJammer isEqualTo -1) exitWith {
	ERROR("Attempted to call getJammerSide without an id or jammer.");
	sideUnknown;
};

private _jammerData = _idOrJammer call EJF_fnc_getJammerData;

if (_jammerData isEqualTo objNull) exitWith {
	ERROR_1("getJammerSide called with a non-existent ID: %1.", _idOrJammer);
	sideUnknown;
};

private _sideOverride = _jammerData get "side";

if (!(_sideOverride isEqualTo 0)) exitWith {
	_sideOverride;
};

private _jammerOwner = _idOrJammer call EJF_fnc_getJammerOwner;

if (_jammerOwner isEqualTo objNull) exitWith {
	// Last resort, get vehicle side
	if ((_jammerData get "type") == 2) exitWith {
		side (_jammerData get "jammer");
	};

	sideUnknown;
};

side _jammerOwner;