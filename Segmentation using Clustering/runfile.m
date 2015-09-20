%%%% Author: Tejas Vyas for CSE 473 Homework 2
%%I used MATLAB's own kmeans function to run the algorithm as the given
%%kmeans wasn't working correctly. Please judge accordingly.
image1 = imread('images/cheetah.jpg'); %Image Set 1: Cheetah on the Beach!
image2 = imread('images/bg.jpg');
image3 = imread('images/gecko.jpg'); %Image Set 2: Gecko on the leaf!
image4 = imread('images/bg2.jpg');
image5 = imread('images/zebra.jpg'); %Image Set 3: Zebra on the Grass!
image6 = imread('images/bg3.jpg');
%% Image Set 1: Cheetah + Beach
idx2 = segmentImg(image1,2); %Using k = 2
invLayImg1 = transferImg(2,idx2,image1,image2); %Using value of Rgs = 2 to get different cluster
figure();
imshow(invLayImg1); 
layeredImg1 = transferImg(1,idx2,image1,image2); %Using different value of Rgs = 1 to get different cluster
figure();
imshow(layeredImg1);
%% Image Set 2: Gecko + Leaf
idx1 = segmentImg(image3,2); %Using k = 2
invLayImg2 = transferImg(2,idx1,image3,image4);  %Using value of Rgs = 2 to get different cluster
figure();
imshow(invLayImg2);
layeredImg2 = transferImg(1,idx1,image3,image4);  %Using different value of Rgs = 1 to get different cluster
figure();
imshow(layeredImg2);
%% Image Set 3: Zebra + Grass
idx3 = segmentImg(image5,2); %Using k = 2
invLayImg3 = transferImg(2,idx3,image5,image6);  %Using value of Rgs = 2 to get different cluster
figure();
imshow(invLayImg3);
layeredImg3 = transferImg(1,idx3,image5,image6);  %Using different value of Rgs = 1 to get different cluster
figure();
imshow(layeredImg3);
