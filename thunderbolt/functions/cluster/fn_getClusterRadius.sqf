/*
    Find the radius of the circle that can hold all points in this cluster

    0: POSITION 2D           - cluster center
    1: ARRAY                 - array of objects in the cluster

    return: NUMBER           - distance from the center of a cluster to the furthest point
*/

private ["_center","_list","_radius"];
_center = _this select 0;
_list = _this select 1;

_radius = 0;

{
    private ["_psn","_distance"];
    _psn = getPosWorld _x;
    _psn resize 2; // 2D Position
    _distance = _psn distanceSqr _center;
    if (_distance > _radius) then
    {
        _radius = _distance;
    };
    true
} count _list;

sqrt _radius