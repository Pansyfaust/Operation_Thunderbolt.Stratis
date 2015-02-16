class aiFactions
{
    class Default
    {
        name = "Default";
        factionClass[] = {}; // CfgFaction classes, multiple can be used for auto inclusion        
        findUnits = 0; // Automatically include units that belong to the faction(s), you have to use whitelists otherwise

        class Unit // Abstract class
        {
            condition = "false"; // Conditiono auto include units into this category, if blank, no units will be auto included
                               // the config entry is passed to the called compiled string
            cost = 1; // Per man if group of cost of the vehicle without crew
            isGroup = 0; // 1: use CfgGroups, 0: use CfgVehicles
            whitelist[] = {}; // CfgGroups/CfgVehicles to always use, does not need to belong to the factionClass[] factions
            blacklist[] = {}; // These classnames will never be included by the auto inclusion

            spawnMethods[] = {}; // This category may only use the applicable aiSpawning
            scripts[] = {}; // These functions are run after spawn, group is passed as the parameter            
        };

        // Infantry
        class Infantry : Unit
        {
            condition = "";
            cost = 1; // Per man
            isGroup = 1;
            spawnMethods[] = {"Magic"};
        };

        class Diver : Infantry
        {
            condition = "";
            cost = 1.2;
        };

        class Recon : Infantry
        {
            cost = 1.2;
        };

        class Sniper : Infantry
        {
            cost = 1.4;
        };

        // Ground Vehicles
        class Vehicle // Abstract class
        {
            crewCost = 1; // Cost of each crew member
        };

        class Car : Vehicle
        {
            cost = 2;
        };

        class Wheeled : Vehicle
        {
            cost = 4;
        };

        class Tracked : Vehicle
        {
            cost = 4;
        };

        class Armor : Vehicle
        {
            cost = 8;
        };

        // Support
        class Mortar : Vehicle
        {
            cost = 4;
        };

        class Artillery : Vehicle
        {
            cost = 4;
        };

        class AntiAir : Vehicle
        {
            cost = 4;
        };

        class Support : Vehicle
        {
            cost = 4;
        };

        class Transport : Vehicle
        {
            cost = 4;
        };

        // Helicopters
        class TransportHeli : Vehicle
        {
            cost = 4;
        };

        class ArmedTransportHeli : Vehicle
        {
            cost = 4;
        };

        class AttackHeli : Vehicle
        {
            cost = 4;
        };

        class HeavyAttackHeli : Vehicle
        {
            cost = 4;
        };

        // Planes
        class FighterPlane : Vehicle
        {
            cost = 4;
        };

        class CASPlane : Vehicle
        {
            cost = 4;
        };

        // Others
        class APMines
        {
            cost = 10;
            whitelist[] = {};
            blacklist[] = {};
        };

        class ATMines : APMines {};
    };

    class NATO : Default
    {
        name = "NATO";
        factionClass[] = {"BLU_F"};
        findUnits = 1;
    };

    class CSAT : Default
    {
        name = "CSAT";
        factionClass[] = {"OPF_F"};
        findUnits = 1;
    };

    class AAF : Default
    {
        name = "AAF";
        factionClass[] = {"IND_F"};
        findUnits = 1;
    };

    class TEST_FACTION : Default
    {
        name = "Test Faction";
        factionClass[] = {"IND_F"};

        class Unit;
        class Infantry : Unit
        {
            condition = "true";
            cost = 1; // Per man
            isGroup = 1;
            whitelist[] = {"OIA_InfSquad"};
            spawnMethods[] = {"TEST_SPAWN"};
            scripts[] = {"hint 'SUCCESS!'"};
        };
    };
};