/*
    OpenUPS Case Copyright 2023 Edward A. Kisiel hominoid@cablemi.com

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
    Code released under GPLv3: http://www.gnu.org/licenses/gpl.html

    202304xx version 0.9 OpenUPS Case
        
    see https://github.com/hominoids/OpenUPS
    
    openups_top(length=145)
    openups(length=145, bat_layout, bat_type)
    hdd35_ups(length=145,width=101.6)
    hdd35_ups_top(length=145,width=101.6)
    openups_pcb(bat_layout, bat_type)
    battery_placement(bat_layout, bat_num, bat_space, bat_type, bat_dia, bat_len)
    battery_clip(bat_dia = 18.4)
    led(ledcolor = "red")
    battery(type)
    jst_xh(num_pin)
    jst_sh(num_pin)
    standoff(standoff[radius,height,holesize,supportsize,supportheight,sink,style,i_dia,i_depth])
    slab(size, radius)
    slot(hole,length,depth)

*/

use <./lib/fillets.scad>;

case = "drivebay";            // "drivebay", "standalone", "vertical"
pcb_enable = true;
//length = 145;
bat_layout = "2P_staggered";  // "straight", "staggered", "2P_staggered"
bat_type = "21700";           // "18650", "18650_convex", "21700"
/* standoffs
   [radius,height,holesize,supportsize,supportheight,sink,style,reverse,insert_e,i_dia,i_depth])
   sink 0=none, 1=countersink, 2=recessed hole, 3=nut holder, 4=blind hole
   style 0=hex shape, 1=cylinder
*/
if(case == "drivebay") {
//    translate([-94/2,-length/2,0]) {    
    length = 145;
    top_standoff = [7,25,3.5,10,4,1,0,1,0,4.5,5];
    bottom_standoff = [7,10,3.5,10,4,4,1,0,1,4.5,5];
    pcb_standoff = [7,10,3.5,10,4,1,1,0,0,0,0];
    support_standoff = [7,10,3.5,15,3,4,1,0,0,0,0];
    
    openups(length, bat_layout, bat_type, bottom_standoff, pcb_standoff, support_standoff);
    // pcb placement
    if(pcb_enable == true) {
        openups_pcb(bat_layout, bat_type);
    }
    translate([0,0,0]) openups_top(length, top_standoff);
//    color("dimgrey") translate([206,0,37]) rotate([0,180,0]) openups_top(length);
//    }
}
if(case == "standalone") {
//    translate([-94/2,-length/2,0]) {    
    length = 153;
    top_standoff = [7,25,3.5,10,4,1,0,1,0,4.5,5];
    bottom_standoff = [7,10,3.5,10,4,4,1,0,1,4.5,5];
    pcb_standoff = [7,10,3.5,10,4,1,1,0,0,0,0];
    support_standoff = [7,10,3.5,15,3,4,1,0,0,0,0];
    
    openups(length, bat_layout, bat_type, bottom_standoff, pcb_standoff, support_standoff);
    // pcb placement
    if(pcb_enable == true) {
        translate([0,(145-length)/2,0]) openups_pcb(bat_layout, bat_type);
    }
    translate([0,0,0]) openups_top(length, top_standoff);
}
if(case == "vertical") {
    translate([0,0,96]) rotate([0,90,0]){    
        length = 153;
        top_standoff = [7,25,3.5,10,4,1,0,1,0,4.5,5];
        bottom_standoff = [7,10,3.5,10,4,4,1,0,1,4.5,5];
        pcb_standoff = [7,10,3.5,10,4,1,1,0,0,0,0];
        support_standoff = [7,10,3.5,15,3,4,1,0,0,0,0];
        
        openups(length, bat_layout, bat_type, bottom_standoff, pcb_standoff, support_standoff);
        // pcb placement
        if(pcb_enable == true) {
            translate([0,(145-length)/2,0]) openups_pcb(bat_layout, bat_type);
        }
        translate([0,0,0]) openups_top(length, top_standoff);
    }
}

module openups_top(length=145, top_standoff) {

