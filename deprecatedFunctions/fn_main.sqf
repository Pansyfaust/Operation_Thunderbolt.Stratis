fnc_Distance2D = {
    //Modified BIS function
    private ["_pos1","_pos2"];
    _pos1 = _this select 0;
    _pos2 = _this select 1;
    if (typeName _pos1 == "OBJECT") then {_pos1 = getposATL _pos1};
    if (typeName _pos2 == "OBJECT") then {_pos2 = getposATL _pos2};
    _pos1 = [_pos1 select 0, _pos1 select 1];
    _pos2 = [_pos2 select 0, _pos2 select 1];
    _pos1 distance _pos2
};

fnc_DirTo = {
    //Same as the BIS function but with getposATL
    private ["_pos1","_pos2","_return"];
    _pos1 = _this select 0;
    _pos2 = _this select 1;
    if (typename _pos1 == "OBJECT") then {_pos1 = getposATL _pos1};
    if (typename _pos2 == "OBJECT") then {_pos2 = getposATL _pos2};
    _return = ((_pos2 select 0) - (_pos1 select 0)) atan2 ((_pos2 select 1) - (_pos1 select 1));
    _return % 360
};

fnc_AngleDiff = {
    private ["_dir1","_dir2","_diff"];
    _dir1 = _this select 0;
    _dir2 = _this select 1;
    _diff = abs (_dir1 - _dir2) % 360;
    if (_diff > 180) then {_diff = 360 - _diff};
    _diff
};

fnc_RemoveArrayItem = {
    private ["_array","_item","_i"];
    _array = _this select 0;
    _item = _this select 1;
    _i = _array find _item;
    if (_i != -1) then {
        _array set [_i, objNull];
        _array = _array - [objNull];
    };
    _array
};

fnc_RemoveNested = {
    //Removes nested array elements
    private ["_array","_tgt","_i"];
    _array = _this select 0;
    _tgt = _this select 1;
    _i = 0;
    {
        if (str (_x select 0) == str _tgt) exitWith {
            _array set [_i, objNull];
            _array = _array - [objNull];
        };
        _i = _i + 1;
    } forEach _array;
    _array
};

//[POS, [X RADIUS/HALF WIDTH, Y RADIUS/ HALF WIDTH, ANGLE, IS RECT?], ["West", "EAST D", False], ["","",""]] call fnc_CreateTrigger;
fnc_CreateTrigger = {
    private ["_psn","_size","_activation","_statements","_trigger"];
    _psn = _this select 0;
    _size = _this select 1;
    _activation = _this select 2;
    _statements = _this select 3;
    if (typeName _psn == "OBJECT") then {_psn = getposATL _psn};
    _trigger = createTrigger ["EmptyDetector", _psn];
    _trigger setTriggerArea _size;
    _trigger setTriggerActivation _activation;
    _trigger setTriggerStatements _statements;
    _trigger
};

fnc_MeanVelocity = {
    private ["_list","_count","_useDir","_mean_vel","_magnitude","_total_x","_total_y","_vel","_mean_x","_mean_y"];
    _list = _this select 0;
    _count = count _list;
    //True produces mean dir instead of velocity
    _useDir = if (count _this > 1) then {_this select 1} else {False};

    if (_count == 0) then {
        _mean_vel = -1;
        _magnitude = -1;
    } else {
        _total_x = 0;
        _total_y = 0;
        {
            _vel = if (_useDir) then {vectorDir _x} else {velocity _x};
            _total_x = _total_x + (_vel select 0);
            _total_y = _total_y + (_vel select 1);
        } forEach _list;
    
        _mean_x = _total_x / _count;
        _mean_y = _total_y / _count;
        _mean_vel = (_mean_x) atan2 (_mean_y);
        _mean_vel = _mean_vel % 360;
        _magnitude = ([_mean_x,_mean_y] distance [0,0]);
        if !(_useDir) then {_magnitude = _magnitude * 3.6};
    };

    //DEBUGGING
    //if DEBUG then {hint format ["Player Dir: %1\nMean Dir: %2\nMagnitude: %3\nUnit Count: %4\n Dir: %5",getdir player,_mean_vel,_magnitude,_count,_useDir]};

    //Any negative return is an error
    [_mean_vel,_magnitude]
};

