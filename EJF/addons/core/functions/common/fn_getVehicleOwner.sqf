params ["_vehicle"];

private _owner = objNull;

private _driver = driver _vehicle;

if (!(_driver isEqualTo objNull) && { isPlayer _driver && alive _driver }) then {
  _owner = _driver;
};

if (_owner isEqualTo objNull) exitWith {
  private _units = crew _vehicle;

  private _playerUnits = _units select { isPlayer _x && alive _x };
  private _newOwner = _playerUnits param [0];

  if (isNil "_newOwner") then {
    private _aiUnits = _units select { !isPlayer _x && alive _x };

    _newOwner = _aiUnits param [0];
  };

  if (isNil "_newOwner") exitWith {
    objNull;
  };

  _newOwner;
};

_owner;