private _enabledJammers = [];

{
	private _jammer = _y get "jammer";
	private _enabled = _y get "enabled";
	
	if (_enabled) then {
		_enabledJammers pushBack _y;
	};
} foreach (call EJF_fnc_getJammerHashMap);

_enabledJammers;