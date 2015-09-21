function interpImg = ViewInterpolation();
l = InterpolateL;
r = InterpolateR;
row = 370;
col = 447;
for(i = 1:row)
    for(j = 1:col)
        if(l(i,j,:)~=0)
            interpImg(i,j,:) = l(i,j,:);
        else if(r(i,j,:)~=0)
            interpImg(i,j,:) = r(i,j,:);
            else
                interpImg(i,j,:) = 0;
            end
        end
    end
end    
figure();
imshow(uint8(interpImg));    
end

function interpImgR = InterpolateR();
% parameters
interp = 0.5;   % interpolation factor of 0.5 should give a virtual view exactly at the center of line connecting both the cameras. can vary from 0 (left view) to 1 (right view)

% read in images and disparity maps
i1 = imread('Data\view1.png');           % left view
i2 = imread('Data\view5.png');           % right view

%  i1 = double(i1);
%  i2 = double(i2);
d1 = double(imread('Data\disp1.png'));   % left disparity map, 0-255
d2 = double(imread('Data\disp5.png'));   % right disparity map, 0-255

shiftR = interp * d2;
% tag bad depth values with NaNs
% d1(d1==0) = NaN;
% d2(d2==0) = NaN;
[row,col] = size(d2);

for(i = 1:row)
    for(j = 1:col)
    interpImgR(i,j + ceil(shiftR(i,j)),:) = i2(i,j,:);
    end
end
figure();
imshow(uint8(interpImgR));
end

function interpImgL = InterpolateL();
interp = 0.5;   % interpolation factor of 0.5 should give a virtual view exactly at the center of line connecting both the cameras. can vary from 0 (left view) to 1 (right view)
% read in images and disparity maps
i1 = imread('Data\view1.png');           % left view
d1 = double(imread('Data\disp1.png'));   % left disparity map, 0-255
shiftL = interp * d1;
[row,col] = size(d1);
for(i = 1:row)
    for(j = 1:col)
        if(j - ceil(shiftL(i,j))>=1)
            interpImgL(i,j - ceil(shiftL(i,j)),:) = i1(i,j,:);
        end
    end
end
imshow(interpImgL);
end

















