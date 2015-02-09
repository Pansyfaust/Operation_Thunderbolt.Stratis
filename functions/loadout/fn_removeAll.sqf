/*
    Remove everything from a unit. This could be a define macro but inheriting defines is a PAIN

    0: OBJECT                - unit whose inventory we will clear

    return: NONE
*/

private "_unit";
_unit = _this select 0;

removeAllWeapons _unit;
removeAllItems _unit;
removeAllAssignedItems _unit;
removeUniform _unit;
removeVest _unit;
removeBackpack _unit;
removeHeadgear _unit;
removeGoggles _unit;