    pcbsize = [94,145,2];
    pcb_position = [-2,0,10];
    wallthick = 2;
    top_height = 25;
    bottom_height = 12;
    height = top_height + bottom_height;
    adj = .01;
    $fn = 180;

/* open ups case */
    difference() {
        color("dimgrey") translate([-6,145-length,37]) rotate([0,180,270]) hdd35_ups_top(length);
        if(bat_layout == "staggered") {
            color("dimgrey") translate([pcb_position[0]+10,pcb_position[1]+30,-1]) 
                cylinder(d=6.5, h=4);
            color("dimgrey") translate([pcb_position[0]+10,pcb_position[1]+pcbsize[1]-55,-1]) 
                cylinder(d=6.5, h=4);
            color("dimgrey") translate([pcb_position[0]+pcbsize[0]-4,pcb_position[1]+pcbsize[1]-30,-1]) 
                cylinder(d=6.5, h=4);
            color("dimgrey") translate([pcb_position[0]+pcbsize[0]-4,pcb_position[1]+54,-1]) 
                cylinder(d=6.5, h=4);
        }
        if(bat_layout == "2P_staggered") {
            color("dimgrey") translate([pcb_position[0]+4,pcb_position[1]+53+(145-length)/2,height-wallthick-adj]) 
                cylinder(d=6.5, h=4);
            color("dimgrey") translate([pcb_position[0]+4,pcb_position[1]+pcbsize[1]-53+(145-length)/2,height-wallthick-adj]) 
                cylinder(d=6.5, h=4);
            color("dimgrey") translate([pcb_position[0]+pcbsize[0]-4,pcb_position[1]+pcbsize[1]-25+(145-length)/2,height-wallthick-adj]) 
                cylinder(d=6.5, h=4);
            color("dimgrey") translate([pcb_position[0]+pcbsize[0]-4,pcb_position[1]+35+(145-length)/2,height-wallthick-adj]) 
                cylinder(d=6.5, h=4);
        }
        if(bat_layout == "straight") {
            color("dimgrey") translate([pcb_position[0]+10,pcb_position[1]+30,-1]) 
                cylinder(d=6.5, h=4);
            color("dimgrey") translate([pcb_position[0]+10,pcb_position[1]+pcbsize[1]-55,-1]) 
                cylinder(d=6.5, h=4);
            color("dimgrey") translate([pcb_position[0]+pcbsize[0]-4,pcb_position[1]+pcbsize[1]-30,-1]) 
                cylinder(d=6.5, h=4);
            color("dimgrey") translate([pcb_position[0]+pcbsize[0]-4,pcb_position[1]+54,-1]) 
                cylinder(d=6.5, h=4);
        }
        // end trim
        // rear fan slot
        color("dimgrey") translate([pcbsize[0]-10,3+(145-length),17-adj]) rotate([90,90,0]) slot(3,4,4);
//        color("dimgrey") translate([pcbsize[0]-16,-adj,12-adj]) cube([10,wallthick+(adj*2),7]);
        // rear terminal blocks
        color("dimgrey") translate([-adj,-adj+(145-length),12-adj]) cube([77,wallthick+(adj*2),4]);
        // front fan slot
        color("dimgrey") translate([pcbsize[0]-10,pcbsize[1]+adj,17-adj]) rotate([90,90,0]) slot(3,4,4);
//        color("dimgrey") translate([pcbsize[0]-16.25,pcbsize[1]-wallthick-adj,12-adj]) cube([10,wallthick+(adj*2),7]);
        // led opening
        color("dimgrey") translate([pcbsize[0]-69.75,pcbsize[1]-wallthick-adj,13-adj]) 
            rotate([270,0,0]) cylinder(d=3, h=4);
        color("dimgrey") translate([pcbsize[0]-65,pcbsize[1]-wallthick-adj,13-adj]) 
            rotate([270,0,0]) cylinder(d=3, h=4);
        color("dimgrey") translate([pcbsize[0]-60,pcbsize[1]-wallthick-adj,13-adj]) 
            rotate([270,0,0]) cylinder(d=3, h=4);
//        color("dimgrey") translate([pcbsize[0]-71.5,pcbsize[1]-wallthick-adj,12-adj]) cube([14,wallthick+(adj*2),3]);
    }
    if(bat_layout == "staggered") {
        color("dimgrey") translate([pcb_position[0]+10,pcb_position[1]+30,0]) 
            standoff(bottom_standoff);
        color("dimgrey") translate([pcb_position[0]+10,pcb_position[1]+pcbsize[1]-55,0]) 
            standoff(bottom_standoff);
        color("dimgrey") translate([pcb_position[0]+pcbsize[0]-4,pcb_position[1]+pcbsize[1]-30,0]) 
            standoff(bottom_standoff);
        color("tan") translate([pcb_position[0]+pcbsize[0]-4,pcb_position[1]+54,0]) 
            standoff(bottom_standoff);
    }
    if(bat_layout == "2P_staggered") {
        color("dimgrey") translate([pcb_position[0]+4,pcb_position[1]+53+(145-length)/2,height]) 
            standoff(top_standoff);
        color("dimgrey") translate([pcb_position[0]+4,pcb_position[1]+pcbsize[1]-53+(145-length)/2,height]) 
            standoff(top_standoff);
        color("dimgrey") translate([pcb_position[0]+pcbsize[0]-4,pcb_position[1]+pcbsize[1]-25+(145-length)/2,height]) 
            standoff(top_standoff);
        color("dimgrey") translate([pcb_position[0]+pcbsize[0]-4,pcb_position[1]+35+(145-length)/2,height]) 
            standoff(top_standoff);
    }
    if(bat_layout == "straight") {
        color("dimgrey") translate([pcb_position[0]+10,pcb_position[1]+30,0]) 
            standoff(bottom_standoff);
        color("dimgrey") translate([pcb_position[0]+10,pcb_position[1]+pcbsize[1]-55,0]) 
            standoff(bottom_standoff);
        color("dimgrey") translate([pcb_position[0]+pcbsize[0]-4,pcb_position[1]+pcbsize[1]-30,0]) 
            standoff(bottom_standoff);
        color("dimgrey") translate([pcb_position[0]+pcbsize[0]-4,pcb_position[1]+54,0]) 
            standoff(bottom_standoff);
    }    
}


module openups(length=145, bat_layout, bat_type, bottom_standoff, pcb_standoff, support_standoff) {

