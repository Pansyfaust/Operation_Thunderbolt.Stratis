/*
    Remove all attachments from selected weapons (muzzle, optic, side)

    0: OBJECT                   - unit whose inventory we will edit
    1 (Optional): ARRAY         - config types to remove, default: all stock types (muzzle, optic, side)
    2 (Optional): ARRAY         - weapon types to edit, default: all

    return: NONE
*/

// Added: Script command for listing weapon's attachments in cargo (weaponAttachments)
// Changed: weaponAttachments renamed to weaponAccessoriesCargo (this set of technologies is not yet ready for use, heavily WIP)

#define MUZZLE_TYPE 101
#define OPTIC_TYPE 201
#define SIDE_TYPE 301

#define PRIMARY_WEP 0
#define SECONDARY_WEP 1
#define HANDGUN_WEP 2

#define CONFIG_PATH (configFile >> "CfgWeapons" >> _x >> "ItemInfo" >> "type")

private ["_unit","_types","_weapons"];
_unit = [_this, 0] call BIS_fnc_param;
_types = [_this, 1, [MUZZLE_TYPE, OPTIC_TYPE, SIDE_TYPE], [[]]] call BIS_fnc_param;
_weapons = [_this, 2, [PRIMARY_WEP, SECONDARY_WEP, HANDGUN_WEP], [[]]] call BIS_fnc_param;

if (PRIMARY_WEP in _weapons) then
{
    {
        if (getNumber CONFIG_PATH in _types) then {_unit removePrimaryWeaponItem _x};
    } count primaryWeaponItems _unit;
};

if (SECONDARY_WEP in _weapons)then
{
    {
        if (getNumber CONFIG_PATH in _types) then {_unit removeSecondaryWeaponItem _x};
    } count secondaryWeaponItems _unit;
};

if (HANDGUN_WEP in _weapons) then
{
    {
        if (getNumber CONFIG_PATH in _types) then {_unit removeHandgunItem _x};
    } count handgunItems _unit;
}