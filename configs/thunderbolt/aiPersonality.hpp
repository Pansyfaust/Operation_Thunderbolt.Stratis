class aiPersonality
{
    class Default
    {
        name = "Default";
        aggression = 0.6; // 0: always defensive, 1: always attacking
        forceConcentration = 0.7; // 0: spread out evenly, 1: focus on 1 cluster
        morale = 0.8; // 0: french mode, 1: fight to the death
        
        infantrySpawnPreference[] = {0.3, 0.4, 0.1, 0.1, 0.1}; // magic, building, road, heli, para
        infantrySpawnFallbackOrder[] = {};
        vehicleSpawnPreference[] = {0.05, 0.8, 0.1, 0.05}; // magic, road, slingload, paradrop
        vehicleSpawnFallbackOrder[] = {};
    };

    class Aggressive : Default
    {
        name = "Aggressive";
        aggression = 1;
    };

    class Cowards : Default
    {
        name = "Cowards";
        morale = 0;
    };

    class TEST_PERSONALITY : Default
    {
        name = "Test Personality";
        infantrySpawnPreference[] = {0, 0, 0, 0, 0};
    };
};