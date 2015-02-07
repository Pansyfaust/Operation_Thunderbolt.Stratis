if (!isServer) exitWith {};

//(random 0.7) min 0.56
DynamicWeather = [
    time, 0,
    random 0.7,
    [random 1, random 0.05, -200 + random 250]
];
sleep 0.01;
[DynamicWeather, "fnc_UpdateWeather", True] spawn BIS_fnc_MP;
sleep 10;

while {!GameOver} do {
    OldWeather = DynamicWeather;
    _delay = 120 + random 180;
    DynamicWeather = [
        time, _delay,
        random 0.7,
        [random 1, random 0.05, -200 + random 250]
    ];
    [DynamicWeather, "fnc_UpdateWeather", True] spawn BIS_fnc_MP;
    sleep _delay;
};