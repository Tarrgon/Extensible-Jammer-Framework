#include "..\..\script_component.hpp"

params [["_jammer", objNull, [[], objNull]], ["_innerRange", 0, [0]], ["_outerRange", 0, [0]], ["_detectionRange", 0, [0]], ["_enabled", true, [true]], ["_jammerOwnerTemp", objNull, [objNull]], ["_side", 0, [sideUnknown, 0]], ["_jammingLogic", [-1, -1, -1, -1], [[]]], ["_hasCustomAction", [], [[]]]];

if (!isServer) exitWith {
	[_jammer, _innerRange, _outerRange, _detectionRange, _enabled, _jammerOwnerTemp, _side, _jammingLogicPlayer, _jammingLogicAI, _jammingLogicStatic, _hasCustomAction] remoteExecCall ["EJF_fnc_addJammer", 2];
};


if (_jammer isEqualTo objNull) exitWith {
	ERROR("Attempted to call addJammer without a jammer.");
	-1;
};

if (isNil "_innerRange" ) exitWith {
	ERROR("Attempted to call addJammer without an inner range.");
	-1;
};

if (isNil "_outerRange") exitWith {
	ERROR("Attempted to call addJammer without an outer range.");
	-1;
};

if (_innerRange > _outerRange) exitWith {
	ERROR("Attempted to call addJammer with an inner range greater than the outer range.");
	-1;
};

private _id = call EJF_fnc_generateId;
private _jammerType = switch (true) do {
	case (_jammer isKindOf "CAManBase"): { 0 };

	case (_jammer isEqualType []): { 1 };

	case (_jammer isKindOf "AllVehicles"): { 2 };

	default { -1 };
};

private _isSoldier = _jammerType == 0;
private _isStaticLocation = _jammerType == 1;
private _isVehicle = _jammerType == 2;

private _jammerOwner = if (_jammerOwnerTemp isNotEqualTo objNull) then { netId _jammerOwnerTemp; } else {
	if (_isSoldier) exitWith { netId _jammer; };

	// Vehicles are intentionally handled on-the-fly with getJammerOwner
	// if (_isVehicle) exitWith {
	// 	private _owner = _jammer call EJF_fnc_getVehicleOwner;

	// 	if (_owner isNotEqualTo objNull) exitWith { netId _owner; };

	// 	"";
	// };

	"";
};

private _jammerData = createHashMap;
_jammerData set ["id", _id];
_jammerData set ["jammer", _jammer];
_jammerData set ["enabled", _enabled];
_jammerData set ["jammerOwner", _jammerOwner];
_jammerData set ["innerRangeSqr", _innerRange * _innerRange];
_jammerData set ["outerRangeSqr", _outerRange * _outerRange];
_jammerData set ["detectionRangeSqr", _detectionRange * _detectionRange];
_jammerData set ["type", _jammerType];
_jammerData set ["side", _side];
_jammerData set ["jammingLogicPlayer", _jammingLogic # 0];
_jammerData set ["jammingLogicAI", _jammingLogic # 1];
_jammerData set ["jammingLogicVehicle", _jammingLogic # 2];
_jammerData set ["jammingLogicStatic", _jammingLogic # 3];
_jammerData set ["hasCustomAction", _hasCustomAction];
_jammerData set ["_forceUpdate", false];

if (_isVehicle) then {
	_jammerData set ["vehiclePreviousOwner", _jammerOwner];
};

EJF_jammerHashMap set [_id, _jammerData];
EJF_jammerHashMapDirty = true;

EJF_jammerPreviousDistances set [_id, createHashMap];

if (!_isStaticLocation) then {
	private _jammerIds = _jammer getVariable ["EJF_jammerIds", []];
	_jammerIds pushBack _id;
	_jammer setVariable ["EJF_jammerIds", _jammerIds, true];

// 	private _eventHandlerId = _jammer addEventHandler ["Deleted", {
// 		private _jammerId = _jammer getVariable "EJF_jammerId";
// 		_jammerId call EJF_removeJammer;
// 	}];

// 	_jammerData set ["deletedEventHandlerId", _eventHandlerId];
};

_jammerData;