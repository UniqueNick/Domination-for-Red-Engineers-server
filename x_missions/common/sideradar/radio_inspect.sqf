/*
    x_missions/common/sideradar/radio_inspect.sqf
    created 2022.06.01
	author: Sygsky, on #410 request by Rokse
	description: Inspect event handler for radio install SM, may be used on 2 trucks and 1 radiomast

	Parameters array passed to the script upon activation in _this  variable is: [target, caller, ID, arguments]
    target (_this select 0): Object  - the object which the action is assigned to
    caller (_this select 1): Object  - the unit that activated the action
    ID (_this select 2): Number  - ID of the activated action (same as ID returned by addAction)
    arguments (_this select 3): Anything  - arguments given to the script if you are using the extended syntax

	changed:
	returns: nothing
*/

_veh = _this select 0;
_txt = localize (if (_veh isKindOf "Truck") then {
		if (locked _veh) then {"STR_RADAR_TRUCK_LOCKED"} else { "STR_RADAR_TRUCK" }
	} else {
		if (isNil "sideradio_status") then {"STR_RADAR_MAST_INSTALLED"} else {"STR_RADAR_MAST"}
	}
);
(localize _txt) call XfGlobalChat;
