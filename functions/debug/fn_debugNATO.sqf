#define BLU_COL [profilenamespace getvariable ['Map_BLUFOR_R',0], \
                 profilenamespace getvariable ['Map_BLUFOR_G',1], \
                 profilenamespace getvariable ['Map_BLUFOR_B',1], \
                 profilenamespace getvariable ['Map_BLUFOR_A',0.8]]


#define OPF_COL [profilenamespace getvariable ['Map_OPFOR_R',0], \
                 profilenamespace getvariable ['Map_OPFOR_G',1], \
                 profilenamespace getvariable ['Map_OPFOR_B',1], \
                 profilenamespace getvariable ['Map_OPFOR_A',0.8]]

#define IND_COL [profilenamespace getvariable ['Map_Independent_R',0], \
                 profilenamespace getvariable ['Map_Independent_G',1], \
                 profilenamespace getvariable ['Map_Independent_B',1], \
                 profilenamespace getvariable ['Map_Independent_A',0.8]]

//BIS_fnc_sideColor

#define UNK_COL [1,1,1,0.8]

private ["_group","_icon"];
_group = [_this,0] call bis_fnc_param;
_icon = _group getVariable ["TB_debugNATOsymbol", []];

if (_icon isEqualTo []) then
{
    private ["_leader","_type","_sidePrefix","_color","_symbol"];
    _leader = leader _group;
    _type = typeOf vehicle _leader;

    switch (side _group) do
    {
        case blufor:
        {
            _sidePrefix = "b_";
            _color = BLU_COL;
        };
        case opfor:
        {
            _sidePrefix = "o_";
            _color = OPF_COL;
        };
        case independent:
        {
            _sidePrefix = "n_";
            _color = IND_COL;
        };
        //case civilian: {"c_"};
        default
        {
            _sidePrefix = "n_";
            _color = UNK_COL;
        };
    };
    
    _symbol = call {
        private ["_cfg","_nameSound","_simulation","_return"];
        _cfg = configFile >> "cfgVehicles" >> _type;
        _nameSound = getText (_cfg >> "namesound");
        _simulation = toLower getText (_cfg >> "simulation");

        // Soldier
        if (_nameSound in ["veh_infantry_SF_s","veh_infantry_sniper_s"]) exitWith {"recon"};
        if (_simulation == "soldier") exitWith {"inf"};

        // Vehicle
        if (getNumber (_cfg >> "attendant") == 1) exitWith {"med"};
        if (getNumber (_cfg >> "isUAV") > 0) exitWith {"uav"};
        if (getNumber (_cfg >> "transportRepair") > 0) exitWith {"maint"};
        if (getNumber (_cfg >> "transportAmmo") > 0) exitWith {"support"};
        if (getNumber (_cfg >> "transportRefuel") > 0) exitWith {"service"};
        
        _return = switch _simulation do
        {
            case "motorcycle";
            case "car";
            case "carx": {"motor_inf"};
            case "tank";
            case "tankx":
            {
                switch (true) do
                {
                    case (_nameSound == "veh_vehicle_apc_s"): {"mech_inf"};
                    case (_nameSound == "veh_static_mortar_s"): {"mortar"};
                    case (getNumber (_cfg >> "artilleryScanner") == 1): {"art"};
                    case (_type isKindOf "StaticWeapon"): {"installation"};
                    default {"armor"};
                };
            };
            case "parachute";
            case "paraglide";
            case "helicopter";
            case "helicopterx": {"air"};
            case "airplane";
            case "airplanex": {"plane"};
            case "ship";
            case "submarinex";
            case "shipx": {"naval"};
            default {"unknown"};
        };
        _return
    };

    _icon = ["\a3\ui_f\data\map\Markers\NATO\" + _sidePrefix + _symbol + ".paa", _color];

    _group setVariable ["TB_debugNATOsymbol", _icon];
};

_icon