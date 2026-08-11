#include "..\..\script_component.hpp"

params [["_jammer", objNull, [[], objNull]], ["_innerRange", 0, [0]], ["_outerRange", 0, [0]], ["_detectionRange", 0, [0]], ["_enabled", true, [true]], ["_jammerOwnerTemp", objNull, [objNull]], ["_side", 0, [sideUnknown, 0]], ["_jammingLogicPlayer", -1, [0]], ["_jammingLogicAI", -1, [0]], ["_jammingLogicStatic", -1, [0]], ["_hasCustomAction", [], [[]]]];

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
private _isStaticLocation = _jammer isEqualType [];

private _isSoldier = if (_isStaticLocation) then { false; } else { _jammer isKindOf "CAManBase"; };
private _jammerOwner = if (_jammerOwnerTemp isNotEqualTo objNull) then { netId _jammerOwnerTemp; } else {
	if (!_isStaticLocation && _isSoldier) exitWith { netId _jammer; };

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
_jammerData set ["isStaticLocation", _isStaticLocation];
_jammerData set ["side", _side];
_jammerData set ["jammingLogicAI", _jammingLogicAI];
_jammerData set ["jammingLogicPlayer", _jammingLogicPlayer];
_jammerData set ["jammingLogicStatic", _jammingLogicStatic];
_jammerData set ["hasCustomAction", _hasCustomAction];
_jammerData set ["_forceUpdate", false];

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