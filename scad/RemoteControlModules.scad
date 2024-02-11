$fn = 100;

//////////////// Internal Modules ////////////////

module round_case(xx, yy, zz, d, cw) {
    difference () {
        translate([0, 0, d/2]) {
            minkowski() {
                cube([xx - d, yy - d, zz], center = true);
                sphere(d/2);
            }
        }

        // chopp off top
        translate([0, 0, zz]) cube([xx + 1, yy + 1, zz], center = true);

        // hollow inside
       translate([0, 0, d/2 + cw]) {
           minkowski() {
               cube([xx - 2*cw - d, yy - 2*cw - d, zz], center = true);
               sphere(d/2);
           }
       }
    }
}

module mid_notch(h, t = 0.8) {
    w1 = 6.6;
    w2 = 7.25;
    
    translate([0, t/2, 0]) {
        rotate([90, 0, 0]) {
            linear_extrude(t) {
                polygon(points = [[-w2/2, -h/2], [w2/2, -h/2], [w1/2, h/2], [-w1/2, h/2]]);
            }
        }
    }
}

module bat_sign(w = 5, l = 20, h = 1) {
    // width of the battery
    //w = 5;
    // width of the shoulder on plus pole
    w2 = 2;
    // width of the plus pole
    w3 = (w - w2)/2;
    // thickness of the sign
    t = 0.25;
    // height of the plus pole
    h2 = 1;
    // height of the +/- symbols
    h3 = 2;
    // height of the battery
    bl = l - h2;
    // position of + sign, in percentage of the height of battery
    p1 = 0.85;
    // position of - sign, in percentage of the height of battery
    p2 = (1 - p1);

    // Left side
    translate([0, 0, 0])
        cube([t, bl, h], center = false);
    // right side
    translate([w - t, 0, 0])
        cube([t, bl, h], center = false);
    // bottom side
    translate([0, 0, 0])
        cube([w, t, h], center = false);
    // upper left shoulder
    translate([0, bl - t, 0])
        cube([w3, t, h], center = false);
    // upper right shoulder
    translate([w - w3, bl - t, 0])
        cube([w3, t, h], center = false);
    // upper plus pole
    translate([w3 - t, bl - t + h2, 0])
        cube([w2 + 2*t, t, h], center = false);
    // left plus pole
    translate([w3 - t, bl - t, 0])
        cube([t, h2 + t, h], center = false);
    // right plus pole
    translate([w2 + w3, bl - t, 0])
        cube([t, h2 + t, h], center = false);

    // Plus sign
    translate([(w - t)/2, bl * p1 - h3/2, 0])
        cube([t, h3, h]);
    translate([(w - h3)/2, bl * p1 - t/2, 0])
        cube([h3, t, h]);

    // Minus sign
    translate([(w - t)/2, bl * p2 - h3/2, 0])
        cube([t, h3, h]);
}

module bat_support(w = 21.4, h1 = 2, h2 = 0.4, t = 0.8, g = 0.4)
{
    r = 10.33 / 2;
    difference() {
        translate([-w/2, -t/2, 0])
            cube([w, t, h1], center = false);
        translate([-(r + g), 0, r + h2])
            rotate([90, 0, 0])
                cylinder(2*t, r, r, center = true);
        translate([r + g, 0, r + h2])
            rotate([90, 0, 0])
                cylinder(2*t, r, r, center = true);
    }
}

// ================================
// |        |   X      |   Y      |
// --------------------------------
// | B1     |   16.5   |   17     |
// | B2     |    5.5   |   27     |
// | B3     |   16.5   |   27     |
// | B4     |   27.5   |   27     |
// | B5     |    5.5   |   37     |
// | B6     |   16.5   |   37     |
// | B7     |   27.5   |   37     |
// | BFoul  |   16.5   |   47     |
// | BGame  |    8     |   57.2   |
// | BClear |   25     |   57.2   |
// | BEsc   |    8     |   67.8   |
// | BEnter |   25     |   67.8   |
// --------------------------------

