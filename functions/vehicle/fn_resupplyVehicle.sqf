/*
    This function rearms a vehicle based on its configured magazines.
    generic script to rearm all types of vehicles.
*/

// Internal function for config magazine retrieval (Why not make this a function in its own right?)
private "_fncGetMags";
_fncGetMags =
{
    _magazines = [];
    _class = _this;
    _mags = [_class,"magazines",[]] call BIS_fnc_returnConfigEntry;
    _class = (_class >> "Turrets");
    // Recursion to retrieve all magazines from turret
    for "_i" from 0 to _i < count _class do
    {
        _mags = _mags + ((_class select _i) call _fncGetMags);
    };
    _mags
};

_vehicle = vehicle _this;
_class = configFile >> "CfgVehicles" >> typeOf _vehicle;

_vehicle setFuel 1;
_vehicle setVehicleAmmo 0;
{_vehicle addMagazine _x} forEach (_class call _fncGetMags);