    pcbsize = [94,145,2];
    pcb_position = [-2,0,10];
    adj = .01;
    $fn = 180;

/* open ups case */
    difference() {
        color("dimgrey") translate([-6,pcbsize[1],0]) rotate([0,0,270]) hdd35_ups(length);
        color("dimgrey") translate([pcb_position[0],pcb_position[1]+(145-length)/2,10]) slab(pcbsize, 3);
        if(bat_layout == "staggered") {
            color("dimgrey") translate([pcb_position[0]+10,pcb_position[1]+30,-1]) 
                cylinder(d=6.5, h=4);
            color("dimgrey") translate([pcb_position[0]+10,pcb_position[1]+pcbsize[1]-55,-1]) 
                cylinder(d=6.5, h=4);
            color("dimgrey") translate([pcb_position[0]+pcbsize[0]-4,pcb_position[1]+pcbsize[1]-30,-1]) 
                cylinder(d=6.5, h=4);
            color("dimgrey") translate([pcb_position[0]+pcbsize[0]-4,pcb_position[1]+54,-1]) 
                cylinder(d=6.5, h=4);
        }
        if(bat_layout == "2P_staggered") {
            color("dimgrey") translate([pcb_position[0]+4,pcb_position[1]+53+(145-length)/2,-1]) 
                cylinder(d=6.5, h=4);
            color("dimgrey") translate([pcb_position[0]+10,pcb_position[1]+25+(145-length)/2,-1]) 
                cylinder(d=6.5, h=4);
            color("dimgrey") translate([pcb_position[0]+4,pcb_position[1]+pcbsize[1]-53+(145-length)/2,-1]) 
                cylinder(d=6.5, h=4);
            color("dimgrey") translate([pcb_position[0]+4,pcb_position[1]+pcbsize[1]-25+(145-length)/2,-1]) 
                cylinder(d=6.5, h=4);
            color("dimgrey") translate([pcb_position[0]+pcbsize[0]-4,pcb_position[1]+pcbsize[1]-25+(145-length)/2,-1]) 
                cylinder(d=6.5, h=4);
            color("dimgrey") translate([pcb_position[0]+pcbsize[0]-10,pcb_position[1]+pcbsize[1]/2+(145-length)/2,-1]) 
                cylinder(d=6.5, h=4);
            color("dimgrey") translate([pcb_position[0]+pcbsize[0]-4,pcb_position[1]+35+(145-length)/2,-1]) 
                cylinder(d=6.5, h=4);
        }
        if(bat_layout == "straight") {
            color("dimgrey") translate([pcb_position[0]+10,pcb_position[1]+30,-1]) 
                cylinder(d=6.5, h=4);
            color("dimgrey") translate([pcb_position[0]+10,pcb_position[1]+pcbsize[1]-55,-1]) 
                cylinder(d=6.5, h=4);
            color("dimgrey") translate([pcb_position[0]+pcbsize[0]-4,pcb_position[1]+pcbsize[1]-30,-1]) 
                cylinder(d=6.5, h=4);
            color("dimgrey") translate([pcb_position[0]+pcbsize[0]-4,pcb_position[1]+54,-1]) 
                cylinder(d=6.5, h=4);
        }
        // power plug
        color("dimgrey") translate([78.6,-1+(145-length), .75]) cube([10.5,14,9.5]);
//        color("dimgrey") translate([65,-1,3.75]) cube([11.5,10,10]);
        // terminal blocks
        if(case == "standalone" || case == "vertical") {
            color("dimgrey") translate([21.5,6+(145-length),-3]) cube([55.5,5,15]);
        }
        else {
            color("dimgrey") translate([21.5,-1+(145-length),-3]) cube([55.5,10,15]);
        }
        // sata1 & sata2
        color("dimgrey") translate([-1,-1+(145-length),3.75]) cube([78.5,10,10]);
//        color("dimgrey") translate([-1,-1+(145-length),3.75]) cube([23,10,10]);
        // front i2c
        color("dimgrey") translate([45.5,140,8.5]) rotate([270,0,0]) slot(3.5,9.5,6);
        color("grey") translate([45.5,143.5,8.5]) rotate([270,0,0]) slot(5.5,9.5,6);
//        color("dimgrey") translate([43.875,140,6.75]) cube([12.75,10,3.5]);
        // front usb-c
        color("dimgrey") translate([64,140,8]) rotate([270,0,0]) slot(4,6,6);
        color("grey") translate([63.75,143.5,8]) rotate([270,0,0]) slot(8,6,6);
    }
    if(bat_layout == "staggered") {
        color("dimgrey") translate([pcb_position[0]+10,pcb_position[1]+30,0]) 
            standoff(bottom_standoff);
        color("dimgrey") translate([pcb_position[0]+10,pcb_position[1]+pcbsize[1]-55,0]) 
            standoff(bottom_standoff);
        color("dimgrey") translate([pcb_position[0]+pcbsize[0]-4,pcb_position[1]+pcbsize[1]-30,0]) 
            standoff(bottom_standoff);
        color("tan") translate([pcb_position[0]+pcbsize[0]-4,pcb_position[1]+54,0]) 
            standoff(bottom_standoff);
    }
    if(bat_layout == "2P_staggered") {
        color("dimgrey") translate([pcb_position[0]+4,pcb_position[1]+53+(145-length)/2,0]) 
            standoff(bottom_standoff);
        color("dimgrey") translate([pcb_position[0]+10,pcb_position[1]+25+(145-length)/2,0]) 
            standoff(pcb_standoff);
        color("dimgrey") translate([pcb_position[0]+4,pcb_position[1]+pcbsize[1]-53+(145-length)/2,0]) 
            standoff(bottom_standoff);
        color("dimgrey") translate([pcb_position[0]+4,pcb_position[1]+pcbsize[1]-25+(145-length)/2,0]) 
            standoff(pcb_standoff);
        color("dimgrey") translate([pcb_position[0]+pcbsize[0]-4,pcb_position[1]+pcbsize[1]-25+(145-length)/2,0]) 
            standoff(bottom_standoff);
        color("dimgrey") translate([pcb_position[0]+pcbsize[0]-10,pcb_position[1]+pcbsize[1]/2+(145-length)/2,0]) 
            standoff(pcb_standoff);
        color("dimgrey") translate([pcb_position[0]+pcbsize[0]-4,pcb_position[1]+35+(145-length)/2,0]) 
            standoff(bottom_standoff);
    }
    if(bat_layout == "straight") {
        color("dimgrey") translate([pcb_position[0]+10,pcb_position[1]+30,0]) 
            standoff(bottom_standoff);
        color("dimgrey") translate([pcb_position[0]+10,pcb_position[1]+pcbsize[1]-55,0]) 
            standoff(bottom_standoff);
        color("dimgrey") translate([pcb_position[0]+pcbsize[0]-4,pcb_position[1]+pcbsize[1]-30,0]) 
            standoff(bottom_standoff);
        color("dimgrey") translate([pcb_position[0]+pcbsize[0]-4,pcb_position[1]+54,0]) 
            standoff(bottom_standoff);
    }
    // pcb supports
    color("dimgrey") translate([pcb_position[0]+94/2,pcb_position[1]+32.5,0]) 
        standoff(support_standoff);
    color("dimgrey") translate([pcb_position[0]+94/2,pcb_position[1]+72.5,0]) 
        standoff(support_standoff);  
    color("dimgrey") translate([pcb_position[0]+94/2,pcb_position[1]+112.5,0]) 
        standoff(support_standoff);
    
}


/* 3.5" hd bay ups holder */
module hdd35_ups(length=145,width=101.6) {
    
    wallthick = 3;
    floorthick = 2;
    hd35_x = length;                    // 145mm for 3.5" drive
    hd35_y = width;
    hd35_z = 12;
    adjust = .1;    
    $fn=90;
    
