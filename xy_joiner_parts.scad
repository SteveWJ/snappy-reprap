include <config.scad>
use <GDMUtils.scad>
use <joiners.scad>
use <tslot.scad>


module xy_joiner()
{
	joiner_length=10;
	hardstop_offset=8;

	hoff = (platform_length*2-rail_width-20)/2;
	color("Sienna")
	render(convexity=10)
	union() {
		difference() {
			// Bottom
			translate([0, -joiner_length/2, -platform_thick/2]) {
				cube(size=[platform_width-joiner_width, joiner_length, platform_thick], center=true);
			}

			// Clear for joiners.
			translate([0,0,-platform_height/2]) {
				joiner_pair_clear(spacing=platform_width-joiner_width, h=platform_height, w=joiner_width, a=joiner_angle);
			}
		}

		// Snap-tab joiners.
		translate([0,0,-platform_height/2]) {
			intersection() {
				joiner_pair(spacing=platform_width-joiner_width, h=platform_height, w=joiner_width, l=joiner_length, a=joiner_angle);
				grid_of(xa=[-(platform_width-joiner_width)/2, (platform_width-joiner_width)/2]) {
					xrot(90) rrect(r=joiner_width/3, size=[joiner_width, platform_height, joiner_length*2], center=true);
				}
			}
		}

		// Top half-joiners.
		translate([0, hoff, 0]) {
			translate([0, 0, rail_height/2/2]) {
				translate([platform_length/4, 0, 0]) {
					intersection() {
						half_joiner(h=rail_height/2, w=joiner_width, l=hoff+joiner_length, a=joiner_angle);
						xrot(90) rrect(r=joiner_width/3, size=[joiner_width, rail_height/2, (hoff+joiner_length)*2], center=true);
					}
				}
				translate([-platform_length/4, 0, 0]) {
					intersection() {
						half_joiner2(h=rail_height/2, w=joiner_width, l=hoff+joiner_length, a=joiner_angle, slop=printer_slop);
						xrot(90) rrect(r=joiner_width/3, size=[joiner_width, rail_height/2, (hoff+joiner_length)*2], center=true);
					}
				}
			}
		}

		// Connect top half-joiners.
		translate([0, platform_thick/2-joiner_length, rail_height/2-platform_thick/2])
			xrot(90) cube(size=[platform_length/2, platform_thick, platform_thick], center=true);

		// Remove indents on attachment to main body
		grid_of(
			xa=[-platform_length/4, platform_length/4],
			ya=[-joiner_length/2]
		) {
			cube(size=[joiner_width, joiner_length, joiner_width], center=true);
		}

		// Rack and pinion hard stop.
		translate([0, -joiner_length+(joiner_length-hardstop_offset)/2, -platform_thick-rail_offset/2]) {
			cube(size=[motor_mount_spacing+joiner_width+5, joiner_length-hardstop_offset, rail_offset], center=true);
		}

		// endstop trigger
		translate([0, -joiner_length/2, 0]) {
			mirror_copy([1, 0, 0]) {
				translate([motor_mount_spacing/2+joiner_width/2+2, 0, 0]) {
					translate([10/2, 0, -(platform_thick+rail_offset+groove_height/2+2)/2]) {
						xrot(90) rrect(r=10/3, size=[10, platform_thick+rail_offset+groove_height/2+2, joiner_length], center=true);
					}
				}
			}
		}
	}
}
//!xy_joiner();



module xy_joiner_parts() { // make me
	zrot(90) xrot(90) xy_joiner();
}



xy_joiner_parts();



// vim: noexpandtab tabstop=4 shiftwidth=4 softtabstop=4 nowrap

