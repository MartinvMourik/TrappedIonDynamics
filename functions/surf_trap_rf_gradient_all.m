function [ grad ] = surf_trap_rf_gradient_all( trap_dims, positions)
%SURF_TRAP_POTENTIAL Summary of this function goes here
%   Detailed explanation goes here
x = positions(:,3,1);
y = positions(:,2,1);

a = trap_dims(1);
b = trap_dims(2);
c = trap_dims(3);
x = x+a/2;

grad_x = y/pi.*(1./(y.^2+(a-x).^2)-1./(y.^2+(a+b-x).^2)+...
    1./(y.^2+(c+x).^2)-1./(x.^2+y.^2));
grad_y = 1/pi.*((a-x)./(y.^2+(a-x).^2)-(a+b-x)./(y.^2+(a+b-x).^2)-...
    (c+x)./(y.^2+(c+x).^2)+x./(x.^2+y.^2));
grad_z = zeros(size(grad_x));

grad = [grad_z,grad_y,grad_x];
end