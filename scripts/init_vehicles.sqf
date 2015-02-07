{
    if (!(_x isKindOf "Thing") OR _x == HQ) then {
        if (_x isKindOf "LandVehicle") then {
            if (random 1 < 0.2) then {_x setDir getDir _x + 180};
            if (typeOf _x == "c_offroad") then {
                //_x animate ["HidePolice", floor random 2];
                if (random 1 < 0.1) then {
                    _x animate ["HideServices", 0];
                } else {
                    if (random 1 < 0.33) then {_x animate [["HideBumper1","HideBumper2"] call BIS_fnc_SelectRandom, 0]};
                    if (random 1 < 0.33) then {_x animate ["HideConstruction", 0]};
                };
                if (random 1 < 0.2) then {_x animate ["HideBackpacks", 0]};
                //if (random 1 < 0.25) then {_x animate ["HideDoor3", 1]};
                if (random 1 < 0.25) then {
                    _x animate ["HideDoor2", 1];
                    _x animate ["HideDoor1", 1];
                    _x animate ["HideGlass2", 1];
                };
            };
        };
        clearWeaponCargoGlobal _x;
        clearMagazineCargoGlobal _x;
        clearItemCargoGlobal _x;
        _x addEventHandler ["Killed", {_this spawn fnc_CleanupVehicle}];
        _x call fnc_MakeProtected;
        if (random 1 < 0.2) then {_x setDamage random 0.9};
    };
} forEach vehicles;