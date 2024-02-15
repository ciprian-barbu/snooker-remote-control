include <RemoteControlModules.scad>

cw = 2;
_bdcw = 23;
_bdhwh = 0.75;
_bdlw = 1.5;
_bdlh = 1.5;
_bdlcw = _bdcw + 2 * _bdlw;
_bdbh = _bdlh + _bdhwh;
cow1 = _bdcw;
cow2 = _bdlcw;
col = 53;
coh1 = _bdlh;
coh2 = cw + _bdbh - coh1;

RemoteControlBatteryDoor(cow1, cow2, col, coh1, coh2);
