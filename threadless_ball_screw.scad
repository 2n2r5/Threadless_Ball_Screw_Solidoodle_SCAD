/* 

		This file had been created by Tim Chandler a.k.a. 2n2r5 and is 
		being shared under the creative commons - attribution license.
		Any and all icons, references to 2n2r5.com, 2n2r5.net, Tim 
		Chandler ,2n2r5 or Trademarks must remain in the the end product. 
		This script is free to use for any and all purposes, both 
		commercial and non-commercial provided that the above conditions 
		are met. 


		Please refer to http://creativecommons.org/licenses/by/3.0/ 
		for more information on this license.
*/

/*

Script by: Tim Chandler (2n2r5)

Filename: threadless_ball_screw.scad
Date of Creation: 7/26/13
True Revision Number: V1
Date of Revision: 7/26/13

Description:
This will create a customizable version of thing:112718, the "Threadless Ball Screw", for mounting on the solidoodle bed.


Todo:

 - make prettier bases that fit the platform better
 - fix bdfc to be more accurate and actually touch the smooth rod with out the aid of "snug"
 - clean up code
 - add hole pattern for wooden platform
 - add library of bearings with 5,4 and 3 mm centers
 - included a clipping check function for overlapping holes
 - clean up code before letting general public play with it

*/



/* [Mount and Platform Shape] */
BaseShape="round"; //options are "round" or "box" more and better options coming
//Mounting screw size
mss = 3 ;

//Mounting Hole Depth
mhd = 10 ;

/* For Square Base */
//Size of Base (OEM M3 screws will stick out around 14-15mm)
bh = 15;

//Y width of Base
byw = 35;

//X width of Base
bxw= 35;

/* For Round Base */
//Base width (radius)
bwr=20;

//Mounting holes from center

mhfc= [
		[	-12.5,7.5,-(bh-mhd)/2	],
	  	[	-12.5,-7.5,-(bh-mhd)/2	],
	  	[	12.5,7.5,-(bh-mhd)/2	],	
	  	[	12.5,-7.5,-(bh-mhd)/2	]
	  	];



/* [Bearing Spec] */

//Bearing Outer Diameter
bod = 14 ;

//Bearing Inner Diameter and Screw hole size
bid = 5 ;

//Bearing Width ;
bw = 5 ;

//Total Number of Bearings
nob = 3;

//Use this to rotate the bearings if they are not in a friendly place
rotAdj = 50;



/* [Steps Per MM] */

//Smooth Rod Diameter
srd = 6 ; //[3/8,9.525:5/16,7.9375:1/4,6.35:3:5:6:8:10:12]

//Bed Hole Size (if left the same size at smoot rod diameter, the fit tends to be too snug)
bhs = 9;

//Desired steps/mm
pitch = 2 ;


/* ------------------- Rookie Line (Do not cross unless you know what you are doing) --------------------- */


/* --- Caluculations --- */


//simplify base size
base = [bxw,byw,bh];

//simplify bearing
bsize = [bod/2,bid/2,bw];

//bearing mounting angle to get desired pitch
bma = atan(pitch / (srd * 3.141592 ));

//X distance from center of bearing
bdfc = cos(bma)*(bod/2);

$fn=30;

snug = (bod/2-bdfc)*2;

echo ("The bearing angle will be set to ", bma ,"degrees.");
echo ("Bearing is " , bdfc , "Horizontally from edge.");
echo (snug);




/* ------------- Start Shapes Below ---------------*/

/* 

In the interest of making this script easily adaptable,
 all main shapes will be separate modules and will be 
 called like you would use an include statement into other modules.

*/

// This builds the basic shape of the bearing
module Bearing (bigd,smalld,bbwidth) {
	difference(){
	cylinder(r=bigd,h=bbwidth);
	%cylinder(r=smalld,h=bbwidth);
	}
}

//base with mounting holes
module Base(){
	difference(){
		
		union(){
				if(BaseShape=="round"){
					cylinder(r=bwr,h=bh,center=true);
				} else if (BaseShape==box){

					cube(base,center=true);
				} else {

				}
			}
		
		union(){
			
			for(i=mhfc)	{


				translate(i) {
					cylinder(r=mss/2, h=mhd, center=true);
					/*

					This is code to add inset nutsto the baseplate connections. This will cause things to be unprintable

					union(){
						cylinder(r=5.5/2, h=2.5,$fn=6, center=true);                                                                                                                                           
						

						}
					
					*/
					}
					
				}
			//Hole for smooth rod
			%cylinder(r=(srd/2)*1.0,h=100,center=true);
			cylinder(r=bhs/2, h=bh,center=true );

			}
		}
	}	


/* Bearing mounts are all made positive and will be subtracted from base */
module bearingMounts(){
// --------------- ***** For anything that will be used in a rotational translate loop (I.E. bearing cut out, mounting screw, mounting nut)  ****** ----------- //
	for (j= [0:nob]) {

		rotate([bma,bma,j*360/nob+rotAdj]) translate([(srd/2)+bdfc-snug*20,0,bh/2]){ Bearing(bod/2*(1.05),bid/2,bw*(1.05));
		translate([0,0,-bh/2])cylinder(r=bid/2,h=bh,center=true);
		translate([0,0,-bh*(7/8)])cylinder(r=4.1,h=bh/2,$fn=6,center=true);
		}

	}
// -------------- **** End Rotational Translate Loop **** ------------- //
}



// Module output and formatting here
difference(){
Base();

bearingMounts();
}