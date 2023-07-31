folder = 'C:\Users\Justin\Desktop\Medical Images Processing\corresponded\20230209\014\label\'
dicomList = dir(fullfile(folder,'*.png'));
numberOfSlices = numel(dicomList)
imgSize = 288
slices = zeros(imgSize,imgSize,numberOfSlices);
for k = 1:numberOfSlices
    f = fullfile(folder,dicomList(k).name);
    img = imread(f)
%     slices(:,:,k) = rescale(img(:,:,3));
    slices(:,:,k) = rescale(img); %scales the entries of an array to the interval [0,1]
end

for k = 1:numberOfSlices
    imshow(slices(:,:,k),[])
end

% set the slice heights
z = 1:numberOfSlices; % algorithm works with non-equidistant slices distances

%% slice interpolation
R = 2; %ratio of new dz over old dz
lambda = 10000; % the higher the regularization factor lambda it will search for more global motions but ignores local structures
tau = 100;  % step size of the implicit gradient descent
TOL = 0.04;
maxIter = 1000;
borderSize = 0.1;

[slices_interpolated,z_interpolated,vx,vy] = sliceInterp_spline_intensitySpline(slices,z,R,lambda,tau,TOL,maxIter,borderSize);

s = size(slices_interpolated)
s = s(3)

for k = 1:s
    imshow(slices_interpolated(:,:,k),[])
    fileName = append(pad(int2str(k),3,'left','0'),'.png')    
    imwrite(slices_interpolated(:,:,k), fullfile('interpolated\mri\014\',fileName))
end