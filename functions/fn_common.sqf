//FUTURE: dedicated server probably doesnt need to keep most of these functions in memory
fnc_SetPlayer = {
    private ["_className","_action"];
    scopeName "main";
    _className = toLower gettext (configFile >> "cfgVehicles" >> typeOf player >> "displayName");

	/* ACRE Dependency
    if (_className in ["squad leader","team leader"]) then {
        [] spawn {
            sleep 1;
            player addItem "ACRE_PRC148_UHF";
        };
    };
	*/
	
	/* TODO: FIX
    if !(Use_NV) then {
        player unassignItem "NVGoggles";
        player removeItem "NVGoggles";
        player addPrimaryWeaponItem "acc_flashlight";
    };
	*/

    if (sunOrMoon == 0) then {
        if (_className in ["grenadier","squad Leader","team Leader"]) then {
            {player removeMagazines _x} forEach ["1Rnd_SmokeRed_Grenade_shell",
                                                 "1Rnd_SmokeGreen_Grenade_shell",
                                                 "1Rnd_SmokeYellow_Grenade_shell",
                                                 "1Rnd_SmokePurple_Grenade_shell",
                                                 "1Rnd_SmokeBlue_Grenade_shell",
                                                 "1Rnd_SmokeOrange_Grenade_shell"];
            player addMagazines ["UGL_FlareWhite_F", 10];
            {player addMagazine _x} forEach ["UGL_FlareGreen_F",
                                             "UGL_FlareRed_F",
                                             "UGL_FlareYellow_F",
                                             "UGL_FlareCIR_F"];
            breakTo "main";
        } else {    
            for "_i" from 1 to (5 + floor(random 5)) do {
                player addMagazine (["Chemlight_blue",
                                     "Chemlight_green",
                                     "Chemlight_red",
                                     "Chemlight_yellow"] call BIS_fnc_selectRandom);
            };
        };
    };
};

fnc_RespawnAction = {
    private "_action";
    sleep 1;
    _action = player addAction ["<t color='#00FFFF'>Use if stuck</t>", "scripts\spawnnearpoint.sqf",[],100];
    sleep 30;
    player removeAction _action;
};

fnc_UpdateWeather = {
    private ["_time","_over","_fog"];
    _time = _this select 1;
    _over = _this select 2;
    _fog = _this select 3;

    _time setOvercast _over;
    _time setFog _fog;
    if (_time == 0) then {
        //Temporary solution until setOvercast works with clouds enabled
        [_over, _fog] spawn {
            skipTime 1;
            sleep 1;             
            skipTime -1;
            0 setFog (_this select 1);
            10e10 setOvercast (_this select 0);
            10e10 setFog (_this select 1);
        };
    };
};

/*fnc_EH_Put = {
    private ["_item","_count"];
    _item = _this select 1;
    _count = 0;

    if (_item isKindOf "ReammoBox_F") exitWith {};
    if (_item isKindOf "Man") exitWith {};
    if (_item isKindOf "AllVehicles") exitWith {};

    while {!isNull _item AND _count < 2} do {
        _count = _count + 1;
        sleep 5;
    };
    deleteVehicle _item;
};*/

fnc_RespawnTime = {
    setPlayerRespawnTime 60;
    while {!CanRespawn} do {
        [format ["<t size='0.8' shadow='1'>Cannot respawn until objective cleared</t>"],0,-(safezoneH-3.2)/2,1,0,0] spawn bis_fnc_dynamicText;
        if (playerRespawnTime < 3) then {setPlayerRespawnTime 3};
        sleep 0.01;
    };
};