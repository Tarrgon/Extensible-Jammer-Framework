#include "..\..\script_component.hpp"

if (!hasInterface || isNil "EJF_filmGrainHandle") exitWith {};

params [["_intensity", 0, [0]]];

if (EJF_filmGrainHandle == -1) then {
	private _priority = 2001;

	while {
		EJF_filmGrainHandle = ppEffectCreate ["FilmGrain", _priority];
		EJF_filmGrainHandle < 0;
	} do {
		_priority = _priority + 1;
	};

	EJF_filmGrainHandle ppEffectEnable true;
	EJF_filmGrainHandle ppEffectAdjust [0, 1.25, 2.01, 0.75, 1.0, 0];
	EJF_filmGrainHandle ppEffectCommit 0;
};

if (EJF_filmGrainHandle >= 0) then {
	private _sharpness = switch true do {
		case (_intensity < 0.2): { 0.8 };
		case (_intensity < 0.5): { linearConversion [0.2, 0.5, _intensity, 0.8, 0.3, true] };
		case (_intensity < 0.8): { linearConversion [0.5, 0.8, _intensity, 0.3, 0.5, true] };
		case (_intensity <= 1): { linearConversion [0.8, 1, _intensity, 0.5, 0.2, true] };
	};

	private _grainSize = switch true do {
		case (_intensity < 0.2): { 3 };
		case (_intensity < 0.5): { linearConversion [0.2, 0.5, _intensity, 3, 1.8, true] };
		case (_intensity < 0.8): { linearConversion [0.5, 0.8, _intensity, 1.8, 4, true] };
		case (_intensity <= 1): { linearConversion [0.8, 1, _intensity, 4, 6, true] };
	};

	EJF_filmGrainHandle ppEffectAdjust [_intensity max 0, _sharpness, _grainSize, 0.75, 1.0, 0];
	EJF_filmGrainHandle ppEffectCommit 0.1;
};