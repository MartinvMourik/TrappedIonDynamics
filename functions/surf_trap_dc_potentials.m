function [ potential ] = surf_trap_dc_potentials(position,electrode_corners,electrode_voltage)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
x = position(1);
y = position(2);
z = position(3);
ecz = sort(electrode_corners([1,2]));
ecx = sort(electrode_corners([3,4]));
potential = 0;
for i = 1:2
    for j = 1:2
        xc = ecx(i);
        zc = ecz(j);
        pm_sign = sign(i-1.5)*sign(j-1.5);
        potential = potential + pm_sign/2/pi*(atan((xc - x)*(zc - z)/(y*sqrt(y^2 + (xc - x)^2 + (zc - z)^2))));
    end
end
potential = potential*electrode_voltage;