    difference() {
        union() {
            difference() {
                translate([(hd35_x/2),(hd35_y/2),(hd35_z/2)])         
                    cube_fillet_inside([hd35_x,hd35_y,hd35_z], 
                        vertical=[3,3,3,3], top=[0,0,0,0], bottom=[0,0,0,0], $fn=90);      
                translate([(hd35_x/2),(hd35_y/2),(hd35_z/2)+floorthick])           
                    cube_fillet_inside([hd35_x-(wallthick*2),hd35_y-(wallthick*2),hd35_z], 
                        vertical=[0,0,0,0], top=[0,0,0,0], bottom=[0,0,0,0], $fn=90);
                   
                // end trim
                if(case == "drivebay") {
                    translate([-adjust,4,wallthick+7]) cube([wallthick+(adjust*2),hd35_y-7,10]);
                    translate([hd35_x-wallthick-adjust,4,wallthick+7]) cube([wallthick+(adjust*2),hd35_y-7,10]);
                }
                // bottom vents
                for ( r=[15:40:hd35_x-40]) {
                    for (c=[hd35_y-76:4:75]) {
                        translate ([r,c,-adjust]) cube([35,2,wallthick+(adjust*2)]);
                    }
                }       
            }

        // side nut holder support    
        translate([16,wallthick-adjust,7]) rotate([-90,0,0]) cylinder(d=10,h=3);
        translate([76,wallthick-adjust,7]) rotate([-90,0,0])  cylinder(d=10,h=3);
            if(length >= 120) {
                translate([117.5,wallthick-adjust,7]) rotate([-90,0,0])  cylinder(d=10,h=3);
                translate([117.5,hd35_y-wallthick+adjust,7]) rotate([90,0,0])  cylinder(d=10,h=3);
            }
        translate([76,hd35_y-wallthick+adjust,7]) rotate([90,0,0])  cylinder(d=10,h=3);
        translate([16,hd35_y-wallthick+adjust,7]) rotate([90,0,0])  cylinder(d=10,h=3);
        
        // bottom-side support
        translate([wallthick,wallthick,floorthick-2]) rotate([45,0,0]) cube([hd35_x-(wallthick*2),3,3]);
        translate([wallthick,hd35_y-wallthick+adjust,floorthick-2]) rotate([45,0,0]) cube([hd35_x-(wallthick*2),3,3]);
         
        }
        // side screw holes
        translate([16,-adjust,7]) rotate([-90,0,0]) cylinder(d=3.6,h=7);
        translate([76,-adjust,7]) rotate([-90,0,0])  cylinder(d=3.6,h=7);
        translate([117.5,-adjust,7]) rotate([-90,0,0])  cylinder(d=3.6,h=7);
        translate([117.5,hd35_y+adjust,7]) rotate([90,0,0])  cylinder(d=3.6,h=7);
        translate([76,hd35_y+adjust,7]) rotate([90,0,0])  cylinder(d=3.6,h=7);
        translate([16,hd35_y+adjust,7]) rotate([90,0,0])  cylinder(d=3.6,h=7);
        
        // side nut trap    
        translate([16,wallthick-adjust,7]) rotate([-90,0,0]) cylinder(r=3.30,h=5,$fn=6);
        translate([76,wallthick-adjust,7]) rotate([-90,0,0])  cylinder(r=3.30,h=5,$fn=6);
        translate([117.5,wallthick-adjust,7]) rotate([-90,0,0])  cylinder(r=3.30,h=5,$fn=6);
        translate([117.5,hd35_y-wallthick-adjust,7]) rotate([90,0,0])  cylinder(r=3.30,h=5,$fn=6);
        translate([76,hd35_y-wallthick-adjust,7]) rotate([90,0,0])  cylinder(r=3.30,h=5,$fn=6);
        translate([16,hd35_y-wallthick-adjust,7]) rotate([90,0,0])  cylinder(r=3.30,h=5,$fn=6);
    }
}


/* 3.5" hd bay ups holder top*/
module hdd35_ups_top(length=145,width=101.6) {
    
    wallthick = 2;
    floorthick = 2;
    height = 25;
    hd35_x = length;                    // 145mm for 3.5" drive
    hd35_y = width;
    hd35_z = 12;
    adjust = .1;    
    $fn=90;
    
    difference() {
        union() {
            difference() {
                translate([(hd35_x/2),(hd35_y/2),(height/2)])         
                    cube_fillet_inside([hd35_x,hd35_y,height], 
                        vertical=[3,3,3,3], top=[0,0,0,0], bottom=[0,0,0,0], $fn=90);      
                translate([(hd35_x/2),(hd35_y/2),(height/2)+floorthick])           
                    cube_fillet_inside([hd35_x-(wallthick*2),hd35_y-(wallthick*2),height], 
                        vertical=[2,2,2,2], top=[0,0,0,0], bottom=[2,2,2,2], $fn=90);
                // bottom vents
                for ( r=[15:40:hd35_x-40]) {
                    for (c=[hd35_y-76:4:75]) {
                        translate ([r,c,-adjust]) cube([35,2,wallthick+(adjust*2)]);
                    }
                }       
            }
        }
    }
}


/* open ups pcb */
module openups_pcb(bat_layout, bat_type) {
    
    pcbsize = [94,145,2];
    pcb_position = [-2,0,10];
    bat_num = 6;
    bat_dia = 21;
    bat_len = 70;
    bat_space = 3;
    adj = .01;
    $fn = 90;

