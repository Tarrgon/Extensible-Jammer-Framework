#include "..\..\script_component.hpp"

INFO("Initializing common event handlers...");

EJF_fnc_handleVehicleOwnerChange = {
	params ["_vehicle"];

	if (local _vehicle) then {
		private _jammerIds = _vehicle getVariable ["EJF_jammerIds", []];
		private _vehicleOwner = _vehicle call EJF_fnc_getVehicleOwner;

		if (isNull _vehicleOwner) exitWith {};

		{
			private _jammerData = _x call EJF_fnc_getJammerData;
			private _previousOwnerNetId = _jammerData getOrDefault ["vehiclePreviousOwner", ""];
			if (_previousOwnerNetId isEqualTo "") exitWith {
				[_jammerData get "id", netId _vehicleOwner] call EJF_fnc_setJammerPreviousOwner;
			};

			private _previousOwner = objectFromNetId _previousOwnerNetId;

			if (_previousOwner isNotEqualTo _vehicleOwner) then {
				[_jammerData get "id", netId _vehicleOwner] call EJF_fnc_setJammerPreviousOwner;
			};
		} forEach _jammerIds;
	};
};

["AllVehicles", "InitPost", {
	params ["_vehicle"];
	_vehicle call EJF_fnc_handleVehicleOwnerChange;
}, true, [], true] call CBA_fnc_addClassEventHandler;

["CAManBase", "SeatSwitchedMan", {
    params ["_vehicle"];
	private _vehicle = param [2];
	_vehicle call EJF_fnc_handleVehicleOwnerChange;
}, true, [], true] call CBA_fnc_addClassEventHandler;

["CAManBase", "GetInMan", {
    private _vehicle = param [2];
    _vehicle call EJF_fnc_handleVehicleOwnerChange;
}, true, [], true] call CBA_fnc_addClassEventHandler;