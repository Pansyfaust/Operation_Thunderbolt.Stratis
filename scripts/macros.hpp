#define WHILETRUE for "_i" from 0 to 1 step 0 do 
#define INC(X) X = X + 1
#define DEC(X) X = X - 1
#define CALLCOMP call compile preprocessFileLineNumbers
#define RANDPARAM(X) floor random ({_x >= 0} count getArray ((missionConfigFile >> "Params") select X >> "values"))

#define CONCAT(X,Y) {X pushBack _x} count Y