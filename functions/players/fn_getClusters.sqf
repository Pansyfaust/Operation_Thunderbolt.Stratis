/*
    Divide players into clusters using DBSCAN.
    Used mainly to determine where to distribute AI patrols to intercept players.
    Can also be used to determine the best spots for mortar attacks, airstrike etc (using targets known to an AI leader).
    http://en.wikipedia.org/wiki/DBSCAN
    http://en.wikipedia.org/wiki/OPTICS_algorithm

    0: ARRAY                 - An array of OBJECTS
    1: NUMBER                - maximum distance another point can be away to be considered part of a cluster

    return: ARRAY            - An array of arrays containing player clusters
*/

private ["_data","_eps","_minPoints","_clusters","_index"];
_data = _this select 0;
_maxDistance = _this select 1; // 50m is the max range of STHUD
_maxDistance = _maxDistance ^ 2; // Square it so we don't need to sqr distance checks
_minPoints = 0; // Not implemented, we don't need to differentiate between noise and clusters yet

_index = -1;
_clusters = [];

 _unvisited = "DBSCAN" + str diag_tickTime;

// Check for new neighbors and add them to the cluster
private "_fnc_expandCluster";
_fnc_expandCluster =
{
    private ["_object","_nearPoints"];
    _object = _this select 0;
    _nearPoints = _this select 1;
    
    // Add the object to the current cluster
    (_clusters select _index) pushBack _object;
    systemChat str [_clusters, _index, _object];

    // Check the object's neighbors
    {
        // If we haven't visited this neighbor yet
        if (_x getVariable [_unvisited, true]) then
        {
            // Mark neighbor as visited
            _x setVariable [_unvisited, false];

            // Check this neighbor's neighbors
            private "_neighborNearPoints";
            _neighborNearPoints = _x call _fnc_regionQuery;
            if (count _neighborNearPoints >= _minPoints) then
            {
                [_x, _neighborNearPoints] call _fnc_expandCluster;
            };
        };

        /*if (_x is not yet member of any cluster) then
        {
            // Add this neighbor to the current cluster
            (_clusters select _index) pushBack _x;
        };*/
    } count _nearPoints;
};

// Can this be more optimized?
private "_fnc_regionQuery";
_fnc_regionQuery = 
{
    private ["_points","_pointPsn","_psn"];
    _points = [_this];
    _pointPsn = getPosWorld _this;
    _pointPsn set [2, 0];
    {
        _psn = getPosWorld _x;
        _psn set [2, 0];
        if (_pointPsn distanceSqr _psn <= _eps) then
        {
            _points pushBack _x;
        };
    } count _data;
    _points
};

// Program Start
{
    // If we havent visited this object yet
    if (_x getVariable [_unvisited, true]) then
    {
        // Mark object as visited
        _x setVariable [_unvisited, false];

        // Get points that are near this point
        private "_nearPoints";
        _nearPoints = _x call _fnc_regionQuery;

        // If the point has no neighbors, it's noise
        if (count _nearPoints < _minPoints) then
        {
            // Mark object as noise
            // We don't need to differentiate between noise and clusters yet
        }
        // Otherwise it's a new cluster
        else
        {
            // Add a new cluster to the clusters array
            _clusters pushBack [];
            _index = _index + 1;
        };

        // Check for neighbours of this point's neighbors and add them
        [_x, _nearPoints] call _fnc_expandCluster;
    };
} count _data;

// Remove everyone's visited status
{
    _x setVariable ["_unvisited", nil];
} count _data;

_clusters