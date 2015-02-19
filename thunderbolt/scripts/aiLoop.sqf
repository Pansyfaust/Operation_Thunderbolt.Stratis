/*
    This script is responsible for spawning in AI groups and moving them about.
    It makes decisions based on a personality table.
*/

#include "defines.hpp"

private ["_personality","_composition","_faction","_coefficient","_regen","_points","_aiGroups","_state","_unitsTable"];
_personality = [_this, 0, "Default", [""]] call BIS_fnc_param;
_composition = [_this, 1, "Default", [""]] call BIS_fnc_param;
_faction = [_this, 2, "Default", [""]] call BIS_fnc_param;
_coefficient = [_this, 3, 0.04, [0]] call BIS_fnc_param;
_regen = [_this, 4, 0.01, [0]] call BIS_fnc_param;
_points = 1;

_personality = missionConfigFile >> "CfgThunderbolt" >> "aiPersonality" >> _personality;
_composition = missionConfigFile >> "CfgThunderbolt" >> "aiComposition" >> _composition;
_faction = missionConfigFile >> "CfgThunderbolt" >> "aiFactions" >> _faction;

_aiGroups = [];
_state = STATE_PATROL;

// Build a large array of arrays containing units for the faction sorted into categories eg.
/*
[
    [
        NUMBER: weight,
        STRING: category classname,
        [[CONFIG: config path, NUMBER: cost], ...],
        [NUMBER: spawn config array index, ...],
        [CODE: init scripts, ...],
        CODE: group logic
    ], ...
]
*/
// Must support weighted random
//_unitsTable = [_composition, _faction] call TB_fnc_getFactionTable;
#ifdef DEBUG
    //copyToClipboard str _unitsTable;
    _unitsTable =
    [
        [_faction >> "Infantry", [[configfile >> "CfgGroups" >> "East" >> "OPF_F" >> "Infantry" >> "OIA_InfSquad", 8]], 1]
    ];
#endif

WHILETRUE
{
    DEBUG_MSG("AI Loop Awake")

    // Get player clusters
    private "_clusters";
    _clusters = [playableUnits, 50] call TB_fnc_getClusters; // filter for alive/concious?
    {
        private ["_center","_radius"];
        _center = [_x] call TB_fnc_getClusterCenter;
        _radius = [_center, _x] call TB_fnc_getClusterRadius;
        _clusters set [_foreachIndex, [_x, [_center, _radius]]];
    } forEach _clusters;

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
    /*if (_points > 0) then
    {
        DEBUG_MSG("AI trying to spawn")
        private ["_array","_grp","_spawnCost"];
        _array = [_unitsTable] call TB_fnc_spawnLogic;
        _grp = _array select 0;
        _spawnCost = _array select 1;

        if !(isNull _grp) then
        {
            _aiGroups pushBack _grp;

            // Deduct the cost of spawning
            _points = _points - _spawnCost * _coefficient;
            DEBUG_MSG( ("AI Spawn success (" + str _points + " points)") )

            // Order the group to go do something depending on the current state and personality
            switch (_state) do
            {
                case STATE_PATROL: {}; // go patrol
                case STATE_ALERT: {};
                case STATE_COMBAT: {}; // go move to detected players
            };
        };
    };*/

    DEBUG_MSG("AI Loop Sleep")
    sleep AI_SLEEP;
};