/*
    This script is responsible for creating mission and checking their completion status.
    It is also responsible for any miscellaneous clean up work that needs to be done.
    Synchronize weather (low priority).
*/

#include "defines.hpp"

private "_missions";
_missions = [];

WHILETRUE
{
    DEBUG_MSG("Game Loop Awake")

    // Check if any mission status needs to be updated
    {

    } forEach _missions;

    // Should we end the game?
        // exitWith and tell all players to play the gameover screen

    // Should we give players a mission?
        // Assign mission


    // Delete groups with no units
    {
        if (units _x isEqualTo []) then {deleteGroup _x}
    } forEach allGroups;

    DEBUG_MSG("Game Loop Awake")
    sleep GAME_SLEEP;
};