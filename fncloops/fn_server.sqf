if (!isServer) exitWith {};
while {!GameOver} do {
    
    //Enemy Spawn
    if (HeliCount < MaxHelis AND random 3 < SpawnFreq) then {call fnc_SpawnHeli};
    if (count Minefields < 1 AND random 60 < SpawnFreq) then {call fnc_SpawnMines};
    if (EliteCount < 1 AND random 60 < SpawnFreq) then {call fnc_SpawnElite};
    if (count MortarList < MaxMortar AND random 30 < SpawnFreq) then {call fnc_CreateMortar};    
    if (CarCount < MaxCars AND random 3 < SpawnFreq) then {call fnc_SpawnCar};
    
    //Maintenance 
    {if (count units _x == 0) then {deleteGroup _x}} foreach allGroups;
    call fnc_RemoveEmptyVehicles;
    call fnc_CheckCustomTextureList;

    sleep 30;
};