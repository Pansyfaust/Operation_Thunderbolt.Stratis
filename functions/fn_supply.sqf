#define SUPPLY_STOCK [ \
    [["chemlight_red",4],["chemlight_yellow",4],["chemlight_blue",4],["chemlight_green",4]], \
    ["chemlight_red",8], \
    ["chemlight_yellow",8], \
    ["chemlight_blue",8], \
    ["chemlight_green",8], \
    [["3Rnd_UGL_FlareWhite_F",4],["3Rnd_UGL_FlareGreen_F",2],["3Rnd_UGL_FlareRed_F",2],["3Rnd_UGL_FlareYellow_F",2],["3Rnd_UGL_FlareCIR_F",2]], \
    [["UGL_FlareWhite_F",4],["UGL_FlareGreen_F",4],["UGL_FlareRed_F",4],["UGL_FlareYellow_F",4],["UGL_FlareCIR_F",4]], \
    ["SatchelCharge_Remote_Mag",1], \
    ["NLAW_F",4], \
    [["srifle_GM6_SOS_F",4],["rangefinder",1]], \
    [["srifle_LRR_SOS_F",4],["rangefinder",1]], \
    [["u_b_ghilliesuit",1],["rangefinder",1]] \
]
//Cannot add diving goggles!!!
// [["U_B_Wetsuit",2],["V_RebreatherB",2],["G_Diving",2]] \

#define SUPPLY_R3F [ \
    ["R3F_Famas_F1", 8, [0,1], True, 0, 2, 1], \
    ["R3F_Famas_F1_HG", 8, [0,1], True, 0, 2, 1], \
    ["R3F_Famas_F1_M203", 8, [0,1], True, 1, 2, 1], \
 \
    ["R3F_Famas_G2", 8, [0,1], True, 0, 2, 1], \
    ["R3F_Famas_G2_HG", 8, [0,1], True, 0, 2, 1], \
    ["R3F_Famas_G2_M203", 8, [0,1], True, 1, 2, 1], \
 \
    ["R3F_Famas_surb", 8, [0,2], True, 0, 1, 1], \
    ["R3F_Famas_surb_HG", 8, [0,2], True, 0, 1, 1], \
    ["R3F_Famas_surb_M203", 8, [0,2], True, 1, 1, 1], \
 \
    ["R3F_Famas_felin", 8, [0,2], True, 3, 1, 1], \
 \
    ["R3F_FRF2", 4, [], True, 2, 0, 2], \
 \
    ["R3F_PGM_Hecate_II", 2, [0,1], True, 2, 0, 0], \
    ["R3F_PGM_Hecate_II_POLY", 2, [0,1], False, 2, 0, 0], \
 \
    ["R3F_M107", 2, [0,1], True, 2, 0, 0], \
 \
    ["R3F_Minimi", 4, [], False, 0, 1, 0], \
    ["R3F_Minimi_HG", 4, [], False, 0, 1, 0], \
    ["R3F_Minimi_762", 4, [], False, 0, 1, 0], \
    ["R3F_Minimi_762_HG", 4, [], False, 0, 1, 0], \
 \
    ["R3F_HK417L", 8, [0,1], True, 0, 1, 3], \
    ["R3F_HK417M", 8, [0,1], True, 0, 1, 3], \
    ["R3F_HK417M_HG", 8, [0,1], True, 0, 1, 3], \
    ["R3F_HK417S_HG", 8, [0,1], True, 0, 1, 3], \
 \
    ["R3F_PAMAS", 6, [], False], \
    ["R3F_AT4CS", 2, [], False] \
]

#define SUPPLY_MP7 [ \
    ["C1987_MP7", 8, [1,0], False, 0, 1, 4], \
    ["C1987_MP7_zp", 8, [1,0], False, 3, 1, 4] \
]

#define SUPPLY_USP [ \
    ["Flummi_USP_9mm", 6, "muzzle_snds_L"], \
    ["Flummi_USP_45", 6, "Flummi_snds_45"] \
]

private "_i";
SupplyCount = 0;
MaxSupply = 4 + floor random 5;
SupplyList = [["fnc_AddSupplyStock", SUPPLY_STOCK]];
SupplyNum = [count SUPPLY_STOCK];

