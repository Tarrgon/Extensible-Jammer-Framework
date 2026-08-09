#include "..\..\script_component.hpp"

params [["_idOrJammer", -1, [0, createHashMap]]];

if (_idOrJammer isEqualTo -1) exitWith {
	ERROR("Attempted to call getJammerOwner without an id or jammer.");
	objNull;
};

private _jammerData = _idOrJammer call EJF_fnc_getJammerData;

if (_jammerData isEqualTo objNull) exitWith {
	ERROR_1("getJammerOwner called with a non-existent ID: %1.", _idOrJammer);
	objNull;
};

private _jammer = _jammerData get "jammer";
private _owner = _jammerData get "jammerOwner";

private _unit = if (!(_owner isEqualTo "")) then { objectFromNetId _owner; } else {
	private _isStaticLocation = _jammerData get "isStaticLocation";
	if (_isStaticLocation) exitWith { objNull; };

	private _jammerIsSoldier = _jammer isKindOf "CAManBase";

	if (_jammerIsSoldier) exitWith { _jammer; };

	objNull;
};

if (_unit isEqualTo objNull) exitWith {
	objNull;
};

private _isSoldier = _unit isKindOf "CAManBase";

if (_isSoldier && isPlayer _unit) exitWith {
	_unit;
};

private _group = group _unit;
private _leader = leader _group;

if (isPlayer _leader) exitWith {
	_leader;
};

private _unitsInGroup = units _group;
private _humanPlayerIndex = _unitsInGroup findIf { isPlayer _x };

if (_humanPlayerIndex == -1) exitWith {
	_unit;
};

_unitsInGroup select _humanPlayerIndex;