/*
    function to generate points around a box

    0: POSITION                 - center of the box
    1: NUMBER or ARRAY          - number of point or [min, max] array for random spacing    
    2: ARRAY                    - size of box    
    3 (Optional): NUMBER        - rotation of box
    4 (Optional): BOOL          - return [center, point] call BIS_fnc_dirTo
    5 (Optional): NUMBER        - the first point starts at this dir, default: random 360
    6 (Optional): NUMBER        - doesnt matter/only on roads/avoid roads
    7 (Optional): BOOL          - avoid water/only in water

    Return: ARRAY               - array of points or [points, dir]
*/