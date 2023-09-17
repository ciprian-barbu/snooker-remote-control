include <RemoteControlModules.scad>

h  = 10;
do = 5.5;
di = 5;
ds = 2.4;
// screw head diameter
hd = 4.36;

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
