private ["_composition","_faction","_categories","_factionClass"];
/*_composition = [_this, 0] call BIS_fnc_param;
_faction = [_this, 1] call BIS_fnc_param;

_categories = [_composition, "forcePreference", []] call BIS_fnc_returnConfigEntry;
_factionClass = [_faction, "factionClass", []] call BIS_fnc_returnConfigEntry;

private ["_unitsTable","_whitelists","_blacklists","_conditions"];
_unitsTable = [];
_whitelists = [];
_blacklists = [];
_conditions = [];

{
    if (typeName _x == typeName "") then
    {
        private "_category";
        _category = _faction >> _x;
        if (isClass _category) then
        {
            private ["_whitelist","_blacklist","_condition"];
            _whitelist = [_category , "whitelist", []] call BIS_fnc_returnConfigEntry;
            _blacklist = [_category , "blacklist", []] call BIS_fnc_returnConfigEntry;
            _condition = [_category , "condition", "false"] call BIS_fnc_returnConfigEntry;

            _isGroup = [_category , "isGroup", 0] call BIS_fnc_returnConfigEntry;
            if (_isGroup) then
            {

            };

            if (_condition == "") then {_condition = "false"};
            _whitelists pushBack _whitelist;
            _blacklists pushBack _blacklist;
            _conditions pushBack _condition;
            
            // Start with whitelist classes included
            _unitsTable pushBack _whitelist;
        };
    };
} count _categories;

// Automatically add units from cfgGroups and cfgVehicles
private "_findUnits";
_findUnits = [_faction, "findUnits", 0] call BIS_fnc_returnConfigEntry;
if (_findUnits > 0) then
{
    private ["_cfgGroups","_cfgVehicles"];
    _cfgGroups = [configfile >> "CfgGroups", 3] call BIS_fnc_returnChildren;
    _cfgVehicles = [configfile >> "CfgVehicles", 0] call BIS_fnc_returnChildren;

    {
        private ["_className","_configFaction"];
        _className = className _x;
        _configFaction = [_x, "faction", ""] call BIS_fnc_returnConfigEntry;
        {
            // Belong to correct faction, meet the category's condition and not in category's blacklist
            if (_configFaction in _factionClass &&
                {!(_className in (_blacklists select _forEachIndex))} &&
                {_className call compile _x}) then
            {
                (_unitsTable select _forEachIndex) pushBack _className;
            };
        } forEach _conditions;
    } count _cfgVehicles + _cfgGroups;
};

_unitsTable