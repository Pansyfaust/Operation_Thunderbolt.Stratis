#include "defines.hpp"

private ["_d","_h","_m"];
_d = _this select 0;
_h = _this select 1;
_m = _this select 2;
setDate [2035, 0, _d, _h, _m];
if (!isServer) then {TimeOfDay = nil};

DEBUG_MSG("Date: " + str date)