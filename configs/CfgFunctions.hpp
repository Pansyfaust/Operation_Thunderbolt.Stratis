class TB
{
    // Generic functions for any kind of vehicle
    class Vehicle
    {
        file = "functions\vehicle";
        class resupplyVehicle {}; // WIP
    class getMagazines {}; // Done
    };

    // Functions to interpret player data to help the AI make decisions
    class Players
    {
        file = "functions\players";
        class getClusters {}; // Done
        class getClusterVector {}; // Done
        class isAwayFromPlayers {}; // WIP
    };

    // Functions to find spots on a map to spawn stuff now what we know where players are going
    class Map
    {
        file = "functions\map";
        class offMapPos {}; // WIP
        class isObscuredPos {}; // Dummy
        class randomMapPos {}; // Done
        class findNearClearPos {}; // Dummy
    };

    class Misc {
        file = "functions\misc";
        class pack2Dbin {}; //WIP
    };
    
    // Functions to generate tasks now that we've found good spots
    class Tasks
    {
        file = "functions\tasks";
        class generateTask {}; // WIP
        class initCV {}; // WIP
    };

    // Functions to spawn units
    // BIS already has some relevant functions so lets try to use them as much as possible
    // BIS_fnc_spawnGroup, BIS_fnc_spawnVehicle
    // createVehicleCrew command spawns config default crew for vehicles (including side!)
    class Spawn
    {
        file = "functions\spawn";
        class spawnAirAssault {}; // Dummy
        class spawnMines {}; // Dummy
    };

    // Functions to assign orders to groups (create waypoints, land, unload troops, fire mortar etc)
    // BIS also has functions for these but they're pretty basic/shitty
    class Group
    {
        file = "functions\group";
        class generateWaypoints {};
        class getTargets {}; // Done
    };

    // Functions to help edit loadouts
    class Loadout
    {
        file = "functions\loadout";
        class removeAccessories {};
        class removeAll {};
        class removeNVG {};
    };

    // These functions are only executed if DEBUG is defined
    class Debug
    {
        file = "functions\debug";
        class debugGizmo {}; // Done
        class debugMarker {}; // Done
        class debugMessage {}; // Done
    };
};