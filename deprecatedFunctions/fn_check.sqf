//[POS, RANGE, only infantry?] call fnc_CheckPlayers;
fnc_CheckPlayers = {
    private ["_return","_psn","_limit","_list","_infOnly"];

    _return = [];
    _psn = _this select 0;
    _limit = _this select 1;
    //True if infantry only, optional
    _infOnly = if (count _this > 2) then {_this select 2} else {False};
    _list = if (isMultiplayer) then {playableUnits} else {switchableUnits};

    {
        if ([_x, _psn] call fnc_Distance2D <= _limit) then {
            if (_infOnly) then {
                if (vehicle _x == _x) then {_return set [count _return, _x]};
            } else {
                _return set [count _return, _x];
            };
        };
    } forEach _list;

    //Faster than using nearEntities!
    //Returns a list of players in range
    _return
};

//FUTURE: check only when objective completed and player downed
fnc_CheckWinLose = {
    private ["_return","_list","_status"];
    _list = if (isMultiplayer) then {playableUnits} else {switchableUnits};
    
    if ({alive _x AND _x getVariable ["FAR_isUnconscious", 0] == 0} count _list == 0) then {
        _status = "scripts\end_lose.sqf";
    } else {
        if (ObjectivesCompleted >= MissionLimit) then {
            _status = "scripts\end_win.sqf";
        };
    };

	_return = !isNil "_status";
    if (_return) then {
        [[_status],"BIS_fnc_execVM",True,True] spawn BIS_fnc_MP;
        GameOver = True;
    };

    //True if gameover, else False
    _return;
};

fnc_CheckCustomTextureList = {
    private ["_textures","_list","_delete","_entry"];
    if (count CustomTextureUnits == 0) exitWith {};
    for "_i" from 0 to (count CustomTextureUnits - 1) do {
        _textures = (CustomTextureUnits select _i) select 0;
        _list = (CustomTextureUnits select _i) select 1;
        _delete = [];
    
        for "_unit" from 0 to (count _list - 1) do {
            if (isNull (_list select _unit)) then {
                _delete set [count _delete, _unit];
            };
        };

        {
            _list set [_x, objNull];
        } forEach _delete;
        _list = _list - [objNull];

        _entry = if (count _list > 0) then {[_textures, _list]} else {objNull};
        CustomTextureUnits set [_i, _entry];
    };
    CustomTextureUnits = CustomTextureUnits - [objNull];
};

//[POSITION, TARGETS] call fnc_Closest;
fnc_Closest = {
    private ["_psn","_list","_return","_dist"];

    _psn = _this select 0;
    _list = _this select 1;

    _return = [_list select 0, [_list select 0, _psn] call fnc_Distance2D];
    {
        _dist = [_x, _psn] call fnc_Distance2D;
        if (_dist < _return select 1) then {_return = [_x, _dist]};
    } forEach _list;
    
    _return
};

fnc_ClosestTarget = {
    private ["_grp","_range","_lead","_list","_psn","_tgt"];

    _grp = _this select 0;
    _range = if (count _this > 1) then {_this select 1} else {1000};
    _lead = getposATL leader _grp;
    _tgt = [_lead, 0];

    _list = [_lead, 1000] call fnc_CheckPlayers;
    {
        if (alive _x AND _x getVariable ["FAR_isUnconscious", 0] == 0 AND !(vehicle _x isKindOf "Air")) then {
        _psn = getposATL _x;
            if ([_psn] call fnc_IsGoodTarget AND [_psn] call fnc_IsNearWater) then {
                _tgt = [_psn, [_x, _lead] call fnc_Distance2D];
            };
        };
    } forEach _list;

    //Returns [pos,range] of nearest player, else group leader
    _tgt
};

//[POS, LIST, min] call fnc_IsHidden;
//POS MUST ALWAYS BE ASL
fnc_IsHidden = {
    private ["_psn","_list","_min","_return","_tgt"];

    scopeName "main";
    _psn = _this select 0;
    if (typeName _psn == "OBJECT") then {_psn = getposASL _psn};
    _list = _this select 1;
    _min = if (count _this > 2) then {_this select 2} else {0};
    _return = True;
    
    {
        if ([_x, _psn] call fnc_Distance2D < _min) exitWith {_return = False};

        _tgt = eyePos _x;
        _tgt set [2, (_tgt select 2) + 1];
        if !(terrainIntersectASL [_tgt, _psn]) then {
            //Unreliable?
            if !(lineIntersects [_tgt, _psn, vehicle _x]) then {
                _return = False;
                breakTo "main";
            };
        };        
    } forEach _list;

    //True if hidden else False
    _return
};

fnc_IsNearWater = {
    private ["_psn","_radius","_return"];

    scopeName "main";
    _psn = _this select 0;
    _radius = if (count _this > 1) then {_this select 1} else {25};
    _return = True;

    if !(surfaceIsWater _psn) then {
        for "_dir" from 0 to 315 step 45 do {
            if (surfaceIsWater ([_psn, _dir, _radius] call fnc_NearPoint)) then {breakTo "main"};
        };
        _return = False;
    };

    //Less accurate but more flexible than isFlatEmpty for distance
    //True if near water, else False
    _return
};

fnc_IsGoodTarget = {
    private ["_psn","_active","_return","_areas"];
    
    _psn = _this select 0;
    _active = if (count _this > 1) then {_this select 1} else {True};
    _areas = +DoNotSpawnAreas;
    {_areas set [count _areas, _x]} forEach Minefields;
    if (_active) then {{_areas set [count _areas, [_x, 800]]} forEach ActiveAreas};
    _return = True;

    {
        if ([_x select 0, _psn] call fnc_Distance2D < (_x select 1)) exitWith {
            _return = False;
        };
    } forEach _areas;

    //True if not near safe zones, else False
    _return
};

fnc_CheckItemType = {
    private ["_item","_cfg"];
    _item = _this;
    if (getText (configFile >> "CfgMagazines" >> _item >> "displayname") != "") exitWith {"magazine"};
    _cfg = configFile >> "CfgWeapons" >> _item;
    if (isClass (_cfg >> "WeaponSlotsInfo") AND getNumber (_cfg >> "showEmpty") == 1) exitWith {"weapon"};
    "item"
};