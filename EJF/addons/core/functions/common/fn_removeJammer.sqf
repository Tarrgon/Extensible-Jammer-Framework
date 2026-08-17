#include "..\..\script_component.hpp"

params ["_id"];

if (!isServer) exitWith {
	[_id] remoteExecCall ["EJF_fnc_removeJammer", 2];
};

if (isNil "_id") exitWith {
	ERROR("No ID passed to removeJammer.");
};

if (!(_id in EJF_jammerHashMap)) exitWith {
	ERROR_1("removeJammer called with a non-existent ID: %1.", _i_idOrJammerd);
};

_id call EJF_fnc_enableAllUavsInRange;

private _jammerData = EJF_jammerHashMap get _id;

_jammerData call EJF_fnc_removeJammedDrones;

EJF_jammerHashMap deleteAt _id;
EJF_jammerPreviousDistances deleteAt _id;
EJF_jammerPreviousSides deleteAt _id;

EJF_jammerHashMapDirty = true;