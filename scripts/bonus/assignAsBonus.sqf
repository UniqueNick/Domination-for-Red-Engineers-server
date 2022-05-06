/*
    scripts\bonus\assignAsBonus.sqfб called on server ONLY
	author: Sygsky
	description: handlers assigned to the vehicle to check bonus in/kill events
		called on server (in debug SP mission it is emulated only)
	call: [_veh1, ..., _vehN] execVM "scripts\bonus\assignAsBonus.sqf";
	returns: nothing
*/

#include "bonus_def.sqf"

if (typeName _this == "OBJECT") then {_this = [_this]};
if (typeName _this != "ARRAY") exitWith {hint localize format["--- assignAsBonus.sqf, expected input type is ARRAY, detected %1, EXIT ON ERROR !!!",typeName _this]};
private ["_x"];
_msg_arr = [];
{
	if ( ! (_x isKindOf "LandVehicle" || _x isKindOf "Air" || _x isKindOf "Ship") ) exitWith {
		hint localize format["--- assignAsBonus.sqf: expected type LandVehicle|Air|Ship, detected ""%1"", EXIT ON ERROR !!!", typeOf _x];
	};

	// TODO: set according to the server or client code
	if (X_Server) then { // MP server code
//		_x setVehicleInit "this setVariable [""INSPECT_ACTION_ID"",this addAction [ localize ""STR_CHECK_ITEM"",""scripts\bonus\bonusInspectAction.sqf"",[]]]; this setVariable [""DOSAAF"", """"]";
		_x setVehicleInit "[this,""INI""] spawn SYG_updateBonusStatus;";
		 processInitCommands; // must be executed on all currently connected computers
		if (X_SPE) then { // Server Player Execution on this computer from this computer with the client EXE
			[_x, "INI"] call SYG_updateBonusStatus; // add event to the server run on the client computer too
//			_x setVariable ["INSPECT_ACTION_ID", _x addAction [ localize "STR_CHECK_ITEM", "scripts\bonus\bonusInspectAction.sqf", [] ]];
			hint localize format["+++ assignAsBonus.sqf: X_SPE detected, add local INSPECT_ACTION_ID to the %1", typeOf _x];
		}; // process init command on all client connect at this moment
		// TODO: send info to all connected clients too, may be processInitCommands not work!
	};
	_x call SYG_addEventsAndDispose; // add all std mission-driven events here (not recoverable, may be killed and removed from the mission)

	//  Passed array for "killed" event: [unit, killer]
/**
	_id = _x addEventHandler [ "killed", {
			private ["_cnt"];
			_cnt = count server_bonus_markers_array;
			[server_bonus_markers_array, _this select 0] call SYG_removeObjectFromArray;
			["bonus","DEL", _this select 1, _this select 0] call XSendNetStartScriptClientAll;
			hint localize format["+++ assignAsBonus.sqf: killed _this %1, markers prev. cnt %2, new cnt %3", _this, _cnt, count server_bonus_markers_array];
		}
	];
*/
	_near_loc_name = text (_x call SYG_nearestLocation);
	_msg_arr set [count _msg_arr, ["STR_BONUS", _near_loc_name, typeOf _x]];
	hint localize format["+++ assignAsBonus.sqf: all events set, ""%1"" action will be added on clients to the %2 near %3", localize "STR_CHECK_ITEM", typeOf _x, _near_loc_name];
} forEach _this;

["msg_to_user","*",_msg_arr,8,1,false,"good_news"] call XSendNetStartScriptClientAll;

