folder = 'C:\Users\Justin\Desktop\Medical Images Processing\categorized\001\PET\1353 (FDG WBS PET CT Axial)\'
dicomList = dir(fullfile(folder,'*.dcm'));
numberOfSlices = 20 %numel(dicomList)
imgSize = 824
slices = zeros(imgSize,imgSize,numberOfSlices);
for k = 1:numberOfSlices
    f = fullfile(folder,dicomList(k).name);
    dcm = dicomread(f)
    slices(:,:,k) = rescale(dcm(:,:,3)); %scales the entries of an array to the interval [0,1]
end

for k = 1:numberOfSlices
    imshow(slices(:,:,k),[])
end

% set the slice heights
z = 1:numberOfSlices; % algorithm works with non-equidistant slices distances

%% slice interpolation
R = 3; %ratio of new dz over old dz
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
    fileName = append(int2str(k),'.png')    
    imwrite(slices_interpolated(:,:,k), fullfile('interpolated\001\b\',fileName))
end