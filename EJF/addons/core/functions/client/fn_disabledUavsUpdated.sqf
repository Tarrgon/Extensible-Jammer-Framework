#include "..\..\script_component.hpp"

if (!hasInterface) exitWith {};

params ["_disabledUavs"];

EJF_disabledUavs = _disabledUavs;

{
	private _drone = _x;
	_drone call EJF_fnc_checkUavConnectability;
} forEach allUnitsUAV;