    difference() {
        color("tan") translate(pcb_position) slab(pcbsize, 3);
        if(bat_layout == "staggered") {
            color("tan") translate([pcb_position[0]+10,pcb_position[1]+30,pcb_position[2]-1]) cylinder(d=3.5, h=4);
            color("tan") translate([pcb_position[0]+10,pcb_position[1]+pcbsize[1]-55,pcb_position[2]-1]) cylinder(d=3.5, h=4);
            color("tan") translate([pcb_position[0]+pcbsize[0]-4,pcb_position[1]+pcbsize[1]-30,pcb_position[2]-1]) 
                cylinder(d=3.5, h=4);
            color("tan") translate([pcb_position[0]+pcbsize[0]-4,pcb_position[1]+54,pcb_position[2]-1]) cylinder(d=3.5, h=4);
        }
        if(bat_layout == "2P_staggered") {
            color("tan") translate([pcb_position[0]+4,pcb_position[1]+53,pcb_position[2]-1]) cylinder(d=3.5, h=4);
            color("tan") translate([pcb_position[0]+10,pcb_position[1]+25,pcb_position[2]-1]) cylinder(d=3.5, h=4);
            color("tan") translate([pcb_position[0]+4,pcb_position[1]+pcbsize[1]-53,pcb_position[2]-1]) cylinder(d=3.5, h=4);
            color("tan") translate([pcb_position[0]+4,pcb_position[1]+pcbsize[1]-25,pcb_position[2]-1]) cylinder(d=3.5, h=4);
            color("tan") translate([pcb_position[0]+pcbsize[0]-4,pcb_position[1]+pcbsize[1]-25,pcb_position[2]-1]) 
                cylinder(d=3.5, h=4);
            color("tan") translate([pcb_position[0]+pcbsize[0]-10,pcb_position[1]+pcbsize[1]/2,pcb_position[2]-1]) 
                cylinder(d=3.5, h=4);
            color("tan") translate([pcb_position[0]+pcbsize[0]-4,pcb_position[1]+35,pcb_position[2]-1]) cylinder(d=3.5, h=4);
        }
        if(bat_layout == "straight") {
            color("tan") translate([pcb_position[0]+10,pcb_position[1]+30,pcb_position[2]-1]) cylinder(d=3.5, h=4);
            color("tan") translate([pcb_position[0]+10,pcb_position[1]+pcbsize[1]-55,pcb_position[2]-1]) cylinder(d=3.5, h=4);
            color("tan") translate([pcb_position[0]+pcbsize[0]-4,pcb_position[1]+pcbsize[1]-30,pcb_position[2]-1]) 
                cylinder(d=3.5, h=4);
            color("tan") translate([pcb_position[0]+pcbsize[0]-4,pcb_position[1]+54,pcb_position[2]-1]) cylinder(d=3.5, h=4);
        }
    }
    /// power jack
    color("grey") translate([pcb_position[0]+pcbsize[0]-3,pcb_position[1]+13,pcb_position[2]+pcbsize[2]+1])
        rotate([90,180,0]) import("lib/PJ-063AH.stl");
    color("black") translate([pcb_position[0]+81,pcb_position[1]+1,pcb_position[2]+pcbsize[2]]) 
        linear_extrude(height = .5) text("+V IN", size=2.5);
    color("black") translate([pcb_position[0]+78,pcb_position[1]+8,pcb_position[2]+pcbsize[2]]) 
        linear_extrude(height = .5) text("+12V - +24V", size=2);

    // fan 1
    translate([pcb_position[0]+pcbsize[0]-5,pcb_position[1]+22,pcb_position[2]+pcbsize[2]+3]) 
        rotate([180,0,0]) import("lib/2304-5211-TG.stl");
    color("black") translate([pcb_position[0]+pcbsize[0]-12,pcb_position[1]+15,pcb_position[2]+pcbsize[2]]) 
        rotate([0,0,0]) linear_extrude(height = .5) text("FAN 1", size=2);
//    translate([pcb_position[0]+78,pcb_position[1]+7,pcb_position[2]+pcbsize[2]-2]) rotate([90,180,0]) jst_xh(4);
//    color("black") translate([pcb_position[0]+68.5,pcb_position[1]+.5,pcb_position[2]+pcbsize[2]]) 
//        rotate([0,0,0]) linear_extrude(height = .5) text("FAN 1", size=2);

    // front fan2
    translate([pcb_position[0]+pcbsize[0]-13,pcb_position[1]+pcbsize[1]-15,pcb_position[2]+pcbsize[2]+3]) 
        rotate([180,0,180]) import("lib/2304-5211-TG.stl");
    color("black") translate([pcb_position[0]+pcbsize[0]-6,pcb_position[1]+pcbsize[1]-1,pcb_position[2]+pcbsize[2]]) 
        rotate([0,0,180]) linear_extrude(height = .5) text("FAN 2", size=2);
  
    // +vout green terminal block
    color("lightgreen") translate([pcb_position[0]+73,pcb_position[1]+4,pcb_position[2]+pcbsize[2]-5]) 
        rotate([0,180,180]) import("lib/691213710002.stl");
    color("black") translate([pcb_position[0]+68,pcb_position[1]+5.5,pcb_position[2]+pcbsize[2]]) 
        rotate([0,0,0]) linear_extrude(height = .5) text("+V OUT", size=2);
    color("black") translate([pcb_position[0]+69.5,pcb_position[1]+.5,pcb_position[2]+pcbsize[2]]) 
        rotate([0,0,0]) linear_extrude(height = .5) text("+", size=3);
    color("black") translate([pcb_position[0]+74.5,pcb_position[1]+.5,pcb_position[2]+pcbsize[2]]) 
        rotate([0,0,0]) linear_extrude(height = .5) text("-", size=4);
        
    // +vout green terminal block
    color("lightgreen") translate([pcb_position[0]+62,pcb_position[1]+4,pcb_position[2]+pcbsize[2]-5]) 
        rotate([0,180,180]) import("lib/691213710002.stl");
    color("black") translate([pcb_position[0]+57,pcb_position[1]+5.5,pcb_position[2]+pcbsize[2]]) 
        rotate([0,0,0]) linear_extrude(height = .5) text("+V OUT", size=2);
    color("black") translate([pcb_position[0]+58.5,pcb_position[1]+.5,pcb_position[2]+pcbsize[2]]) 
        rotate([0,0,0]) linear_extrude(height = .5) text("+", size=3);
    color("black") translate([pcb_position[0]+63.5,pcb_position[1]+.5,pcb_position[2]+pcbsize[2]]) 
        rotate([0,0,0]) linear_extrude(height = .5) text("-", size=4);
        
