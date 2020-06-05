// 
// Perf Lattice Triangle
//
// An offset grid pattern from opposing directions

//
// Controls
//

annulus_inner_radius = 10;
annulus_outer_radius = 200;
triangle_side = 300;

// radius of hemispherical cutouts
perf_radius = 5;

// gap between neighboring cutouts
perf_gap = 1;

// height of cylindrical ridge above hemisphere cutout
perf_ridge = 0.5;

//
// Derived controls
//

lattice_thickness = perf_radius + 2 * perf_ridge;

// We want the centers of three mutually neighboring cutouts
// to form an equilateral triangle
spacing_length = 2 * perf_radius + perf_gap;
spacing_height = (sqrt(3) / 2) * spacing_length;
center_height = spacing_height / 3;

triangle_height = (sqrt(3) / 2) * triangle_side;
triangle_center_height = triangle_height / 3;
triangle_area = pow(triangle_height,2) / sqrt(3);

half_latice_size = ceil(triangle_side / (perf_radius + perf_gap)) + 1;

cell_width = perf_gap + perf_radius;

difference() {
    translate([0, 0, -perf_ridge]) {
        points = [
            [-2 * triangle_center_height, 0],
            [triangle_center_height, - triangle_side /  2],
            [triangle_center_height, triangle_side / 2]
        ];
    
        linear_extrude(height = lattice_thickness) {
            polygon(points);
        };
    }
    
    cylinder(r = annulus_inner_radius, h = 2 * lattice_thickness + 1, center = true);
    
    
    for(x_index = [-half_latice_size: half_latice_size]) 
    for(y_index = [-half_latice_size: half_latice_size]) {
        length_offset = (y_index % 2) * spacing_length/2;
            
        lower_center_x = x_index * spacing_length + length_offset;
        lower_center_y = y_index * spacing_height;
        lower_center = sqrt(pow(lower_center_x, 2) + pow(lower_center_y, 2));
        lower_inner_limit = lower_center - (perf_radius + perf_gap);
        
        upper_center_x = x_index * spacing_length + length_offset + spacing_length /2;
        upper_center_y = y_index * spacing_height + center_height;
        upper_center = sqrt(pow(upper_center_x, 2) + pow(upper_center_y, 2));
        upper_inner_limit = upper_center - (perf_radius + perf_gap);
        
        if (
            lower_inner_limit > annulus_inner_radius &&
            lower_center_x < (triangle_center_height - cell_width) &&
            atan((abs(lower_center_y) + cell_width) / (lower_center_x + triangle_center_height * 2 - cell_width)) < 30
        ) translate([
            lower_center_x,
            lower_center_y, 
            0
            ])
        {
            sphere(r = perf_radius);
            cylinder(r = perf_radius, h = -perf_ridge, center = false);
        }
    
        if (
            upper_inner_limit > annulus_inner_radius &&
            upper_center_x < (triangle_center_height - (perf_radius + perf_gap)) &&
            atan((abs(upper_center_y) + cell_width) / (upper_center_x + triangle_center_height * 2 - cell_width)) < 30 &&
            upper_center_x > - 2 * triangle_center_height + cell_width
        ) translate([
            upper_center_x,
            upper_center_y,
            perf_radius])
        {
            sphere(r = perf_radius);
            cylinder(r = perf_radius, h = perf_ridge, center = false);
        }
    }
}

