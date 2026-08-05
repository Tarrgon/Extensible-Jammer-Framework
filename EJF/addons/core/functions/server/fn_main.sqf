#include "..\..\script_component.hpp"

if (!isServer) exitWith {};

private _lastEnabled = missionNamespace getVariable ["ejf_enabled", true];
while {true} do {
	private _allUavs = allUnitsUAV;
	private _enabled = missionNamespace getVariable ["ejf_enabled", true];
	if (_enabled) then {
		private _allEnabledJammers = call EJF_fnc_getEnabledJammers;
		[_allUavs, _allEnabledJammers] call EJF_fnc_processJamming;
	} else {
		if (_lastEnabled) then {
			[_allUavs] call EJF_fnc_unjamAll;
		};
	};

	if (EJF_jammerHashMapDirty) then {
		publicVariable "EJF_jammerHashMap";
		EJF_jammerHashMapDirty = false;
	};

	if (EJF_disabledUavsDirty) then {
		[EJF_disabledUavs] remoteExec ["EJF_fnc_disabledUavsUpdated", 0, "EJF_setDisabledUavs"];
		EJF_disabledUavsDirty = false;
	};

	_lastEnabled = _enabled;

	sleep (missionNamespace getVariable ["ejf_update_interval", 2]);
};