module wide_button(d1, d2) {
    // inner rectangle width
    _d2 = d2 - d1;
    square([_d2, d1], center = true);
    translate([-_d2/2, 0])
        circle(d1/2);
    translate([_d2/2, 0])
        circle(d1/2);
}

module buttons_grid(w, l, h, d, d1 = 6.2, d2 = 11.3, tb = 10) {
    // column offset #1
    _co1 = 11;
    // row offset #1
    _ro1 = 10;
    // column offset #2
    _co2 = 8.5;
    // row offset #2
    _ro2 = 10.6;
    // row offset #3
    _ro3 = 10.2;

    linear_extrude(h) {
        difference() {
            minkowski() {
                square([w - d, l - d], center = true);
                circle(d/2);
            }
            // B1
            translate([0, l/2 - tb])
                circle(d1/2);
            // B2
            translate([-_co1, l/2 - tb - _ro1])
                circle(d1/2);
            // B3
            translate([0, l/2 - tb - _ro1])
                circle(d1/2);
            // B4
            translate([_co1, l/2 - tb - _ro1])
                circle(d1/2);
            // B5
            translate([-_co1, l/2 - tb - 2*_ro1])
                circle(d1/2);
            // B6
            translate([0, l/2 - tb - 2*_ro1])
                circle(d1/2);
            // B7
            translate([_co1, l/2 - tb - 2*_ro1])
                circle(d1/2);
            // BFoul
            translate([0, l/2 - tb - 3*_ro1])
                circle(d1/2);
            // BGame
            translate([-_co2, l/2 - tb - 3*_ro1 - _ro3])
                wide_button(d1, d2);
            // BClear
            translate([_co2, l/2 - tb - 3*_ro1 - _ro3])
                wide_button(d1, d2);
            // BEsc
            translate([-_co2, l/2 - tb - 3*_ro1 - _ro3 - _ro2])
                wide_button(d1, d2);
            // BEnter
            translate([_co2, l/2 - tb - 3*_ro1 - _ro3 - _ro2])
                wide_button(d1, d2);
        }
    }
}

module diode_cone_block(w, l, h, dr, cr) {
    // cone height
    _ch = h * w/dr/2;
    difference() {
        cube([w, l, h], center = true);
        translate([0, 0, h/2 - _ch + 0.1])
            scale([w/cr/2, 1, 1])
                cylinder(_ch, 0, cr);
        translate([0, 0, -h/2 - 0.5])
            cylinder(h + 1, dr/2, dr/2);
    }
}

module diode_cone_block_half(w, l, h, dr, cr) {
    translate([0, 0, l/2]) {
        difference() {
            rotate([-90, 0, 0])
                diode_cone_block(w, l, h, dr, cr);
            translate([-w/2 -0.5, - h/2 -0.5, 0])
                cube([w + 1, h + 1, l+1]);
        }
    }
}

// Screw joint in
// h   : height of the joint
// do  : outer diameter (on the case)
// di  : inner diameter (top)
// ds  : screw hole diameter
// shh : screw hole height
module screw_joint_in(h, do, di, ds, shh = 8) {
    difference() {
        cylinder(h, do/2, di/2);
        translate([0, 0, h - shh])
            cylinder(shh + 1, ds/2, ds/2);
    }
}

// Screw joint out
// h  : height of the joint
// do : outer diameter (on the case)
// di : inner diameter (top)
// ds : screw hole diameter
// hd : screw head diameter
module screw_joint_out(h, do, di, ds, hd = 4.36) {
    // screw hole height
    difference() {
        cylinder(h, do/2, di/2);
        translate([0, 0, -0.1])
            cylinder(h - (di - hd)  + 0.1, (hd + do - di)/2, hd/2);
        translate([0, 0, h - (di - hd) - 0.5])
            cylinder(di - hd + 1, ds/2, ds/2);
    }
}

module tprism(w1, w2, l, h) {
    rotate([90, 0, 0]) {
        linear_extrude(height = l, center = true) {
            polygon(points = [ [-w2/2, -h/2], [w2/2, -h/2], [w1/2, h/2], [-w1/2, h/2] ]);
        }
    }
}