    // +12v green terminal block        
    color("lightgreen") translate([pcb_position[0]+51,pcb_position[1]+4,pcb_position[2]+pcbsize[2]-5]) 
        rotate([0,180,180]) import("lib/691213710002.stl");
    color("black") translate([pcb_position[0]+47,pcb_position[1]+5.5,pcb_position[2]+pcbsize[2]]) 
        rotate([0,0,0]) linear_extrude(height = .5) text("+12V", size=2);
    color("black") translate([pcb_position[0]+47.5,pcb_position[1]+.5,pcb_position[2]+pcbsize[2]]) 
        rotate([0,0,0]) linear_extrude(height = .5) text("+", size=3);
    color("black") translate([pcb_position[0]+52.5,pcb_position[1]+.5,pcb_position[2]+pcbsize[2]]) 
        rotate([0,0,0]) linear_extrude(height = .5) text("-", size=4);
        
    // +12v green terminal block    
    color("lightgreen") translate([pcb_position[0]+40,pcb_position[1]+4,pcb_position[2]+pcbsize[2]-5]) 
        rotate([0,180,180]) import("lib/691213710002.stl");
    color("black") translate([pcb_position[0]+36,pcb_position[1]+5.5,pcb_position[2]+pcbsize[2]]) 
        rotate([0,0,0]) linear_extrude(height = .5) text("+12V", size=2);
    color("black") translate([pcb_position[0]+37,pcb_position[1]+.5,pcb_position[2]+pcbsize[2]]) 
        rotate([0,0,0]) linear_extrude(height = .5) text("+", size=3);
    color("black") translate([pcb_position[0]+41.5,pcb_position[1]+.5,pcb_position[2]+pcbsize[2]]) 
        rotate([0,0,0]) linear_extrude(height = .5) text("-", size=4);
        
    // +5v green terminal block    
    color("lightgreen") translate([pcb_position[0]+29,pcb_position[1]+4,pcb_position[2]+pcbsize[2]-5]) 
        rotate([0,180,180]) import("lib/691213710002.stl");
    color("black") translate([pcb_position[0]+26,pcb_position[1]+5.5,pcb_position[2]+pcbsize[2]]) 
        rotate([0,0,0]) linear_extrude(height = .5) text("+5V", size=2);
    color("black") translate([pcb_position[0]+26,pcb_position[1]+.5,pcb_position[2]+pcbsize[2]]) 
        rotate([0,0,0]) linear_extrude(height = .5) text("+", size=3);
    color("black") translate([pcb_position[0]+31,pcb_position[1]+.5,pcb_position[2]+pcbsize[2]]) 
        rotate([0,0,0]) linear_extrude(height = .5) text("-", size=4);
        
    // sata 2
    translate([pcb_position[0]+23.25,pcb_position[1]+7,pcb_position[2]+pcbsize[2]-2]) rotate([90,180,0]) jst_xh(4);
    color("black") translate([pcb_position[0]+13.5,pcb_position[1]+1,pcb_position[2]+pcbsize[2]]) 
        rotate([0,0,0]) linear_extrude(height = .5) text("SATA 2", size=2);
    // sata 1
    translate([pcb_position[0]+12,pcb_position[1]+7,pcb_position[2]+pcbsize[2]-2]) rotate([90,180,0]) jst_xh(4);
    color("black") translate([pcb_position[0]+2.5,pcb_position[1]+1,pcb_position[2]+pcbsize[2]]) 
        rotate([0,0,0]) linear_extrude(height = .5) text("SATA 1", size=2);

    // front leds
    translate([pcb_position[0]+25,pcb_position[1]+pcbsize[1]-3,pcb_position[2]+pcbsize[2]]) led();
    color("black") translate([pcb_position[0]+28.5,pcb_position[1]+pcbsize[1]-4,pcb_position[2]+pcbsize[2]]) 
        rotate([0,0,180]) linear_extrude(height = .5) text("PWR", size=1.25);
    translate([pcb_position[0]+30,pcb_position[1]+pcbsize[1]-3,pcb_position[2]+pcbsize[2]]) led("yellow");
    color("black") translate([pcb_position[0]+33.5,pcb_position[1]+pcbsize[1]-4,pcb_position[2]+pcbsize[2]]) 
        rotate([0,0,180]) linear_extrude(height = .5) text("CHR", size=1.25);
    translate([pcb_position[0]+35,pcb_position[1]+pcbsize[1]-3,pcb_position[2]+pcbsize[2]]) led("green");
    color("black") translate([pcb_position[0]+38.5,pcb_position[1]+pcbsize[1]-4,pcb_position[2]+pcbsize[2]]) 
        rotate([0,0,180]) linear_extrude(height = .5) text("FULL", size=1.25);
    
    //front i2c
    translate([pcb_position[0]+46.5,pcb_position[1]+pcbsize[1]-4.25,pcb_position[2]+pcbsize[2]-2]) 
        rotate([90,180,180]) jst_sh(4);
    color("black") translate([pcb_position[0]+51,pcb_position[1]+pcbsize[1]-1,pcb_position[2]+pcbsize[2]]) 
        rotate([0,0,180]) linear_extrude(height = .5) text("I2C", size=2);

    translate([pcb_position[0]+53,pcb_position[1]+pcbsize[1]-4.25,pcb_position[2]+pcbsize[2]-2]) 
        rotate([90,180,180]) jst_sh(4);
    color("black") translate([pcb_position[0]+58,pcb_position[1]+pcbsize[1]-1,pcb_position[2]+pcbsize[2]]) 
        rotate([0,0,180]) linear_extrude(height = .5) text("I2C", size=2);

    // front usb-c
    translate([pcb_position[0]+69,pcb_position[1]+pcbsize[1]-9.5,pcb_position[2]+pcbsize[2]-4]) 
        rotate([0,180,0]) import("lib/usb-c.stl");
    color("black") translate([pcb_position[0]+73,pcb_position[1]+pcbsize[1]-1,pcb_position[2]+pcbsize[2]]) 
        rotate([0,0,180]) linear_extrude(height = .5) text("USB C", size=2);

