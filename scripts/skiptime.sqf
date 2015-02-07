private ["_d","_m"];
_d = _this select 0;
_m = (_this select 1) * 60;
setDate [2035, 0, _d, 0, _m];
if (!isServer) then {timeOfDay = nil};