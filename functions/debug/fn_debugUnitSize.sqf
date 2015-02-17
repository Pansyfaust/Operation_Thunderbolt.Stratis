private "_count";
_count = _this;

_count = ceil (_count/2) - 1;
_count = _count min 3; // Only count up to platoon size

format ["\a3\ui_f\data\map\Markers\NATO\group_%1.paa", _count]