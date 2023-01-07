//Script to create a barrel

//Position on barrel origin
translate([0,0,height/2]) barrel();

//These parameters all changeable - bilge radius should be greater than head radius but no more than double
height=30;//height of barrel
headRadius=10;//radius of head of barrel
bilgeRadius=13;//radius of bilge (widest part of barrel)
staves=14;//number of staves (planks) in barrel
hoopDepth=0.2;//distance hoops protrude outside barrel
addChimeToBase=false;//indented base will probably need support

//These parameters affect the position and sizes of the barrel hoops and chime(s)
//initially defaulted to percentages of barrel height or radius

otherhoopWidth=height*(6/100);//width of quarter and french hoops 
headhoopWidth=height*(10/100);//width of head hoop
quarterhoopDistance=height*(18/100);//distance of quarter hoop from top of barrel
frenchhoopDistance=height*(30/100);//distance of french hoops from top of barrel
chimeHeight=height*(3/100);//Height of chime i.e top lip
chimeWidth=headRadius*(8/100);//Width of chime i.e. top lip

//2D barrel for extrusion
module barrel2D(h,hr,br) {
	
	//determine radius of circle needed for right barrel arc
	ah=br-hr;
	r=(ah/2) + ((h*h)/(8*ah));
	
	difference() {
		intersection() {
			translate ([br/2,0,0]) square([br,h],center=true);
			translate([br-r,0,0]) circle(r,$fn=100);
		}	
		
		//perhaps refine this so that chimes follow curve of barrel rather than being perpendicular
		translate ([0,h/2-chimeHeight,0]) square([hr-chimeWidth,chimeHeight]);
		
		if (addChimeToBase==true) {
			translate ([0,-h/2,0]) square([hr-chimeWidth,chimeHeight]);
		}
	}
}


module barrel() {
  
	//body of barrel
	rotate_extrude($fn=staves) {
		barrel2D(height,headRadius,bilgeRadius);
 	}

	 //barrel hoops
	s=bilgeRadius+hoopDepth;
	
	intersection() {
	  	rotate_extrude($fn=64) {
			barrel2D(height,headRadius+hoopDepth,bilgeRadius+hoopDepth);
		}
		
		union() {
			
			//head hoops
			translate([0,0,height/2-headhoopWidth]) cylinder(r=s,h=headhoopWidth);
			translate([0,0,-height/2]) cylinder(r=s,h=headhoopWidth);

			//quarter hoops
			translate([0,0,height/2-otherhoopWidth-quarterhoopDistance]) cylinder(r=s,h=otherhoopWidth);
			translate([0,0,-height/2+quarterhoopDistance]) cylinder(r=s,h=otherhoopWidth);

			//french hoops
			translate([0,0,height/2-otherhoopWidth-frenchhoopDistance]) cylinder(r=s,h=otherhoopWidth);
			translate([0,0,-height/2+frenchhoopDistance]) cylinder(r=s,h=otherhoopWidth);

		}
	}
}

