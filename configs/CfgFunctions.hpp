class TB
{
    // Generic functions for any kind of vehicle
    class Vehicle
    {
        file = "functions\vehicle";
        class resupplyVehicle {}; // WIP
    };

    // Functions to interpret player data to help the AI make decisions
    class Players
    {
        file = "functions\players";
        class getPlayerClusters {}; // Dummy
        class getClusterVector {}; // Dummy
        class isAwayFromPlayers {}; // WIP
    };

    // Functions to find spots on a map to spawn stuff now what we know where players are going
    class Map
    {
        file = "functions\map";
        class offMapPos {}; // WIP
        class isObscuredPos {}; // Dummy
        class randomMapPos {}; // Done
    };

    // Functions to generate tasks now that we've found good spots
    class Tasks
    {
        file = "functions\tasks";
        class generateTask {}; // WIP
        class initCV {}; // WIP
    };

    // Functions to spawn units
    class Spawn
    {
        file = "functions\spawn";
    };

    // Functions to assign orders to groups (create waypoints, land, unload troops, fire mortar etc)
    class Group
    {
        file = "functions\group";
    };

    // These functions are only executed if DEBUG is defined
    class Debug
    {
        file = "functions\debug";
        class debugGizmo {}; // Done
        class debugMarker {}; // Done
        class debugMessage {}; // Done
    };
    
    // What's this for pansy?
    class Scripts {};
};