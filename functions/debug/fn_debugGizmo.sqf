/*
    Create an object and return it.
    I recommend using it with the Object (Helpers) stuff.

    0 (Optional): STRING        - object classname
    1 (Optional): POSITION      - object location
    2 (Optional): STRING        - object color in RGBA

    return: OBJECT              - the object created
*/

private ["_className","_psn","_color","_gizmo"];

_className = [_this, 0, "Sign_Sphere200cm_F", [""]] call BIS_fnc_param;
_psn = [_this, 1, [0,0,0], [[]]] call BIS_fnc_param;
_color = [_this, 2, "", ["",[]]] call BIS_fnc_param;
if (typeName _color == "ARRAY") then
{
    _color = format ["#(rgb,8,8,3)color(%1,%2,%3,%4)", _color select 0, _color select 1, _color select 2, _color select 3];
};

_gizmo = createVehicle [_className, [0,0,0], [], 0, "NONE"];
_gizmo setPosWorld _psn;
if (_color != "") then
{
    _gizmo setObjectTextureGlobal [0, _color];
};

_gizmo