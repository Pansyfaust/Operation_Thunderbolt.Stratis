#define RAND_ANGLE 30

fnc_FindPos = {
    private ["_list","_min","_max","_mode","_checked","_return","_tgt","_tgtPos","_nearList","_dir","_spawnPos","_enemy_psn"];

    scopeName "main";
    _list = +(_this select 0);
    _min = _this select 1;
    _max = _this select 2;
    _mode = if (count _this > 3) then {_this select 3} else {0};
    _checked = [];
	//le lazy fix
    _return = [[],[]];

    for "_tries" from 1 to 20 do {
        scopeName "find_loop";
    
        if (count _list == 0) then {breakTo "main"} else {    
            _tgt = _list call BIS_fnc_selectRandom;
            _tgtPos = getposASL _tgt;
            //if DEBUG then {[format["Tries: %1<br/>Mode: %2",_tries,_mode],0,-(safezoneH-3.2)/2,6,0.5,0,9] spawn bis_fnc_dynamicText};

            if !(_tgt in _checked) then {
                if (!alive _tgt AND _tgt getVariable ["FAR_isUnconscious", 1] == 1) then {
                    _list = [_list, _tgt] call fnc_RemoveArrayItem;
                    breakTo "find_loop";
                };

                /*if (vehicle _tgt != _tgt) then {
                    _list = [_list, _tgt] call fnc_RemoveArrayItem;
                    breakTo "find_loop";
                };*/

                if ([_tgtPos] call fnc_IsNearWater) then {
                    _list = [_list, _tgt] call fnc_RemoveArrayItem;
                    breakTo "find_loop";
                };
    
                if !([_tgtPos] call fnc_IsGoodTarget) then {
                    _list = [_list, _tgt] call fnc_RemoveArrayItem;
                    breakTo "find_loop";
                };
        
                _checked set [count _checked, _tgt];
            };

            if (_mode > 0) then {
                //Quit if less than 1/5 total guys in this group out of current list
                _nearList = [_tgt, 60] call fnc_CheckPlayers;
                if (count _nearList < (count _list) / 5) then {
                    _list = [_list, _tgt] call fnc_RemoveArrayItem;
                    breakTo "find_loop";
                };
            
                //Quit if group isn't heading or looking at a particular dir
                _dir = [_nearList] call fnc_MeanVelocity;
                if (_dir select 1 < 10) then {
                    _dir = [_nearList,True] call fnc_MeanVelocity;
                    if (_dir select 1 < 0.75) then {
                        _list = [_list, _tgt] call fnc_RemoveArrayItem;
                        breakTo "find_loop";
                    };
                };
                _dir = (_dir select 0) - RAND_ANGLE + random (RAND_ANGLE * 2);
            } else {
                _dir = random 360;
            };

            _spawnPos = [_tgtPos, _dir, _min, _max, 2] call fnc_NearPoint;
    
            if ([_spawnPos] call fnc_IsNearWater) then {breakTo "find_loop"};        
            if !([_spawnPos] call fnc_IsGoodTarget) then {breakTo "find_loop"};

            switch (_mode) do {
                case 0: {
                    _nearList = [_spawnPos, 1000] call fnc_CheckPlayers;
                    if !([ATLToASL _spawnPos, _nearList, 350] call fnc_IsHidden) then {breakTo "find_loop"};
                };
                case 1: {
                    _nearList = [_spawnPos, 1000] call fnc_CheckPlayers;
                    if !([ATLToASL _spawnPos, _nearList, 150] call fnc_IsHidden) then {breakTo "find_loop"};
                };
                case 2: {
					if (!isNil "_enemy_psn") then {
						_nearList = (_enemy_psn) nearEntities [["SoldierEB","Car_F","StaticWeapon"],160];
						{if (side _x == East) then {breakTo "enemy_loop"}} forEach _nearList;
					};
                };
            };

            _return = [_spawnPos,_tgtPos];
            breakTo "main";
        };
    };

    //Returns spawn and target pos, else empty array
    _return
};

//[SIZE, MAX SLOPE, pos, min, max, maxTry, no opfor?] call fnc_FindClearSpot;
fnc_FindClearSpot = {
    private ["_area","_slope","_origin","_min","_max","_forRespawn","_return","_psn","_list","_list2"];
    scopeName "main";
    
    _area = _this select 0;
    _slope = _this select 1;
    _origin = if (count _this > 2) then {_this select 2} else {getposATL Center};
    if (typeName _origin == "OBJECT") then {_origin = getposATL _origin};
    _min = if (count _this > 3) then {_this select 3} else {0};
    _max = if (count _this > 4) then {_this select 4} else {4000};
    _maxTry = if (count _this > 5) then {_this select 5} else {100};
    _forRespawn = if (count _this > 6) then {_this select 6} else {False};
    _return = [];

    for "_tries" from 1 to _maxTry do {
        scopeName "findpos";

        _psn = [_origin, random 360, _min, _max] call fnc_NearPoint;

        //DEBUGGING
        //if DEBUG then {[_psn, "mil_dot", "ColorYellow"] call fnc_DebugMarker};

        _psn = _psn isFlatEmpty [_area, 50, _slope, _area, 0, False];

        if (count _psn == 3) then {
            if (isOnRoad _psn) then {breakTo "findpos"};
            if !([_psn] call fnc_IsGoodTarget) then {breakTo "findpos"};
            if (_forRespawn) then {
                _list2 = [];
                _list = _psn nearEntities [["SoldierEB","Car_F","Ship_F","StaticWeapon"], 500];
                {
                    if (side _x == East) then {_list2 set [count _list2, _x]};
                } forEach _list;
                if !([_psn, _list2, 300] call fnc_IsHidden) then {breakTo "findpos"};
            } else {
                if (count ([_psn, 800] call fnc_CheckPlayers) > 0) then {breakTo "findpos"};
            };
            _return = _psn;

            //DEBUGGING
            if DEBUG then {[_psn, "mil_triangle", "ColorOPFOR"] call fnc_DebugMarker};

            breakTo "main";
        };
    };

    //Returns blank array if no position found
    _return
};

/*fnc_FindRespawnPos = {
    private ["_list","_tgt","_psn"];

    scopeName "main";
    while {!CanRespawn AND !GameOver} do {
        _list = if (isMultiplayer) then {playableUnits} else {switchableUnits};
        while {count _list > 0} do {            
            _tgt = _list call BIS_fnc_selectRandom;
            if (alive _tgt AND _tgt getVariable ["FAR_isUnconscious", 0] == 0) then {
                _psn = [1, 0.5, _tgt, 5, 1000, 10, True] call fnc_FindClearSpot;
                if (count _psn == 3) then {
                    "respawn_west" setMarkerPos _psn;
                    CanRespawn = True;
                    publicVariable "CanRespawn";
                    sleep 30;
                    CanRespawn = False;
                    publicVariable "CanRespawn";
                    "respawn_west" setMarkerPos [-1000,-1000];
                    breakTo "main";
                };
            };
            _list = [_list, _tgt] call fnc_RemoveArrayItem;
            sleep 0.01;
        };
    sleep 30;
    };
};*/