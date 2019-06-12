params ["_radius","_diff"];

[["The zones are being generated<br/>Please wait for mission initialization to complete..."]] spawn BIS_fnc_typeText;
"DO NOT USE ACTION MENU UNTIL MISSION INITIALIZATION IS COMPLETE" remoteExec ["systemChat"];
"DO NOT USE ACTION MENU UNTIL MISSION INITIALIZATION IS COMPLETE" remoteExec ["hint"];

// ON WATER ? >> FLAT ? >> DISTANCE BETWEEN ZONES ? >> OK !

_worldName = getText(configFile >> "cfgWorlds" >> worldName >> "description");

_fortified = false;
openMap [true, true];
hint "Click somewhere on the island to place enemy zones";
_zones_array = [[-9999,-9999,-9999]];
for [{_i=1}, {_i<=zones_number}, {_i=_i+1}] do  // BEGIN "FOR" LOOP --
{
    player globalChat format["Choose location for zone #%1...",_i];
    _found = false;
    _zone_radius = 0;
    _points_zone = 0;
    while {_zone_radius<=zones_min_radius} do {
        _random_zones_max_radius = random zones_max_radius;
        _zone_radius = round _random_zones_max_radius;
        _points_zone = round (_zone_radius/10);
    };

    while {!_found} do {
        clicked = false;
        OnMapSingleClick "ClickedPos = _pos; clicked = true;";
        _found_distance = false;
        _missionPos = [];

        if (clicked) then {

            _posDeMeilleurTruc = [];
            _posDeMeilleurTruc = [ClickedPos, 0,50,15,0,0.1,0,[],[[0,0],[0,0]]] call BIS_fnc_findSafePos;

            if (0 == _posDeMeilleurTruc select 0 && 0 == _posDeMeilleurTruc select 1) then {
                clicked = false;
                hint "Invalid position, the position must be flat and no objects must be near the position";
            } else {
                onMapSingleClick "";
                hint "Valid pos, creating enemy zone";
                _found_distance = true;
                _missionPos = _posDeMeilleurTruc;
            };
        };

        if (_found_distance) then {
            _missionPos = [round(_missionPos select 0),round(_missionPos select 1)];
            _generatezonescript = [format["Zone %1",_i],_points_zone,_zone_radius,_missionPos,_fortified,true] spawn duws_fnc_createzone;
            _found = true;
            _zones_array = _zones_array + [_missionPos];

            player globalChat format["Zone location #%1 found !",_i];
            player globalChat format["Generating zone #%1",_i];
            waituntil {scriptdone _generatezonescript};
        };
    };
};

openMap [false, false];

//hintSilent format["All zones found\nWelcome to %1\nHave fun !\nDUWS by kibot",_worldName];
player globalChat format["All zones found. Welcome to %1, %2",_worldName,profileName];


//hint format["MISSION INITIALIZATION COMPLETE!\nCampaign generated\nzones: %1\nmaximum radius: %2m\nminimum radius: %3m\nmax. distance from HQ: %4m\n\nIf you experience performance issues, restart the mission and try reducing the amount of zones/and or their radius",zones_number,zones_max_radius,zones_min_radius,zones_max_dist_from_hq];
"MISSION INITIALIZATION COMPLETE!" remoteExec ["systemChat"];
(format["MISSION INITIALIZATION COMPLETE!\nCampaign generated\nzones: %1\nmaximum radius: %2m\nminimum radius: %3m\nmax. distance from HQ: %4m\n\nIf you experience performance issues, restart the mission and try reducing the amount of zones/and or their radius",zones_number,zones_max_radius,zones_min_radius,zones_max_dist_from_hq]) remoteExecCall ["hint"];
[] spawn {
    sleep 9;
    [] call duws_fnc_bottom_right_message;
};


// For some reasons I had to add a zone [0,0,0] in _zones_array, now I must remove it:
_zones_array = [_zones_array, 0] call BIS_fnc_removeIndex;

//player globalchat format["%1",_zones_array];
[_zones_array, getpos hq_blu1, [0,0,0], blufor_ap, opfor_ap, 2700,blufor_ai_skill,opfor_ai_skill, 2000] call duws_fnc_WARCOM_init; // 2700 is 40 mins
sleep 0.1;

[] spawn duws_fnc_autoSave;
sleep 1;

[[format["MISSION INITIALIZATION COMPLETE!<br/>Campaign generated<br/>Welcome to %1, %2",_worldName,profilename]]] spawn BIS_fnc_typeText;
playMusic ["EventTrack01a_F_EPA", 0];

if (debugmode) exitWith {};
