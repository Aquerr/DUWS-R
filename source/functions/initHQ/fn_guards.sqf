params ["_centerPos","_hq"];

// Create the guards
_groupGuard = createGroup WEST;
_hqGuard1 = _groupGuard createUnit [Blufor_Rifleman, _centerPos, [], 0, "FORM"];
_hqGuard1 setpos [(_centerPos select 0)-6.5, (_centerPos select 1)-1.6];
_hqGuard1 setdir 270;
[_hqGuard1,"STAND","FULL"] call BIS_fnc_ambientAnimCombat;

_hqGuard2 = _groupGuard createUnit [Blufor_Rifleman, _centerPos, [], 0, "FORM"];
_hqGuard2 setpos [(_centerPos select 0)-6.5, (_centerPos select 1)-4.7];
_hqGuard2 setdir 270;
[_hqGuard2,"STAND_IA","FULL"] call BIS_fnc_ambientAnimCombat;

_hqGuard3 = _groupGuard createUnit [Blufor_Teamleader, _centerPos, [], 0, "FORM"];
_hqGuard3 setpos [(_centerPos select 0), (_centerPos select 1)-7.58];
_hqGuard3 setdir 180;
[_hqGuard3,"LEAN","FULL"] call BIS_fnc_ambientAnimCombat;

_hqGuard4 = _groupGuard createUnit [Blufor_Rifleman_AT, _centerPos, [], 0, "FORM"];
_hqGuard4 setpos [(_centerPos select 0), (_centerPos select 1)-9];
_hqGuard4 setdir 0;
[_hqGuard4,"STAND","FULL"] call BIS_fnc_ambientAnimCombat;

// patrolling guard
_groupPatrol = createGroup WEST;
_hqGuard5 = _groupPatrol createUnit [Blufor_Grenadier, _centerPos, [], 0, "FORM"];
_hqGuard5 setpos [(_centerPos select 0)+10, (_centerPos select 1)+10];

_groupPatrol setCombatMode "YELLOW";
_wp = _groupPatrol addWaypoint [[(_centerPos select 0)+10, (_centerPos select 1)+10], 0];
_wp setWaypointType "MOVE";
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "LIMITED";

_wp = _groupPatrol addWaypoint [[(_centerPos select 0)-10, (_centerPos select 1)+10], 0];
_wp setWaypointType "MOVE";
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "LIMITED";

_wp = _groupPatrol addWaypoint [[(_centerPos select 0)-10, (_centerPos select 1)-10], 0];
_wp setWaypointType "MOVE";
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "LIMITED";

_wp = _groupPatrol addWaypoint [[(_centerPos select 0)+10, (_centerPos select 1)-10], 0];
_wp setWaypointType "MOVE";

_wp = _groupPatrol addWaypoint [[(_centerPos select 0)+10, (_centerPos select 1)+10], 0];
_wp setWaypointType "CYCLE";
_wp setWaypointBehaviour "SAFE";
_wp setWaypointSpeed "LIMITED";

_hq addAction ["<t color='#ff0066'>Replace Guards (20CP)</t>", {_this call DUWS_fnc_reguard}, [_groupGuard, _groupPatrol, _centerPos, _hq], 0, true, true, "", "_this == player"];
