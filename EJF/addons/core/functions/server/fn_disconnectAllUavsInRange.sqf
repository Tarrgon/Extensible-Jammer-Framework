#include "..\..\script_component.hpp"

if (!isServer) exitWith {
	ERROR("Attempted to call disconnectAllUavsInRange from client.");
	false;
};

params [["_idOrJammer", -1, [0, createHashMap]]];

if (_idOrJammer isEqualTo -1) exitWith {
	ERROR("Attempted to call disconnectAllUavsInRange without an id or jammer.");
	false;
};

private _jammerData = _idOrJammer call EJF_fnc_getJammerData;

if (_jammerData isEqualTo objNull) exitWith {
	ERROR_1("disconnectAllUavsInRange called with a non-existent ID: %1.", _idOrJammer);
	false;
};

private _posJammer = _jammerData call EJF_fnc_getJammerPosition;
private _innerRange = _jammerData get "innerRangeSqr";

{
	private _uav = _x;

	private _posUav = getPosWorld _uav;
	private _dist = _posJammer distanceSqr _posUav;

	if (_dist <= _innerRange) then {
		private _uavNetId = netId _uav;
		private _jammerId = _jammerData get "id";

		if (!(_uavNetId in EJF_uavsInInnerRanges)) then {
			EJF_uavsInInnerRanges set [_uavNetId, [_jammerId]];
		} else {
			private _arr = EJF_uavsInInnerRanges get _uavNetId;
			_arr pushBackUnique _jammerId;

			EJF_uavsInInnerRanges set [_uavNetId, _arr];
		};

		// private _canTarget = [_jammerData, _uav] call EJF_fnc_jammerCanTargetDrone;
		
		// if (!_canTarget) then {
		// 	private _uavNetId = netId _uav;

		// 	if (!(_jammerId in EJF_disabledFriendlyUavs)) then {
		// 		EJF_disabledFriendlyUavs set [_jammerId, [_uavNetId]];
		// 	} else {
		// 		private _arr = EJF_disabledFriendlyUavs get _jammerId;
		// 		_arr pushBackUnique _uavNetId;
		// 	};
		// };

		EJF_disabledUavs pushBackUnique _uavNetId;
		EJF_disabledUavsDirty = true;

		_uav call EJF_fnc_checkUavConnectability;
	};
} forEach allUnitsUAV;