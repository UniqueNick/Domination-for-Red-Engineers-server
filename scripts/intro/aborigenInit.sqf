/*
	aborigenInit.sqf
	author: Sygsky
	description: add all actions and events to the aborigen on player client
	returns: nothing
	todo:
		move ammobox creation and arming in this file to make it local and fully available!!!
		create ammobox always on far position from the tent entrance
		loading the ammo proc is situated at line 284 , file stupplayer1.sqf: _box = nearestObject [getPos spawn_tent, "ReammoBox"];
*/
#include "x_setup.sqf"

#define ABORIGEN "ABORIGEN"

_civ = _this;
_civ setVariable [ABORIGEN, true];

waitUntil {!isNull player};
// not all players can use Antigua items except killed event
if (!((name player) in __ARRIVED_ON_ANTIGUA__)) exitWith {format["+++ You '%1' cant to arrive at Antigua, exit.", name player]};

hint localize format["+++ aborigenInit.sqf: processed unit %1, pos %2", typeOf _civ, [_civ, 10] call SYG_MsgOnPosE0];

// TODO: add follow sub-menus to the civilian:
// 1. "Ask about boats". 2. "Ask about cars". 3. "Ask about weapons". 4. "Ask about soldiers". 5. "Ask about rumors"
{
	_civ addAction[ localize format["STR_ABORIGEN_%1", _x], "scripts\intro\SYG_aborigenAction.sqf", _x]; // "STR_ABORIGEN_BOAT", "STR_ABORIGEN_CAR" etc
} forEach ["BOAT", "CAR", "WEAPON", "MEN", "RUMORS","GO","NAME"];

while { !(player call SYG_pointOnAntigua) } do { sleep 5; }; // while out of Antigua

while {((getPos player) select 2) > 5} do { sleep 2}; // while in air

if (alive _civ) then { // show info
	player groupChat format [localize "STR_ABORIGEN_INFO", round (player distance _civ), ([player,_civ] call XfDirToObj) call SYG_getDirName]; // "Aborigen is on dist. %1 to %2"
} else {
	player groupChat (localize "STR_ABORIGEN_INFO_NONE"); // "Locals are not observed"
};

//+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ Giggle while not closer than 5 meters
while {(player distance _civ) > 5} do {
	sleep (5 + (random 2));
	_civ setMimic (["Default","Normal","Smile","Hurt","Ironic","Sad","Cynic","Surprised","Agresive","Angry"] call XfRandomArrayVal);
	_civ say format["laughter_%1", (floor (random 12)) + 1]; // 1..12
	_civ setDir (getDir _civ) + ((random 20) - 10);
};

// set marker on civ
_marker = "aborigen_marker";
if ((markerType "aborigen_marker") == "") then {
	_marker = createMarkerLocal[_marker, getPosASL _civ];
	_marker setMarkerTypeLocal  "Vehicle";
	_marker setMarkerColorLocal "ColorGreen";
	if ( (name _civ) == "Error: No unit") then {
		_marker setMarkerTextLocal ("*");
	} else { _marker setMarkerTextLocal (name _civ); };

	_marker setMarkerSizeLocal [0.5, 0.5];
};

_civ setMimic "Normal";
// Do watch while alive or near
_civ doWatch player;
while { (alive _civ) && (alive player) && ((player distance _civ) < 40)} do { sleep 5};
_civ doWatch objNull;
_civ spawn {
	private ["_list","_civ"];
	_civ = _this;
	_list = [
		"ActsPercMstpSlowWrflDnon_Lolling",  // Stretches, as if the unit has just woken up
		"ActsPercMstpSnonWnonDnon_DancingDuoIvan", // Does various dance moves
		"ActsPercMstpSnonWnonDnon_DancingDuoStefan", // Dances
		"ActsPercMstpSnonWnonDnon_DancingStefan",	// As above
		"TestDance",
		"TestFlipflop",
		"TestJabbaFun",
		"AmovPercMstpSnonWnonDnon_exerciseKata",	//		Martial arts moves
		"AmovPercMstpSnonWnonDnon_exercisePushup",	//	Pushups
		"AmovPercMstpSnonWnonDnon_Ease",	//	"At ease"
		"AmovPercMstpSnonWnonDnon_AmovPsitMstpSnonWnonDnon_ground",	//	Sits on the ground
		"AmovPercMstpSnonWnonDnon",	//	Stand without weapon
		"AmovPercMstpSlowWrflDnon_seeWatch",	//	Checks watch with weapon in other hand
		"AmovPercMstpSlowWrflDnon_AmovPsitMstpSlowWrflDnon"	//	Sits on ground
	];
	//++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ Dancing
	while { (canStand _civ) && ((player distance _civ) > 30)} do {
		_arr = _civ nearObjects [ "CAManBase", 50];
		_cnt = {(canStand _x) && (isPlayer _x)} count _arr;
		if (_cnt  == 1) then { // only for single player
			_civ doWatch player;
			sleep 1;
			_civ switchMove (_list select _i);
			sleep 9;
			_civ doWatch objNull;
		};
		sleep (random 5);
	};
};

while {alive _civ} do {
	sleep 10;
	if ( ([getMarkerPos _marker, getPosASL _civ] call SYG_distance2D) > 10) then {
		_marker setMarkerPosLocal (getPosASL _civ);
	};
};
deleteMarkerLocal _marker;
// exit this humorescue

