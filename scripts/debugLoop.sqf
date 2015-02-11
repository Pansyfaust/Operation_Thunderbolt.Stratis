/*
    This script is responsible for updating the position of any debug markers and objects.
*/

#include "defines.hpp"

#define NATOICON_SIZE 0.8
#define SIZEICON_SIZE 1.2
#define FONT_SIZE 0.035

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
        _text = str round (_psn distance player);

        // Draw NATO symbol
        drawIcon3D [_icon select 0, _icon select 1, _psnRaised, NATOICON_SIZE, NATOICON_SIZE, 0, _text, 0, FONT_SIZE, "PuristaMedium"];
        // Draw unit size
        drawIcon3D [_size, [0,0,0,1], _psnRaised, SIZEICON_SIZE, SIZEICON_SIZE, 0];
    } count allGroups;
}];

// Map stuff
[] spawn
{
    waitUntil {!isNull (findDisplay 12)};
    (findDisplay 12 displayCtrl 51) ctrlAddEventHandler ["Draw",
    {
        private "_display";
        _display = _this select 0;
    
        {
            private ["_params","_psn1","_psn2","_color"];
            _params = _x select 0;
            _psn1 = _params select 0;
            _psn2 = _params select 1;
            _color = _params select 2;
            if (typeName _psn1 == typeName {}) then {_psn1 = call _psn1};
            if (typeName _psn2 == typeName {}) then {_psn2 = call _psn2};
            _display drawLine [_psn1, _psn2, _color];
        } count TB_debugLine;
    
        // Display all groups
        {
            private ["_icon","_psn","_text"];
            _icon = [_x] call TB_fnc_debugNATO;
            _psn = getPosVisual leader _x;
            _text = str round (_psn distance player);
            _display drawIcon
            [
                _icon select 0, 
                _icon select 1, 
                _psn, 1, 1, 0, str (_icon select 0), 0, 0.1, "PuristaMedium"
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