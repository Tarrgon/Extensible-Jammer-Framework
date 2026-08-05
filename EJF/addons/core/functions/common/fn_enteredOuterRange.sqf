#include "..\..\script_component.hpp"

params ["_uav", "_jammer", "_dist"];

private _hasCustomAction = 1 in (_jammer get "hasCustomAction");

private _uavNetId = netId _uav;

if (isDedicated) exitWith {
	private _canTarget = [_jammer, _uav] call EJF_fnc_jammerCanTargetDrone;
	if (_canTarget) then {
		if (!_hasCustomAction) then {
			if (!(_uavNetId in EJF_uavsInOuterRanges)) then {
				EJF_uavsInOuterRanges set [_uavNetId, [(_jammer get "id")]];
			} else {
				(EJF_uavsInOuterRanges get _uavNetId) pushBack (_jammer get "id");
			};
		};

		[_uav, _jammer, _dist] remoteExec ["EJF_fnc_enteredOuterRange", -2];
		["EJF_server_UavEnteredOuterRange", [_uav, _jammer, _dist]] call CBA_fnc_serverEvent;
	};
};

// Single player
private _canTarget = true;

if (isServer && hasInterface) then {
	_canTarget = [_jammer, _uav] call EJF_fnc_jammerCanTargetDrone;

	if (_canTarget && !_hasCustomAction) then {
		if (!(_uavNetId in EJF_uavsInOuterRanges)) then {
			EJF_uavsInOuterRanges set [_uavNetId, [(_jammer get "id")]];
		} else {
			(EJF_uavsInOuterRanges get _uavNetId) pushBack (_jammer get "id");
		};
	};
};

if (!_canTarget) exitWith {};

private _drone = getConnectedUAV player;
if (!_hasCustomAction && !(isNull _drone) && {cameraOn isEqualTo _drone} && _uav isEqualTo _drone) then {
	EJF_jammersInOuterRange pushBackUnique (_jammer get "id");
};

["EJF_client_UavEnteredOuterRange", [_uav, _jammer, _dist]] call CBA_fnc_localEvent;