//////////////// External Modules ////////////////

module RemoteControlTop(w, l, h, d, cw, lw, lh) {
    round_case(w, l, h, d, cw);
    // add ledge
    difference() {
        translate([0, 0, h/2 - 1]) {
            linear_extrude(lh + 1) {
                minkowski() {
                    square([w - 2*(cw - lw) - d, l - 2*(cw - lw) - d], center = true);
                    circle(d/2);
                }
            }
        }

        // hollow inside
        translate([0, 0, h/2 - 2]) {
            linear_extrude(lh + 3) {
                minkowski() {
                    square([w - 2*cw - d, l - 2*cw - d], center = true);
                    circle(d/2);
                }
            }
        }
    }
}

module RemoteControlTopButtons(w, l, h, d, cw, lw, lh) {
    // width of buttons grid
    wb = 35;
    // length of buttons grid
    lb = 80;
    // delta for avoiding holes
    _d = 0.1;
    // resized grid parameters
    wbh = wb - _d;
    lbh = lb - _d;
    // bevel depth of the buttons grid
    bd = 0;
    // For buttons grid, distance between top button and top of buttons grid
    bgtb = 10;
    // For PCB, distance from top button to top of PCB
    pcbtb = 18;
    // For PCB, distance from top of PCB to top of case body
    // this is more or less how much the IR diode protubes outside the case body
    pcbgt = 5;
    // gap between buttons grid to front
    g1 = pcbtb - bgtb + pcbgt;
    // gap between buttons grid to side edge
    g2 = 3;
    // PCB width 
    pcbw = 34;
    // PCB length
    pcbl = 84.7;
    // Diode cutout block width
    dcbw = 13.5;
    // Diode cutout block length
    dcbl = 4.5;

    // Diode cone block height
    dcbh = 3.5;
    // Diode diameter
    dcdr = 4.9;
    // Diode cone outer radius
    dcor = 4;

    // screw joint outer diameter
    _sjdo = 5.5;
    // screw joint inner diameter
    _sjdi = 5;
    // screw hole diameter
    _sjds = 2.2;
    // gap from screw joint to case
    _sjgc = 0.6;
    // x coordinate of the screw joints
    _sjx = (w - _sjdo)/2 - cw - _sjgc;
    // y coordinate of the screw joints
    _sjy = (l - _sjdo)/2 - cw - _sjgc;

    // notch joint length
    _njl = cw/2 + 0.2;
    // notch joint height
    _njh = lh/2 * 0.9;

    // notch joint x coordinate (half of the segment delimited by the diode cutout block
    _njx = (w - dcbw)/2 - lw;
    // notch joint y coordinate
    _njy = l/2 - lw + 0.1;
    // notch joint z coordinate
    _njz = (h + lh) / 2;


    ///////////////// Main body with cutouts //////////////
    // PCB must sit flush to the battery pack,
    // so we place everything relative to the front of the remote control
    // y coordinate for the buttons grid, relative to the gap to top of case body
    _yd = (l - lb)/2 - g1;
    _ydh = (l - lbh)/2 - (g1 + _d);
    difference() {
        RemoteControlTop(w, l, h, d, cw, lw, lh);

        // Cut out space for the buttons grid
        translate([0, _ydh, -h/2]) {
            linear_extrude(cw + 1) {
                minkowski() {
                    square([wbh - d, lbh - d], center = true);
                    circle(d/2);
                }
            }
        }

        // Cut out space for the diode cone block
        translate([0, (l - cw)/2, (h - dcbl + lh)/2 + 0.5])
            cube([dcbw, cw + 1, dcbl + lh + 1], center = true);

        // left top notch instead of screw joint
        translate([- _njx, _njy , _njz])
            rotate([90, 0, 0])
                cylinder(_njl, _njh, _njh/2);

        // right top notch instead of screw joint
        translate([_njx, _njy , _njz])
            rotate([90, 0, 0])
                cylinder(_njl, _njh, _njh/2);

    }

