#include "scripts\defines.hpp"

DEBUG_MSG("Started")
#ifdef DEBUG
    paramsarray = [10,0,0,2,3,0,3,7,7,2,1];
#endif

// Don't fucking save the game
enableSaving [false, false];

// Broadcast time to every machine
// Use local variable first so init.sqf doesnt update prematurely on the server
// Should update dedicated server time too so AI is affected by lighting
private "_timeOfDay";
_timeOfDay = paramsarray select 0;
_timeOfDay = if (_timeOfDay < 0) then
{
    [2035, 0, 1 + floor random 365, floor random 24, floor random 60] // Random day/hour/minute of the year 2035
}
else
{
    [2035, 0, 157, _timeOfDay, 0] // Fixed date so that lighting is more predictable
};
[_timeOfDay, true] call BIS_fnc_setDate;
DEBUG_MSG("Set Date: " + str _timeOfDay)
DEBUG_MSG("Actual Date: " + str date)

// Broadcast starting weather to players (WIP, weather is not a priority now)
/*WeatherMode = paramsarray select 1;
publicVariable "WeatherMode";*/
[0, 1, 0] call BIS_fnc_setFog;
[0] call BIS_fnc_setOvercast;

// Broadcast NV availability
Use_NV = paramsarray select 2;
switch (Use_NV) do
{
    case -2: {Use_NV = floor random 4};
    case -1: {Use_NV = floor random 2};
};
Use_NV = switch (Use_NV) do
{
    case 0: {[false,false]};
    case 1: {[true,true]};
    case 2: {[true,false]};
    case 3: {[false,true]};
};
publicVariable "Use_NV";


// Find players starting position and broadcast it


// Start game loops
["TEST_PERSONALITY","TEST_COMPOSITION","TEST_FACTION"] execVM "scripts\aiLoop.sqf"; // Personality, Composition, Faction
execVM "scripts\gameLoop.sqf";