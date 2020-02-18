// by Xeno
//
// x_repengineer.sqf
//
// Runs only on client side
//

#include "x_setup.sqf"

private ["_aid","_caller","_coef","_damage","_damage_ok","_damage_val","_fuel","_fuel_ok","_fuel_steps",
        "_rep_count","_rep_array","_breaked_out","_rep_action","_type_name", "_trArr","_fuel_capacity_in_litres","_addscore"];

#ifdef __NON_ENGINEER_REPAIR_PENALTY__
_is_engineer = format ["%1", player] in d_is_engineer;
// hint localize format["_is_engineer = %1", _is_engineer];
#endif

_caller = _this select 1;
_aid = _this select 2;

_truck_near = false;
_trArr =  nearestObjects [ position player, SYG_repTruckNamesArr, 21]; // find nearest repair vehicle in radius 20 meters
_truck_near = false;
{
    if ( alive _x ) exitWith { _truck_near = true; };
} forEach _trArr;

if (!d_eng_can_repfuel && !_truck_near) exitWith {
	hint (localize "STR_SYS_18");//"Следует восстановить способность ремонта и заправки техники на базе...";
};

#ifdef __RANKED__

if (score player < (d_ranked_a select 0)) exitWith {
	(format [localize "STR_SYS_139", score player,(d_ranked_a select 0)]) call XfHQChat; // "Для ремонта и заправки техники необходимо очков: %2. Вы имеете только %1 ..."
};

 if (time >= d_last_base_repair) then {
	d_last_base_repair = -1;
};
if (player in (list d_engineer_trigger) && d_last_base_repair != -1) exitWith {
	_coef = ceil((d_last_base_repair - time)/60);
	// "Wait some time to restore repairing ability..."
	(format[localize "STR_SYS_17",_coef]) call XfHQChat;
};
if (player in (list d_engineer_trigger)) then {d_last_base_repair = time + 300;};
#endif

_caller removeAction _aid;
if (!(local _caller)) exitWith {};
_rep_count = 1;

if (objectID2 isKindOf "Air") then {
	_rep_count = 0.1;
} else {
	if (objectID2 isKindOf "Tank") then {
		_rep_count = 0.2;
	} else {
		_rep_count = 0.3;
	};
};

_fuel = fuel objectID2;
_damage = damage objectID2;

_damage_val    = (_damage / _rep_count); // how many undamage steps for reparing

_fuel_capacity_in_litres = objectID2 call SYG_fuelCapacity; // litres of fuel in vehicle fuel tanks
#ifdef __LIMITED_REFUELLING__
_refuel_add = 0;

_rankIndex = _caller call XGetRankIndexFromScoreExt;
_refuel_volume = d_refuel_volume + d_refuel_per_rank * _rankIndex; // how many liters to refuel

if (_fuel_capacity_in_litres > 0) then
{
   _refuel_add = _refuel_volume/_fuel_capacity_in_litres;  // max part of volume he could refuel, (value in Arma config not in litres)
};
_fuel_add      = _refuel_add min (1 - _fuel);     // how many he will up to the fuel tank limit
_refuel_limit  = ( _fuel + _fuel_add ) min 1.0;   // limit value he can refuel up to the capacity of the vehicle fuel tank

_fuel_steps = 0;
if (_refuel_add > 0) then
{
	_fuel_steps = _refuel_volume * (_fuel_add / _refuel_add) / 20; // how many animations are need to complete refuelling
};

_fuel_vol_on_step    = 0; // default is "already refuelled"
if ( abs(_fuel_steps) > 0.0000001) then {_fuel_vol_on_step = _fuel_add /_fuel_steps;}; // how many refuel at one step
//hint localize format["x_repengineer.sqf: %1, _fuel %8, _fuel_capacity_in_litres %2, _refuel_add %3, _fuel_add %4, _refuel_limit %5, _fuel_steps %6, _fuel_vol_on_step %7, damage %9, _damage_val %10", typeOf objectID2,_fuel_capacity_in_litres,_refuel_add,_fuel_add,_refuel_limit,_fuel_steps,_fuel_vol_on_step,_fuel,_damage,_damage_val];

_rep_array = [objectID2,_refuel_limit];
#else
_refuel_limit  = 1.0;
_fuel_steps      = ((_refuel_limit - _fuel) / _rep_count); // how many refuel steps for refuelling
_fuel_vol_on_step    = _rep_count; // how may refuel at one step
_rep_array     = [objectID2];
//hint localize "x_repengineer.sqf: No __LIMITED_REFUELLING__ defined";
#endif

_coef = ceil (_fuel_steps max _damage_val);

_lfuel = format[localize "STR_SYS_15"/* "%1/%2 л." */,round(_fuel_capacity_in_litres*_fuel),_fuel_capacity_in_litres];
hint format [localize "STR_SYS_16"/* "Статус техники:\n---------------------\nТопливо: %1\nПовреждение: %2" */,_lfuel, round(_damage*1000)/1000];

