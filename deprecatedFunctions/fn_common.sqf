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

