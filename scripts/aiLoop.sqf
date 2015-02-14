/*
    This script is responsible for spawning in AI groups and moving them about.
    It makes decisions based on a personality table.
*/

#include "defines.hpp"

private ["_personality","_composition","_faction","_aiGroups","_state","_unitsTable"];
_personality = [_this, 0, "Default", [""]] call BIS_fnc_param;
_composition = [_this, 1, "Default", [""]] call BIS_fnc_param;
_faction = [_this, 2, "Default", [""]] call BIS_fnc_param;

_personality = missionConfigFile >> "CfgThunderbolt" >> "aiPersonality" >> _personality;
_composition = missionConfigFile >> "CfgThunderbolt" >> "aiComposition" >> _composition;
_faction = missionConfigFile >> "CfgThunderbolt" >> "aiFactions" >> _faction;

_aiGroups = [];
_state = STATE_PATROL;

// Build a large array of arrays containing units for the faction sorted into categories eg.
// [[infantry group classnames], [tank classnames]]
// Must support weighted random
/*

// check if [_faction, "findUnits"] call BIS_fnc_returnConfigEntry; is true
    // build classname arrays (check with faction blacklists)
    TB_fnc_getFactionUnits
    TB_fnc_getFactionGroups
    TB_fnc_getFactionVehicles

    // seperate into categories

    // pushBack whitelist into catagories

// put everything neatly into _unitsTable
_unitsTable = [[]];
*/

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
    //if (call TB_fnc_canWeSpawn) then
    if (true) then
    {


        private ["_spawnClassType", "_spawnFunctionType","_spawnClass","_spawnFunction"];
        
        _spawnClassType = ([_composition, "forcePreference"] call BIS_fnc_returnConfigEntry) call TB_fnc_weightedRandom;
        _spawnFunctionType = ([_personality, "infantrySpawnPreference"] call BIS_fnc_returnConfigEntry) call TB_fnc_weightedRandom;
        
        _spawnClass = [_unitsTable select _spawnClassType] call TB_fnc_weightedRandom;
        _spawnFunction = _spawnFunctions select _spawnFunctionType;

        _group = [_spawnClass] call _spawnFunction;
        // Order the group to go do something depending on the current state and personality
        /*
            #define STATE_PATROL 0
            #define STATE_ALERT 1
            #define STATE_COMBAT 2
        */
        };
    };

    DEBUG_MSG("AI Loop Sleep")
    sleep AI_SLEEP;
};