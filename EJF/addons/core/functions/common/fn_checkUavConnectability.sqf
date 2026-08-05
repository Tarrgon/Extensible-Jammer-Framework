#include "..\..\script_component.hpp"

params ["_uav"];

private _netId = netId _uav;
private _isDisabled = _netId in EJF_disabledUavs;

if (hasInterface) then {
	private _isConnected = isUAVConnected _uav;

	if (_isDisabled) then {
		if (player isUAVConnectable [_uav, true]) then {
			player disableUAVConnectability [_uav, true];
			EJF_disconnectedUavs pushBackUnique _uav;
		};

		if (_isConnected) then {
			call EJF_fnc_disconnectFromUav;
		}
	} else {
		private _isDisconnectedIndex = EJF_disconnectedUavs findIf { _x isEqualTo _uav };

		if (_isDisconnectedIndex != -1) then {
			player enableUAVConnectability [_uav, true];

			EJF_disconnectedUavs deleteAt _isDisconnectedIndex;
		};
	};
};

[_uav, !_isDisabled] remoteExecCall ["setAutonomous"];
[_uav, _isDisabled] remoteExecCall ["lockWP"];
[_uav, !_isDisabled] remoteExecCall ["enableUAVWaypoints"];

private _group = group _uav;

if (_isDisabled) then {
	private _waypointCount = (count (waypoints _group));

	if (_waypointCount > 0) then {
		EJF_savedDroneWaypoints = call EJF_fnc_getSavedWaypointsHashMap;

		private _savedWaypoints = EJF_savedDroneWaypoints getOrDefault [_netId, []];

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

		EJF_savedDroneWaypoints set [_netId, _savedWaypoints];

		publicVariable "EJF_savedDroneWaypoints";

		[_group, currentWaypoint _group] setWaypointPosition [_uav, -1];
		
		sleep 0.1;
		
		for "_i" from _waypointCount - 1 to 0 step -1 do {
			deleteWaypoint [_group, _i];
		};
	};
} else {
	EJF_savedDroneWaypoints = call EJF_fnc_getSavedWaypointsHashMap;

	if (_netId in EJF_savedDroneWaypoints) then {

		{
			_x params ["_waypointPosition", "_waypointType", "_waypointTimeout", "_extras"];

			if (!(_waypointType isEqualTo "LOITER") && _waypointPosition distance2D _uav <= 10) then { continue; };

			private _newWaypoint = _group addWaypoint [_waypointPosition, -1];
			
			_newWaypoint setWaypointType _waypointType;
			_newWaypoint setWaypointTimeout _waypointTimeout;
															
			switch (_waypointType) do {
				case "LOITER": {
					_newWaypoint setWaypointLoiterRadius (_extras # 0);
					_newWaypoint setWaypointLoiterType (_extras # 1);
				};
			};	
		} forEach (EJF_savedDroneWaypoints get _netId);

		EJF_savedDroneWaypoints deleteAt _netId;

		publicVariable "EJF_savedDroneWaypoints";
	};
};