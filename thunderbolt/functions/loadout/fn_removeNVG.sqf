/*
    Remove all NVG goggles
    If needed we could do this like fn_removeAccessories to cover removing binocs etc.

    0: OBJECT                   - unit whose inventory we will edit

    return: NONE
*/

private "_unit";
_unit = [_this, 0] call BIS_fnc_param;

#define NVG_TYPE 201
#define CONFIG_PATH (configFile >> "CfgWeapons" >> _x >> "ItemInfo" >> "type")

{
    if (getNumber CONFIG_PATH == NVG_TYPE) then {_unit unlinkItem _x}; true
} count assignedItems _unit;