/*
    Display and log debug messages.
    
    0: STRING               - debug text

    return: NONE
*/
if (isNull player) exitWith {};

private "_msg";
_msg = "DEBUG: " + _this;

//Using customChat in the future looks nicer, but more troublesome
//player customChat [debugChannel, _this];
systemChat _msg;
diag_log _msg;