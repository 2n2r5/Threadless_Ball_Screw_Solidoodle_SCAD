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
True Revision Number: V1.6
Date of Revision: 7/28/13

Description:
This will create a customizable version of thing:112718, the "Threadless Ball Screw", for mounting on the solidoodle bed.


Todo:

 - make prettier bases that fit the platform better

*/



/* [Mount and Platform Shape] */

// Circle or Rectangle base (more options coming)
Base_Shape= "round"; // ["round":Round,"box":Box] 

//Which bed type?
Solidoodle_Bed_Type = "aluminum" ; //[aluminum, wood, other]

//Mounting screw size (M3 is standard)
Mount_Screw_Size = 3 ;// [3:M3,4:M4,5:M5]

//Bed mounting screw hole depth
Bed_Mounting_Hole_Depth = 10 ;

//Height of Base (OEM M3 screws will stick out around 14-15mm)
Base_Height = 17;

//Bed Hole Size (This should be greater than the smooth rod diameter but enough that it doesn't inhibit the rod from turning)
Bed_Hole_Size = 9;


// -------------- "Box" Base Shape Options ---------- 

//Y width of Base
Box_Y_Width = 35;

//X width of Base
Box_X_Width = 35;

// -------------- "Round" Base Shape Option ---------

//Round Base width 
Round_Base_Width = 40;






/* [Bearing & Smooth Rod Options] */

//Bearing Outer Diameter
Bearing_Outer_Diameter = 16 ;// [6:22]

//Bearing Inner Diameter and Screw hole size
Bearing_Inner_Diameter = 5 ; //[3,4,5,6]

//Bearing Width ;
Bearing_Width = 5 ; //[2,2.5,3,4,5,6]

//Total Number of Bearings (use 4 bearings works best with wood bed)
Number_of_Bearings = 3; //[2,3,4,5]

//Nut Size for screws that hold bearings (measured between widest points of nut)
Bearing_Nut_Size = 8.9; //[8.9:M5, 7.7:M4,6.1:M3]

//Smooth Rod Diameter
Smooth_Rod_Diameter = 8 ; //[9.525:3/8,7.9375:5/16,6.35:1/4,3:3MM,5:5MM,6:6MM,8:8MM,10:10MM,12:12MM]

//Use this to rotate the bearings if they are not in a friendly place
Bearing_Rotation_Adjustment = 50;

//How many MM per rotation? This is like thread pitch on threaded rod.
Bearing_Pitch = 5 ; 


/* ------------------- Rookie Line (Do not cross unless you know what you are doing) --------------------- */

/* [hidden] */

/* Variable Clean-up (makes pretty variables usable) */

BaseShape = Base_Shape	;
mss = Mount_Screw_Size	;
sdbt = Solidoodle_Bed_Type;
mhd = Bed_Mounting_Hole_Depth;
bh = Base_Height		;
bhs = Bed_Hole_Size		;
byw = Box_Y_Width		;
bxw = Box_X_Width		;
bwr = Round_Base_Width	;
bod = Bearing_Outer_Diameter;
bid = Bearing_Inner_Diameter;
bw = Bearing_Width		;
nob = Number_of_Bearings;
bnd = Bearing_Nut_Size	;
srd = Smooth_Rod_Diameter;
rotAdj = Bearing_Rotation_Adjustment;
pitch = Bearing_Pitch	;


//Mounting holes (Download the script to change this to something other than a solidoodle)
mhfc = [[ -12.5,7.5,-(bh-mhd)/2 ],[ -12.5,-7.5,-(bh-mhd)/2 ],[ 12.5,7.5,-(bh-mhd)/2],[12.5,-7.5,-(bh-mhd)/2 ]] ; 						

// [[ -12.5,7.5,-(bh-mhd)/2 ],[ -12.5,-7.5,-(bh-mhd)/2 ],[ 12.5,7.5,-(bh-mhd)/2 ],[12.5,-7.5,-(bh-mhd)/2 ]]   <--Use this for Aluminum Bed
mhfcw = [[ -8,8,-(bh-mhd)/2 ],[ -8,-8,-(bh-mhd)/2 ],[ 8,8,-(bh-mhd)/2 ],[8,-8,-(bh-mhd)/2 ]]; // <-- Use this for Wood Bed 


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
//echo ("Bearing is " , bdfc , "Horizontally from edge.");
echo (snug);





				/* ------------- End Variables and Start Shapes Below ---------------*/

/*

			In the interest of making this script easily adaptable,
			all main shapes will be separate modules will be peiced 
			together at the bottom of this script.

*/



// This builds the basic shape of the bearing For refrence and cutouts
module Bearing (bigd,smalld,bbwidth) {
	difference(){
		cylinder(r=bigd,h=bbwidth);
		%cylinder(r=smalld,h=bbwidth);
	}
}

//Main body of the nut.This acts as the Adapter between the bearing mounts and the bed mounts
module Base(){
	difference(){

		union(){
			if(BaseShape=="round"){
				cylinder(r=bwr/2,h=bh,center=true);
			} else if (BaseShape=="box"){
				cube(base,center=true);
			} else if (BaseShape=="yourShapeHere"){
				//More shapes can be added here
			}
		}

		union(){

			//Start mounting screw cutouts here
			if (sdbt=="aluminum") {
				for(i=mhfc) {
					translate(i) {
						cylinder(r=mss/2, h=mhd, center=true);
					}		
				}
			} else if (sdbt=="wood") {
				for(g=mhfcw) {
					translate(g) {
						cylinder(r=mss/2, h=mhd, center=true);
					}		
				}
			}

			//Hole for smooth rod
			%cylinder(r=(srd/2)*1.0,h=100,center=true); //This shows the smooth rod that the bearings will be spaced for.
			cylinder(r=bhs/2, h=bh,center=true );  //This is the actual hole cut.

		}
	}
}


/* Bearing mounts are all made positive and will be subtracted from base */
module bearingMounts(){
	
// --------------- ***** For anything that will be used in a rotational translate loop (I.E. bearing cut out, mounting screw, mounting nut) ****** ----------- //
	for (j= [0:nob]) {
		rotate([bma,0,j*360/nob+rotAdj]) translate([(srd/2)+bdfc-snug,0,bh/2-1]){ 
			
			#Bearing(bod/2*(1.05),bid/2,bw*(1.05)); //Main Bearings as defined in bearing module plus 5% to keep slack around the bearing
			translate([0,0,-bh/2])cylinder(r=bid/2,h=bh,center=true); //Shaft for bolt/screw to hold the bearing
			translate([0,0,-bh*(7/8)])cylinder(r=bnd/2,h=bh/2,$fn=6,center=true); //Retainer for nut bearing bolt
		}

	}
}



// Part assembly starts here
difference(){
Base();
bearingMounts();
}
