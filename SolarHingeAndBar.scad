include <../bosl2/std.scad>

size = [30, 30, 9];
depth = size[2];
margin = 0.3;
inner_radius = 2.25;
epsilon=0.01;

module m5_screw_hole(depth) {
    screw_head_depth = 3.2;
    cyl(d=5.3, l=20, $fn=50, anchor=CENTER);
    // hole for the screw head
    up(depth - screw_head_depth + epsilon)
    cyl(d=10, l=20, $fn=80, anchor=BOTTOM);
}

// this version is designed to use the printed component to enhance.
module enhance_bar_cf() {
    wall_depth = 8;
    cuboid(size=[200, 20, wall_depth], anchor=BOTTOM)
    {
        position(LEFT)
        // translate([-1.7, 0, -0.8]) // wall_depth = 5
        translate([2.9, 0, -1.2]) // wall_depth = 8
        yrot(45)
        difference() {
            cuboid(size=[30, 20, wall_depth], anchor=RIGHT);
            translate([-15, 0, -wall_depth / 2 + 4])
            m5_screw_hole(wall_depth);
        }

        position(RIGHT)
        // translate([-1.7, 0, -0.8]) // wall_depth = 5
        translate([-2.9, 0, -1.2]) // wall_depth = 8
        yrot(-45)
        difference() {
            cuboid(size=[30, 20, wall_depth], anchor=LEFT);
            translate([15, 0, -wall_depth / 2 + 4])
            m5_screw_hole(wall_depth);
        }
    }
}

// sometimes when the angle is fixed, a bar is enough
// this version is designed to use an extra alumium bar
module enhance_bar() {
    wall_depth = 5;
    difference() {
        cuboid([70, 20, wall_depth], anchor=BOTTOM, rounding=2, edges=["Z"], $fn=30);
        left(20)
        m5_screw_hole(wall_depth);
        right(20)
        m5_screw_hole(wall_depth);
    }
}

module hingeV2() {
    // core hinge, the center line is the z axis
    inner_diameter = 7;
    body_width = 30;
    clearance = 0.9;

    // part 1
    union() {
        cyl(d=inner_diameter, l=body_width, $fn=50);
        cyl(d=inner_diameter * 2, l=body_width / 3, $fn=100);
    }
    // part 2
    difference() {
        cyl(d=inner_diameter * 2, l=body_width, $fn=100);
        cyl(d=inner_diameter * 2 + epsilon, l=body_width / 3 + clearance, $fn=100);
        cyl(d=inner_diameter + clearance, l=body_width, $fn=50);
    }

    // body hosting the screw holes
    wall_depth = inner_diameter;
    tongue_len = 5;
    body_len = 40;
    // part 1
    difference() {
        translate([inner_diameter / 2, tongue_len, 0])
        union() {
            cube([wall_depth, tongue_len + inner_diameter, body_width / 3], anchor=CENTER);
            translate([0, tongue_len, 0])
            cube([wall_depth, body_len, body_width], anchor=FRONT);
        }
        translate([7.5, tongue_len + body_len - 10, epsilon])
        yrot(-90)
        m5_screw_hole(wall_depth);
    }
    // part 2
    translate([inner_diameter / 2, - inner_diameter, 0])
    difference() {
        union() {
            translate([0, (inner_diameter - tongue_len) / 2, 0])
            cube([wall_depth, tongue_len + inner_diameter, body_width], anchor=CENTER);
            cube([wall_depth, body_len, body_width], anchor=BACK);
        }
        // re-enforce the center cylinder
        translate([-inner_diameter / 2, inner_diameter, 0])
        cyl(d=inner_diameter + clearance, l=body_width, $fn=50);
        translate([0, inner_diameter, 0])
        cube([wall_depth + 2 * epsilon, tongue_len + inner_diameter * 2 + 2 * epsilon, body_width / 3 + clearance], anchor=CENTER);
        // translate([wall_depth / 2, - tongue_len - body_len + 18, epsilon])
        translate([4.4, - tongue_len - body_len + 18, epsilon])
        yrot(-90)
        m5_screw_hole(wall_depth);
    }
}

// This version cannot bend over 60 degrees
module hinge() {
    // part1
    difference() {
        cuboid(size, chamfer=3, edges=[FRONT + TOP, FRONT + BOTTOM]);
        translate([0, 5, -depth / 2])
        m5_screw_hole(depth);
    }
    translate([0, -size[1]/2 - depth / 2 - margin, 0])
    rotate([90, 0, 90])
    translate([0, 0, -size[0] / 2])
    difference() {
        linear_extrude(height=size[0])
        hull() {
            circle(r=depth/2, $fn=100);
            translate([depth/2+margin*2, 0])
            square(size=[depth, depth], center=true);
        }

        translate([0, 0, size[0]/3-margin])
        difference() {
            linear_extrude(height=size[0]/3+2*margin)
            hull() {
                circle(r=depth/2, $fn=100);
                translate([depth/2+margin*2, 0])
                square(size=[margin, depth], center=true);
            }
            translate([0, 0, -epsilon/2])
            cylinder(r=inner_radius-margin, h=size[0]/2, $fn=100);
        }

        // chamfer for the main body
        chamfer_size = size[0] / 3;
        chamfer_size_offset = -2;

        translate([depth + margin + chamfer_size_offset / 2, depth / 2, size[0] / 2])
        yflip()
        rotate([90, 0, 180])
        prismoid(size1=[chamfer_size - chamfer_size_offset, chamfer_size + 2 * margin],
            size2=[0, chamfer_size + 2 * margin],
            shift=[(chamfer_size - chamfer_size_offset) / 2, 0], h=depth);
        translate([depth + margin + chamfer_size_offset / 2, -depth / 2, size[0] / 2])
        rotate([90, 0, 180])
        prismoid(size1=[chamfer_size - chamfer_size_offset, chamfer_size + 2 * margin],
            size2=[0, chamfer_size + 2 * margin],
            shift=[(chamfer_size - chamfer_size_offset) / 2, 0], h=depth);
    }

    // part 2
    connector_depth_coefficient = 1;
    translate([0, -size[1] - depth * (0.5 + connector_depth_coefficient) - margin * 2, 0]) 
    rotate([0, 0, 180])
    {
        difference() {
            cuboid(size, rounding=depth/2, edges=[FRONT + TOP, FRONT + BOTTOM], $fn=50);
            translate([0, 5, -depth / 2])
            m5_screw_hole(depth);
        }
        translate([0, -size[1] / 2 - depth * connector_depth_coefficient - margin, 0])
        rotate([90, 0, 90])
        translate([0, 0, -size[0] / 6])
        difference() {
            linear_extrude(height=size[0]/3)
            hull() {
                circle(r=depth/2, $fn=100);
                translate([depth * connector_depth_coefficient + margin * 2, 0])
                square(size=[depth * connector_depth_coefficient, depth], center=true);
            }
            translate([0, 0, -epsilon/2])
            cylinder(r=inner_radius, h=size[0]/2, $fn=100);
        }
    }
}

hingeV2();
// enhance_bar_cf();