private ["_textures","_list"];
{
    _textures = _x select 0;
    _list = _x select 1;
    {
        [_x, _textures] call fnc_SetTexture;
    } forEach _list;
} forEach _this;