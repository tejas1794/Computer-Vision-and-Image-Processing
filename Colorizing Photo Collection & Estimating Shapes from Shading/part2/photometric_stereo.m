function [albedo_image, surface_normals] = photometric_stereo(imarray, light_dirs)
% imarray: h x w x Nimages array of Nimages no. of images
% light_dirs: Nimages x 3 array of light source directions
% albedo_image: h x w image
% surface_normals: h x w x 3 array of unit surface normals

%% <<< fill in your code below >>>


for rowidx=1:192
    for colidx=1:168
         J = reshape(imarray(rowidx, colidx, :), 64, 1) ;
     end
 end

 g = light_dirs\J;
 surface_normals = g/norm(g);
 albedo_image = g;
 

