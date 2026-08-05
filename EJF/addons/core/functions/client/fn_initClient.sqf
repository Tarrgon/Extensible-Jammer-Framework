#include "..\..\script_component.hpp"

if (!hasInterface) exitWith {};
INFO("Initializing Client...");

EJF_filmGrainHandle = -1;
EJF_jammersInOuterRange = [];
EJF_disconnectedUavs = [];

private _filmGrainActive = false;
private _previouslyInDrone = false;

// Annoying, but as far as I know there's no way to check if they replaced their current UAV terminal with a new one
// of the same type as all you get back is a class name and not an object.
["loadout", {
	// 621 - UAV Terminal item type number
	private _hasTerminal = ((configfile >> "CfgWeapons" >> (player getSlotItemName 612) >> "ItemInfo" >> "type") call BIS_fnc_getCfgData) isEqualTo 621;

	if (!isNil "_hasTerminal") then {
		if (_hasTerminal) then {
			{
				_x call EJF_fnc_checkUavConnectability;
			} forEach allUnitsUAV;
		};
	};
}, true] call CBA_fnc_addPlayerEventHandler;

while {true} do {
	private _drone = getConnectedUAV player;
	private _inDrone = !(isNull _drone || {cameraOn != _drone});
	
	if (_inDrone && !_previouslyInDrone) then {
		call EJF_fnc_checkNearbyJammers;
	};

	if (_filmGrainActive && !_inDrone) then {
		EJF_jammersInOuterRange = [];
		0 call EJF_fnc_setFilmGrainIntensity;
		_filmGrainActive = false;
	} else {
		if (_inDrone && !isNil {EJF_jammersInOuterRange param [0]}) then {
			private _dronePos = getPosWorld _drone;
			private _closestJammer = -1;
			private _closestDist = -1;

			{
				private _jammerId = _x;
				private _jammerCanTarget = [_jammerId, _drone] call EJF_fnc_jammerCanTargetDrone;
				private _jammerPos = _jammerId call EJF_fnc_getJammerPosition;
				private _dist = _dronePos distanceSqr _jammerPos;

				if (_dist < _closestDist || _closestDist == -1) then {
					_closestDist = _dist;
					_closestJammer = _jammerId;
				};
			} forEach EJF_jammersInOuterRange;

			if (!(_closestJammer isEqualTo -1)) then {
				_filmGrainActive = true;

				_closestJammer = _closestJammer call EJF_fnc_getJammerData;

				private _innerRange = _closestJammer get "innerRangeSqr";
				private _outerRange = _closestJammer get "outerRangeSqr";

				private _severity = 0;

				if (_closestDist <= _innerRange) then {
					_severity = 1;
				} else {
					if (_outerRange > _innerRange) then {
						_severity = linearConversion [_outerRange, _innerRange, _closestDist, 0, 1, true];
					} else {
						_severity = 1;
					};
				};

				private _intensity = if (_severity > 0) then {0.005 + (0.995 * _severity)} else {0};
				(_intensity min 1) call EJF_fnc_setFilmGrainIntensity;
			};
		};
	};

	_previouslyInDrone = _inDrone;

	sleep 0.1;
};