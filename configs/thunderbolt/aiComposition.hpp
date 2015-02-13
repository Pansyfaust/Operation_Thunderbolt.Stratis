class aiComposition
{
    class Default
    {
        name = "Default";
        forcePreference[] = {0.35, 0.05, 0.2 ,0.15, 0.05, 0.1, 0.1, 0}; // infantry, recon, motorized, mechanized, armored, heli, mines, naval (WIP)
        supportPreference[] = {0.4, 0.1, 0.1, 0.1, 0.1, 0.1 ,0.1}; // assist, air assault, paratroops, mortar, artillery, gunship, cas
    };

    class Infantry : Default
    {
        name = "Infantry";
        forcePreference[] = {0.8, 0.1, 0 , 0, 0, 0, 0, 0};
    };
};