    // batteries
    translate([pcb_position[0]+4,pcb_position[1]+2,pcb_position[2]+pcbsize[2]]) 
        battery_placement(bat_layout, bat_num, bat_space, bat_type, bat_dia, bat_len);
}


module battery_placement(bat_layout, bat_num, bat_space, bat_type, bat_dia, bat_len) {

    if(bat_layout == "straight") {
        translate([bat_len,bat_dia/2,.38+(bat_dia/2)]) {
            for( b = [0:1:bat_num-1]) {
                translate([0,b*bat_dia+b*bat_space,1]) rotate([-90,0,90]) battery(bat_type);
                color("dimgrey") translate([-2,b*bat_dia+b*bat_space,1]) rotate([0,0,90]) battery_clip(bat_dia);
                color("dimgrey") translate([-bat_len+2,b*bat_dia+b*bat_space,1]) rotate([0,0,270]) battery_clip(bat_dia);

            }
        }
    }
    if(bat_layout == "staggered") {
        translate([bat_len,bat_dia/2,.38+(bat_dia/2)]) {
            for( b = [0:1:bat_num-1]) {
                if(b == 0 || b == 2 || b == 4) {
                    translate([0,b*bat_dia+b*bat_space,1]) rotate([-90,0,90]) battery(bat_type);
                    color("dimgrey") translate([-2,b*bat_dia+b*bat_space,1]) rotate([0,0,90]) battery_clip(bat_dia);
                    color("dimgrey") translate([-bat_len+2,b*bat_dia+b*bat_space,1]) 
                        rotate([0,0,270]) battery_clip(bat_dia);
                }
                if(b == 1 || b == 3 || b == 5) {
                    translate([16,b*bat_dia+b*bat_space,1]) rotate([-90,0,90]) battery(bat_type);
                    color("dimgrey") translate([14,b*bat_dia+b*bat_space,1]) rotate([0,0,90]) battery_clip(bat_dia);
                    color("dimgrey") translate([-bat_len+18,b*bat_dia+b*bat_space,1]) 
                        rotate([0,0,270]) battery_clip(bat_dia);
                }

            }
        }
    }
    if(bat_layout == "2P_staggered") {
        translate([bat_len,bat_dia/2,.38+(bat_dia/2)]) {
            for( b = [0:1:bat_num-1]) {
                if(b == 0 || b == 1 || b == 4 || b == 5) {
                    translate([0,b*bat_dia+b*bat_space,1]) rotate([-90,0,90]) battery(bat_type);
                    color("dimgrey") translate([-2,b*bat_dia+b*bat_space,1]) rotate([0,0,90]) battery_clip(bat_dia);
                    color("dimgrey") translate([-bat_len+2,b*bat_dia+b*bat_space,1]) 
                        rotate([0,0,270]) battery_clip(bat_dia);
                }
                if(b == 2 || b == 3) {
                    translate([16-bat_len,b*bat_dia+b*bat_space,1]) rotate([-90,0,270]) battery(bat_type);
                    color("dimgrey") translate([14,b*bat_dia+b*bat_space,1]) rotate([0,0,90]) battery_clip(bat_dia);
                    color("dimgrey") translate([-bat_len+18,b*bat_dia+b*bat_space,1]) 
                        rotate([0,0,270]) battery_clip(bat_dia);
                }

            }
        }
    }
}


module battery_clip(bat_dia = 18.4) {
    
    mat = .38;
    width = 9.5;
    tab = 8.9;
    bat_holder = bat_dia+2*mat;
    adj = .1;

    difference() {
        translate([0,width,0]) rotate([90,0,0]) cylinder(d=bat_holder, h=9.5);
        translate([0,width+adj,0]) rotate([90,0,0]) cylinder(d=bat_dia, h=10.5);
        translate([mat/2-11.1/2,-adj,mat-1.3-bat_dia/2]) cube([11.1-mat,width+2*adj,3]);
        translate([0,width+adj,0]) rotate([90,-45,0]) cube([bat_dia,bat_dia,bat_holder]);
    }
    difference() {
        translate([-11.1/2,0,-1.3-bat_dia/2]) cube([11.1,width,3]);
        translate([mat-11.1/2,-adj,mat/2-1.3-bat_dia/2]) cube([11.1-2*mat,width+2*adj,3]);
    }
    difference() {
        translate([-(tab/2),-3.5,-1-bat_dia/2]) rotate([-5,0,0]) cube([tab,3.5,10]);
        translate([-(tab/2)-adj,-3.5+mat,mat-1-bat_dia/2]) rotate([-5,0,0]) cube([tab+2*adj,3.5+mat,10]);
    }    
    translate([0,-2.225,0]) rotate([85,0,0]) cylinder(d=tab, h=mat);
    difference() {
        translate([0,-2.75,0]) sphere(d=3);
        translate([-5,-2.75,-5]) rotate([85,0,0]) cube([tab,10,10]);
    }
}


module led(ledcolor = "red") {
    
    color(ledcolor) translate([0,0,0]) cube([3,1.5,.4]);
    color("silver") translate([0,0,0]) cube([.5,1.5,.5]);
    color("silver") translate([2.5,0,0]) cube([.5,1.5,.5]);
}


module battery(type) {

    adj = .01;
    if(type == "18650") {
        difference() {
            cylinder(d=18.4, h=65);
            translate([0,0,65-4]) difference() {
                cylinder(d=18.5, h=2);
                cylinder(d=17.5, h=3);
            }
        }
    }
    if(type == "18650_convex") {
        difference() {
            cylinder(d=18.4, h=68);
            translate([0,0,65-4]) difference() {
                cylinder(d=18.5, h=2);
                cylinder(d=17.5, h=3);
            }
            translate([0,0,65-adj]) difference() {
                cylinder(d=18.5, h=3+2*adj);
                cylinder(d=14.4, h=3+2*adj);
            }
        }
    }
    if(type == "21700") {
        difference() {
            cylinder(d=21, h=70);
            translate([0,0,70-4]) difference() {
                cylinder(d=21.1, h=2);
                cylinder(d=20.1, h=3);
            }
        }
    }
}


// JST-PH connector class
module jst_xh(num_pin) {
    
