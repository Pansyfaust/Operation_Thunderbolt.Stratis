null = [] spawn
{
    waitUntil
    {
        _targets = test nearTargets 1000;
        _index = -1;
        {
            if (_x select 2 == blufor) exitWith {_index = _forEachIndex};
        } foreach _targets;
        if (_index >= 0) then
        {
            _nearTargetsAcc = str ((_targets select _index) select 5);
            _getHideDistance = str ((player modelToWorld (player selectionPosition "aiming_axis")) distance (test getHideFrom player));
            hintSilent (_nearTargetsAcc + "\n" + _getHideDistance);
        };
        sleep 1;
        false;
    };
};
player allowDamage false;
oneachframe {dummy setpos (test getHideFrom player)};