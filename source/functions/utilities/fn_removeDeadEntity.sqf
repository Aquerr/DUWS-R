/*
	author: nerdi
	description: Super simple script that removes the dead crop after 20min.
	returns: nothing
*/

params ["_corpse"];
private _time = DUWS_Dead_Units_Removal_Time;
sleep 600;
deleteVehicle _corpse;
true;
