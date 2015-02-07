if (!isServer) exitWith {};
private ["_list","_newArray","_targets","_unit","_value"];

while {!(call fnc_CheckWinLose)} do {
    //if DEBUG then {hint format ['Detect: %1\nMax: %2',DetectionLevel,MaxDetection]};

    _list = +(list DetectTrigger);
    _newArray = [];
    _targets = [];
    
    //+1 to all detected
    {
        if (count _list == 0) exitWith {};
        _unit = _x select 0;
        _value = _x select 1;
    
        {
            if (_x == _unit) exitWith {
                _list = _list - [_x];
                if (_value <= MaxDetection) then {
                    _value = _value + 1;
                    //Who knows if this works as intended
                    if (_value == MaxDetection) then {
                        {if (side _x == East AND (assignedVehicle leader _x) isKindOf "Air") then {_x reveal [_unit, 1.5]}} forEach allGroups;
                    };
                } else {
                    _targets set [count _targets, _unit];
                };
                _newArray set [count _newArray, [_unit, _value]];
            };
        } forEach _list;
    } forEach Detected;
    
    //Add newly detected units
    if (count _list > 0) then {
        {
            if !(isNull _x) then {_newArray set [count _newArray, [_x, 1]]};
        } forEach _list;
    };
    
    //if DEBUG then {hint format ["%1", Detected]};
    Detected = _newArray;
    Targets = _targets;
    
    //Attack detected units with high value
    if (count _targets > 0) then {
        if (!(_targets call fnc_Mortar) AND isNull SpecialAttack) then {
            switch (floor random 10) do {
                case 0: {
                    SpecialAttack = _targets call fnc_SpawnHeli;
                };
                case 1: {
                    SpecialAttack = _targets call fnc_SpawnElite;
                };
                case 2: {
                    SpecialAttack = [_targets call BIS_fnc_selectRandom, 2] call fnc_SpawnHeliInf;
                };
                case 3: {
                    SpecialAttack = call fnc_SpawnAttack;
                };
                case 4: {
                    SpecialAttack = call fnc_SpawnAttack;
                };
                default {
                    SpecialAttack = [_targets call BIS_fnc_selectRandom, [0,0,1] call BIS_fnc_selectRandom] call fnc_SpawnHeliInf;
                };
            };
        };
    } else {
        if (EncounterCount < MaxEncounter AND random 6 < 1) then {call fnc_SpawnEncounter};
    };

    //Mission Assignment
    if (ActiveMissions < 1) then {call fnc_AssignMission};

    sleep 5;
};