    ///////////////// Diode cone block //////////////
    translate([0, (l - dcbh)/2, h/2 - dcbl])
        diode_cone_block_half(dcbw, 2 * dcbl, dcbh, dcdr, dcor);

    ///////////////// Buttons grid //////////////
    // Button type 1 dimension
    _d1 = 6.2;
    // Button type 2 dimension
    _d2 = 11.3;
    translate([0, _yd, -h/2 + bd])
        buttons_grid(wb, lb, cw - bd, d, _d1, _d2);

    ///////////////// Battery Pack //////////////
    // battery pack width
    _bpw = 23.8;
    //  battery pack length
    _bpl = 50.7;
    //  battery pack height
    _bph = 10.3;
    // battery pack thickness
    _bpt = 1;
    // y coordinate of battery pack, which sits next to the PCB
    _yb = (l - _bpl)/2 - pcbgt - pcbl;
    // z offset for the battery pack to be on the same level with the PCB
    _zbo = 1.5;
    // z coordinate of battery pack
    _zb = -h/2 +_bph/2 + cw - _bpt + _zbo;

    // Battery Pack filler height
    _bpfh = 1;

    translate([0, _yb, _zb - _bpfh])
        BatteryPack(_bpw, _bpl, _bph, _bpfh);

    translate([0, _yb, _zb])
        BatteryPack(_bpw, _bpl, _bph);

    ///////////////// Battery Pack Wall Supports //////////////
    // battery pack wall support width
    _bpwsd = 3.0;
    // battery pack wall support length (50% should do)
    _bpwsl = _bpl * 0.5;
    // battery pack wall support height
    _bpwsh = _bph;
    // battery pack wall support y coordinate
    _ybpws = _yb;
    // battery pack wall support x coordinate (small delta to meld into the wall)
    _xbpws = (_bpw + _bpwsd - 0.1)/2;
    // battery pack wall support z coordinate
    _zbpws = _zb - _bpfh;

    // Left wall support
    translate([-_xbpws, _ybpws, _zbpws])
        cube([_bpwsd, _bpwsl, _bpwsh], center = true);

    // Right wall support
    translate([_xbpws, _ybpws, _zbpws])
        cube([_bpwsd, _bpwsl, _bpwsh], center = true);

    ///////////////// PCB delimiters //////////////
    // delimiter wall width
    _dww = 3.2;
    // delimiter wall length
    _dwl = pcbl * 0.75;
    // delimiter wall height
    _dwh = h + lh/2 - bd;
    // small delta to allow some room between PCB and the delimiter walls
    _dwd = 0.4;
    // x coordinate of the delimiter walls
    _dwx = (pcbw + _dww + _dwd) / 2;
    // y coordinate of the delimiter walls
    _dwy = (l - pcbgt - pcbl)/2;
    // z coordinate of the delimiter walls
    _dwz = (bd + lh)/2;

    // Left delimiter wall
    translate([- _dwx, _dwy, _dwz])
        cube([_dww, _dwl, _dwh], center = true);

    // Right delimiter wall
    translate([_dwx, _dwy, _dwz])
        cube([_dww, _dwl, _dwh], center = true);

    ///////////////// Screw joints //////////////
    // left bottop screw joint
    translate([- _sjx, - _sjy, -h/2])
        screw_joint_in(h, _sjdo, _sjdi, _sjds);

    // right bottop screw joint
    translate([_sjx, - _sjy, -h/2])
        screw_joint_in(h, _sjdo, _sjdi, _sjds);
}

module BatteryPackFill(w = 23.8, l = 50.7, h = 1) {
    cube([w, l, h], center = true);
}

module BatteryPack(w = 23.8, l = 50.7, h = 10, t = 1) {
    // height of the nothches above the contacts
    h2 = 2.5;
    // thickness #2
    t2 = 1.2;
    // thickness #3
    t3 = 0.8;
    // width #2
    w2 = 3;
    // width #3
    w3 = 6.6;
    // width #4
    w4 = 7.8;
    // contact gap
    cg = 0.8;

