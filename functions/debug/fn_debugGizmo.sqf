/*
    Create an object and return it.
    I recommend using it with the Object (Helpers) stuff.

    0 (Optional): STRING    - object classname
    1 (Optional): POSITION ASL         - object location
    2 (Optional): STRING    - object color in RGBA

    return: OBJECT          - the object created
*/

private ["_className","_psn","_color","_gizmo"];

_className = [_this, 0, "Sign_Sphere100cm_F", [""]] call BIS_fnc_param;
_psn = [_this, 1, [0,0,0], [[]]] call BIS_fnc_param;
_color = [_this, 2, "", [""]] call BIS_fnc_param;

_gizmo = createVehicle [_className, [0,0,0], [], 0, "NONE"];
_gizmo setPosWorld _psn;
if (_color != "") then
{
    _gizmo setObjectTextureGlobal [0, "#(rgb,8,8,3)color(" + _color + ")"];
};

_gizmo