/*
	scripts\bonus\bonusInspectAction.sqf, executed on client only
	author: Sygsky at 17-NOV-2021
	description:
        Parameters array passed to the script upon activation in _this variable is: [target, caller, ID, arguments]
        target (_this select 0): Object - the object which the action is assigned to
        caller (_this select 1): Object - the unit that activated the action
        ID (_this select 2): Number - ID of the activated action (same as ID returned by addAction)
        arguments (_this select 3): Anything - arguments given to the script if you are using the extended syntax

	this method removes called action from vehicle
	returns: nothing
*/
_veh = _this select 0;
_name = name (_this select 1); // caller name (if a man)

_loc = _veh call SYG_nearestSettlement;
_loc_name =  text  _loc;
hint localize format ["+++ bonus.INSPECT: %1, pl ""%2"", loc %3, RECOVERABLE %4, DOSAAF %5", _this, _name, _loc_name, _veh getVariable "RECOVERABLE",_veh getVariable "DOSAAF"];
if ( !isPLayer (_this select 1) ) exitWith {
	// "One of your local soldiers %1 inspected vehicle %2, which he discovered."
	["msg_to_user","*",[["STR_BONUS_5"], _name, typeOf _veh],0,0,false,"message_received"] call XSendNetStartScriptClientAll;
	hint localize format["--- bonus.INSPECT: Not player (%1) inspected bonus vehicle near %2. Exit.", typeOf (_this select 1), _loc_name];
};

if ( (getPos _veh) call SYG_pointIsOnBase ) exitWith {
	// Vehicle is on base, print message about and assign vehicle to be restoreable
	_id = _veh getVariable "INSPECT_ACTION_ID";
	if (!isNil "_id") then {
		_veh setVariable ["INSPECT_ACTION_ID", nil];
		_veh setVariable ["RECOVERABLE", true]; // mark vehicle as recoverable bonus one
        _veh setVariable ["DOSAAF", nil];// just in case
		_veh removeAction _id;
		hint localize format["+++ bonus.INSPECT ON BASE: inspect action removed from %1", typeOf _veh];
		["bonus", "REG", _name, _veh ] call XSendNetStartScriptServer;  // send to server and it will return event to all clients
		hint localize format ["+++ bonus.INSPECT ON BASE: vehicle %1 is registered on the base, remove '%2' from command list and assign veh as bonus", typeOf _veh, localize "STR_CHECK_ITEM"];
	} else {
		_veh removeAction (_this select 2);
		hint format["--- bonus.INSPECT ON BASE: inspect action not expected but executed. Remove!"];
	};
};

_already_marked =  _veh in client_bonus_markers_array;
if (!_already_marked) then {
	_var = _veh getVariable "RECOVERABLE";
	if (!isNil "_var") then { _already_marked = !_var };
};

if ( _already_marked ) exitWith { // Do nothing except inform about vehicle already marked
	hint localize format["+++ bonus.INSPECT: %1 is inspected by ""%2"" near ""%3"" already is marked known. Exit.", typeOf _veh, _name, _loc_name];
	localize "STR_BONUS_4" hintC [format[localize "STR_BONUS_4_1", typeOf _veh ],
						format[localize "STR_BONUS_4_2", typeOf _veh, localize "STR_REG_ITEM"]
//						,format["""RECOVERABLE"" = %1", _veh getVariable "RECOVERABLE"]
						];
};

// Vehicle not on base and not marked (inspected) before

_veh setVariable ["RECOVERABLE", false]; // mark vehicle as inspected, marked and not recoverable
_veh setVariable ["DOSAAF", nil]; // just in case
["bonus", "ADD", _name, _veh ] call XSendNetStartScriptServer; // send to server and it will return event to all clients
hint localize format["+++ bonus.INSPECT: Vehicle %1 inspected by '%2' near '%3'. Exit.", typeOf _veh, _name, _loc_name];
