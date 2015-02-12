/*
    This script is responsible for spawning in AI groups and moving them about.
    It makes decisions based on a personality table.
*/

#include "defines.hpp"

private ["_personality","_aiGroups","_state"];
_personality = [_this, 0, "Default", [""]] call BIS_fnc_param;
_personality = missionConfigFile >> "CfgThunderbolt" >> "aiPersonality" >> _personality;
_aiGroups = [];
_state = STATE_PATROL;


WHILETRUE
{
    DEBUG_MSG("AI Loop Awake")

    // Loop through all groups under the AI's control
    {
        private "_leader";
        _leader = leader _x;
        // Remove the group if all units are dead part 1
        if (!alive _leader) then
        {
            _aiGroups set [_foreachIndex, grpNull];
            DEBUG_MSG("Removing dead group from aiGroups")
        }
        else
        {
            // Is the group in combat?
            if (isNull (_leader findNearestEnemy _leader)) then
            {
                // Has the group been in combat long enough? + has radioman
                    // Decide the type of support to call in <PERSONALITY>
                    // Call for support
                // Does the group have a lot of dead units + is infantry
                    // Pop smoke
                    // Retreat
                // Is the group a vehicle transport?
                    // Pop smoke
                    // Deploy infantry
                    // Reveal known targets to infantry
            } else {
                // Is this group too far away from any player cluster (different distance if vehicle or infantry)
                    // Remove kebab (or cache if it's defending something)
            };
        };
    } forEach _aiGroups; // Shouldn't use allGroups for reasons

    // Remove the group if all units are dead part 2
    _aiGroups = _aiGroups - [grpNull];


    // Can we spawn stuff?
    //if (call TB_fnc_canWeSpawn) then
    if (true) then
    {
        // Decide whether to attack an objective, spawn patrols or defend area <PERSONALITY>
        private "_spawnType"; // Use a NUMBER with #defines
        
        _spawnType = ([_personality, "forcePreference"] call BIS_fnc_returnConfigEntry) call TB_fnc_weightedRandom;
        
        switch (_spawnType) do
        {
            // If patrol:
            case SPAWN_PATROL:
            {
                // Get player group clusters
                // Determine player movement
                // Decide what to spawn <PERSONALITY>
                // Spawn units at location ahead of players
            };

            case SPAWN_PARADROP: {};

            case SPAWN_WHEELED: {};

            case SPAWN_TRACKED: {};

            case SPAWN_PLANE: {};

            case SPAWN_ARTILLERY: {}:

            case SPAWN_HELI:
            // Else:
                // Find a spot to spawn
                // Move units to objective
        };
    };

    DEBUG_MSG("AI Loop Sleep")
    sleep AI_SLEEP;
};