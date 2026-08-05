#include "..\..\script_component.hpp"

private _innerLoopCheck = 0;

while {true} do {
	{
		private _toDelete = [];

		private _uavNetId = _x;
		private _jammerIds = _y;

		private _uav = objectFromNetId _uavNetId;

		if (_uav isEqualTo objNull || _uavNetId in EJF_disabledUavs) then { continue; };

		private _uavPos = getPosWorld _uav;

		private _closestDist = 9999999999;
		private _closestJammer = objNull;

		{
			private _jammerPos = _x call EJF_fnc_getJammerPosition;

			if (_jammerPos isEqualTo false) then {
				_toDelete pushBack _forEachIndex;
				continue;
			};

			private _dist = _jammerPos distanceSqr _uavPos;

			if (_dist < _closestDist) then {
				_closestDist = _dist;
				_closestJammer = _x call EJF_fnc_getJammerData;
			};
		} forEach _jammerIds;

		for "_i" from (count _toDelete) - 1 to 0 step -1 do {
			private _index = _toDelete select _i;
			
			_jammerIds deleteAt _index;
		};

		if (_closestJammer isEqualTo objNull) then {
			continue;
		};

		private _innerRange = _closestJammer get "innerRangeSqr";
		private _outerRange = _closestJammer get "outerRangeSqr";

		private _spotDistance = linearConversion [_outerRange, _innerRange, _closestDist, 1, 0, true];

		[_uav, ["spotDistance", _spotDistance]] remoteExecCall ["setSkill", owner _uav];

		{
			[_x, ["spotDistance", _spotDistance]] remoteExecCall ["setSkill", owner _x];
		} forEach (crew _uav);

	} forEach EJF_uavsInOuterRanges;

	if (_innerLoopCheck >= 3) then {
		private _toDelete = [];

		{
			private _uavNetId = _x;

			private _uav = objectFromNetId _uavNetId;

			if (_uav isEqualTo objNull) then {
				_toDelete pushBack _forEachIndex;
				continue;
			};

			private _group = group _uav;

			private _waypointCount = (count (waypoints _group));

			if (_waypointCount > 0) then {
				EJF_savedDroneWaypoints = call EJF_fnc_getSavedWaypointsHashMap;

				private _savedWaypoints = EJF_savedDroneWaypoints getOrDefault [_uavNetId, []];

				{
					private _waypoint = _x;
					private _waypointType = waypointType _waypoint;
					
					private _extras = [];
					
					switch (_waypointType) do {
						case "LOITER": {
							_extras pushBack waypointLoiterRadius _waypoint;
							_extras pushBack waypointLoiterType _waypoint;
						}
					};
					
					_savedWaypoints pushBack [waypointPosition _waypoint, _waypointType, waypointTimeout _waypoint, _extras];
				} forEach (waypoints _group);

				EJF_savedDroneWaypoints set [_uavNetId, _savedWaypoints];

				publicVariable "EJF_savedDroneWaypoints";

				[_group, currentWaypoint _group] setWaypointPosition [_uav, -1];
				
				sleep 0.1;
				
				for "_i" from _waypointCount - 1 to 0 step -1 do {
					deleteWaypoint [_group, _i];
				};
			};

			private _owner = owner _uav;

			[_uav, false] remoteExecCall ["setAutonomous"];
			[_uav, true] remoteExecCall ["lockWP"];
			[_uav, false] remoteExecCall ["enableUAVWaypoints"];
			
			[_uav, ["spotDistance", 0]] remoteExecCall ["setSkill"];

			{
				[_x, ["spotDistance", 0]] remoteExecCall ["setSkill"];
			} forEach (crew _uav);
		} forEach EJF_disabledUavs;

		for "_i" from (count _toDelete) - 1 to 0 step -1 do {
			private _index = _toDelete select _i;
			private _uavNetId = EJF_disabledUavs select _index;

			EJF_uavsInInnerRanges deleteAt _uavNetId;
			EJF_disabledUavs deleteAt _index;
		};

		_innerLoopCheck = 0;
	} else {
		_innerLoopCheck = _innerLoopCheck + 1;
	};

	sleep 0.5;
};