fnc_MissionMarker = {
    private ["_tgt","_isSupply","_color","_size","_psn","_marker"];

    _tgt = _this select 0;
    _isSupply = if (count _this > 1) then {_this select 1} else {False};
    _color = if (_isSupply) then {"ColorBLUFOR"} else {"ColorOPFOR"};
    _name = if (_isSupply) then {format ["Supply%1",SupplyCount]} else {format ["Mission%1",MissionCount]};
    _size = SpawnFreq * 50 + random 100;
    
    while {True} do {
        _psn = [_tgt, random 360, 0, _size, 0, False] call fnc_NearPoint;
        if !([_psn] call fnc_IsNearWater) exitWith {};
    };
    
    _marker = createMarker [_name, _psn];
    _marker setMarkerShape "ELLIPSE";
    _marker setMarkerSize [_size+5,_size+5];
    _marker setMarkerBrush "Border";
    _marker setMarkerColor _color;

    _marker
};

fnc_UpdateJIP = {
    private ["_playerid","_timePassed","_newDelay",
             "_newOverValue","_newFogValue","_newFogFade","_newFogAlt",
             "_oldFogValue","_oldFogFade","_oldFogAlt",
             "_JIPdelay","_interp","_JIPFogValue","_JIPFogFade","_JIPFogAlt",
             "_JIPweather"];

    _playerid = _this;

    if (WeatherMode == -1) then {
        _timePassed = Time - (DynamicWeather select 0);

        _newDelay = DynamicWeather select 1;
        _newOverValue = DynamicWeather select 2;
        _newFogValue = (DynamicWeather select 3) select 0;
        _newFogFade = (DynamicWeather select 3) select 1;
        _newFogAlt = (DynamicWeather select 3) select 2;

        _oldFogValue = (OldWeather select 3) select 0;
        _oldFogFade = (OldWeather select 3) select 1;
        _oldFogAlt = (OldWeather select 3) select 2;

        //Remaining time
        _JIPdelay = (_newDelay - _timePassed) max 0;

        //FUTURE: remove when fog2 is out
        if (_newDelay > 0) then {
            _interp = _timePassed / _newDelay;
            _JIPFogValue = _oldFogValue + (_newFogValue - _oldFogValue) * _interp;
            _JIPFogFade = _oldFogFade + (_newFogFade - _oldFogFade) * _interp;
            _JIPFogAlt = _oldFogAlt + (_newFogAlt - _oldFogAlt) * _interp;
        } else {
            _JIPFogValue = _newFogValue;
            _JIPFogFade = _newFogFade;
            _JIPFogAlt = _newFogAlt;
        };

        _JIPweather = [
            0, 0,
            overcast,
            [_JIPFogValue, _JIPFogFade, _JIPFogAlt]
        ];
        [_JIPweather, "fnc_UpdateWeather", _playerid] spawn BIS_fnc_MP;
        _JIPweather = [
            0, _JIPdelay,
            _newOverValue,
            [_newFogValue, _newFogFade, _newFogAlt]
        ];
        [DynamicWeather, "fnc_UpdateWeather", _playerid] spawn BIS_fnc_MP;
    };
};

fnc_OnPlayerConnected = {
    private ["_uniqueid","_playerid","_list"];
    scopeName "main";
    _uniqueid = _this;
    _playerid = -1;
    
    sleep 0.01;
    for "_tries" from 1 to 100 do {
        _list = [playableUnits, player] call fnc_RemoveArrayItem;
        {
            if (getPlayerUID _x == _uniqueid) then {
                _playerid = owner _x;
                breakTo "main";
            };
        } forEach _list;  
        sleep 0.1;
    };
    _playerid call fnc_UpdateJIP;
    if DEBUG then {player globalchat "Updating JIP"};
};


MissionsPool = [];
_class = (missionConfigFile >> "ThunderboltConfig" >> "MissionTypes");
for [{_x=0},{_x< count _class},{_x=_x+1}] do {
	MissionsPool set [count MissionsPool,_class select _x];
};

fnc_AssignMission = {
    //if (count MissionsPool == 0) exitWith {execVM "missions\End_Exfil.sqf"};
    (MissionsPool call BIS_fnc_SelectRandom) spawn TB_fnc_generateTask;
/*
    if (execVM _msnFile) then {
        MissionsPool = [MissionsPool,_msn] call fnc_RemoveArrayItem;
    };
*/
};