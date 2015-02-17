class aiComposition
{
    class Default
    {
        name = "Default";
        // When auto including it will check categories from the top down
        forcePreference[] =
        {
            /*"Diver", 1,
            "Recon", 1,
            "Sniper", 1,
            "Infantry", 1,
            "Car", 1,
            "Wheeled", 1,
            "Tracked", 1,
            "Armor", 1,
            "Mortar", 1,
            "Artillery", 1,
            "AntiAir", 1,
            "Support", 1,
            "Transport", 1,
            "TransportHeli", 1,
            "ArmedTransportHeli", 1,
            "AttackHeli", 1,
            "HeavyAttackHeli", 1,
            "FighterPlane", 1,
            "CASPlane", 1,
            "ATMines", 1,
            "APMines", 1*/
        };
        supportPreference[] = {}; // assist, air assault, paratroops, mortar, artillery, gunship, cas
    };

    class TEST_COMPOSITION : Default
    {
        name = "Test Composition";
        forcePreference[] = {"Infantry", 1};
    };
};