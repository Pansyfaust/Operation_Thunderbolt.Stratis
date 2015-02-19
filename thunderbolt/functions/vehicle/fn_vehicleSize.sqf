/*
	Glorious RV Engine is uncapable of determining sizes of p3ds without spawning them into the game world so we must use caching and spawning of dummy objects.
	returns the size of a given vehicle classname (must be subclass of CfgVehicles).
	
	Parameters:
	0: STRING		- Classname of CfgVehicles subclass to be sampled.

	Returns: ARRAY 	- x,y,z size of vehicle in meters.
*/
_vehicle = _this;
_size = -1;
if (isClass (configFile >> "CfgVehicles" >> _vehicle)) then {
	_model = getString (configFile >> "CfgVehicles" >> _vehicle >> "Model");
	//split p3d at end of model if it does show up and check if model path is relevant

	if (isNil "TB_VehicleSizeArray") then {
		TB_VehicleSizeArray = [];
	};

	{
		if ((_x select 0) == _model) exitWith {_size = (_x select 1)};
	}forEach TB_VehicleSizeArray;

	if (size == -1) then {
		_obj = _vehicle createVehicle [0,0,0];
		_bb = boundingBoxReal _obj;
		deleteVehicle _obj;
		_p1 = _bb select 0;
		_p2 = _bb select 1;
		_size = [];
		{
			_size pushBack (abs ((_p2 select _forEachIndex) - (_x))); 
		}forEach _p1;
		TB_VehicleSizeArray pushBack [_model, _size];
	};
};
_size