    // Hollow the entire case
    difference() {
        cube([w, l, h], center = true);
        translate([0, 0, t]) {
            cube([w - 2*t, l - 2*t2, h], center = true);
        }
        // upper left contact notch
        translate([-(w - w2)/2, (l - cg)/2 - t2, (h - h2)/2])
            cube([w2 + 2, cg, h2 + 1], center = true);

        // upper right contact notch
        translate([(w - w2)/2, (l - cg)/2 - t2, (h - h2)/2])
            cube([w2 + 2, cg, h2 + 1], center = true);
    }

    union() {
        // upper left contact tab
        translate([-(w - w2)/2, l/2 - t3/2 - t2 - cg, 0]) {
            cube([w2, t3, h], center = true);
        }

        // upper right contact tab
        translate([(w - w2)/2, l/2 - t3/2 - t2 - cg, 0]) {
            cube([w2, t3, h], center = true);
        }

        // upper middle contact tab
        translate([0, l/2 - t3/2 - t2 - cg, 0]) {
            mid_notch(h, t3);
        }
        // temp variable
        _lt = t2 + cg + t3;
        translate([0, l/2 - _lt/2, 0]) {
            cube([t3, _lt, h], center = true);
        }
    }

    union() {
        // lower left contact tab
        translate([-(w - w2)/2, -(l/2 - t3/2 - t2 - cg), 0]) {
            cube([w2, t, h], center = true);
        }

        // lower right contact tab
        translate([(w - w2)/2, -(l/2 - t3/2 - t2 - cg), 0]) {
            cube([w2, t, h], center = true);
        }

        // lower middle contact tab
        translate([0, -(l/2 - t3/2 - t2 - cg), 0]) {
            cube([w4, t, h], center = true);
        }
    }

    bw = 5;
    bl = 20;
    bh = 0.5;

    // Battery sign #1
    translate([-w/4 - bw/2 , -bl/2, -h/2 + t])
        bat_sign(bw, bl, bh);

    // Battery sign #2
    translate([w/4 + bw/2 , bl/2, -h/2 + t])
        rotate([0, 0, 180])
            bat_sign(bw, bl, bh);

    // battery support thickness
    bst = 0.8;

    // upper batter support
    translate([0, bl/2 + bst/2 + 0.4, -h/2 + t - 0.1])
        bat_support(w = w - 2*t, h1 = 1.8, h2 = 0.4, t = bst);

    // lower batter support
    translate([0, -(bl/2 + bst/2 + 0.4), -h/2 + t - 0.1])
        bat_support(w = w - 2*t, h1 = 1.8, h2 = 0.4, t = bst);
}

module RemoteControlBottom(w, l, h, d, cw, lw, lh) {
    difference() {
        round_case(w, l, h, d, cw);
        // cut out ledge
        translate([0, 0, h/2 - lh]) {
            linear_extrude(lh + 1) {
                minkowski() {
                    square([w - 2*(cw -lw) - d, l - 2*(cw - lw) - d], center = true);
                    circle(d/2);
                }
            }
        }
    }
}

