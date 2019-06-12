params ["_MissionPos"];
// define random pos AROUND TARGET. spawn markers at random.
_radius = 175;
_randompos = [(_missionpos select 0)+(random _radius)-(random _radius), (_missionpos select 1)+(random _radius)-(random _radius)];

// CREATE NAME
_mission_name = MissionNameCase2;

// CREATE MARKER (ICON)
_markername = format["target%1%2",round(_randompos select 0),round(_randompos select 1)]; // Define marker name
_markerstr = createMarker [str(_markername), _randompos];
_markerstr setMarkerShape "ICON";
str(_markername) setMarkerType "selector_selectedEnemy";
str(_markername) setMarkerColor "ColorOPFOR";
str(_markername) setMarkerText "Assassinate";
str(_markername) setMarkerSize [1, 1];

// CREATE MARKER (ELLIPSE ZONE)
_markername2 = format["%1%2ellipsetarget",round(_randompos select 0),round(_randompos select 1)]; // Define marker name
_markerstr2 = createMarker [str(_markername2), _randompos];
_markerstr2 setMarkerShape "ELLIPSE";
str(_markername2) setMarkerBrush "SolidBorder";
str(_markername2) setMarkerColor "ColorOPFOR";
str(_markername2) setMarkerSize [_radius, _radius];
str(_markername2) setMarkerAlpha 0.5;

// CREATE PATROLS
sleep 1;
[_missionpos, 15] call duws_fnc_createoppatrol; // <-- around target
[_randompos, _radius] call duws_fnc_createoppatrol;
[_randompos, _radius] call duws_fnc_createoppatrol;
[_randompos, _radius] call duws_fnc_createopteam;
Opfor_MRAP createVehicle ([(_missionpos select 0)+(random 10),(_missionpos select 1)+(random 10)]);

_group = createGroup east;
_target = _group createUnit [Opfor_Officer, _missionpos, [], 0, "FORM"];
_unit = _group createUnit [Opfor_Rifleman, _missionpos, [], 0, "FORM"];
_unit = _group createUnit [Opfor_Rifleman, _missionpos, [], 0, "FORM"];

// TASK AND NOTIFICATION
//_taskhandle = player createSimpleTask ["taskTarget"];
//_taskhandle setSimpleTaskDescription ["A high enemy target has been spotted somewhere in this location. Hunt him down.",_mission_name,""];
//_taskhandle setSimpleTaskDestination (getMarkerPos str(_markername));
[west, "_taskhandle", ["A high ranking enemy target has been spotted somewhere in this location. Hunt him down.", "High Value Target", "(getMarkerPos str(_markername)"], objNull, true] call BIS_fnc_taskCreate;

if (!ismultiplayer) then {
    [] spawn duws_fnc_autoSave;
};

["TaskAssigned",["",_mission_name]] call bis_fnc_showNotification;

waitUntil {sleep 2; !alive _target};  // MISSION COMPLETED --

// remove markers
deleteMarker str(_markername2);
deleteMarker str(_markername);

//player removeSimpleTask _taskhandle;
["_taskhandle", "WEST"] remoteExecCall ["BIS_fnc_deleteTask", 0, true];

sleep 1;

// Give cookies  (bonus & notifications)
reward = (20 * cp_reward_multiplier);
["TaskSucceeded",["",_mission_name]] call bis_fnc_showNotification;
["cpaddedmission",[reward]] call bis_fnc_showNotification;
WARCOM_blufor_ap = WARCOM_blufor_ap + 20;
missions_success = missions_success + 1;
commandpointsblu1 = commandpointsblu1 + reward;
opfor_ap = opfor_ap - 20;
publicVariable "commandpointsblu1";
publicVariable "WARCOM_blufor_ap";
finishedMissionsNumber = finishedMissionsNumber + 1;
publicVariable "finishedMissionsNumber";
[] call operative_mission_complete;

// ADD PERSISTENT STAT
_addmission = [] call duws_fnc_persistent_stats_missions_total;
