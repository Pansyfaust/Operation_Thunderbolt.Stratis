/*
    Create a global marker. Returns the marker name back for convenience.

    0: STRING               - marker name
    1: POSITION 2D          - marker location
    2 (Optional): STRING    - marker icon
    3 (Optional): STRING    - marker color
    4 (Optional): NUMBER    - marker size
    5 (Optional): STRING    - marker text

    return: STRING          - marker name
*/

private ["_psn","_type","_color","_size","_name","_text"];

_name = [_this, 0] call BIS_fnc_param;
_psn = [_this, 1] call BIS_fnc_param;
_type = [_this, 2, "mil_dot", [""]] call BIS_fnc_param;
_color = [_this, 3, "ColorRed", [""]] call BIS_fnc_param;
_size = [_this, 4, 1, [0]] call BIS_fnc_param;
_text = [_this, 5, "", [""]] call BIS_fnc_param;

createMarker [_name, _psn];
_name setMarkerShape "ICON";
_name setMarkerType _type;
_name setMarkerColor _color;
_name setMarkerSize [_size,_size];
_name setMarkerText _text;

_name