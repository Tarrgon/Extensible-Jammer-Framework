#include "..\..\script_component.hpp"

if (!isServer) exitWith {};

INFO("Initializing server event handlers...");

addMissionEventHandler ["EntityDeleted", {
	params ["_entity"];

	private _jammerIds = _entity getVariable ["EJF_jammerIds", []];

	{
		_x call EJF_removeJammer;
	} forEach _jammerIds
}];