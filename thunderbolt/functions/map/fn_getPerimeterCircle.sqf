/*
    function to generate points around a circle

    0: POSITION                 - center of the circle
    1: NUMBER or ARRAY          - number of point or [min, max] array for random spacing
    2: NUMBER                   - radius of circle
    3 (Optional): BOOL          - return [center, point] call BIS_fnc_dirTo
    4 (Optional): NUMBER        - the first point starts at this dir, default: random 360
    5 (Optional): NUMBER        - doesnt matter/only on roads/avoid roads
    6 (Optional): BOOL          - avoid water/only in water    

    Return: ARRAY               - array of points or [points, dir]
*/