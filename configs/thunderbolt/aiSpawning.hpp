class aiSpawning
{
    class Default
    {
        size = ""; // NUMBER: radius of spawn area, STRING: compiled and called to return a value
        positionFunction = ""; // Compiled and called to find a position, the size is passed to this script
        maxAttempts = 100; // Maximum number of attempts to find a position
        spawnFunction = ""; // Compiled and called to spawn units, the position is passed to this script
    };

    class Magic
    {
        size = 5;
        positionFunction = "";
        spawnFunction = "";
    };
};