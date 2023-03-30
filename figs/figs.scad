include <../bosl2/std.scad>

module step(n) {
    if (n >= 0)
    color([0.5, 0.5, 1.0])
    translate([20, 0, 0])
    cube([2440, 20, 20]);

    if (n >= 1) {
        cube([20, 800, 20]);
        translate([2460, 0, 0])
        cube([20, 800, 20]);

        translate([20, 500, 0])
        color([0.5, 0.5, 1.0])
        cube([2440, 20, 20]);
    }

    if (n >= 2) {
        translate([0, 500, 0])
        cube([20, 20, 800]);
        translate([2460, 500, 0])
        cube([20, 20, 800]);
    }

    if (n >= 3) {
        translate([2320, 505, 5])
        yrot(45)
        color([0, 0, 0])
        cube([10, 10, 200]);

        translate([150, 505, 5])
        yrot(-45)
        color([0, 0, 0])
        cube([10, 10, 200]);
    }

    if (n >= 4) {
        xrot(-31)
        color([0.5, 0.5, 1.0])
        cube([20, 20, 1220]);

        translate([2460, 0, 0])
        xrot(-31)
        color([0.5, 0.5, 1.0])
        cube([20, 20, 1220]);
    }

    if (n >= 5) {
        translate([20, 1200 * sin(31), 1200 * cos(31)])
        color([0.5, 0.5, 1.0])
        cube([2440, 20, 20]);
    }
}

step(0);