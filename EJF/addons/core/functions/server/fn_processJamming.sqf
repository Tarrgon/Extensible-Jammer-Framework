#include "..\..\script_component.hpp"

if (!isServer) exitWith {};

params [["_allUavs", [], [[]]], ["_allEnabledJammers", [], [[]]]];

{
	private _uav = _x;
	private _uavNetId = netId _uav;
	private _posUav = getPosWorld _uav;
	private _uavCurrentSide = side _uav;
	private _uavPreviousSide = _uav getVariable ["EJF_lastSide", _uavCurrentSide];
	
	_uav setVariable ["EJF_lastSide", _uavCurrentSide];

	{
		private _jammer = _x;
		private _jammerId = _jammer get "id";

		private _innerRange = _jammer get "innerRangeSqr";
		private _outerRange = _jammer get "outerRangeSqr";
		private _detectionRange = _jammer get "detectionRangeSqr";

		private _forceUpdate = _jammer get "_forceUpdate";

		private _currentSide = _jammer call EJF_fnc_getJammerSide;
		private _previousSide = EJF_jammerPreviousSides getOrDefault [_jammerId, _currentSide];

		private _previousDistances = EJF_jammerPreviousDistances get _jammerId;
		private _previousDistance = if (_forceUpdate || _previousSide isNotEqualTo _currentSide || _uavCurrentSide isNotEqualTo _uavPreviousSide) then { 99999999; } else { _previousDistances getOrDefault [_uavNetId, 99999999]; };

		private _posJammer = _jammer call EJF_fnc_getJammerPosition;
		
		private _dist = _posJammer distanceSqr _posUav;

		switch (true) do {
			case (_previousDistance > _innerRange && _dist <= _innerRange): {
				[_uav, _jammer, _dist] call EJF_fnc_enteredInnerRange;
			};

			case (_previousDistance > _outerRange && _dist <= _outerRange): {
				[_uav, _jammer, _dist] call EJF_fnc_enteredOuterRange;
			};

			case (_previousDistance > _detectionRange && _dist <= _detectionRange): {
				[_uav, _jammer, _dist] call EJF_fnc_enteredDetectionRange;
			};

			case (_previousDistance <= _detectionRange && _dist > _detectionRange): {
				[_uav, _jammer, _dist] call EJF_fnc_exitedDetectionRange;
			};

			case (_previousDistance <= _outerRange && _dist > _outerRange): {
				[_uav, _jammer, _dist] call EJF_fnc_exitedOuterRange;
			};

			case (_previousDistance <= _innerRange && _dist > _innerRange): {
				[_uav, _jammer, _dist] call EJF_fnc_exitedInnerRange;
			};
		};

		if (_forceUpdate) then {
			_jammer set ["_forceUpdate", false];
		};

		_previousDistances set [_uavNetId, _dist];
		EJF_jammerPreviousSides set [_jammerId, _currentSide];
	} forEach _allEnabledJammers;
} forEach _allUavs;