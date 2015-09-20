function idx = segmentImg(I, k)
% function idx = segmentImage(img)
% Returns the logical image containing the segment ids obtained from 
%   segmenting the input image
%
% INPUTS
% I - The input image contining textured foreground objects to be segmented
%     out.
% k - The number of segments to compute (also the k-means parameter).
%
% OUTPUTS
% idx - The logical image (same dimensions as the input image) contining 
%       the segment ids after segmentation. The maximum value of idx is k.
%          

    % 1. Create your bank of filters using the given alogrithm; 
    % 2. Compute the filter responses by convolving your input image with  
    %     each of the num_filters in the bank of filters F.
    %     responses(:,:,i)=conv2(I,F(:,:,i),'same')
    %     NOTE: we suggest to use 'same' instead of 'full' or 'valid'.
    % 3. Remember to take the absolute value of the filter responses (no
    %     negative values should be used).
    % 4. Construct a matrix X of the points to be clustered, where 
    %     the rows of X = the total number of pixels in I (rows*cols); and
    %     the columns of X = num_filters;
    %     i.e. each pixel is transformed into a num_filters-dimensional
    %     vector.
    % 5. Run kmeans to cluster the pixel features into k clusters,
    %     returning a vector IDX of labels.
    % 6. Reshape IDX into an image with same dimensionality as I and return
    %     the reshaped index image.
    %
    %I = imread('cheetah.jpg');
    I = double(rgb2gray(I)); 
    I=I(:,:,1);
    F=makeLMfilters;
    [~,~,num_filters] = size(F);
    for i = 1:48 %For all the num_filter values, convolve responses and then take absolute value of them.
        responses(:,:,i)=conv2(I,F(:,:,i),'same');
        responses = abs(responses);
    end
    
    rows = size(responses,1);   %Number of rows of the responses matrix
    cols = size(responses,2);   %Number of columsn of the responses matrix
    X = ones(rows*cols,num_filters); %Making a new matrix of ones with rows being total number of pixels and columns being filters
    X = reshape(responses, rows*cols, num_filters); %Reshape to make appropriate dimension
       
    %disp(X);
    IDX2 = kmeans(X,k); %Running kmeans on the X with k-means parameter
    idx = reshape(IDX2,rows,cols); %Reshaping to proper dimensions so that its ready for superposition.
    %imshow(mat2gray(idx)); %Checking whether the clustering is appropriate
    %disp(rows);
    %disp(cols);
    return;
    %disp(size(idx,1));
    %disp(size(IDX2,2));
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                                                                     %
        %                            END YOUR CODE                            %
        %                                                                     %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
