function [ dc_potential ] = create_dc_potential( X,Y,Z,field,curvatures,center)
%CREATE_DC_POTENTIAL Summary of this function goes here
%   Detailed explanation goes here
    X = X - center(1);
    Y = Y - center(2);
    Z = Z - center(3);
    grid_size = size(X);
    X = reshape(X,[prod(grid_size),1]);
    Y = reshape(Y,[prod(grid_size),1]);
    Z = reshape(Z,[prod(grid_size),1]);
    dc_potentialm(:,1) = field(1)*X;
    dc_potentialm(:,2) = field(2)*Y;
    dc_potentialm(:,3) = field(3)*Z;
    dc_potentialm(:,4) = curvatures(1)*(Y.*Z);
    dc_potentialm(:,5) = curvatures(2)*(Z.*X);
    dc_potentialm(:,6) = curvatures(3)*(2*X.^2 - Y.^2 - Z.^2);
    dc_potentialm(:,7) = curvatures(4)*(Y.*X);
    dc_potentialm(:,8) = curvatures(5)*(Y.^2 - Z.^2);
    dc_potential = sum(dc_potentialm,2);
    dc_potential = reshape(dc_potential,grid_size);
end

