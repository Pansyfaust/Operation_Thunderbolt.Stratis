private ["_grp","_color","_posn","_seed","_i","_tgt"];
if !DEBUG exitWith {};
_grp = _this select 0;
_color = _this select 1;
_posn = getposATL (leader _grp);
_seed = random 1000;
_i = 0;

fnc_DebugMarker = {
    private ["_psn","_type","_color","_size","_name","_text","_marker"];

    if !DEBUG exitWith {};
    _psn = _this select 0;
    _type = _this select 1;
    _color = _this select 2;
    _size = if (count _this > 3) then {_this select 3} else {1};
    _name = if (count _this > 4) then {_this select 4} else {random 100000};
    _text = if (count _this > 5) then {_this select 5} else {""};

    _marker = createMarker [format["%1",_name],_psn];
    _marker setMarkerShape "ICON";
    _marker setMarkerType _type;
    _marker setMarkerColor _color;
    _marker setMarkerSize [_size,_size];
    _marker setMarkerText format [" %1",_text];
};


_tgt = format ["%1T",_seed];
[_posn,"mil_destroy",_color,0.8,_tgt] call fnc_DebugMarker;

while {{alive _x} count units _grp > 0} do {
	_posn = getposATL (leader _grp);
    [_posn,"mil_dot",_color,0.5,format["%1%2",_seed,_i]] call fnc_DebugMarker;
    _tgt setMarkerPos _posn;
    _i = _i + 1;
    sleep 5;
};

_tgt setMarkerType "mil_objective";
sleep 10;

for "_count" from 0 to _i do {
	deleteMarker format ["%1%2",_seed,_count];
	sleep 0.05;
};

sleep 10;
deleteMarker _tgt;