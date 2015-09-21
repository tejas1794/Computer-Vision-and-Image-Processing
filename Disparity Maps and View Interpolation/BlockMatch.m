% BlockMatch.m by Tejas Vyas for CSE 473 Proj3
function disp = BlockMatch()
dispMapLR;
dispMapRL;
%consChk;
%mseErr;
end
function DisparityMapLeft = dispMapLR()
%Reading Images
left = imread('view1.png');
right = imread('view5.png');
% Converting the images from RGB to grayscale by taking mean
leftImg = mean(left, 3);
rightImg = mean(right, 3);
%Creating a zeros array for output image
DisparityMapRight = zeros(size(leftImg));
%Tried multiple ones, this one seemed most optimal
disparityRange = 49;

tempblockSize = 3;
blockSize = 2 * tempblockSize + 1;
% Get the image dimensions.
[row, col] = size(leftImg);
% Parsing through rows 
for (m = 1 : row)
    % Set min/max row bounds for the template and blocks.
    minr = max(1, m - tempblockSize);
    maxr = min(row, m + tempblockSize);
	% Parsing through columns
    for (n = 1 : col)
        % Set the min/max column bounds
		minCol = max(1, n - tempblockSize);
        maxCol = min(col, n + tempblockSize);
		% 'minDim' is maximum searchable pixels in left.
		% 'maxDim' is maximum searchable pixels in right.
		minDim = 0;
        maxDim = min(disparityRange, col - maxCol);

		% Select the block from the right image to use as the template.
        template = rightImg(minr:maxr, minCol:maxCol);
		totalBlocks = maxDim - minDim + 1;
		% vector to hold the block differences.
		blockDiff = zeros(totalBlocks, 1);
		
		%Difference between the template and each of the blocks.
		for (i = minDim : maxDim)
			% Select the block from the left image at the distance 'i'.
			block = leftImg(minr:maxr, (minCol + i):(maxCol + i));
			% Compute the 1-based index of this block into the 'blockDiffs' vector.
			blockIndex = i - minDim + 1;
			% Taking the SSD between the template and the block and store the resulting value.
			blockDiff(blockIndex, 1) = sum(sum(abs(template - block)));
		end
		
		% Sorting the SSD 
		[placeholder, sortedIndeces] = sort(blockDiff);
		bestImg = sortedIndeces(1, 1);
		
		% Convert the 1-based index of this block back into an offset.
		d = bestImg + minDim - 1;
			
		% Calculate a sub-pixel estimate of the disparity by interpolating.
		if ((bestImg == 1) || (bestImg == totalBlocks))
			DisparityMapRight(m, n) = d;
		else
			% Grab the SSD values at the closest matching blocks and
			% neighbors
			match1 = blockDiff(bestImg - 1);
			match2 = blockDiff(bestImg);
			match3 = blockDiff(bestImg + 1);
			DisparityMapRight(m, n) = d - (0.5 * (match3 - match1) / (match1 - (2*match2) + match3));
		end
    end
end
figure();
imshow((DisparityMapRight), []);
figure();
axis image;
colormap('jet');
colorbar;
caxis([0 disparityRange]);
end
function DisparityMapRight = dispMapRL()
% Reading the images.
left = imread('view1.png');
right = imread('view5.png');
% Converting the images from RGB to grayscale by taking mean
leftImg = mean(left, 3);
rightImg = mean(right, 3);
%Creating a zeros array for output image
DisparityMapRight = zeros(size(leftImg));
%Tried multiple ones, this one seemed most optimal
disparityRange = 49;

