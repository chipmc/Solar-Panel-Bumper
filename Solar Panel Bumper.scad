// 6/9/2021 v1.0
// v1.1 - 1mm in on holes and more of a header for the zip-tie holes
// v1.2 - Minor adjustments to the placement of the mounting screwholes - moved the cable hole up a bit

// Bumper for a Voltaic Solar Panel (2 part design)
// By Chip McClelland and Sanjna Jotwani
// Diagram for the panel here: https://voltaicsystems.com/content/Voltaic%20Systems%20P103%20R3B.pdf

// Uses the rounded corder module from Dnniel Upshaw
// https://danielupshaw.com/openscad-rounded-corners/

// License - Open Source GPL 3.0


// Higher definition curves
$fs = 0.01;

difference() {          // The command tells OpenSCAD to create a solid object that reflects the difference of the shpapes inside the brackets
    // Bumper Definition
    // Yellow is the positive piece
    translate(v = [-65, -7.42, 0])
    color("Yellow")
    roundedcube([133,27.42,0], false, 3, "ymax");

    // Green is the negative piece
    translate(v = [-56.5, -14.42, 3])
    color("Green")
    roundedcube([115,22.42,0], false, 3, "ymax");
    
    // One hole in the middle for the lead wire
    // Brown is the holes for the screws
    translate(v = [0, 2, -10])
    color("brown")
    cylinder(h=10,r=6,center="true");

    // Blue are the holes for the screws
    translate(v = [-49.6, 0, -10])
    color("blue")
    cylinder(h=10,r=2.7,center="true");

    // Blue are the holes for the screws
    translate(v = [49.6, 0, -10])
    color("blue")
    cylinder(h=10,r=2.7,center="true");
    
    // You could add more holes here for the zip ties - just copy the 4 lines above, change the color, and paste below
    // Then change the "translate" values to put some holes across the top
    
    // Purple are the holes for the zip-ties
    translate(v = [55, 13, -10])
    color("purple")
    cylinder(h=50,r=2.7,center="true");

    // Purple are the holes for the zip-ties
    translate(v = [35, 13, -10])
    color("purple")
    cylinder(h=50,r=2.7,center="true");

    // Purple are the holes for the zip-ties
    translate(v = [15, 13, -10])
    color("purple")
    cylinder(h=50,r=2.7,center="true");
    
    // Purple are the holes for the zip-ties
    translate(v = [-55, 13, -10])
    color("purple")
    cylinder(h=50,r=2.7,center="true");
    
    // Purple are the holes for the zip-ties
    translate(v = [-35, 13, -10])
    color("purple")
    cylinder(h=50,r=2.7,center="true");
    
    // Purple are the holes for the zip-ties
    translate(v = [-15, 13, -10])
    color("purple")
    cylinder(h=50,r=2.7,center="true");
}


// This is the end of the user code for the bumper - below this is a definition for a "rounded corner version of cube"

// Module Definition
module roundedcube(size = [1, 1, 1], center = false, radius = 0.5, apply_to = "all") {
	// If single value, convert to [x, y, z] vector
	size = (size[0] == undef) ? [size, size, size] : size;

	translate_min = radius;
	translate_xmax = size[0] - radius;
	translate_ymax = size[1] - radius;
	translate_zmax = size[2] - radius;

	diameter = radius * 2;

	module build_point(type = "sphere", rotate = [0, 0, 0]) {
		if (type == "sphere") {
			sphere(r = radius);
		} else if (type == "cylinder") {
			rotate(a = rotate)
			cylinder(h = diameter, r = radius, center = true);
		}
	}

	obj_translate = (center == false) ?
		[0, 0, 0] : [
			-(size[0] / 2),
			-(size[1] / 2),
			-(size[2] / 2)
		];

	translate(v = obj_translate) {
		hull() {
			for (translate_x = [translate_min, translate_xmax]) {
				x_at = (translate_x == translate_min) ? "min" : "max";
				for (translate_y = [translate_min, translate_ymax]) {
					y_at = (translate_y == translate_min) ? "min" : "max";
					for (translate_z = [translate_min, translate_zmax]) {
						z_at = (translate_z == translate_min) ? "min" : "max";

						translate(v = [translate_x, translate_y, translate_z])
						if (
							(apply_to == "all") ||
							(apply_to == "xmin" && x_at == "min") || (apply_to == "xmax" && x_at == "max") ||
							(apply_to == "ymin" && y_at == "min") || (apply_to == "ymax" && y_at == "max") ||
							(apply_to == "zmin" && z_at == "min") || (apply_to == "zmax" && z_at == "max")
						) {
							build_point("sphere");
						} else {
							rotate = 
								(apply_to == "xmin" || apply_to == "xmax" || apply_to == "x") ? [0, 90, 0] : (
								(apply_to == "ymin" || apply_to == "ymax" || apply_to == "y") ? [90, 90, 0] :
								[0, 0, 0]
							);
							build_point("cylinder", rotate);
						}
					}
				}
			}
		}
	}
}