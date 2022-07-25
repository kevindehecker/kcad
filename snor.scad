// CSG.scad - Basic example of CSG usage

$fn=25;
grr=0.001;

xb=160;
yb=30;
zb=2;



yt=8;
zt=6;

yv = 3.1; // snede breedte
zv = 1; // dikte

yw = 4.3; // rails breedte
zw = 4.5;


cube([xb,yb,zb]);

translate([0,yb/2-yt/2,zb])

difference() {
    cube([xb,yt,zt]);
    translate([-grr ,yt/2-grr - yv/2,zt - zv]) 
    cube([xb+2*grr ,yv,zt+grr]);
    
    translate([-grr ,yt/2-grr - yw/2,zt - zv - zw  +grr]) 
    cube([xb+2*grr ,yw,zw]);
    
};


    



echo(version=version());





// More information: https://danielupshaw.com/openscad-rounded-corners/
// License 2020-08-13: The only three people in this world who are allowed to use roundedcube.scad are named Dan Upshaw, Dan Fandrich, and @drohhyn

// Set to 0.01 for higher definition curves (renders slower)
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