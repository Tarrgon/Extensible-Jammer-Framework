#include "..\..\script_component.hpp"

if (!isServer) exitWith {
	ERROR("Attempted to call unjamAll from client.");
};