//Load mods if available
if (UseMods) then {
    if (isClass (configfile >> "CfgVehicles" >> "R3F_WeaponBox")) then {
        SupplyList set [count SupplyList, ["fnc_AddSupplyR3F", SUPPLY_R3F]];
        _i = count SupplyNum;
        SupplyNum set [_i, (count SUPPLY_R3F) + (SupplyNum select (_i-1))];
    
        if (isClass (configfile >> "CfgWeapons" >> "C1987_MP7_HK_suppressor")) then {
            SupplyList set [count SupplyList, ["fnc_AddSupplyR3F", SUPPLY_MP7]];
            _i = count SupplyNum;
            SupplyNum set [_i, (count SUPPLY_MP7) + (SupplyNum select (_i-1))];
        };
    };
    
    if (isClass (configfile >> "CfgVehicles" >> "Flummi_Box_USP")) then {
        SupplyList set [count SupplyList, ["fnc_AddSupplyUSP", SUPPLY_USP]];
        _i = count SupplyNum;
        SupplyNum set [_i, (count SUPPLY_USP) + (SupplyNum select (_i-1))];
    };
};

fnc_AddSupplyStock = {
    private ["_box","_items","_item","_itemCount","_type","_magazines"];
    _box = _this select 0;
    _items = _this select 1;
    if (typeName (_items select 0) != "ARRAY") then {_items = [_items]};
    
    {
        _item = _x select 0;
        _itemCount = _x select 1;
        _itemCount = floor (_itemCount / 2) + 1 + floor random _itemCount;
        _type = _item call fnc_CheckItemType;

        switch (_type) do {
            case "magazine": {
                _box addMagazineCargoGlobal [_item, _itemCount];
            };
            case "weapon": {
                _magazines = getArray (configFile >> "CfgWeapons" >> _item >> "magazines");                
                if (count _magazines > 0) then {                    
                    _box addWeaponCargoGlobal [_item, 1];
                    _box addMagazineCargoGlobal [_magazines select 0, _itemCount];
                } else {
                    _box addWeaponCargoGlobal [_magazines select 0, _itemCount];
                };
            };
            case "item": {
                _box addItemCargoGlobal [_item, _itemCount];
            };
        };
    } forEach _items;
};

fnc_AddSupplyR3F = {
    private ["_box","_item","_optics","_opticsDes","_scopes","_magFamas25","_magFamas30","_magHectate2",
             "_magM107","_magHK417","_magMP7","_weapon","_magCount","_magazines","_magazineTypes","_isCamo",
             "_wepType","_useIR","_useSilencer","_opticItem","_lightItem","_IRItem","_silencerItem"];

    _box = _this select 0;
    _item = _this select 1;

    _optics = ["R3F_AIMPOINT","R3F_EOTECH","R3F_J4","R3F_OB50"];
    _opticsDes = ["R3F_AIMPOINT_DES","R3F_EOTECH_DES","R3F_J4_DES"];
    _scopes = ["R3F_J8","R3F_J8_MILDOT","R3F_J10","R3F_J10_MILDOT","R3F_NF","R3F_ZEISS"];

    _weapon = _item select 0;
    _magCount = _item select 1;
    _magCount = floor (_magCount / 2) + 1 + floor random _magCount;
    _magazines = getArray (configFile >> "CfgWeapons" >> _weapon >> "magazines");
    _magazineTypes = _item select 2;
    _isCamo = if (_item select 3 AND random 1 < 0.25) then {True} else {False};
    if (_isCamo) then {_weapon = _weapon + "_DES"};
    
    _box addWeaponCargoGlobal [_weapon, 1];
    
    //Add Magazines
    if (count _magazineTypes == 2) then {
        for "_i" from 1 to _magCount do {
            if (random 1 < 0.3) then {
                _box addMagazineCargoGlobal [_magazines select (_magazineTypes select 1), 1];                    
            } else {                    
                _box addMagazineCargoGlobal [_magazines select (_magazineTypes select 0), 1];
            };
        };
    } else {
        _box addMagazineCargoGlobal [_magazines select 0, _magCount];
    };
    
    if (count _item > 4) then {
        _wepType = _item select 4;
        _useIR = _item select 5;
        _useSilencer = _item select 6;
        //Weapon, average number of magazines, magazine types, has desert?, type, IR, silencer
        //TYPE: 0 =  rifle, 1 = m203, 2 = sniper, 3 = no optics
        //IR: 0 = no IR, 1 = pointer only, 2 = pirat + pointer
        //SILENCER: 0 = no silencer, 1 = R3F_SILENCIEUX_FAMAS, 2 = R3F_SILENCIEUX_FRF2, 3 = R3F_SILENCIEUX_HK417, 4 = MP7
    
        //Add sniper optics
        if (_wepType == 2) then {
            _opticItem = _scopes call BIS_fnc_SelectRandom;
            if (_isCamo) then {_opticItem = _opticItem + "_DES"};
            _box addItemCargoGlobal [_opticItem, 1];
        } else {
            //Add regular optics
            if (random 1 < 0.8 AND _wepType != 3) then {
                _opticItem = if (_isCamo) then {_opticsDes call BIS_fnc_SelectRandom} else {_optics call BIS_fnc_SelectRandom};
                _box addItemCargoGlobal [_opticItem, 1];
            };
            _lightItem = if (_isCamo) then {"R3F_LAMPE_SURB_DES"} else {"R3F_LAMPE_SURB"};
            
            //Add flashlight
            if (random 1 < 0.7) then {
                _box addItemCargoGlobal [_lightItem, 1];
            };
        };
    
        //Add m203 ammo
        if (_wepType == 1 AND random 1 < 0.5) then {
            _box addMagazineCargoGlobal ["1Rnd_HE_Grenade_shell", round random 7];
        };
    
        //Add IR attachment
        if (random 1 < 0.7) then {
            switch (_useIR) do {
                case 1: {_IRItem = "R3F_POINTEUR_SURB"};
                case 2: {_IRItem = ["R3F_PIRAT","R3F_POINTEUR_SURB"] call BIS_fnc_SelectRandom};
            };
            if (_useIR != 0) then {
                if (_isCamo) then {_IRItem = _IRItem + "_DES"};
                _box addItemCargoGlobal [_IRItem, 1];
            };
        };
    
        //Add silencer
        if (_useSilencer > 0 AND random 1 < 0.1) then {
            switch (_useSilencer) do {
                case 1: {_silencerItem = "R3F_SILENCIEUX_FAMAS"};
                case 2: {_silencerItem = "R3F_SILENCIEUX_FRF2"};
                case 3: {_silencerItem = "R3F_SILENCIEUX_HK417"};
                case 4: {_silencerItem = "C1987_MP7_HK_suppressor"};
            };
            if (_isCamo) then {_silencerItem = _silencerItem + "_DES"};
            _box addItemCargoGlobal [_silencerItem, 1];
        };
    };
};

