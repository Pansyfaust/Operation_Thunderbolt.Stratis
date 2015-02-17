private ["_grp","_leader","_type","_sidePrefix","_color","_side","_symbol"];
_grp = _this;
_leader = leader _grp;
_type = typeOf vehicle _leader;
_side = side _grp;
_color = [_side] call BIS_fnc_sideColor;

_sidePrefix = switch (_side) do
{
    case blufor: {"b_"};
    case opfor: {"o_"};
    case independent: {"n_"};
    default {"n_"};
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

private ["_icon"];
_icon = [format ["\a3\ui_f\data\map\Markers\NATO\%1%2.paa", _sidePrefix, _symbol], _color];

_icon