    size_x = 2.4+(num_pin*2);
    size_y = 5.75;

    union() {
        difference() {
            color("white") cube([size_x, size_y, 7]);
            color("white") translate([.5, .5, .5]) cube([size_x-1, size_y-1, 7]);
            color("white") translate([1, -.1,6]) cube([0.25*num_pin, size_y-2, 7]);
            color("white") translate([size_x-2, -.1,6]) cube([0.25*num_pin, size_y-2, 7]);
            color("white") translate([-.1,1,6]) cube([size_y-2,0.25*num_pin,7]);
            color("white") translate([size_x-2,1,6]) cube([size_y-2,0.25*num_pin,7]);
        }
        translate([1.25, 0, 0]) union() {
            for(ind=[0:num_pin-1]) {
                color("silver") translate([ind*2.5, 2.4, .5]) cube([.5, .5, 4]);
            }
        }
    }
}


// JST-SH connector class
module jst_sh(num_pin) {
    
    size_x = 1+(num_pin);
    size_y = 2.9;

    union() {
        difference() {
            color("white") cube([size_x, size_y, 4.25]);
            color("white") translate([.25, .25, .25]) cube([size_x-.5, size_y-.5, 4.25]);
        }
        difference() {
            color("white") translate([-.4, 0, 2.75]) cube([.5, 1, 1.5]);
            color("white") translate([-1, .5, 2.25]) cube([1, 1, 1.5]);            
        }
        difference() {
            color("white") translate([size_x-.1, 0, 2.75]) cube([.5, 1, 1.5]);
            color("white") translate([size_x, .5, 2.25]) cube([1, 1, 1.5]);            
        }
        translate([1, 0, 0]) union() {
            for(ind=[0:num_pin-1]) {
                color("silver") translate([(ind*1)-.125, 1, .5]) cube([.25, .25, 3.5]);
            }
        }
    }
}


/* standoff module
    standoff(standoff[radius,height,holesize,supportsize,supportheight,sink,style,reverse,insert_e,i_dia,i_depth])
        sink=0 none
        sink=1 countersink
        sink=2 recessed hole
        sink=3 nut holder
        sink=4 blind hole
        
        style=0 hex shape
        style=1 cylinder
*/
module standoff(stand_off){

    radius = stand_off[0];
    height = stand_off[1];
    holesize = stand_off[2];
    supportsize = stand_off[3];
    supportheight = stand_off[4];
    sink = stand_off[5];
    style = stand_off[6];
    reverse = stand_off[7];
    insert_e = stand_off[8];
    i_dia = stand_off[9];
    i_depth = stand_off[10];
    
    adjust = 0.1;
    
    difference (){ 
        union () { 
            if(style == 0 && reverse == 0) {
                rotate([0,0,30]) cylinder(d=radius*2/sqrt(3),h=height,$fn=6);
            }
            if(style == 0 && reverse == 1) {
                translate([0,0,-height]) rotate([0,0,30]) cylinder(d=radius*2/sqrt(3),h=height,$fn=6);
            }
            if(style == 1 && reverse == 0) {
                cylinder(d=radius,h=height,$fn=90);
            }
            if(style == 1 && reverse == 1) {
                translate([0,0,-height]) cylinder(d=radius,h=height,$fn=90);
            }
            if(reverse == 1) {
                translate([0,0,-supportheight]) cylinder(d=(supportsize),h=supportheight,$fn=60);
            }
            else {
                cylinder(d=(supportsize),h=supportheight,$fn=60);
            }
        }
        // hole
        if(sink <= 3  && reverse == 0) {
                translate([0,0,-adjust]) cylinder(d=holesize, h=height+(adjust*2),$fn=90);
        }
        if(sink <= 3  && reverse == 1) {
                translate([0,0,-adjust-height]) cylinder(d=holesize, h=height+(adjust*2),$fn=90);
        }
        // countersink hole
        if(sink == 1 && reverse == 0) {
            translate([0,0,-adjust]) cylinder(d1=6.5, d2=(holesize), h=3);
        }
        if(sink == 1 && reverse == 1) {
            translate([0,0,+adjust-2.5]) cylinder(d1=(holesize), d2=6.5, h=3);
        }
        // recessed hole
        if(sink == 2 && reverse == 0) {
            translate([0,0,-adjust]) cylinder(d=6.5, h=3);
        }
        if(sink == 2 && reverse == 1) {
            translate([0,0,+adjust-3]) cylinder(d=6.5, h=3);
        }
        // nut holder
        if(sink == 3 && reverse == 0) {
            translate([0,0,-adjust]) cylinder(r=3.3,h=3,$fn=6);     
        }
        if(sink == 3 && reverse == 1) {
            translate([0,0,+adjust-3]) cylinder(r=3.3,h=3,$fn=6);     
        }
        // blind hole
        if(sink == 4 && reverse == 0) {
            translate([0,0,2]) cylinder(d=holesize, h=height,$fn=90);
        }
        if(sink == 4 && reverse == 1) {
            translate([0,0,-height-2-adjust]) cylinder(d=holesize, h=height,$fn=90);
        }
        if(insert_e > 0 && reverse == 0) {
            translate([0,0,height-i_depth]) cylinder(d=i_dia, h=i_depth+adjust,$fn=90);
        }
        if(insert_e > 0 && reverse == 1) {
            translate([0,0,-height-adjust]) cylinder(d=i_dia, h=i_depth+adjust,$fn=90);
        }
    }
}


/* slab module */
module slab(size, radius) {
    
    x = size[0];
    y = size[1];
    z = size[2];   
    linear_extrude(height=z)
    hull() {
        translate([0+radius ,0+radius, 0]) circle(r=radius);	
        translate([0+radius, y-radius, 0]) circle(r=radius);	
        translate([x-radius, y-radius, 0]) circle(r=radius);	
        translate([x-radius, 0+radius, 0]) circle(r=radius);
    }  
}


/* slot module */
module slot(hole,length,depth) {
    
    hull() {
        translate([0,0,0]) cylinder(d=hole,h=depth);
        translate([length,0,0]) cylinder(d=hole,h=depth);        
        }
    } 