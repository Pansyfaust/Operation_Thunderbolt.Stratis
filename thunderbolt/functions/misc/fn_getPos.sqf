/*
	Like getPos but faster because BIS is shit
    ASL over water ATL over land
*/

private "_pos";
_pos = getPosASL _this;
if !(surfaceIsWater _pos) then
{
    _pos = ASLToATL _pos;
};
_pos