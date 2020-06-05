// 
// Perf Lattice Annulus
//
// An offset grid pattern from opposing directions

//
// Controls
//

annulus_inner_radius = 20;
annulus_outer_radius = 160;

// radius of hemispherical cutouts
perf_radius = 5;

// gap between neighboring cutouts
perf_gap = 2;

// height of cylindrical ridge above hemisphere cutout
perf_ridge = 0.5;

//
// Derived controls
//

annulus_inner_radius_sqr = pow(annulus_inner_radius, 2);
annulus_outer_radius_sqr = pow(annulus_outer_radius, 2);

lattice_thickness = perf_radius + 2 * perf_ridge;

// We want the centers of three mutually neighboring cutouts
// to form an equilateral triangle
spacing_length = 2 * perf_radius + perf_gap;
spacing_height = (sqrt(3) / 2) * spacing_length;
center_height = spacing_height / 3;

half_latice_size = ceil(annulus_outer_radius / (perf_radius + perf_gap)) + 1;

difference() {
    translate([0, 0, -perf_ridge]) {
        cylinder(r = annulus_outer_radius, h = lattice_thickness);
    }
    
    cylinder(r = annulus_inner_radius, h = 2 * lattice_thickness + 1, center = true);
    
    
    for(x_index = [-half_latice_size: half_latice_size]) 
    for(y_index = [-half_latice_size: half_latice_size]) {
        length_offset = (y_index % 2) * spacing_length/2;
            
        lower_center_x = x_index * spacing_length + length_offset;
        lower_center_y = y_index * spacing_height;
        lower_center = sqrt(pow(lower_center_x, 2) + pow(lower_center_y, 2));
        lower_outer_limit = lower_center + perf_radius + perf_gap;
        lower_inner_limit = lower_center - (perf_radius + perf_gap);
        
        upper_center_x = x_index * spacing_length + length_offset + spacing_length /2;
        upper_center_y = y_index * spacing_height + center_height;
        upper_center = sqrt(pow(upper_center_x, 2) + pow(upper_center_y, 2));
        upper_outer_limit = upper_center + perf_radius + perf_gap;
        upper_inner_limit = upper_center - (perf_radius + perf_gap);
        
        if (
            lower_inner_limit > annulus_inner_radius &&
            lower_outer_limit < annulus_outer_radius
        ) translate([
            lower_center_x,
            lower_center_y, 
            0
            ])
        {
            sphere(r = perf_radius);
            cylinder(r = perf_radius, h = perf_ridge, center = false);
        }
    
        if (
            upper_inner_limit > annulus_inner_radius &&
            upper_outer_limit < annulus_outer_radius
        ) translate([
            upper_center_x,
            upper_center_y,
            perf_radius])
        {
            sphere(r = perf_radius);
            cylinder(r = perf_radius, h = -perf_ridge, center = false);
        }
    }
}

