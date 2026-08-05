#include "..\..\script_component.hpp"

params [["_idOrJammer", -1, [0, createHashMap]], ["_drone", objNull, [objNull]]];

if (_idOrJammer isEqualTo -1) exitWith {
	ERROR("Attempted to call removeJammedDrones without an id or jammer.");
	false;
};

private _jammerData = _idOrJammer call EJF_fnc_getJammerData;

if (_jammerData isEqualTo objNull) exitWith {
	ERROR_1("removeJammedDrones called with a non-existent ID: %1.", _idOrJammer);
	false;
};

private _innerRange = _jammerData get "innerRangeSqr";
private _outerRange = _jammerData get "outerRangeSqr";
private _detectionRange = _jammerData get "detectionRangeSqr";

{
	private _uav = _x;
	private _posUav = getPosWorld _uav;
	private _posJammer = _jammerData call EJF_fnc_getJammerPosition;
	
	private _dist = _posJammer distanceSqr _posUav;
	
	if (_dist <= _detectionRange) then {
		[_uav, _jammerData, _dist, true] call EJF_fnc_exitedDetectionRange;
	};

	if (_dist <= _outerRange) then {
		[_uav, _jammerData, _dist, true] call EJF_fnc_exitedOuterRange;
	};
	
	if (_dist <= _innerRange) then {
		[_uav, _jammerData, _dist, true] call EJF_fnc_exitedInnerRange;
	};
} forEach allUnitsUav;