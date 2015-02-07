/*
    This script is responsible for spawning in AI groups and moving them about.
    It makes decisions based on a personality table.
*/

#include "defines.hpp"

private "_aiGroups";
_aiGroups = [];

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
        // Decide whether to attack an objective, spawn patrols or defend area <PERSONALITY>
        // If patrol:
            // Get player group clusters
            // Determine player movement
            // Decide what to spawn <PERSONALITY>
            // Spawn units at location ahead of players
        // Else:
            // Find a spot to spawn
            // Move units to objective

    DEBUG_MSG("AI Loop Sleep")
    sleep AI_SLEEP;
};