function [ rf_min ] = find_rf_min( X,Y,Z,rf_potential )
%FIND_RF_MIN Summary of this function goes here
%   Detailed explanation goes here
rf_size = size(rf_potential);
Xf = (min(X(:))+max(X(:)))/2;
Yf = linspace(min(Y(:)),max(Y(:)),200);
Zf = linspace(min(Z(:)),max(Z(:)),200);

rf_potential_2d = reshape(rf_potential((rf_size(1)+1)/2,:,:),[rf_size(2),rf_size(3)]);
rf_fine = interp2(rf_potential_2d,4);
[Ex,Ey] = gradient(rf_fine);
pseudo = (Ex.^2+Ey.^2);
pseudo = pseudo/min(pseudo(:));
func = @(x) interp2(pseudo,x(1),x(2));
min_point = fminunc(func,[100,100]);
rf_fine_size = size(rf_fine);
rf_min(1) = Xf;
rf_min(2) = (Yf(1)+Yf(end))*min_point(1)/rf_fine_size(1);
rf_min(3) = (Zf(1)+Zf(end))*min_point(2)/rf_fine_size(2);

end