fnc_AddSupplyUSP = {
    private ["_box","_item","_weapon","_magCount","_supressor","_magazine"];
    _box = _this select 0;
    _item = _this select 1;
    _weapon = _item select 0;
    _magCount = _item select 1;
    _supressor = _item select 2;
    _magCount = floor (_magCount / 2) + 1 + floor random _magCount;
    _magazine = (getArray (configFile >> "CfgWeapons" >> _weapon >> "magazines")) select 0;
    
    if (random 1 < 0.25) then {_weapon = _weapon + "_tan"};
    _box addWeaponCargoGlobal [_weapon, 1];
    _box addMagazineCargoGlobal [_magazine, _magCount];
    if (random 1 < 0.2) then {
        _box addItemCargoGlobal [_supressor, 1];
    };    
};

fnc_EquipSupply = {
    private ["_box","_total","_i","_cmd","_item"];
    _box = _this;
    _total = SupplyNum select (count SupplyNum - 1);

    for "_count" from 0 to round random 2 do {
        _i = random _total;
        {
            if (_i < _x) exitWith {_i = SupplyNum find _x};
        } forEach SupplyNum;
        _cmd = missionNamespace getVariable ((SupplyList select _i) select 0);
        _item = ((SupplyList select _i) select 1) call BIS_fnc_SelectRandom;
        [_box, _item] call _cmd;
    };
};

fnc_LoopSupply = {
    
};

fnc_SpawnSupply = {
    private ["_psn","_supplyUnits","_marker","_boxTypes","_boxType","_box"];

    _psn = [4,0.6] call fnc_FindClearSpot;
    if (count _psn == 3) then {
        _supplyUnits = [];
        _marker = [_psn, True] call fnc_MissionMarker;
        _boxTypes = ["Box_NATO_Ammo_F",
                     "Box_NATO_AmmoOrd_F",
                     "Box_NATO_Grenades_F",
                     "Box_NATO_Support_F",
                     "Box_NATO_Wps_F",
                     "Box_NATO_WpsSpecial_F",
                     "Box_NATO_Support_F"];

        for "_i" from 1 to (2 + floor random 3) do {
            _boxType = if (random 1 < 0.3) then {_boxTypes call BIS_fnc_SelectRandom} else {"B_supplyCrate_F"};
            _box = createVehicle [_boxType, _psn, [], 4, "NONE"];
            if (_boxType == "B_supplyCrate_F") then {
                _box call fnc_EquipSupply;
            };
            _box addEventHandler ["Killed", {_this spawn fnc_CleanupVehicle}];
            _box setDir random 360;
            _supplyUnits set [count _supplyUnits, _box];
        };

        for "_i" from 1 to (1 + floor random 3) do {
            _supplyUnits set [count _supplyUnits, createVehicle ["Chemlight_red",_psn,[],4,"NONE"]];
        };

        SupplyCount = SupplyCount + 1;
        //_supplyUnits spawn fnc_LoopSupply;
    };
};