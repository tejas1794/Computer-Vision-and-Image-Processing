% CSE 473/573 Programming Assignment 1, starter Matlab code
% Adapted from A. Efros
% (http://graphics.cs.cmu.edu/courses/15-463/2010_fall/hw/proj1/)
% and R. Fergus
% http://cs.nyu.edu/~fergus/teaching/vision/assign1.pdf

function [coloredim] = part1(imname)
% name of the input file
% a loop to initiate go through all 6 images and perform the alignment on them accordingly.
    for i=1:6
        j='part1_';
        l='.jpg';
        imagename = strcat(j,num2str(i),l); % helper join method for string concatenation
        %%imname = 'part1_3.jpg'; %single file argument line
        imname = imagename; %comment out if using single file

        % read in the image
        fullim = imread(imname);

        % convert to double matrix 
        fullim = im2double(fullim);

        % compute the height of each part (just 1/3 of total)
        height = floor((size(fullim,1))/3);
        % separate color channels
        B = fullim(1:height,:);
        G = fullim(height+1:height*2,:);
        R = fullim(height*2+1:height*3,:);
        B2 = imcrop(B,[50,50,325,355]); %Cropping all 3 colors to make the alignment more correct.
        G2 = imcrop(G,[50,50,325,355]);
        R2 = imcrop(R,[50,50,325,355]);
        % Align the images
        % Functions that might be useful to you for aligning the images include: 
        % "circshift", "sum"

        aG = align(G2,B2); 
        aR = align(R2,B2);


        % open figure
        %imshow(imname);
        %% figure(1);

        % create a color image (3D array)
        colorim = cat(3, aR, aG, B2); %using the cropped B frame and aligned cropped frames for cat
        % ... use the "cat" command
        %figure,imshow(aR);
        %figure,imshow(B2);
        %figure,imshow(aG);
        % show the resulting image
        % ... use the "imshow" command
        figure,imshow(colorim); 
        % save result image
        imwrite(colorim,['result-' imname]);
    end
   
    
end
%% align img1 to img2
function [result] = align(img1, img2)
min = inf; %min acting as a n for the ssd to take all the pictures in the image
%for loops to go through all the points in x, y plane
for x = -10:10
    for y = -10:10
        img1shift = circshift(img1, [x y]);
        sumsqdef = sum(sum((img2-img1shift).^2));
        if sumsqdef < min
            min = sumsqdef;
            output = [x y];
        end
    end
end
    result = circshift(img1, output); %using circshift to place the image on the ssd image frame
end
