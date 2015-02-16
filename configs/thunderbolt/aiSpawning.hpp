class aiSpawning
{
    class Default
    {
        size = ""; // NUMBER: radius of spawn area, STRING: compiled and called to return a value
        positionFunction = ""; // Compiled and called to find a position, the size is passed to this script
        maxAttempts = 100; // Maximum number of attempts to find a position
        spawnFunction = ""; // Compiled and called to spawn units, the position is passed to this script
    };

    class Magic : Default
    {
        size = 5;
        positionFunction = "";
        spawnFunction = "";
    };

    class TEST_SPAWN : Default
    {
        size = "random 1";
        positionFunction = "if (isNull player) exitWith {[]}; [player, 100, random 360] call BIS_fnc_relPos";
        spawnFunction = "[_this select 1, opfor, _this select 0] call BIS_fnc_spawnGroup";
    };
};