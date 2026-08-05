#include "..\..\script_component.hpp"

if (!isServer) exitWith {};

params [["_idOrJammer", -1, [0, createHashMap]]];

if (_idOrJammer isEqualTo -1) exitWith {
	ERROR("Attempted to call enableAllUavsInRange without an id or jammer.");
	false;
};

private _jammerData = _idOrJammer call EJF_fnc_getJammerData;

if (_jammerData isEqualTo objNull) exitWith {
	ERROR_1("enableAllUavsInRange called with a non-existent ID: %1.", _idOrJammer);
	false;
};

private _jammerId = _jammerData get "id";
private _toDelete = [];

{
	private _uavNetId = _x;
	private _jammerIds = _y;

	private _index = _jammerIds findIf { _x isEqualTo _jammerId };
	
	if (_index != -1) then {
		_jammerIds deleteAt _index;

		if (isNil { _jammerIds param [0] }) then {
			_toDelete pushBackUnique _uavNetId;

			private _index = EJF_disabledUavs findIf { _x isEqualTo _uavNetId; };

			if (_index != -1) then {
				EJF_disabledUavs deleteAt _index;
				EJF_disabledUavsDirty = true;

				private _uav = objectFromNetId _uavNetId;

				_uav call EJF_fnc_checkUavConnectability;
			};
		};
	};
} forEach EJF_uavsInInnerRanges;

{
	EJF_uavsInInnerRanges deleteAt _x;
} forEach _toDelete;