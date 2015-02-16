/*
    This script is responsible for spawning in AI groups and moving them about.
    It makes decisions based on a personality table.
*/

#include "defines.hpp"

private ["_personality","_composition","_faction","_coefficient","_regen","_points","_aiGroups","_state","_unitsTable"];
_personality = [_this, 0, "Default", [""]] call BIS_fnc_param;
_composition = [_this, 1, "Default", [""]] call BIS_fnc_param;
_faction = [_this, 2, "Default", [""]] call BIS_fnc_param;
_coefficient = [_this, 3, 0.01, [0]] call BIS_fnc_param;
_regen = [_this, 4, 0.01, [0]] call BIS_fnc_param;
_points = 1;

_personality = missionConfigFile >> "CfgThunderbolt" >> "aiPersonality" >> _personality;
_composition = missionConfigFile >> "CfgThunderbolt" >> "aiComposition" >> _composition;
_faction = missionConfigFile >> "CfgThunderbolt" >> "aiFactions" >> _faction;

_aiGroups = [];
_state = STATE_PATROL;

// Build a large array of arrays containing units for the faction sorted into categories eg.
// [[infantry group classnames], [tank classnames]]
// Must support weighted random
_unitsTable = [_composition, _faction] call TB_fnc_getFactionTable;
#ifdef DEBUG
    copyToClipboard str _unitsTable;
#endif

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


    // Can we spawn stuff? Check if we have enough points
    //if (_points > 0) then
    if (false) then
    {
        private ["_spawnClassType", "_spawnFunctionType","_spawnClass","_spawnFunction"];
        
        _spawnClassType = ([_composition, "forcePreference"] call BIS_fnc_returnConfigEntry) call TB_fnc_weightedRandom;
        _spawnFunctionType = ([_personality, "infantrySpawnPreference"] call BIS_fnc_returnConfigEntry) call TB_fnc_weightedRandom;
        
        _spawnClass = [_unitsTable select _spawnClassType] call TB_fnc_weightedRandom;
        _spawnFunction = _spawnFunctions select _spawnFunctionType;

        private ["_group","_cost"];
        _group = [_spawnClass] call _spawnFunction;
        // Order the group to go do something depending on the current state and personality
        /*
            #define STATE_PATROL 0
            #define STATE_ALERT 1
            #define STATE_COMBAT 2
        */
        /*
        switch (_state) do
        {
            case STATE_PATROL: {}; // go patrol
            case STATE_ALERT: {};
            case STATE_COMBAT: {}; // go move to detected players
        };
        */
    };

    DEBUG_MSG("AI Loop Sleep")
    sleep AI_SLEEP;
};