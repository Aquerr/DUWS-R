/*
	author: nerdi
	description: Super simple script that removes the dead crop after 20min.
	returns: nothing
*/

params ["_corpse"];
_time = DUWS_Dead_Units_Removal_Time;
sleep DUWS_Dead_Units_Removal_Time;
systemChat "Removing entity..." + (name _corpse);
deleteVehicle _corpse;
true;
