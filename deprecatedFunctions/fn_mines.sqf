fnc_LoopMines = {
    private ["_psn","_blue_list"];
    _psn = _this select 1;
    Minefields set [count Minefields, [_psn, 150]];
    
    sleep 300;
    while {True} do {
        _blue_list = [_psn, 500] call fnc_CheckPlayers;
        if (count _blue_list <= 0) exitWith {};
        sleep 60;
    };
    {deleteVehicle _x} forEach (_this select 0);
    Minefields = [Minefields, _psn] call fnc_RemoveNested;
};

//[OBJECT/POS, length/min radius, breadth/max radius, quantity, rectangle?, road mode, multiplier, list of mine types] call fnc_CreateMines;
//[player,20,50,100,True,2,["APERSTripMine"]] call fnc_CreateMines;
fnc_CreateMines = {
    private ["_psn","_input1","_input2","_quantity","_isRect","_roadMode","_multiplier","_mines","_count","_mineList","_randPos","_mine"];
    
    _psn = _this select 0;
    if (typeName _psn == "OBJECT") then {_psn = getposATL _psn};
    _input1 = _this select 1;
    _input2 = _this select 2;
    _quantity = _this select 3;
    _isRect = if (count _this > 4) then {_this select 4} else {false};
    //0: Everywhere, 1: Roads Only, 2: Excluding Roads
    _roadMode = if (count _this > 5) then {_this select 5} else {0};
    _multiplier = if (count _this > 6) then {_this select 6} else {2};
    //ATMine,APERSTripMine,SLAMDirectionalMine
    _mines = if (count _this > 7) then {_this select 7} else {[(missionConfigFile >> "ThunderboltConfig" >> "classNames"),"MineClasses",[]] call BIS_fnc_returnConfigEntry};
    _count = 0;
    _mineList = [];

    for "_tries" from 1 to (floor (_quantity * _multiplier)) do {
        scopeName "mine_loop";
        if (_count >= _quantity) exitWith {};
        
        if (_isRect) then {
            _randPos = [(_psn select 0) + (_input1 / 2) - (random _input1),
                        (_psn select 1) + (_input2 / 2) - (random _input2), 0];
        } else {
            _randPos = [_psn, random 360, _input1, _input2, 0] call fnc_NearPoint;
        };

        if !([_randPos] call fnc_IsNearWater) then {
            switch (_roadMode) do {
                case 1: {if !(isOnRoad _randPos) then {breakTo "mine_loop"}};
                case 2: {if (isOnRoad _randPos) then {breakTo "mine_loop"}};
            };
            _mine = createMine [(_mines call BIS_fnc_selectRandom),_randPos,[],0];
            _mine setDir random 360;
            East revealMine _mine;
            _count = _count + 1;
            _mineList set [count _mineList, _mine];

            //DEBUGGING
            /*if DEBUG then {
                //hint format ["Mines: %1", _count];
                West revealMine _mine;
            };*/
        };
    };

    //Returns a list of the mines generated
    _mineList
};

//call fnc_SpawnMines;
fnc_SpawnMines = {
    private ["_list","_psn","_mineList"];   

    _list = if isMultiplayer then {playableUnits} else {switchableUnits};
    _psn = ([_list,300,500,2] call fnc_findPos) select 0;

    if (count _psn > 0) then {
        _mineList = [_psn, 0, 100 + random 50, 50 + random 50, false, 2] call fnc_CreateMines;
        [_mineList,_psn] spawn fnc_LoopMines;
    };
};