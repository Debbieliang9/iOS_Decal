/*
 * Project 1-1: Computing a Displacement Map
 *
 * Feel free to define additional helper functions.
 */

#include "calc_depth.h"
#include "utils.h"
#include <math.h>
#include <limits.h>
#include <stdio.h>

/* Implements the normalized displacement function */
unsigned char normalized_displacement(int dx, int dy,
        int maximum_displacement) {
    double squared_displacement = dx * dx + dy * dy;
    double normalized_displacement = round(255 * sqrt(squared_displacement)
            / sqrt(2 * maximum_displacement * maximum_displacement));
    return (unsigned char) normalized_displacement;
}

/* Helper function to return the square euclidean distance between two values. */
unsigned int square_euclidean_distance(unsigned char a, unsigned char b) {
   /*
    * This is an optional helper function which you may find useful. It
    * currently has an incomplete example CUnit test to help with debugging.
    * This test is not graded and is merely for your convenience. See the spec
    * for details on how to use CUnit.
    // */
    // how do you calculate the distance between two characters?？
    return (a-b) * (a-b);
}
unsigned int absolute_value(int x) {
    if (x < 0) {
        return -x;
    }
    return x;
}

void calc_depth(unsigned char *depth_map, unsigned char *left,
        unsigned char *right, int image_width, int image_height,
        int feature_width, int feature_height, int maximum_displacement) {
    /* YOUR CODE HERE */
    int total_pixels = image_width * image_height;

    // fill in the depth_map with zeros.
    for (int total = 0; total < total_pixels; total++) {
        depth_map[total] = 0;
    }

    // this loops through the area where the green pixel can go on the left:
    for (int hy = feature_height; hy < image_height - feature_height; hy ++) {
            for (int wx = feature_width; wx < image_width - feature_width; wx++) {
                int curr = hy * image_width + wx;
                // now we enter the search area:
                int s_a_y_u = hy - maximum_displacement;
                int s_a_y_b = hy + maximum_displacement;
                int s_a_x_l = wx - maximum_displacement;
                int s_a_x_r = wx + maximum_displacement;
                while (s_a_y_u < 0) {
                    s_a_y_u ++;
                }
                while (s_a_y_b > image_height) {
                    s_a_y_u --;
                }
                while (s_a_x_l < 0) {
                    s_a_y_u ++;
                }
                while (s_a_x_r > image_width) {
                    s_a_y_u --;
                }
                unsigned int smallest_normalized_displacement = 225; // this will be the smallest eclidean distance.
                int square_euclidean_distance_total = 32767;
                // int chosen_x = 0;
                // int chosen_y = 0;
                unsigned int diffx = 0;
                unsigned int diffy = 0;
                // for each green pixel on the left, there should be one search area for it to have many features on the left.
                // r_f_y and r_f_x here will define the area where the center pixel can be on the right image.
                // inside this for loop, we want to figure out a pixel that has the smallest corresponding euclidean distance. 
                for (int r_f_y = s_a_y_u + feature_height; r_f_y < s_a_y_b - feature_height; r_f_y ++) {
                    for (int r_f_x = s_a_x_l + feature_width; r_f_x < s_a_x_r - feature_width; r_f_x++) {
                        // now let's get one feature on the right.
                        int square_euclidean_distance_total_one_feature_on_left = 0;
                        for (int r_f_y_f = r_f_y - feature_height; r_f_y_f < r_f_y + feature_height + 1; r_f_y_f ++) {
                            for (int r_f_x_f = r_f_x - feature_width; r_f_x_f < r_f_x + feature_width + 1; r_f_x_f ++) {
                                int currr = r_f_y_f * feature_width + r_f_x_f;
                                int square_euclidean_distance_pixel = square_euclidean_distance(left[currr], right[currr]);
                                square_euclidean_distance_total_one_feature_on_left += square_euclidean_distance_pixel;
                            }
                        }
                        if (square_euclidean_distance_total_one_feature_on_left < square_euclidean_distance_total) {
                            square_euclidean_distance_total = square_euclidean_distance_total_one_feature_on_left;
                            // chosen_y = r_f_y;
                            // chosen_x = r_f_x;
                            diffy = absolute_value(r_f_y - hy);
                            diffx = absolute_value(r_f_x - wx);
                            smallest_normalized_displacement = normalized_displacement(diffx , diffy, maximum_displacement);
                        } if (square_euclidean_distance_total_one_feature_on_left == square_euclidean_distance_total) {
                            int maybe_diffy = absolute_value(r_f_y - hy);
                            int maybe_diffx = absolute_value(r_f_x - wx);
                            unsigned int smallest_normalized_displacement_candidate = normalized_displacement(maybe_diffx, maybe_diffy, maximum_displacement);
                            if (smallest_normalized_displacement_candidate < smallest_normalized_displacement) {
                                // chosen_y = r_f_y;
                                // chosen_x = r_f_x;
                                diffy = maybe_diffy;
                                diffx = maybe_diffx;
                                smallest_normalized_displacement = smallest_normalized_displacement_candidate;
                            }
                        }
                    }
                }
                // now we have got the smallest_normalized_displacement for this pixel (selected by the first for loop)
                depth_map[curr] = smallest_normalized_displacement;

            }
        }


}


/*
ssh cs61c-adh@hive21.cs.berkeley.edu
Nc+u7GAw
Debbieliang9
92873-Taesu-87
https://github.com/61c-student/fa18-proj1-Debbieliang9
./depth_map
./depth_map -l test/images/quilt2-left.bmp -r test/images/quilt2-right.bmp -h 0 -w 0 -t 1 -o test/output/quilt2-output.bmp -v
// */










