// Original from Drongo's Drone Tweaks https://steamcommunity.com/sharedfiles/filedetails/?id=3456575967

private _drone=_this select 0;
private _target=_this select 1;
//private _speed=40;
private _speed=20;
//_speed=speed _drone;
if((count _this)>2)then{_speed=_this select 2};
private _minDistanceToTarget=.1;
if((count _this)>3)then{_minDistanceToTarget=_this select 3};
private _AP=FALSE;
private _crocus=FALSE;
private _crocusAP=[
"B_KVN_AP",
"O_KVN_AP",
"I_KVN_AP",
"B_KVN_AP_TI",
"O_KVN_AP_TI",
"I_KVN_AP_TI",
"B_CROCUS_AP",
"O_CROCUS_AP",
"I_CROCUS_AP",
"B_CROCUS_AP_TI",
"O_CROCUS_AP_TI",
"I_CROCUS_AP_TI"
];
private _crocusAT=[
"B_KVN_AT",
"O_KVN_AT",
"I_KVN_AT",
"B_KVN_AT_TI",
"O_KVN_AT_TI",
"I_KVN_AT_TI",
"B_CROCUS_AT",
"O_CROCUS_AT",
"I_CROCUS_AT",
"B_CROCUS_AT_TI",
"O_CROCUS_AT_TI",
"I_CROCUS_AT_TI"
];

if((toUpper(typeOf _drone))in _crocusAT)then{
	_crocus=TRUE;
	_speed=15;
};
if((toUpper(typeOf _drone))in _crocusAP)then{
	_crocus=TRUE;
	_AP=TRUE;
	_speed=15;
	_minDistanceToTarget=1;
};
if(ddtDebug)then{systemChat format["FPV attack speed: %1",_speed]};
_drone setCombatMode"BLUE";
_drone setBehaviour"CARELESS";
private _targetVelocity=[];

private _netId = netId _drone;

while{!isNull _drone && {!isNull _target}}do{
	if((count(crew _drone))<1)exitWith{};
	//if(isNull _drone || {isNull _target} || {getPosASLVisual _drone distance _targetPos <= _minDistanceToTarget})exitWith{};
	if(isNull _drone || {isNull _target})exitWith{};

	private _currentPos = getPosASLVisual _drone;

	if (_netId in EJF_disabledUavs) then {
		// private _targetPos = _currentPos vectorAdd ((vectorNormalized (vectorDir _drone)) vectorMultiply 10);
		// _targetPos set [2, _currentPos select 2];
		private _forwardVector = vectorDir _drone;// vectorNormalized (_targetPos vectorDiff _currentPos);
		// private _rightVector = (_forwardVector vectorCrossProduct [0,0,1]) vectorMultiply -1;
		private _upVector = vectorUp _drone;
		_targetVelocity = _forwardVector vectorMultiply _speed;
		_drone setVelocity _targetVelocity;
		sleep 0.3;
		if(isNull _drone) exitWith {};
		_drone setVectorDirAndUp [_forwardVector, _upVector];
		continue;
	};

	private _targetPos = getPosASLVisual _target;
	//private _currentPos=getPosWorldVisual _drone;
	//private _targetPos=getPosWorldVisual _target;
	if(((getPosASLVisual _drone)distance _targetPos)<=_minDistanceToTarget)exitWith{};
	private _forwardVector=vectorNormalized(_targetPos vectorDiff _currentPos);
	private _rightVector=(_forwardVector vectorCrossProduct[0,0,1])vectorMultiply -1;
	private _upVector=_forwardVector vectorCrossProduct _rightVector;
	_targetVelocity=_forwardVector vectorMultiply _speed;
	_drone setVelocity _targetVelocity;
	sleep .3;
	if(isNull _drone)exitWith{};
	_drone setVectorDirAndUp [_forwardVector,_upVector];
};
if(isNull _drone)exitWith{};
_drone setFuel 0;
if!(_crocus)exitWith{};
_drone call DB_fnc_fpv_onDestroy;