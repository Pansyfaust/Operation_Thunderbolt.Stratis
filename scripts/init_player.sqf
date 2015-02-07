waitUntil {!isNull player};
//player enableSimulation False;

//player addEventHandler ["Killed", {_this spawn fnc_RespawnTime}];
//player addEventHandler ["Respawn", {call fnc_SetPlayer}];

waitUntil {time > 3};
waitUntil {!isNil "Use_NV"};
call fnc_SetPlayer;

waitUntil {markerAlpha "respawn_west" == 0};
execVM "scripts\spawnnearpoint.sqf";
[] spawn fnc_RespawnAction;

1 fadeSound 1;
player enableSimulation True;
_static = "BIS_fnc_endMission_static" call bis_fnc_rscLayer;
_static cutrsc ["RscStatic","plain"];
sleep 0.5;
cutText ["", "BLACK IN", 0];
sleep 1;
_static cutText ["", "PLAIN"];