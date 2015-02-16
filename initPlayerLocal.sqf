#include "scripts\defines.hpp"

// Make the player blind and deaf
private "_layer";
_layer = "akpBlack" call bis_fnc_rscLayer;
_layer cutText ["", "BLACK FADED", 10e10]; // Can we use cutTitle?
0 fadeSound 0;

#ifdef DEBUG
    execVM "scripts\debugLoop.sqf";
#endif

// Wait for the player object to exist then disable him
waitUntil {!isNull player};
player enableSimulation false;

// Wait until the player has loaded the mission
/* Possible returns:
    "RscDisplayMission",
    "RscDisplayIntro",
    "RscDisplayOutro",
    "RscDisplayMissionEditor"
*/


// Setup the player's loadout
//waitUntil {!isNil "Use_NV"};



// Move player to spawn position


// Start the mission. Play some cool effects and stuff
waitUntil {time > 0};
waitUntil {!(isNull ([] call BIS_fnc_displayMission))}; // Waituntil the main game display is active

1 fadeSound 1;
player enableSimulation true;
("akpStatic" call bis_fnc_rscLayer) cutRsc ["RscStatic","plain"];
sleep 0.5;
_layer cutText ["", "BLACK IN", 0];
sleep 1;
//_side execVM "scripts\typeText_init.sqf";

//call BIS_fnc_VRFadeIn
//call BIS_fnc_VRFadeOut