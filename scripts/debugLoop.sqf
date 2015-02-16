/*
    This script is responsible for updating the position of any debug markers and objects.
*/

#include "defines.hpp"

#define NATOICON_SIZE 0.8
#define SIZEICON_SIZE 1.2
#define NATOFONT_SIZE 0.035

#define WPCYCLE_ICON "a3\ui_f_curator\Data\CfgCurator\waypointcycle_ca.paa"
#define WPMOVE_ICON "a3\ui_f_curator\Data\CfgCurator\waypoint_ca.paa"
#define WPICON_SIZE 0.5
#define WP_COLOR [0,1,0.5,0.8]
#define WPCURRENT_COLOR [1,0.7,0,0.8]
#define WPFONT_SIZE 0.03

TB_debugLine3D = [];
TB_debugIcon3D = [];
TB_debugLine = [];
TB_debugIcon = [];

// 3D stuff
addMissionEventHandler ["Draw3D",
{
    {
        private ["_params","_psn1","_psn2","_color"];
        _params = _x select 0;
        _psn1 = _params select 0;
        _psn2 = _params select 1;
        _color = _params select 2;
        if (typeName _psn1 == typeName {}) then {_psn1 = call _psn1};
        if (typeName _psn2 == typeName {}) then {_psn2 = call _psn2};
        drawLine3D [_psn1, _psn2, _color];
    } count TB_debugLine3D;

    {drawIcon3D (_x select 0)} count TB_debugIcon3D;

    // Display all groups
    {
        private ["_icon","_size","_psn","_psnRaised","_text"];
        _icon = [_x] call TB_fnc_debugNATO;
        _size = [_x] call TB_fnc_debugNATOUnitSize;
        _psn = getPosVisual leader _x;
        _psnRaised = +_psn;
        _psnRaised set [2, (_psn select 2) + 3];
        _text = behaviour leader _x;

        // Draw NATO symbol
        drawIcon3D [_icon select 0, _icon select 1, _psnRaised, NATOICON_SIZE, NATOICON_SIZE, 0, _text, 0, NATOFONT_SIZE, "PuristaMedium"];
        // Draw unit size
        drawIcon3D [_size, [0,0,0,1], _psnRaised, SIZEICON_SIZE, SIZEICON_SIZE, 0];

        // Draw group waypoints
        private ["_waypoints","_waypoint","_waypointPsn","_waypointType","_waypointIcon","_waypointColor","_text"];
        _waypoints = waypoints _x;
        _currentWaypoint = currentWaypoint _x;
        for "_i" from 0 to count _waypoints - 1 do
        {
            _waypoint = _waypoints select _i;
            _waypointPsn = waypointPosition _waypoint;
            _waypointColor = if (_i == _currentWaypoint) then {WPCURRENT_COLOR} else {WP_COLOR};
            // Draw a line from the previous waypoint to this waypoint if this isn't the first waypoint
            if (_i > 0) then
            {
                drawLine3D [waypointPosition (_waypoints select _i-1) , _waypointPsn, _waypointColor];
            };

            _waypointType = waypointType _waypoint;
            _waypointIcon = if (_waypointType == "CYCLE") then {WPCYCLE_ICON} else {WPMOVE_ICON};
            _text = str _i + ": " + _waypointType;
            drawIcon3D [_waypointIcon, _waypointColor, _waypointPsn, WPICON_SIZE, WPICON_SIZE, 0, _text, 2, WPFONT_SIZE, "PuristaMedium"];
        };
    } count allGroups;
}];

// Map stuff
[] spawn
{
    waitUntil {!isNull (findDisplay 12)};
    (findDisplay 12 displayCtrl 51) ctrlAddEventHandler ["Draw",
    {
        private "_map";
        _map = _this select 0;
    
        {
            private ["_params","_psn1","_psn2","_color"];
            _params = _x select 0;
            _psn1 = _params select 0;
            _psn2 = _params select 1;
            _color = _params select 2;
            if (typeName _psn1 == typeName {}) then {_psn1 = call _psn1};
            if (typeName _psn2 == typeName {}) then {_psn2 = call _psn2};
            _map drawLine [_psn1, _psn2, _color];
        } count TB_debugLine;
    
        // Display all groups
        {
            // Draw group waypoints
            private ["_waypoints","_waypoint","_waypointPsn","_waypointType","_waypointIcon","_waypointColor","_waypointLineColor","_text"];
            _waypoints = waypoints _x;
            _currentWaypoint = currentWaypoint _x;
            for "_i" from 0 to count _waypoints - 1 do
            {
                _waypoint = _waypoints select _i;
                _waypointPsn = waypointPosition _waypoint;
                if (_i == _currentWaypoint) then
                {
                    _waypointColor = WPCURRENT_COLOR;
                    _waypointLineColor = "#(rgb,8,8,3)color(1,0.8,0,1)";
                }
                else
                {
                    _waypointColor = WP_COLOR;
                    _waypointLineColor = "#(rgb,8,8,3)color(0,1,0.5,1)";
                };
                // Draw a line from the previous waypoint to this waypoint if this isn't the first waypoint
                if (_i > 0) then
                {
                    //_map drawArrow [waypointPosition (_waypoints select _i-1) , _waypointPsn, _waypointColor];
                    private ["_prevWaypointPsn","_center", "_length", "_dir"];
                    _prevWaypointPsn = waypointPosition (_waypoints select _i-1);
                    _center = _prevWaypointPsn vectorAdd _waypointPsn;
                    _center = _center vectorMultiply 0.5;
                    _dir = [_prevWaypointPsn, _waypointPsn] call BIS_fnc_dirTo;
                    _prevWaypointPsn resize 2;
                    _waypointPsn resize 2;
                    _length = (_prevWaypointPsn distance _waypointPsn) / 2;
                    _map drawRectangle [_center, 2, _length, _dir, [1,1,1,1], _waypointLineColor]
                };
    
                _waypointType = waypointType _waypoint;
                _waypointIcon = if (_waypointType == "CYCLE") then {WPCYCLE_ICON} else {WPMOVE_ICON};
                _text = str _i + ": " + _waypointType;
                _map drawIcon [_waypointIcon, _waypointColor, _waypointPsn, 24, 24, 0, _text, 2, 0.07, "PuristaMedium"];
            };

            // Draw icons on groups
            private ["_icon","_psn","_text"];
            _icon = [_x] call TB_fnc_debugNATO;
            _psn = getPosVisual leader _x;
            _text = str round (_psn distance player);
            _map drawIcon
            [
                _icon select 0, 
                _icon select 1, 
                _psn, 24, 24, 0, behaviour leader _x, 0, 0.07, "PuristaMedium"
            ];
        } count allGroups;
    }];
};

// Remove debug elements if they have an expiry date
_fnc_removeOldElements =
{
    {
        _expireTime = [_x, 1, -1, [0]] call BIS_fnc_param;
        if (_expireTime > 0 && {_expireTime < time}) then
        {
            _this set [_forEachIndex, objNull];
        };

    } forEach _this;

    _this - [objNull]
};

WHILETRUE
{
    {
        _x = _x call _fnc_removeOldElements;
    } count [TB_debugLine3D, TB_debugIcon3D, TB_debugLine, TB_debugIcon];

    sleep 0.1;
};