_type_name = [typeOf (objectID2),0] call XfGetDisplayName;
(format [localize "STR_SYS_19", round(_damage *100), "%", round(_refuel_volume), _type_name]) call XfGlobalChat; // "Repair %1%2, refuel %3 L.: %4... wait..."
_damage_ok = false;
_fuel_ok = false;
d_cancelrep = false;
_breaked_out = false;
_breaked_out2 = false;
_rep_action = player addAction[localize "STR_SYS_77","x_scripts\x_cancelrep.sqf"]; // "Отменить обслуживание"

_addscore = 0; // how many repair steps were done
for "_wc" from 1 to _coef do {
	if (!alive player || d_cancelrep) exitWith {player removeAction _rep_action;};
#ifdef __NON_ENGINEER_REPAIR_PENALTY__
    if (_is_engineer) then {
#endif
	    (format[localize "STR_SYS_152", _addscore + 1]) call XfGlobalChat;
#ifdef __NON_ENGINEER_REPAIR_PENALTY__
	} else {(format[localize "STR_SYS_152", -(_addscore + 1)]) call XfGlobalChat;};
#endif
	player playMove "AinvPknlMstpSlayWrflDnon_medic";
	sleep 3.0;
	waitUntil {animationState player != "AinvPknlMstpSlayWrflDnon_medic"}; // this animation cycle duration is approximatelly 6 seconds
	if (d_cancelrep) exitWith {
		_breaked_out = true;
	};
	if (vehicle player != player) exitWith {
		_breaked_out2 = true;
		hint localize "STR_SYS_142"/* "Обслуживание отменено..." */;
	};
	if (!_fuel_ok) then 
	{
		_fuel = _fuel + _fuel_vol_on_step;
		if (_fuel >= _refuel_limit) then {_fuel = _refuel_limit; _fuel_ok = true;};
	};
	if (!_damage_ok) then 
	{
		_damage = _damage - _rep_count;
		if (_damage <= 0.01) then {_damage = 0;_damage_ok = true;};
		_addscore = _addscore + 1;
	};
	_lfuel = format[localize "STR_SYS_15"/* "%1/%2 л." */,round(_fuel_capacity_in_litres*_fuel),_fuel_capacity_in_litres];
	hint format [localize "STR_SYS_16"/* "Статус техники:\n---------------------\nТопливо: %1\nПовреждение: %2" */,_lfuel, round(_damage*1000)/1000];
};

if (_breaked_out) exitWith {
	(localize "STR_SYS_136") call XfGlobalChat; // "Сервис отменен..."
	player removeAction _rep_action;
};
if (_breaked_out2) exitWith {};
d_eng_can_repfuel = false;
player removeAction _rep_action;
if (!alive player) exitWith {player removeAction _rep_action};
#ifdef __RANKED__

// now count score by steps, not vehicle size and class. Previous version is commented
/*
_parray = d_ranked_a select 1;
_addscore = (
	if (objectID2 isKindOf "Air") then {
		(_parray select 0)
	} else {
		if (objectID2 isKindOf "Tank") then {
			(_parray select 1)
		} else {
			if (objectID2 isKindOf "Car") then {
				(_parray select 2)
			} else {
				(_parray select 3)
			}
		}
	}
);
*/
if (_addscore > 0) then {
    _str = "STR_SYS_137"; //"Добавлено очков за обслуживание техники: %1 ..."
#ifdef __NON_ENGINEER_REPAIR_PENALTY__
    if (!_is_engineer) then
    {
        _addscore = _addscore * __NON_ENGINEER_REPAIR_PENALTY__; // must be negative value!
        SYG_engineering_fund = SYG_engineering_fund - _addscore; // add to enginering fund, not subtract!!!
        publicVariable "SYG_engineering_fund"; // send spent scores to the fund
    #ifdef __REP_SERVICE_FROM_ENGINEERING_FUND__
        _str = "STR_SYS_137_2"; // "Maintenance score (%1) is reallocated to the Engineering Fund (%2)"
    #endif
    #ifndef __REP_SERVICE_FROM_ENGINEERING_FUND__
        _str = "STR_SYS_137_1"; //"Subtracted points for maintenance: %1 ..."
    #endif
    };
#endif
	player addScore _addscore;
	(format [localize _str, _addscore, SYG_engineering_fund]) call XfHQChat;
};
#endif
rep_array = _rep_array;
["rep_array",_rep_array] call XSendNetStartScriptAll;
_rep_array spawn x_repall;
(format [localize "STR_SYS_138", _type_name]) call XfGlobalChat; //"Обслуживание закончено: %1 ..."
if (true) exitWith {};

