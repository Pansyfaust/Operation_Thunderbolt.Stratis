private ["_tgt","_marker"];

_tgt = _this;
_marker = createMarker [format ["%1%2",_tgt,random 100], (getposATL _tgt)];
_marker setMarkerShape "ICON";
_marker setMarkerType "mil_destroy";
_marker SetMarkerColor "ColorRed";
while {!isnull _tgt} do {
    _marker setmarkerpos (getposATL _tgt);
    _marker setMarkerText format ["%1", round (fuel _tgt * 100)];
    sleep 0.5;
};
deleteMarker _marker;