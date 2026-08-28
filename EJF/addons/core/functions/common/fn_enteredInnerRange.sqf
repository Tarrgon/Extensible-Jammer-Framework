#include "..\..\script_component.hpp"

params ["_uav", "_jammer", "_dist"];

private _hasCustomAction = 2 in (_jammer get "hasCustomAction");

private _fnc_disconnectDroneIfPossible = {
	if (_hasCustomAction) exitWith {};

	private _jammingLogic = _jammer call EJF_fnc_getJammingLogic;

	// In smart mode, allied drones are disconnected alongside
	// enemy drones if an enemy drone gets close.
	if (_jammingLogic == 0) then {
		_jammer call EJF_fnc_disconnectAllUavsInRange;
	} else {
		private _uavNetId = netId _uav;
		private _jammerId = _jammer get "id";

		if (!(_uavNetId in EJF_uavsInInnerRanges)) then {
			EJF_uavsInInnerRanges set [_uavNetId, [_jammerId]];
		} else {
			private _arr = EJF_uavsInInnerRanges get _uavNetId;
			_arr pushBackUnique _jammerId;
		};

		EJF_disabledUavs pushBackUnique _uavNetId;
		EJF_disabledUavsDirty = true;

		_uav call EJF_fnc_checkUavConnectability;
	};
};

private _canTarget = [_jammer, _uav] call EJF_fnc_jammerCanTargetDrone;

if (isDedicated) exitWith {
	if (_canTarget) then {
		[_uav, _jammer, _dist] remoteExec ["EJF_fnc_enteredInnerRange", -2];
		["EJF_server_UavEnteredInnerRange", [_uav, _jammer, _dist]] call CBA_fnc_serverEvent;
		
		call _fnc_disconnectDroneIfPossible;
	};
};

// Single player
if (isServer && hasInterface) then {
	if (!_canTarget) exitWith {};
	
	[_uav, _jammer, _dist] remoteExec ["EJF_fnc_enteredInnerRange", -clientOwner];
	call _fnc_disconnectDroneIfPossible;
};

if (!_canTarget) exitWith {};

["EJF_client_UavEnteredInnerRange", [_uav, _jammer, _dist]] call CBA_fnc_localEvent;
