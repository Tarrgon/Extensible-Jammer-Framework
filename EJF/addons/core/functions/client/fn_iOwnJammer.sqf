#include "..\..\script_component.hpp"

if (!hasInterface) exitWith { false; };

params [["_idOrJammer", -1, [0, createHashMap]]];

if (_idOrJammer isEqualTo -1) exitWith {
	ERROR("Attempted to call iOwnJammer without an id or jammer.");
	false;
};

private _jammerOwner = _idOrJammer call EJF_fnc_getJammerOwner;

_jammerOwner isEqualTo player;