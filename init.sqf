/*
HIGH:
Fix ifits not crossing bridges (99% done)
New objectives (and exfil objective)
Finalize supply functions (90%) + vehicle drops
Remove ifrits after stuck
Add empty unarmed vehicles around the map for transportation (90%, needs playtesting)
Leave at least one player alive for gameover screen + anyone with medpack can revive but worse
Rebalance spawn chances and difficulty levels
Retune artillery to use getartilleryETA

LOW:
Only check win/lose when appropriate
Diver patrols/attacks when players are near coast
Enemy patrol boats
Enemy sniper teams
Prevent players from taking medic slot without filling teams
Investigate KA60s not locking on with DAGRs (can we fix it? YES IT'S FIXED)
Test performance difference between script loop and function loop
Better randomization of empty vehicles on the map (random textures, random weapons) (50%, civilian cars done)
Ability to push beached speedboats
Create FSM for helis to use searchlight (will it cause lag?)
Encounter spawning should automatically spawn urban troops, divers, and anti vehicle troops if appropriate
Alert mode should spawn appropriate troops
Test which is faster: array set removal or normal Array = Array - [Element];
Improve car AI
*/

#define ADDLIST(LST,ELE) LST set [count LST, ELE]

//cutText ["", "BLACK FADED", 10e10];
0 fadeSound 0;
0 fadeRadio 0;
enableSaving [False, False];
HQ setGroupId ["HQ"];
hideObject HQ;
//setTerrainGrid 12.5;

paramsarray = [10,0,0,2,3,0,3,7,7,2,1];
/*
player allowDamage False;
onmapsingleclick "player setposATL _pos";
//player setCaptive True;
player addBackpack "B_AssaultPack_rgr";
player addMagazine "RPG32_AA_F";
player addWeapon "launch_RPG32_F";
player addeventhandler ["Fired",{if (_this select 1=="launch_RPG32_F") then {_this select 0 addMagazine (_this select 5)}}];
[] spawn {while {True} do {player setFatigue 0; sleep 5}};
*/

TimeSunrise = 6;
TimeSunset = 18;

//execVM "FAR_revive\FAR_revive_init.sqf";

if (isServer) then {
    execVM "scripts\init_server.sqf";
};

if (!isDedicated) then {
    execVM "scripts\init_player.sqf";
};

/*
Thunderbolt mechanics:

Spawn chances on normal:
Encounter, once every 30 seconds except when attackers are called in
New heli, once every 3 mins
Minefield, once every hour
Elites, once every hour
New mortar, once every half hour
New car, once every 3 mins

Difficulty Multiplier
VE = 0.5; E = 0.8; N = 1; H = 1.2; VH = 1.5; EX/EE = 2

EE should be the same as E except with cluster mortars
60 second cooldown after a heli/car dies before the heli/car count is dropped

Maximum number of helis, mortars and encounters
VE = 1; E/N = 2; H/VH = 3 ,EX/EE = 4

Maxiumum number of cars
VE = 2; E/N = 3; H/VH = 4 ,EX/EE = 5

Max of 1 dynamic minefield and elites
*/