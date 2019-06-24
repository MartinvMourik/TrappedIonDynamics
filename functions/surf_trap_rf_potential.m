function [ potential ] = surf_trap_potential( trap_dims, x, y)
%SURF_TRAP_POTENTIAL Summary of this function goes here
%   Detailed explanation goes here

a = trap_dims(1);
b = trap_dims(2);
c = trap_dims(3);
x = x+a/2;

potential = 1/pi*(atan((a + b - x)./y) - atan((a - x)./y) - ...
    atan(x./y) + atan((c + x)./y));

end
