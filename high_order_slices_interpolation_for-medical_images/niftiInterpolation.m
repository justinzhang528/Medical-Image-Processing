V = niftiread('1_001_seg.nii.gz');
numberOfSlices = 48;

whos V

slices = zeros(240,240,numberOfSlices);
for k = 1:numberOfSlices
    slices(:,:,k) = rescale(V(:,:,k));
end

for k = 1:numberOfSlices
    imshow(slices(:,:,k),[])
end

% set the slice heights
z = 1:numberOfSlices; % algorithm works with non-equidistant slices distances

%% slice interpolation
R = 2; %ratio of new dz over old dz
lambda = 1000; % the higher the regularization factor lambda it will search for more global motions but ignores local structures
tau = 100;  % step size of the implicit gradient descent
TOL = 0.04;
maxIter = 1000;
borderSize = 0.1;

[slices_interpolated,z_interpolated,vx,vy] = sliceInterp_spline_intensitySpline(slices,z,R,lambda,tau,TOL,maxIter,borderSize);

s = size(slices_interpolated)
s = s(3)

for k = 1:s
    imshow(slices_interpolated(:,:,k),[])
%     fileName = append(int2str(k),'.png')
%     imwrite(slices_interpolated(:,:,k), fileName)
end
niftiwrite(slices_interpolated,'1_001_seg_interpolated.nii');