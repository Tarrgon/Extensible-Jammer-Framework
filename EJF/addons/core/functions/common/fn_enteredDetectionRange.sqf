#include "..\..\script_component.hpp"

params ["_uav", "_jammer", "_dist"];

private _hasCustomAction = 0 in (_jammer get "hasCustomAction");

if (isDedicated) exitWith {
	private _canTarget = [_jammer, _uav] call EJF_fnc_jammerCanTargetDrone;
	if (_canTarget) then {
		[_uav, _jammer, _dist] remoteExec ["EJF_fnc_enteredDetectionRange", -2];
		["EJF_server_UavEnteredDetectionRange", [_uav, _jammer, _dist]] call CBA_fnc_serverEvent;
	};
};

// Single player prevents checking jammerCanTargetDrone again unnecessarily
private _canTarget = true;

if (isServer && hasInterface) then {
	_canTarget = [_jammer, _uav] call EJF_fnc_jammerCanTargetDrone;

	if (_canTarget) then {
		[_uav, _jammer, _dist] remoteExec ["EJF_fnc_enteredDetectionRange", -2];
	};
};

if (!_canTarget) exitWith {};

["EJF_client_UavEnteredDetectionRange", [_uav, _jammer, _dist]] call CBA_fnc_localEvent;

if (!_hasCustomAction) then {
	private _iOwnJammer = _jammer call EJF_fnc_iOwnJammer;

	if (_iOwnJammer) then {
		systemChat format["DRONE JAMMER: %1 - ENTERED detection range", getText (configOf _uav >> "displayName")];
	};
};