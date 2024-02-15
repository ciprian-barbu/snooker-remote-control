include <RemoteControlModules.scad>

h  = 10;
do = 6;
di = 5.8;
ds = 2;
// screw head diameter
hd = 3.6;

cl = 28;
ch = 2;

difference() {
    translate([0, 0, ch/2])
        cube([cl, cl, ch], center = true);
    translate([0, 10, -1])
        cylinder(ch + 2, di/2, di/2);
    translate([0, 0, ch/2 + 0.2])
        cube([cl + 1, 2, ch], center = true);
}

translate([0, -10, 0])
    screw_joint_in(h, do, di, ds);

translate([0, 10, 0])
    screw_joint_out(h, do, di, ds, hd);