tempblockSize = 3;
blockSize = 2 * tempblockSize + 1;
% Get the image dimensions.
[row, col] = size(leftImg);
% Parsing through rows 
for (m = 1 : row)
    % Set min/max row bounds for the template and blocks.
    minr = max(1, m - tempblockSize);
    maxr = min(row, m + tempblockSize);
	% Parsing through columns
    for (n = 1 : col)
        % Set the min/max column bounds
		minCol = max(1, n - tempblockSize);
        maxCol = min(col, n + tempblockSize);
		% 'minDim' is maximum searchable pixels in left.
		% 'maxDim' is maximum searchable pixels in right.
		minDim = max(-disparityRange, 1 - minCol);
        maxDim = min(disparityRange, col - maxCol);

		% Select the block from the right image to use as the template.
        template = rightImg(minr:maxr, minCol:maxCol);
		totalBlocks = maxDim - minDim + 1;
		% vector to hold the block differences.
		blockDiff = zeros(totalBlocks, 1);
		
		%Difference between the template and each of the blocks.
		for (i = minDim : maxDim)
			% Select the block from the left image at the distance 'i'.
			block = leftImg(minr:maxr, (minCol + i):(maxCol + i));
			% Compute the 1-based index of this block into the 'blockDiffs' vector.
			blockIndex = i - minDim + 1;
			% Taking the SSD between the template and the block and store the resulting value.
			blockDiff(blockIndex, 1) = sum(sum(abs(template - block)));
		end
		
		% Sorting the SSD 
		[placeholder, sortedIndeces] = sort(blockDiff);
		bestImg = sortedIndeces(1, 1);
		
		% Convert the 1-based index of this block back into an offset.
		d = bestImg + minDim - 1;
			
		% Calculate a sub-pixel estimate of the disparity by interpolating.
		if ((bestImg == 1) || (bestImg == totalBlocks))
			DisparityMapRight(m, n) = d;
		else
			% Grab the SSD values at the closest matching blocks and
			% neighbors
			match1 = blockDiff(bestImg - 1);
			match2 = blockDiff(bestImg);
			match3 = blockDiff(bestImg + 1);
			DisparityMapRight(m, n) = d - (0.5 * (match3 - match1) / (match1 - (2*match2) + match3));
		end
    end
end
figure();
imshow((DisparityMapRight), []);
figure();
axis image;
colormap('jet');
colorbar;
caxis([0 disparityRange]);
end
function mseError = mseErr()
groundDisp = imread('disp1.png');
compDisp=double(dispMapLR);
groundDisp=double(groundDisp);
[row,col] = size(compDisp);
% Find the size (columns and rows) of the image and assign the rows to
% variable nrGroundTruthDisparityMap, and columns to variable ncGroundTruthDisparityMap
[rowg,colg] = size(groundDisp);
% Check to see if both the left and right images have same number of rows
% and columns
arcmn = 1/(row*col);
for (i=1:row)
    for(j=1:col)
        mseRes = sum(sum((compDisp-groundDisp).^2));
    end
end
mseError=mseRes* arcmn;
mseError
end
function consCheck = consChk()
% Perform SAD Correlation based matching (Right to Left)
dispMapR2L=dispMapRL;
thresh = 2;
% Perform SAD Correlation based matching (Left to Right)
dispMapL2R=dispMapLR;
% Prepare matrix for subtraction and scale it for comparison
dispMapL2R=-dispMapL2R;
% Find the size (columns and rows) of the L2R Disparity map and assign the rows to
% variable nrLRCCheck, and columns to variable ncLRCCheck
[nrLRCCheck,ncLRCCheck] = size(dispMapL2R);
% Create an image of size nrLRCCheck and ncLRCCheck, fill it with zeros and assign
% it to variable dispMapLRC
dispMapLRC=ones(nrLRCCheck,ncLRCCheck);
for(i=1:1:nrLRCCheck)
    for(j=1:1:ncLRCCheck)
        xl=j;
        xr=round(xl+dispMapL2R(i,xl));
        if (xr>ncLRCCheck||xr<1)
            dispMapLRC(i,j) = 0; %% occluded pixel
         else            
             xlp=xr+(dispMapR2L(i,xr));
             if (abs(xl-xlp)<thresh)
                 dispMapLRC(i,j) = -dispMapL2R(i,j);  %% non-occluded pixel            
             else
                 dispMapLRC(i,j) = 0; %% occluded pixel                        
             end
        end
    end
end
imshow(dispMapLRC);
end
