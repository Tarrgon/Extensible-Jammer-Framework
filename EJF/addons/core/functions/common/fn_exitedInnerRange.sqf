#include "..\..\script_component.hpp"

params ["_uav", "_jammer", "_dist", ["_disabled", false], ["_force", false]];

private _hasCustomAction = 5 in (_jammer get "hasCustomAction");

// Purposefully not checking _hasCustomAction.
private _fnc_removeFromDisabledUavs = {
	private _uavNetId = netId _uav;
	private _jammerId = _jammer get "id";

	if ((_uavNetId in EJF_uavsInInnerRanges)) then {
		private _arr = EJF_uavsInInnerRanges get _uavNetId;
		private _index = _arr findIf { _x isEqualTo _jammerId; };

		if (_index != -1) then {
			_arr deleteAt _index;
		};

		if (isNil { _arr param [0] }) then {
			EJF_uavsInInnerRanges deleteAt _uavNetId;
			// EJF_disabledFriendlyUavs deleteAt _jammerId;

			private _index = EJF_disabledUavs findIf { _x isEqualTo _uavNetId; };

			if (_index != -1) then {
				EJF_disabledUavs deleteAt _index;
				EJF_disabledUavsDirty = true;

				_uav call EJF_fnc_checkUavConnectability;
				_uav setVariable ["ddtForce", true, true];
			};
		};
	};

	private _jammingLogic = _jammer call EJF_fnc_getJammingLogic;
	if (_jammingLogic == 0) then {
		private _anyEnemyDronesInRange = _jammer call EJF_fnc_anyEnemyUavsInInnerRange;

		if (!_anyEnemyDronesInRange) then {
			_jammer call EJF_fnc_enableAllUavsInRange;
		};
	};
};

if (isDedicated) exitWith {
	private _canTarget = _force || { [_jammer, _uav] call EJF_fnc_jammerCanTargetDrone };
	if (_canTarget) then {
		[_uav, _jammer, _dist, _disabled, _force] remoteExec ["EJF_fnc_exitedInnerRange", -2];
		["EJF_server_UavExitedInnerRange", [_uav, _jammer, _dist]] call CBA_fnc_serverEvent;
	};

	call _fnc_removeFromDisabledUavs; // Friendly drones can be disabled in smart mode, so canTarget is not checked.
};

// Single player
private _canTarget = true;

if (isServer && hasInterface) then {
	_canTarget = _force || { [_jammer, _uav] call EJF_fnc_jammerCanTargetDrone };

	if (_canTarget) then {
		[_uav, _jammer, _dist, _disabled, _force] remoteExec ["EJF_fnc_exitedInnerRange", -clientOwner];
	};

	call _fnc_removeFromDisabledUavs; // Friendly drones can be disabled in smart mode, so canTarget is not checked.
};

if (!_canTarget) exitWith {};

["EJF_client_UavExitedInnerRange", [_uav, _jammer, _dist]] call CBA_fnc_localEvent;
