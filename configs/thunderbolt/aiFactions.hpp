class Factions
{
    class Default
    {
        name = "Default";
        factionClass[] = {}; // CfgFaction classes, multiple can be used for auto inclusion        
        findUnits = 0; // Automatically include units that belong to the faction(s), you have to use whitelists otherwise

        // Infantry
        whitelistInfantry[] = {}; // CfgGroups to always use, does not need to belong to the factionClass[] factions
        blacklistInfantry[] = {}; // These groups will never be included by the auto inclusion
        customInfantry[] = {}; // Array of arrays of infantry classnames for custom groups

        whitelistRecon[] = {};
        blacklistRecon[] = {};
        customRecon[] = {};

        whitelistSniper[] = {};
        blacklistSniper[] = {};
        customSniper[] = {};

        whitelistDiver[] = {};
        blacklistDiver[] = {};
        customDiver[] = {};

        // Ground Vehicle
        whitelistCar[] = {};
        blacklistCar[] = {};

        whitelistWheeled[] = {};
        blacklistWheeled[] = {};

        whitelistTracked[] = {};
        blacklistTracked[] = {};

        whitelistTank[] = {};
        blacklistTank[] = {};

        // Support
        whitelistMortar[] = {};
        blacklistMortar[] = {};

        whitelistArtillery[] = {};
        blacklistArtillery[] = {};

        whitelistAntiAir[] = {};
        blacklistAntiAir[] = {};

        whitelistSupport[] = {};
        blacklistSupport[] = {};

        whitelistTransport[] = {};
        blacklistTransport[] = {};

        // Helicopters
        whitelistTransportHeli[] = {};
        blacklistTransportHeli[] = {};

        whitelistTransportAttackHeli[] = {};
        blacklistTransportAttackHeli[] = {};

        whitelistAttackHeli[] = {};
        blacklistAttackHeli[] = {};

        whitelistHeavyHeli[] = {};
        blacklistHeavyHeli[] = {};

        // Planes
        whitelistFighterPlane[] = {};
        blacklistFighterPlane[] = {};

        whitelistCASPlane[] = {};
        blacklistCASPlane[] = {};

        // Others
        APmines[] = {};
        ATmines[] = {};
    };

    class CSAT : Default
    {
        name = "CSAT";
        factionClass[] = {"OPF_F"};
        findUnits = 1;
    };
};