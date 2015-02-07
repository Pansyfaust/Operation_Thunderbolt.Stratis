private ["_psn","_dir","_radius","_set_x","_set_y"];
_psn = getMarkerPos "respawn_west";
_dir = random 360;
_radius = 12 * sqrt (random 1);
_set_x = (sin _dir) * _radius;
_set_y = (cos _dir) * _radius;
player setposATL [(_psn select 0) + _set_x, (_psn select 1) + _set_y, 0];
player setDir random 360;