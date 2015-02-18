/*
    This script is responsible for updating the debug display
*/

#include "defines.hpp"

#define ICON_SIZE 0.8
#define SIZE_SIZE 1.2
#define TEXT_SIZE 0.035

#define ICON_MAP_SIZE 24
#define SIZE_MAP_SIZE 36
#define TEXT_MAP_SIZE 0.05

#define DISPLAY_FONT "PuristaMedium"

#define CYCLE_ICON "a3\ui_f_curator\Data\CfgCurator\waypointcycle_ca.paa"
#define DEFAULT_ICON "a3\ui_f_curator\Data\CfgCurator\waypoint_ca.paa"

#define WP_ICON_SIZE 0.5
#define WP_ICON_MAP_SIZE 24
#define WP_DEFAULT_COLOR [0,1,0.5,0.8]
#define WP_CURRENT_COLOR [1,0.7,0,0.8]
#define WP_TEXT_SIZE 0.03
#define WP_TEXT_MAP_SIZE 0.04

TB_debugLine3D = [];
TB_debugIcon3D = [];

TB_debugLine = [];
TB_debugIcon = [];
TB_debugEllipse = [];

TB_debugMarker = [];
TB_debugGizmo = [];

// 3D stuff
addMissionEventHandler ["Draw3D", {
    // Draw temporary debug lines and icons
    {drawLine3D (_x select 0)} count TB_debugLine3D;
    {drawIcon3D (_x select 0)} count TB_debugIcon3D;

    // Display all groups icons and waypoints
    {
        private ["_grp","_psn"];
        _grp = _x;
        _psn = getPosVisual formationLeader leader _grp;

        // Draw group waypoints
        private ["_waypoints","_positions","_icons","_texts","_current","_color"];
        _waypoints = _grp getVariable ["TB_debugWaypoints", []];
        if !(_waypoints isEqualTo []) then {
            _positions = _waypoints select 0;
            _icons = _waypoints select 2;
            _texts = _waypoints select 3;
            _current = currentWaypoint _grp;
            // Draw paths
            private "_prevPsn";
            {
                if (_forEachIndex > 0) then {
                    drawLine3D [_x, _prevPsn, WP_DEFAULT_COLOR];
                };
                _prevPsn = _x;
            } forEach (_waypoints select 0);

            // Draw icons
            {
                _color = if (_forEachIndex == _current) then {
                    // Draw line from unit leader to current active waypoint
                    drawLine3D [_psn, _x, WP_CURRENT_COLOR]; WP_CURRENT_COLOR;
                } else {
                    WP_DEFAULT_COLOR;
                };
                drawIcon3D [_icons select _forEachIndex,
                            _color,
                            _x,
                            WP_ICON_SIZE, WP_ICON_SIZE, 0,
                            _texts select _forEachIndex, 2,
                            WP_TEXT_SIZE, DISPLAY_FONT];
            } forEach _positions;
        };

        // If the group has an icon draw it
        private "_grpIcon";
        _grpIcon = _grp getVariable ["TB_debugIcon", []];
        if !(_grpIcon isEqualTo []) then {
            _psn set [2, (_psn select 2) + 3]; // Raise it up a bit

            // Draw NATO symbol
            drawIcon3D [_grpIcon select 0, _grpIcon select 1, _psn, ICON_SIZE,
                ICON_SIZE, 0, _grpIcon select 4, 0, TEXT_SIZE, DISPLAY_FONT];

            // Draw group size
            drawIcon3D [_grpIcon select 2, [0,0,0,1], _psn,
                SIZE_SIZE, SIZE_SIZE, 0];
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

        // Draw temporary debug lines and icons
        {_map drawRectangle (_x select 0)} count TB_debugLine;
        {_map drawIcon (_x select 0)} count TB_debugIcon;
        {_map drawEllipse (_x select 0)} count TB_debugEllipse;

        // Display all groups
        {
            private ["_grp","_psn"];
            _grp = _x;
            _psn = getPosVisual formationLeader leader _x;

            // Draw group waypoints
            private ["_waypoints","_positions","_icons","_texts","_current","_color"];
            _waypoints = _grp getVariable ["TB_debugWaypoints", []];            
            if !(_waypoints isEqualTo []) then {
                _positions = _waypoints select 0;
                _icons = _waypoints select 2;
                _texts = _waypoints select 3;
                _current = currentWaypoint _grp;
                // Draw paths
                {_map drawRectangle _x} count (_waypoints select 4);

                // Draw icons
                {
                    _color = if (_forEachIndex == _current) then {
                        // Draw line from unit leader to current active waypoint
                        _map drawLine [_psn, _x, WP_CURRENT_COLOR]; WP_CURRENT_COLOR;
                    } else {
                        WP_DEFAULT_COLOR;
                    };
                    _map drawIcon [_icons select _forEachIndex,
                                   _color,
                                   _x,
                                   WP_ICON_MAP_SIZE, WP_ICON_MAP_SIZE, 0,
                                   _texts select _forEachIndex, 2,
                                   WP_TEXT_MAP_SIZE, DISPLAY_FONT];
                } forEach _positions;
            };

            // If the group has an icon draw it
            private "_grpIcon";
            _grpIcon = _grp getVariable ["TB_debugIcon", []];
            if !(_grpIcon isEqualTo []) then {
                // Draw NATO symbol
                _map drawIcon [_grpIcon select 0, _grpIcon select 1, _psn, ICON_MAP_SIZE,
                    ICON_MAP_SIZE, 0, _grpIcon select 4, 0, TEXT_MAP_SIZE, DISPLAY_FONT];

                // Draw group size
                _map drawIcon [_grpIcon select 2, [0,0,0,1], _psn,
                    SIZE_MAP_SIZE, SIZE_MAP_SIZE, 0];
            };
        } count allGroups;
    }];
};

// Remove debug elements if they have an expiry date
_fnc_removeOldElements = {
    {
        private "_time";
        _time = _x select 1;
        if (_time < diag_ticktime) then {
            private ["_value","_type"];
            _value = _x select 0;
            _type = typeName _value;
            call {
                if (_type == "OBJECT") exitWith {deleteVehicle _value};
                if (_type == "STRING") exitWith {deleteMarker _value};
            };
            _this set [_forEachIndex, objNull];
        };
    } forEach _this;

    _this - [objNull]
};

// Check if two waypoint arrays are different, 2d compare only
_fnc_waypointsDiffer = {
    private ["_wps1","_wps2","_return"];
    _wps1 = _this select 0;
    _wps2 = _this select 1;
    _return = false;
    {
        private "_psn";
        _psn = _wps2 select _forEachIndex;
        if (_x select 0 != _psn select 0 || {_x select 1 != _psn select 1}) exitWith {_return = true};
    } forEach _wps1;
    _return
};

WHILETRUE
{
    TB_debugLine3D = TB_debugLine3D call _fnc_removeOldElements;
    TB_debugIcon3D = TB_debugIcon3D call _fnc_removeOldElements;

    TB_debugLine = TB_debugLine call _fnc_removeOldElements;
    TB_debugIcon = TB_debugIcon call _fnc_removeOldElements;
    TB_debugEllipse = TB_debugEllipse call _fnc_removeOldElements;

    TB_debugGizmo = TB_debugGizmo call _fnc_removeOldElements;
    TB_debugMarker = TB_debugMarker call _fnc_removeOldElements;

    // Update player group markers
    {
        private ["_grp","_grpIcon"];
        _grp = _x;
        _grpIcon = _grp getVariable ["TB_debugIcon", []];

        // Assign it a symbol if it doesn't have one already
        if (_grpIcon isEqualTo []) then {
            _grpIcon = _grp call TB_fnc_debugNATO;
            _grpIcon append ["", -1, ""];
        };

        // Reassign size icon if the group size changed
        private ["_grpSize","_grpAlive"];
        _grpSize = _grpIcon select 3;
        _grpAlive = {alive _x} count units _grp;
        if (_grpSize != _grpAlive) then {
            _grpIcon set [2, _grpAlive call TB_fnc_debugUnitSize];
            _grpIcon set [3, _grpAlive];
            _grp setVariable ["TB_debugIcon", _grpIcon];
        };

        // Reassign text if conditions have changed
        private ["_grpText","_text"];
        _grpText = _grpIcon select 4;
        _text = behaviour leader _grp;
        if !(_grpText == _text) then {
            _grpIcon set [4, _text];
            _grp setVariable ["TB_debugIcon", _grpIcon];
        };

        // Update waypoint icons array
        private ["_grpWaypoints","_waypoints","_wpPositions","_wpTypes","_wpCount"];
        _grpWaypoints = _grp getVariable ["TB_debugWaypoints", [[],[],[],[],[]]];
        _waypoints = waypoints _grp;
        _wpPositions = [];
        _wpTypes = [];
        _wpCount =
        {
            _wpPositions pushBack waypointPosition _x;
            _wpTypes pushBack waypointType _x;
            true;
        } count _waypoints;

        // If the positions array is out of date, update it
        private "_varPositions";
        _varPositions = _grpWaypoints select 0;
        if (count _varPositions != _wpCount || {[_wpPositions, _varPositions] call _fnc_waypointsDiffer}) then {
            _grpWaypoints set [0, _wpPositions];
            _grp setVariable ["TB_debugWaypoints", _grpWaypoints];
        };

        // If the types array is out of date, update it
        private "_varTypes";
        _varTypes = _grpWaypoints select 1;
        if !(_wpTypes isEqualTo _varTypes) then {
            _grpWaypoints set [1, _wpTypes];

            // Rebuild the icons
            private ["_wpIcons","_icon"];
            _wpIcons = [];
            {
                _icon = switch (_x) do {
                    case "CYCLE": {CYCLE_ICON};
                    default {DEFAULT_ICON};
                };
                _wpIcons pushBack _icon;
                true;
            } count _wpTypes;
            _grpWaypoints set [2, _wpIcons];

            // Rebuild text
            private "_wpText";
            _wpText = [];
            {                
                _wpText pushBack format ["%1: %2", _forEachIndex, _x];
            } forEach _wpTypes;
            _grpWaypoints set [3, _wpText];

            // Rebuild paths
            private ["_wpPaths","_prevPsn"];
            _wpPaths = [];
            {
                if (_forEachIndex > 0) then {
                    _wpPaths pushBack ([_x, _prevPsn, WP_DEFAULT_COLOR] call TB_fnc_lineToRectangle);
                };
                _prevPsn = _x;
            } forEach _wpPositions;
            _grpWaypoints set [4, _wpPaths];

            _grp setVariable ["TB_debugWaypoints", _grpWaypoints];
        };
    } count allGroups;

    sleep 0.2;
};