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

module buttons_grid() {
}

//////////////// External Modules ////////////////

module RemoteControlBottom(w, l, h, d, cw, lw, lh) {
    difference() {
        round_case(w, l, h, d, cw);
        // cut out ledge
        translate([0, 0, h/2 - lh]) {
            linear_extrude(lh + 1) {
                minkowski() {
                    square([w - lw - d, l - 2*lw - d], center = true);
                    circle(d/2);
                }
            }
        }
    }
}

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
    // gap between buttons grid to front
    g1 = 12.5;
    // gap between buttons grid to side edge
    g2 = 3;
    // width of buttons grid
    wb = 35;
    // length of buttons grid
    lb = 80;
    // bevel depth of the buttons grid
    bd = 0.2;

    _yd = (l - lb)/2 - g1;
    difference() {
        RemoteControlTop(w, l, h, d, cw, lw, lh);
        //cube([w, 10, h], center = true);
        //translate([0, _yd, -h/2 + cw/2])
        //    cube([wb, lb, cw + 1], center = true);
        translate([0, _yd, -h/2]) {
            linear_extrude(cw + 1) {
                minkowski() {
                    square([wb - d, lb - d], center = true);
                    circle(d/2);
                }
            }
        }
    }
}

module BatteryPack() {
    // width
    w = 23.5;
    // length
    l = 50.5;
    // height
    h = 11.2;
    // height of the nothches above the contacts
    h2 = 2.5;
    // thickness
    t = 1;
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
