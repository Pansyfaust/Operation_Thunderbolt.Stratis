class TB
{
    // Generic functions for any kind of vehicle
    class Vehicle
    {
        file = "thunderbolt\functions\vehicle";
    };

    // Functions to interpret object data to help the AI make decisions
    class Cluster
    {
        file = "thunderbolt\functions\cluster";
        class getClusterCenter {}; // Done
        class getClusterRadius {}; // Done
        class getClusters {}; // Done
        class getClusterVector {}; // Done
    };

    // Functions to find spots on a map to spawn stuff now what we know where players are going
    class Map
    {
        file = "thunderbolt\functions\map";
        class offMapPos {}; // WIP
        class isObscuredPos {}; // Dummy
        class randomMapPos {}; // Done
        class findNearClearPos {}; // Done
        class isAwayFrom {}; // Done
        class randomPosBox {}; // Dummy
        class randomPosCircle {}; // Dummy
        class getPerimeterBox {}; // Dummy
        class getPerimeterCircle {}; // Dummy

        class magicPos {};
    };

    class Misc
    {
        file = "thunderbolt\functions\misc";
        class pack2Dbin {}; //WIP
        class enumParser {};
        class getPos {}; // Done
        class weightedRandom {}; // Done
    };

    // Functions to generate tasks now that we've found good spots
    class Tasks
    {
        file = "thunderbolt\functions\tasks";
        class generateTask {}; // WIP
        class initCV {}; // WIP
    };

    // Functions to spawn units
    // BIS already has some relevant functions so lets try to use them as much as possible
    // BIS_fnc_spawnGroup, BIS_fnc_spawnVehicle
    // createVehicleCrew command spawns config default crew for vehicles (including side!)
    class Spawn
    {
        file = "thunderbolt\functions\spawn";
        class spawnAirAssault {}; // Dummy
        class spawnMines {}; // Done
        class spawnObjects {}; // Done
    };

    // Functions to assign orders to groups (create waypoints, land, unload troops, fire mortar etc)
    // BIS also has functions for these but they're pretty basic/shitty
    class Group
    {
        file = "thunderbolt\functions\group";
        class generateWaypoints {};
        class getTargets {}; // Done
        class sortVehicleOrMan {}; // Done
    };

    // Functions to aid the AI commander loop
    class AI
    {
        file = "thunderbolt\functions\ai";
        class getFactionTable {}; //WIP
        class spawnLogic {}; // Done
    };

    // Functions to help edit loadouts
    class Loadout
    {
        file = "thunderbolt\functions\loadout";
        class removeAccessories {};
        class removeAll {};
        class removeNVG {};
    };

    // These functions are only executed if DEBUG is defined
    class Debug
    {
        file = "thunderbolt\functions\debug";
        class debugGizmo {}; // Done
        class debugMarker {}; // Done
        class debugMessage {}; // Done
        class debugNATO {}; // Done
        class debugUnitSize {}; // Done
        class lineToRectangle {}; // Done
    };
};