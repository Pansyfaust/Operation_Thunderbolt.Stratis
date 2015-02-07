// 0
class MissionTime
{
    title = "Mission Start Time:";
    values[] = {-1,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23};
    texts[] = {"Random","0000","0100","0200","0300","0400","0500","0600","0700","0800","0900","1000","1100",
               "1200","1300","1400","1500","1600","1700","1800","1900","2000","2100","2200","2300"};
    default = -1;
};

// 1
class Weather
{
    title = "Weather:";
    values[] = {-1,0,1,2,3};
    texts[] = {"Dynamic (Broken with clouds Enabled)","Fine","Overcast","Random Low Fog","Silent Hill"};
    default = 0;
};

// 2
class NightVision
{
    title = "Night Vision:";
    values[] = {-2,-1,0,1,2,3};
    texts[] = {"Random","Random Equal","No","Yes","BLUFOR Only","OPFOR Only"};
    default = -2;
};

// I plan to get rid of most of these after this line

// 3
class Difficulty
{
    title = "Difficulty:";
    values[] = {1,2,3,4,5,6,7};
    texts[] = {"Very Easy","Easy","Normal","Hard","Very Hard","Extreme","European Extreme"};
    default = 4;
};

// 4
class AimAccuracyAI
{
    title = "AI Aim Accuracy:";
    values[] = {0,1,2,3,4,5,6,7,8,9,10};
    texts[] = {"0","1","2","3","4","5","6","7","8","9","10"};
    default = 3;
};

class AimShakeAI
{
    title = "AI Aim Shake:";
    values[] = {0,1,2,3,4,5,6,7,8,9,10};
    texts[] = {"0","1","2","3","4","5","6","7","8","9","10"};
    default = 0;
};
class AimSpeedAI
{
    title = "AI Aim Speed:";
    values[] = {0,1,2,3,4,5,6,7,8,9,10};
    texts[] = {"0","1","2","3","4","5","6","7","8","9","10"};
    default = 3;
};
class SpotDistanceAI {
    title = "AI Spotting Distance:";
    values[] = {0,1,2,3,4,5,6,7,8,9,10};
    texts[] = {"0","1","2","3","4","5","6","7","8","9","10"};
    default = 7;
};
class SpotTimeAI {
    title = "AI Spotting Time:";
    values[] = {0,1,2,3,4,5,6,7,8,9,10};
    texts[] = {"0","1","2","3","4","5","6","7","8","9","10"};
    default = 7;
};
class MissionLimit {
    title = "Objectives To Complete:";
    values[] = {1,2,3};
    texts[] = {"1","2","3"};
    default = 2;
};
class UseMods {
    title = "Use Mods?";
    values[] = {1,0};
    texts[] = {"Yes","No"};
    default = 1;
};