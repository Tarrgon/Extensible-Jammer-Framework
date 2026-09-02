#include "..\..\script_component.hpp"

params ["_uav", "_jammer", "_dist", ["_disabled", false], ["_force", false]];

private _hasCustomAction = 3 in (_jammer get "hasCustomAction");

if (isDedicated) exitWith {
	private _canTarget = _force || { [_jammer, _uav] call EJF_fnc_jammerCanTargetDrone };
	if (_canTarget) then {
		[_uav, _jammer, _dist, _disabled, _force] remoteExec ["EJF_fnc_exitedDetectionRange", -2];
		["EJF_server_UavExitedDetectionRange", [_uav, _jammer, _dist]] call CBA_fnc_serverEvent;
	};
};

// Single player
private _canTarget = true;

if (isServer && hasInterface) then {
	_canTarget = _force || { [_jammer, _uav] call EJF_fnc_jammerCanTargetDrone };
	
	if (_canTarget) then {
		[_uav, _jammer, _dist, _disabled, _force] remoteExec ["EJF_fnc_exitedDetectionRange", -2];
	};
};

if (!_canTarget) exitWith {};

["EJF_client_UavExitedDetectionRange", [_uav, _jammer, _dist]] call CBA_fnc_localEvent;

if (!_hasCustomAction && !_disabled) then {
	private _iOwnJammer = _jammer call EJF_fnc_iOwnJammer;

	if (_iOwnJammer) then {
		systemChat format["DRONE JAMMER: %1 - EXITED detection range", getText (configOf _uav >> "displayName")];
	};
};