#include "scripts\defines.hpp"

// If someone JIPs in late will they have the wrong time?
waitUntil {!isNil "TimeOfDay"};
TimeOfDay execVM "scripts\skipTime.sqf";