#include "defines.hpp"

#define NEAR_RANGE 500
#define NEAR_ALPHA 0.3
#define UNIT_ICON "\a3\ui_f\data\map\Markers\Military\dot_ca.paa"
#define UNIT_SIZE 24
#define SIDE_FILTER [blufor, opfor, independent, civilian, sideEnemy, sideFriendly, sideLogic, sideUnknown]
//[WEST,EAST,GUER,CIV,ENEMY,FRIENDLY,LOGIC,UNKNOWN]

TB_debugClusters = [];

[] spawn {
    waitUntil {!isNull (findDisplay 12)};
    (findDisplay 12 displayCtrl 51) ctrlAddEventHandler ["Draw",
    {
        private "_map";
        _map = _this select 0;
        {
            private ["_unit","_clusters","_color","_nearColor"];
            _units = _x select 0;
            _clusters = _x select 1;
            _color = _x select 2;
            _nearColor = +_color;
            //_nearColor set [3, NEAR_ALPHA];
            {
                private ["_center","_radius"];
                _center = _x select 0;
                _radius = _x select 1;
                _map drawEllipse [_center, _radius, _radius, 0, _color, "fill"]; // Draw the cluster circle

                _radius = _radius + NEAR_RANGE;
                _map drawEllipse [_center, _radius, _radius, 0, _nearColor, ""]; // Draw a zone around the cluster
                true
            } count _clusters;

            {
                _map drawIcon [UNIT_ICON, _color, _x, UNIT_SIZE, UNIT_SIZE, 0, "", 2, 0, "PuristaMedium"]; true
            } count _units;
            true
        } count TB_debugClusters;
    }];
};

// Get cluster information
WHILETRUE
{
    private "_sides";
    _sides = [];
    {
        _sides pushBack [[], [], [_x] call BIS_fnc_sideColor]; true
    } count SIDE_FILTER;

    {
        private ["_side","_index"];
        _side = side _x;
        _index = SIDE_FILTER find _side;
        if (_index >= 0) then {
            ((_sides select _index) select 0) pushBack _x;
        }; true
    } count allUnits;

    {
        private ["_units","_clusters","_areas"];
        _units = _x select 0;
        _clusters = [_units, 50] call TB_fnc_getClusters;
        {_units set [_forEachIndex, getPosWorld _x]} forEach _units;

        _areas = [];
        {
            private ["_center","_radius"];
            _center = [_x] call TB_fnc_getClusterCenter;
            _radius = [_center, _x] call TB_fnc_getClusterRadius;
            _areas pushBack [_center, _radius]; true
        } count _clusters;
        _x set [0, _units];
        _x set [1, _areas]; true
    } count _sides;

    TB_debugClusters = _sides;

    sleep 1;
};