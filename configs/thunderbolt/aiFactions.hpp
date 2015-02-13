class Factions
{
    class Default
    {
        name = "Default";
        factionClass[] = {"BLU_F"}; // CfgFaction classes, multiple can be used for auto inclusion        
        findUnits = 0; // Automatically include units that belong to the faction(s), you have to use whitelists otherwise

        // Infantry classes
        whitelistInfantry[] = {}; // CfgGroups to always use, does not need to belong to the factionClass[] factions
        blacklistInfantry[] = {}; // These groups will never be included by the auto inclusion
        customInfantry[] = {}; // Array of arrays of infantry classnames for custom groups

        whitelistRecon[] = {};
        blacklistRecon[] = {};
        customRecon[] = {};

        // Vehicle classes
        whitelistTruck[] = {};
        blacklistTruck[] = {};

        whitelistCar[] = {};
        blacklistCar[] = {};

        whitelistAPC[] = {};
        blacklistAPC[] = {};

        whitelistIFV[] = {};
        blacklistIFV[] = {};

        whitelistTank[] = {};
        blacklistTank[] = {};

        whitelistMortar[] = {};
        blacklistMortar[] = {};

        whitelistArtillery[] = {};
        blacklistArtillery[] = {};

        whitelistAntiAir[] = {};
        blacklistAntiAir[] = {};

        whitelistTransportHeli[] = {};
        blacklistTransportHeli[] = {};

        whitelistGunship[] = {};
        blacklistGunship[] = {};


        whitelistSupport[] = {};
        blacklistSupport[] = {};
    };

    class CSAT : Default
    {
        name = "CSAT";
        factionClass = "OPF_F";
    };
};