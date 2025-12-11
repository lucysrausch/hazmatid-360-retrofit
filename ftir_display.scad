$fn = 100;

height = 50;
width  = 212;
depth  = 146;

lcd_width     = 196;
lcd_depth     = 131.2;
lcd_radius    = 5;
lcd_thickness = 2;

inserts_depth = 10;
inserts_dia   = 4.1;

difference() {
    // main body
    union() { 
        difference() {
            roundedcube([width, depth, height-5], false, 2, "z");
            translate([-5,0,height-0.85])rotate([-15,0,0])cube([width+10, depth+20, height]);
        }

        translate([0,0,height-5])rotate([-15,0,0])roundedcube([width, depth/cos(15)-1.07, 5], false, 2, "zmax");
    }
    
    // mounting inserts
    translate([width/2, depth/2, 0]) {
        translate([0, 136.15/2, 0])cylinder(h = inserts_depth, d = inserts_dia);
        translate([68.2, 136.15/2, 0])cylinder(h = inserts_depth, d = inserts_dia);
        translate([-68.2, 136.15/2, 0])cylinder(h = inserts_depth, d = inserts_dia);
        
        translate([0, -136.15/2, 0])cylinder(h = inserts_depth, d = inserts_dia);
        translate([68.2, -136.15/2, 0])cylinder(h = inserts_depth, d = inserts_dia);
        translate([-68.2, -136.15/2, 0])cylinder(h = inserts_depth, d = inserts_dia);
        
        translate([98.7, 0, 0])cylinder(h = inserts_depth, d = inserts_dia);
        translate([98.7, 111.8/2, 0])cylinder(h = inserts_depth, d = inserts_dia);
        translate([98.7, -111.8/2, 0])cylinder(h = inserts_depth, d = inserts_dia);
        
        translate([-98.7, 0, 0])cylinder(h = inserts_depth, d = inserts_dia);
        translate([-98.7, 111.8/2, 0])cylinder(h = inserts_depth, d = inserts_dia);
        translate([-98.7, -111.8/2, 0])cylinder(h = inserts_depth, d = inserts_dia);
    }
    
    // inner pocket
    translate([(width)/2+2,(depth-124)/2,-1])cube([182/2-2, 124, 7]);
    translate([(width)/2+2,(depth-124)/2,-1])cube([182/2-2, 50, 11]);
    translate([(width)/2+2,(depth-124)/2,10])rotate([-15,0,0])cube([182/2-2, 124*cos(15), 28]);
    
    translate([(width-182)/2,(depth-124)/2,-1])cube([182/2-2, 124, 7]);
    translate([(width-182)/2,(depth-124)/2,-1])cube([182/2-2, 50, 11]);
    translate([(width-182)/2,(depth-124)/2,10])rotate([-15,0,0])cube([182/2-2, 124*cos(15), 28]);
    
    // test print
    //translate([-1,-1,2])cube([300,200,200]);
    
    // display glass
    translate([(width-lcd_width)/2,10,height-2.5])rotate([-15,0,0])translate([0,0,-lcd_thickness])roundedcube([lcd_width, lcd_depth, 20], false, lcd_radius, "z");
    
    // display panel
    translate([(width-lcd_width)/2+8,10+8,height-2.5-lcd_thickness])rotate([-15,0,0])translate([0,0,-lcd_thickness-3])cube([185.2, 115.2, 20]);
    translate([(width-lcd_width)/2+8,10+8,height-2.5-lcd_thickness])rotate([-15,0,0])translate([150,78,-lcd_thickness-4])cube([38, 36, 20]);
    
    // flex pcb
    translate([(width-lcd_width)/2+8,10+8,height-2.5-lcd_thickness-3])rotate([-15,0,0])translate([150,32,-lcd_thickness-3-10])cube([30, 75, 20]);
    
    
    
}
        
    

$fs = 0.15;

module roundedcube(size = [1, 1, 1], center = false, radius = 0.5, apply_to = "all") {
	// If single value, convert to [x, y, z] vector
	size = (size[0] == undef) ? [size, size, size] : size;

	translate_min = radius;
	translate_xmax = size[0] - radius;
	translate_ymax = size[1] - radius;
	translate_zmax = size[2] - radius;

	diameter = radius * 2;

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
							sphere(r = radius);
						} else {
							rotate = 
								(apply_to == "xmin" || apply_to == "xmax" || apply_to == "x") ? [0, 90, 0] : (
								(apply_to == "ymin" || apply_to == "ymax" || apply_to == "y") ? [90, 90, 0] :
								[0, 0, 0]
							);
							rotate(a = rotate)
							cylinder(h = diameter, r = radius, center = true);
						}
					}
				}
			}
		}
	}
}
