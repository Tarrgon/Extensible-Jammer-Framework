player connectTerminalToUAV objNull;

private _drone = getConnectedUAV player;
private _inDrone = !(isNull _drone || {cameraOn != _drone});

if (_inDrone) then {
	player remoteControl objNull;
	switchCamera player;
};