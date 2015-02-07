DEBUG = True;
waitUntil {!isNil "BIS_fnc_init"};

timeOfDay = paramsarray select 0;
timeOfDay = if (timeOfDay == -1) then {[1 + floor random 365, random 24]} else {[157, timeOfDay]};
[[timeOfDay,"scripts\skiptime.sqf"], "BIS_fnc_execVM", True] spawn BIS_fnc_MP;

WeatherMode = paramsarray select 1;

Use_NV = paramsarray select 2;
switch (Use_NV) do {
    case -2: {Use_NV = floor random 4};
    case -1: {Use_NV = floor random 2};
};
Use_NV = switch (Use_NV) do {
    case 0: {[False,False]};
    case 1: {[True,True]};
    case 2: {[True,False]};
    case 3: {[False,True]};
};
publicVariable "Use_NV";

GameOver = False;

Diff_Level = paramsarray select 3;

SpawnFreq = switch (Diff_Level) do {
    case 1: {0.5};
    case 2: {0.8};
    case 3: {1};
    case 4: {1.2};
    case 5: {1.5};
    case 6: {2};
    case 7: {2};
};

AI_AimAccuracy = (paramsarray select 4) / 10;
AI_AimShake = (paramsarray select 5) / 10;
AI_AimSpeed = (paramsarray select 6) / 10;
AI_SpotDistance = (paramsarray select 7) / 10;
AI_SpotTime = (paramsarray select 8) / 10;

HeliCount = 0;
//VE = 1; E/N = 2; H/VH = 3 ,EX/EE = 4
MaxHelis = ceil (SpawnFreq * 2);

EliteCount = 0;
//There can only be 1 elite group

EncounterCount = 0;
//VE = 1; E/N = 2; H/VH = 3 ,EX/EE = 4
MaxEncounter = MaxHelis;

MissionCount = 0;
ObjectivesCompleted = 0;
ActiveMissions = 0;
MissionLimit = paramsarray select 9;

UseMods = if (paramsarray select 10 == 1) then {True} else {False};

ActiveAreas = [];
Minefields = [];
//There can only be 1 dynamic minefield
DoNotSpawnAreas = [[Area_Xiros,200],
                   [Area_Pythos,200]];

MortarList = [];
//VE = 1; E/N = 2; H/VH = 3 ,EX/EE = 4
MaxMortar = MaxHelis;

SpecialAttack = grpNull;
Detected = [];
Targets = [];
MaxDetection = (7 - SpawnFreq) * 1;

ProtectedVehicles = [];
EmptyVehicles = [];

CarCount = 0;
//VE = 2; E/N = 3; H/VH = 4 ,EX/EE = 5
MaxCars = MaxHelis + 1;

CustomTextureUnits = [];

call TB_fnc_main;
call TB_fnc_check;
call TB_fnc_find;
call TB_fnc_unit;
call TB_fnc_inf;
call TB_fnc_infPatrol;
call TB_fnc_infEncounter;
call TB_fnc_infAttack;
call TB_fnc_infUrban;
call TB_fnc_infElite;
call TB_fnc_car;
call TB_fnc_heli;
call TB_fnc_mines;
call TB_fnc_mortar;
call TB_fnc_supply;

/*
call compileFinal preprocessFileLineNumbers "functions\main_functions.sqf";
call compileFinal preprocessFileLineNumbers "functions\check_functions.sqf";
call compileFinal preprocessFileLineNumbers "functions\find_functions.sqf";
call compileFinal preprocessFileLineNumbers "functions\unit_functions.sqf";
call compileFinal preprocessFileLineNumbers "functions\inf_functions.sqf";
call compileFinal preprocessFileLineNumbers "functions\inf_patrol_functions.sqf";
call compileFinal preprocessFileLineNumbers "functions\inf_encounter_functions.sqf";
call compileFinal preprocessFileLineNumbers "functions\inf_attack_functions.sqf";
call compileFinal preprocessFileLineNumbers "functions\inf_urban_functions.sqf";
call compileFinal preprocessFileLineNumbers "functions\inf_elite_functions.sqf";
call compileFinal preprocessFileLineNumbers "functions\car_functions.sqf";
call compileFinal preprocessFileLineNumbers "functions\heli_functions.sqf";
call compileFinal preprocessFileLineNumbers "functions\mines_functions.sqf";
call compileFinal preprocessFileLineNumbers "functions\mortar_functions.sqf";
call compileFinal preprocessFileLineNumbers "functions\supply_functions.sqf";
*/

DetectTrigger = [Center, [3500, 4000, 0, True], ["West", "EAST D", True], ["","",""]] call fnc_CreateTrigger;

if (WeatherMode == -1) then {
    [] spawn TB_fnc_weather;
};

"respawn_west" setMarkerPos ([1,0.5] call fnc_FindClearSpot);
"respawn_west" setMarkerAlpha 0;

execVM "scripts\init_vehicles.sqf";

sleep 0.01;
onPlayerConnected "_uid spawn fnc_OnPlayerConnected";
switch (WeatherMode) do {
    //Clear
    case 0: {[[0,0,random 0.5,[0,0.1,-200]], "fnc_UpdateWeather", True, True] spawn BIS_fnc_MP};
    //Overcast
    case 1: {[[0,0,0.5 + random 0.5,[0,0,0]], "fnc_UpdateWeather", True, True] spawn BIS_fnc_MP};
    //Random low fog
    case 2: {[[0,0,random 1,[0.5 + random 0.5, 0.05 + random 0.05, random 50]], "fnc_UpdateWeather", True, True] spawn BIS_fnc_MP};
    //Silent hill
    case 3: {[[0,0,1,[1,0,0]], "fnc_UpdateWeather", True, True] spawn BIS_fnc_MP};
};
sleep 5;
while {count MortarList < MaxMortar} do {call fnc_CreateMortar};
sleep 1;
while {CarCount < MaxCars} do {call fnc_SpawnCar};
sleep 1;
while {HeliCount < MaxHelis} do {call fnc_SpawnHeli};
sleep 1;
while {SupplyCount < MaxSupply} do {call fnc_SpawnSupply};
sleep 1;
[] spawn TB_fnc_server;
sleep 1;
[] spawn TB_fnc_detector;