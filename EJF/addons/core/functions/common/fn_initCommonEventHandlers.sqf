private _handle = {
	params ["_vehicle"];

	if (local _vehicle) then {
		private _jammerIds = _vehicle getVariable ["EJF_jammerIds", []];
		private _vehicleOwner = _vehicle call EJF_fnc_getVehicleOwner;

		{
			private _jammerData = _x call EJF_fnc_getJammerData;
			private _previousOwnerNetId = _jammerData get ["vehiclePreviousOwner", ""];
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

["AllVehicles", "SeatSwitched", {
    params ["_vehicle"];
	_vehicle call _handle;
}, true, [], true] call CBA_fnc_addClassEventHandler;

["AllVehicles", "GetIn", {
    params ["_vehicle"];
    _vehicle call _handle;
}, true, [], true] call CBA_fnc_addClassEventHandler;