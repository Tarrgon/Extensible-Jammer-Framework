#include "..\..\script_component.hpp"

params ["_uav", "_jammer", "_dist", ["_disabled", false]];

private _hasCustomAction = 4 in (_jammer get "hasCustomAction");

private _uavNetId = netId _uav;

private _fnc_serverLogic = {
	if (_hasCustomAction) exitWith {};

	if (_uavNetId in EJF_uavsInOuterRanges) then {
		private _jammerIds = EJF_uavsInOuterRanges get _uavNetId;
		private _index = _jammerIds find (_jammer get "id");

		if (_index != -1) then {
			_jammerIds deleteAt _index;

			if (isNil { _jammerIds param [0] }) then {
				EJF_uavsInOuterRanges deleteAt _uavNetId;
			};
		};
	};
};

if (isDedicated) exitWith {
	private _canTarget = [_jammer, _uav] call EJF_fnc_jammerCanTargetDrone;
	if (_canTarget) then {
		call _fnc_serverLogic;

		[_uav, _jammer, _dist] remoteExec ["EJF_fnc_exitedOuterRange", -2];
		["EJF_server_UavExitedOuterRange", [_uav, _jammer, _dist]] call CBA_fnc_serverEvent;
	};
};

// Single player
private _canTarget = true;

if (isServer && hasInterface) then {
	_canTarget = [_jammer, _uav] call EJF_fnc_jammerCanTargetDrone;

	if (_canTarget) then {
		call _fnc_serverLogic;

		[_uav, _jammer, _dist] remoteExec ["EJF_fnc_exitedOuterRange", -clientOwner];
	};
};

if (!_canTarget) exitWith {};

private _drone = getConnectedUAV player;
if (!_hasCustomAction && !(isNull _drone) && {cameraOn isEqualTo _drone} && _uav isEqualTo _drone) then {
	private _index = EJF_jammersInOuterRange findIf { _x isEqualTo (_jammer get "id") };

	if (_index != -1) then {
		EJF_jammersInOuterRange deleteAt _index;
	};
};

["EJF_client_UavExitedOuterRange", [_uav, _jammer, _dist]] call CBA_fnc_localEvent;
