// CSG.scad - Basic example of CSG usage

$fn=25;

w_trali=3;
w_tot = 10;

xb=17;
yb=4.5*w_tot - 0.5*w_trali;
zb=25;
ang = 2;

s = 0.01;
s2 = 2*s;
deepf = 0.8;

difference() {
    roundedcube([xb,yb,zb],radius=1);
    
    
    translate([-s,w_tot/2,-1])
    rotate([ang,0,0])
    cube([xb+s2,w_trali,zb*deepf+s2]);
    
    
    translate([-s,w_tot*1.5,-1])
    rotate([-ang,0,0])
    cube([xb+s2,w_trali,zb*deepf+s2]);
        
    
    translate([-s,w_tot*2.5,-1])
    rotate([ang,0,0])
    cube([xb+s2,w_trali,zb*deepf+s2]);
    
    
    translate([-s,w_tot*3.5,-1])
    rotate([-ang,0,0])
    cube([xb+s2,w_trali,zb*deepf+s2]);    
};

translate([xb/2,yb/2,zb-s])
cylinder(10,4,3);

r_sphere = 17/2;
translate([xb/2,yb/2,zb-2*s+10+r_sphere/2])
sphere(r_sphere);

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