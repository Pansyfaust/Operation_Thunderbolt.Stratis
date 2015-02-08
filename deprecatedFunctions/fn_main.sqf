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
