class ClassNames
{
    VehicleClasses[] = {"O_MRAP_02_F","O_MRAP_02_gmg_F","O_MRAP_02_hmg_F","O_MRAP_02_hmg_F","O_MRAP_02_hmg_F","O_MRAP_02_hmg_F", "O_APC_Wheeled_02_rcws_F","O_Truck_03_covered_F"};
    // We should use faction groups instead of individual soldier classes wherever possible
    InfantryClasses[] = {"O_Soldier_GL_F", "O_Soldier_Exp_F", "O_Medic_F", "O_Soldier_Lite_F", "O_Soldier_Repair_F", "O_Soldier_M_F", "O_Soldier_M_F", "O_Soldier_LAT_F", "O_Soldier_LAT_F",
    "O_Soldier_LAT_F", "O_Soldier_AA_F", "O_Soldier_AR_F", "O_Soldier_AR_F", "O_Soldier_AR_F", "O_Soldier_AR_F", "O_Soldier_F", "O_Soldier_F", "O_Soldier_F", "O_Soldier_F", "O_Soldier_F", "O_Soldier_F", "O_Soldier_F"};
    TransportHeloClasses[] = {"O_Heli_Light_02_unarmed_F","O_Heli_Light_02_unarmed_F", "O_Heli_Transport_04_covered_F", "O_Heli_Transport_04_bench_F"};
    AttackHeloClasses[] = {"O_Heli_Light_02_F", "O_Heli_Light_02_F", "O_Heli_Light_02_F", "O_Heli_Light_02_F", "O_Heli_Light_02_F" , "O_Heli_Attack_02_F"};
};

class MissionTypes
{
    class DestroyCache
    {
        descClass = "DestroyCache";
        clearSpot[] = {4,0.7};
        VehicleTypes[] = {
            "Box_East_Ammo_F",
            "Box_East_AmmoOrd_F",
            "Box_East_Grenades_F",
            "Box_East_Support_F",
            "Box_East_Wps_F",
            "Box_East_WpsSpecial_F",
            "Box_East_Support_F","B_supplyCrate_F"};
        VehicleCount = "(2 + floor random 3)";
        VehicleInit = "";
        PatrolCount = 1;
    };

    class DestroyCV
    {
        descClass = "DestroyCV";
        clearSpot[] = {5,0.5};
        VehicleTypes[] = {"O_MRAP_02_F"};
        VehicleCount = "1";
        VehicleInit = "_this call TB_fnc_initCV";
        PatrolCount = 1;
    };

    class DestroyMortar : DestroyCV
    {
        descClass = "DestoryMortar";
        VehicleTypes[] = {"O_Mortar_01_F"};
        //TODO: add mortar functionality to spawned mortar
        VehicleInit = "";
    };
};