// by Xeno
private ["_vehicle"];
#include "x_setup.sqf"
#include "x_macros.sqf"

#define __Poss _poss = x_sm_pos select 0;
#define __PossAndOther _poss = x_sm_pos select 0;_pos_other = x_sm_pos select 1;

x_sm_pos = [[11531.7,6113.28,0], [11387.1,6130.63,0], [11431.5,5966.3,0],[11665.7,6210.15,0]]; // // index: 43,   Dolores bridges... bridge 1, bridge 2, bridge 3
x_sm_type = "normal"; // "convoy"

#ifdef __SMMISSIONS_MARKER__
if (true) exitWith {};
#endif

if (call SYG_isSMPosRequest) exitWith {argp(x_sm_pos,0)}; // it is request for pos, not SM execution

if (X_Client) then {
	current_mission_text = "Враг наладил маршрут поставки снаряжения, который проходит через Dolores. Вам надлежит разрушить дорожную инфраструктуру города Dolores. Для этого достаточно будет взорвать мосты.";
	current_mission_resolved_text = "Задание выполнено! Мосты уничтожены.";
};

if (isServer) then {
	[x_sm_pos] execVM "x_missions\common\x_sidebridge.sqf";
};

if (true) exitWith {};