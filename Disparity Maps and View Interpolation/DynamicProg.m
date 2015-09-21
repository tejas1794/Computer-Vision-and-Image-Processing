function DisparityMapRight = DynamicProg();
%Write a script that processes stereo image pair to generate disparity map
%using dynamic programming
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
end




































%imshow(Disparity,[]), axis image, colormap('jet'), colorbar;
%caxis([0 disparityRange]);
%imwrite('DisparityDyn.png', Disparity);