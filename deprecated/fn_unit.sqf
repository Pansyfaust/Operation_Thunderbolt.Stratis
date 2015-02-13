//VEHICLE call fnc_CleanVehicle;
fnc_CleanVehicle = {
    private "_veh";
    _veh = _this;
    if (typeName _veh == "ARRAY") then {_veh = _veh select 0};
    {_veh removeAllEventHandlers _x} forEach ["Hit","Engine","Fired","IncomingMissile","Killed","GetIn","GetOut","HandleDamage"];
    _veh setFuel 0.4 + random 0.4;
    _veh setVehicleAmmo random 0.8;
    _veh addEventHandler ["Killed", {_this spawn fnc_CleanupVehicle}];
    //if DEBUG then {hint "Vehicle cleaned"};
};

fnc_DeleteUnit = {
    private "_list";
    _list = [_this, 500] call fnc_CheckPlayers;
    if (count _list == 0) then {
        _list = [_this, 1000] call fnc_CheckPlayers;
        if ([_this, _list, 100] call fnc_IsHidden) then {
            deleteVehicle _this;
            if (count units group _this == 0) then {deleteGroup group _this};
        };
    };

    //Returns True if deleted, False if failed
    isNull _this
};

fnc_MakeProtected = {
    private "_veh";
    _veh = _this;
    ProtectedVehicles set [count ProtectedVehicles, _veh];
    _veh addEventHandler ["GetIn", {_this call fnc_RemoveProtected}];
};

fnc_RemoveProtected = {
    private "_veh";
    _veh = _this select 0;
    ProtectedVehicles = [ProtectedVehicles, _veh] call fnc_RemoveArrayItem;
    _veh call fnc_CleanVehicle;
    //if DEBUG then {hint "RemoveProtected"};
};

//Will NOT remove empty mortars
fnc_RemoveEmptyVehicles = {
    private ["_list","_newArray","_unit","_time"];
    _list = vehicles;
    _newArray = [];

    {
        _unit = _x select 0;
        _time = _x select 1;    
        {
            if (count crew _x != 0) then {
                _list = [_list, _x] call fnc_RemoveArrayItem;
            } else {
                if (_x == _unit) exitWith {
                    _list = [_list, _x] call fnc_RemoveArrayItem;
                    _time = _time + 1;
                    if (_time >= 3) then {_unit call fnc_DeleteUnit};
                    _newArray set [count _newArray, [_unit, _time]];
                };
            };
        } forEach vehicles;
    } forEach EmptyVehicles;

    if (count _list > 0) then {
        {
            if !(_x isKindOf "Thing") then {
                if (count crew _x == 0 AND !(_x in ProtectedVehicles)) then {_newArray set [count _newArray, [_x, 1]]};
            };
        } forEach _list;
    };

    //if DEBUG then {hint format ["%1", EmptyVehicles]};
    EmptyVehicles = _newArray;
};

fnc_CleanupVehicle = {
    private "_veh";
    _veh = _this select 0;
    sleep 300;
    {deleteVehicle _x} forEach (crew _veh);
    sleep 0.1;
    deleteVehicle _veh;
};

fnc_Cleanup = {
    private "_unit";
    _unit = _this select 0;
    /* Probably doesn't work and throws error
    if (!Use_NV AND _unit getVariable ["isElite", False]) then {
        _unit unassignItem "NVGoggles";
        _unit removeItem "NVGoggles";
    };
	*/
    sleep 180;
    if ((getPosATL _unit) select 2 < 0.5 AND vehicle _unit == _unit) then {
        hideBody _unit;
        sleep 5;
    };
    deleteVehicle _unit;
};

fnc_RemoveVehicle = {
    private "_veh";
    _veh = _this;
    if (typeName _veh == "ARRAY") then {_veh = _veh select 0};
    _veh = vehicle _veh;
    {deleteVehicle _x} forEach (crew _veh);
    sleep 0.1;
    deleteVehicle _veh;
};

fnc_HandleDamage = {
    private ["_unit","_part","_parts","_getHit","_multiplier","_i","_oldDamage","_damage"];
    _unit = _this select 0;
    _part = _this select 1;
    _parts = _unit getVariable "parts";
    _getHit = _unit getVariable "getHit";
    _multiplier = _unit getVariable "multiplier";

    if !(_part in _parts) then {
        _parts set [count _parts, _part];
        _getHit set [count _getHit, 0];
    };
    _i = _parts find _part;
    _oldDamage = _getHit select _i;
    _damage = _oldDamage + ((_this select 2) - _oldDamage) * _multiplier;
    _getHit set [_i, _damage];
    _damage    
};

fnc_ReduceDamage = {
    private ["_unit","_multiplier"];
    _unit = _this select 0;
    _multiplier = _this select 1;
    _unit setVariable ["parts", [], False];
    _unit setVariable ["getHit", [], False];
    _unit setVariable ["multiplier", _multiplier, False];
    _unit addEventHandler ["HandleDamage", {_this call fnc_HandleDamage}];
};