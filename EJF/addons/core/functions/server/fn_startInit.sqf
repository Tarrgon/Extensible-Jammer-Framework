if (isServer) then
{
	[] spawn {
		call EJF_fnc_initServer;
		[] remoteExec ["EJF_fnc_initClient", 0, true];
		[] spawn EJF_fnc_main;
		[] spawn EJF_fnc_aiLoop;
	};
};
