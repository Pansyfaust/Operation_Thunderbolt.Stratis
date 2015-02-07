/*
    Check is a position is obscured from the players by terrain
    Check from the camera or aiming_axis memory point of players
    Watch out for ASL and ATL mixups
*/

//Experiment with this
//GIZMO = [] call TB_fnc_debugGizmo; onEachFrame {GIZMO setpos (player modelToWorld (player selectionPosition "camera"))}