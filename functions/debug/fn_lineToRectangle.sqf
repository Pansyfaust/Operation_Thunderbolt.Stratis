private ["_psn1","_psn2","_width","_color","_center","_dir","_length"];
_psn1 = +([_this, 0] call bis_fnc_param);
_psn2 = +([_this, 1] call bis_fnc_param);
_color = [_this, 2, "#(rgb,8,8,3)color(1,1,1,1)", [[],""]] call bis_fnc_param;
_width = [_this , 3, 1, [0]] call bis_fnc_param;

_psn1 set [2, 0];
_psn2 set [2, 0];
_center = (_psn1 vectorAdd _psn2) vectorMultiply 0.5;
_dir = [_psn1, _psn2] call BIS_fnc_dirTo;

_psn1 resize 2;
_psn2 resize 2;
_length = (_psn1 distance _psn2) / 2;

if (typeName _color == "ARRAY") then
{
    _color = format ["#(rgb,8,8,3)color(%1,%2,%3,%4)", _color select 0, _color select 1, _color select 2, _color select 3];
};

[_center, _width, _length, _dir, [1,1,1,1], _color]