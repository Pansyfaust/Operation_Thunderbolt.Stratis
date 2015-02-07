//[GRP, POSITION, RADIUS] call fnc_AssignPatrol;
fnc_AssignPatrol = {
    private ["_grp","_psn","_radius","_dir","_oldDir","_percent","_wp_psn","_wp"];

    _grp = _this select 0;
    _psn = _this select 1;
    _radius = _this select 2;

    _dir = random 360;
    _oldDir = random 360;

    for "_i" from 1 to 3 + round random 3 do {
        while {[_dir,_oldDir] call fnc_AngleDiff < 60} do {_dir = random 360};
        _oldDir = _dir;

        _percent = 0.8 + random 0.2;
        while {_percent > 0} do {
            _wp_psn = [_psn, _dir, _radius * _percent] call fnc_NearPoint;

            if ([_wp_psn, False] call fnc_IsGoodTarget AND !([_wp_psn] call fnc_IsNearWater)) exitWith {};
            _percent = _percent - 0.1;
            _wp_psn = _psn;
        };

        _wp = _grp addWaypoint [_wp_psn,0];
        _wp setWaypointType "MOVE";

        //DEBUGGING
        //if DEBUG then {[_wp_psn, "mil_destroy", "ColorGreen", 0.5, random 1000, _i] call fnc_DebugMarker};
    };

    _wp = _grp addWaypoint [getWPPos[_grp,1],0];
    _wp setWaypointType "CYCLE";

    //DEBUGGING
    /*if DEBUG then {   
        [(getWPPos[_grp,1]), "mil_destroy", "ColorGreen"] call fnc_DebugMarker;
        _marker = createMarker [format["Area%1",random 1000], _psn];
        _marker setMarkerShape "ELLIPSE";
        _marker setMarkerSize [_radius,_radius];
        _marker setMarkerBrush "Border";
        _marker setMarkerColor "ColorGreen";
    };*/
};

//[TARGET OBJ, RADIUS, patrol size] call fnc_SpawnPatrol;
fnc_SpawnPatrol = {
    private ["_spawnPos","_radius","_size","_grp"];

    _spawnPos = _this select 0;
    if (typeName _spawnPos == "OBJECT") then {_spawnPos = getposATL _spawnPos};
    _radius = _this select 1;
    _size = if (count _this > 2) then {_this select 2} else {2 + floor(random 5)};

    if (random 20 < 1) then {
        _grp = [_spawnPos, 15, _size] call fnc_CreateElite;
    } else {
        _grp = [_spawnPos, 15, _size] call fnc_CreateRegular;
    };

    if (random 1 < 0.5) then {_grp enableAttack False};
    _grp setBehaviour "AWARE";
    if (random 6 > Diff_Level) then {
        _grp spawn {
            sleep 30;
            _this setBehaviour "SAFE";
        };
    };

    [_grp, _spawnPos, _radius] call fnc_AssignPatrol;

    //DEBUGGING
    //if DEBUG then {[_grp, "ColorRed"] execVM "scripts\debug_tracking.sqf"};

    //Return group
    _grp
};