module RemoteControlBottomBatDoor(w, l, h, d, cw, lw, lh) {
    // Diode cutout block width
    dcbw = 13.5;
    // Diode cutout block length
    dcbl = 4.5;
    // battery door holder wall width
    _bdhww = 2;
    // battery door holder wall height
    _bdhwh = 1;
    // battery door ledge height
    _bdlh = 1;
    // battery door ledge width
    _bdlw = 1.5;
    // battery door cutout width
    _bdcw = 23;
    // battery door cutout length
    _bdcl = 54;
    // battery door cutout height
    _bdch = cw + _bdhwh;
    // battery door cutout x coordinate
    _bdcx = 0;
    // battery door cutout y coordinate
    _bdcy = - (l - _bdcl) / 2;
    // battery door cutout z coordinate
    _bdcz = - (h - _bdch) / 2 - 0.1;
    // battery door block width
    _bdbw = _bdcw + 2 * (_bdlw + _bdhww);
    // battery door block length
    _bdbl = _bdcl - cw - 0.1;
    // battery door block height (apply small delta)
    _bdbh = _bdlh + _bdhwh + 0.1;
    // battery door block x coordinate
    _bdbx = 0;
    // battery door block y coordinate
    _bdby = _bdcy + cw/2;
    // battery door block z coordinate (apply small delta)
    _bdbz = - (h/2 - _bdbh/2 - cw) - 0.1;
    // battery door ledge cutout width
    _bdlcw = _bdcw + 2 * (_bdlw);
    _bdlcl = _bdcl + 0.1;
    _bdlch = _bdlh;
    _bdlcx = 0;
    _bdlcy = - (l - _bdcl)/2;
    _bdlcz = - (h/2 - cw - _bdlch/2);
    // screw joint outer diameter
    _sjdo = 5.5;
    // screw joint inner diameter
    _sjdi = 5;
    // screw hole diameter
    _sjds = 2.2;
    // screw head diameter
    _sjhd = 4.36;
    // gap from screw joint to case
    _sjgc = 0.6;
    // x coordinate of the screw joints
    _sjx = (w - _sjdo)/2 - cw - _sjgc;
    // y coordinate of the screw joints
    _sjy = (l - _sjdo)/2 - cw - _sjgc;

    // notch joint length
    _njl = cw/2;
    // notch joint height
    _njh = lh/2 * 0.75;

    // notch joint x coordinate (half of the segment delimited by the diode cutout block
    _njx = _sjx - d/2;
    // notch joint y coordinate
    _njy = l/2 - lw + 0.1;
    // notch joint z coordinate
    _njz = (h - lh) / 2;

    ///////////////// Main body with cutouts //////////////

    difference() {
        union() {
            RemoteControlBottom(w, l, h, d, cw, lw, lh);
            translate([_bdbx, _bdby, _bdbz])
                cube([_bdbw, _bdbl, _bdbh], center = true);
        }

        // Cut out space for the diode cone block
        translate([0, (l - cw)/2, (h - dcbl + lh)/2 + 0.5])
            cube([dcbw, cw + 1, dcbl + lh + 1], center = true);

        // Cut out bulk space for the battery door
        translate([_bdcx, _bdcy, _bdcz])
            cube([_bdcw, _bdcl, _bdch], center = true);

        // Cut out top space for the battery door
        translate([_bdbx, _bdby + 0.05, _bdbz])
            cube([_bdcw, _bdbl + 0.1, _bdbh + 0.1], center = true);

        // Cut out space for the battery door ledge
        translate([_bdlcx, _bdlcy, _bdlcz])
            cube([_bdlcw, _bdlcl, _bdlch], center = true);

        // Cut out space for the screw joints
        translate([- _sjx, - _sjy, -h/2])
            cylinder(h, _sjdo/2 -0.05, _sjdi/2 -0.05);
        translate([_sjx, - _sjy, -h/2])
            cylinder(h, _sjdo/2 -0.05, _sjdi/2 -0.05);
    }

    ///////////////// Notches //////////////
    translate([- _njx, _njy , _njz])
        rotate([90, 0, 0])
            cylinder(_njl, _njh, _njh/2);

    // right top notch instead of screw joint
    translate([_njx, _njy , _njz])
        rotate([90, 0, 0])
            cylinder(_njl, _njh, _njh/2);

    ///////////////// Diode cone block //////////////
    // Diode cone block height
    dcbh = 3.5;
    // Diode diameter
    dcdr = 4.9;
    // Diode cone outer radius
    dcor = 4;

    translate([0, (l - dcbh)/2, h/2 - dcbl])
        diode_cone_block_half(dcbw, 2 * dcbl, dcbh, dcdr, dcor);

    ///////////////// Screw joints //////////////
    // left bottop screw joint
    translate([- _sjx, - _sjy, -h/2])
        screw_joint_out(h, _sjdo, _sjdi, _sjds, _sjhd);

    // right bottop screw joint
    translate([_sjx, - _sjy, -h/2])
        screw_joint_out(h, _sjdo, _sjdi, _sjds, _sjhd);
}
