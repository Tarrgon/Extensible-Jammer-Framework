#include "..\..\script_component.hpp"

params [["_idOrJammer", -1, [0, createHashMap]], ["_jammingLogicAI", -1, [0]], ["_jammingLogicPlayer", -1, [0]], ["_jammingLogicStatic", -1, [0]]];

if (!isServer) exitWith {
	if (!(_idOrJammer isEqualType 0)) exitWith {
		ERROR("Must use ID when calling setters over network (setJammerLogic)");
		false;
	};

	[_idOrJammer, _innerRange, _outerRange, _detectionRange] remoteExecCall ["EJF_fnc_setJammerLogic", 2];
};

if (_idOrJammer isEqualTo -1) exitWith {
	ERROR("Attempted to call setJammerLogic without an id or jammer.");
	false;
};

private _jammerData = _idOrJammer call EJF_fnc_getJammerData;

if (_jammerData isEqualTo objNull) exitWith {
	ERROR_1("setJammerLogic called with a non-existent ID: %1.", _idOrJammer);
	false;
};

_jammerData set ["jammingLogicAI", _jammingLogicAI];
_jammerData set ["jammingLogicPlayer", _jammingLogicPlayer];
_jammerData set ["jammingLogicStatic", _jammingLogicStatic];
_jammerData set ["_forceUpdate", true];

EJF_jammerHashMapDirty = true;

true;