#include "..\..\script_component.hpp"

if (!isServer) exitWith {};

params [["_idOrJammer", -1, [0, createHashMap]]];

if (_idOrJammer isEqualTo -1) exitWith {
	ERROR("Attempted to call anyEnemyUavsInInnerRange without an id or jammer.");
	false;
};

private _jammerData = _idOrJammer call EJF_fnc_getJammerData;

if (_jammerData isEqualTo objNull) exitWith {
	ERROR_1("anyEnemyUavsInInnerRange called with a non-existent ID: %1.", _idOrJammer);
	false;
};

private _jammerId = _jammerData get "id";
private _posJammer = _jammerData call EJF_fnc_getJammerPosition;
private _innerRange = _jammerData get "innerRangeSqr";

private _result = false;

{
	private _uavNetId = _x;
	private _jammerIds = _y;
	
	if (_jammerId in _jammerIds) then {
		private _uav = objectFromNetId _uavNetId;
		private _canTarget = [_jammerData, _uav] call EJF_fnc_jammerCanTargetDrone;

		if (!_canTarget) exitWith {
			_result = true;
		};
	};

	if (_result) exitWith {};
} forEach EJF_uavsInInnerRanges;

_result;