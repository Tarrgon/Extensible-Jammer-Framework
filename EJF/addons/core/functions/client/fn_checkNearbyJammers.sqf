#include "..\..\script_component.hpp"

if (!hasInterface) exitWith {};

private _drone = getConnectedUAV player;

if (_drone isEqualTo objNull) exitWith {};

private _allEnabledJammers = call EJF_fnc_getEnabledJammers;
private _dronePos = getPosWorld _drone;

{
	private _jammer = _x;
	private _innerRange = _jammer get "innerRangeSqr";
	private _outerRange = _jammer get "outerRangeSqr";
	private _jammerPos = _jammer call EJF_fnc_getJammerPosition;

	private _dist = _dronePos distanceSqr _jammerPos;

	switch (true) do {
		case (_dist <= _innerRange): {
			_drone call EJF_fnc_checkUavConnectability;
		};

		case (_dist <= _outerRange): {
			EJF_jammersInOuterRange pushBack (_jammer get "id");
		};
	};
} forEach _allEnabledJammers;