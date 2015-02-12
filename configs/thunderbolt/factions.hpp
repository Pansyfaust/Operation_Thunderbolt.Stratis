class Factions
{
    class Default
    {
        name = "Default";
        factionClass = "BLU_F"; // CfgFactionClasses

        infantry[] = {};
        recon[] = {};
        sniper[] = {};
        diver[] = {};

        transport[] = {};
        motorised[] = {};
        mechanized[] = {};
        armored[] = {};

        mortar[] = {};
        artillery[] = {};
        antiAir[] = {};
        rocketArtillery[] = {};
        casAircraft[] = {};
        fighterAircraft[] = {};
    };

    class NATO : Default
    {
        name = "Aggressive";
    };

    class CSAT : Default
    {
        name = "Aggressive";
    };
};