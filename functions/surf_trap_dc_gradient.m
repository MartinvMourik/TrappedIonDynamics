function [ dc ] = surf_trap_dc_gradient(position,electrode_corners,electrode_voltages)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
x = position(1);
y = position(2);
z = position(3);

no_of_electrodes = length(electrode_voltages);
Ex = 0;
Ey = 0;
Ez = 0;
for i = 1:no_of_electrodes
    for j = 1:2
        for k = 1:2
%             ecz = sort(electrode_corners(i,[1,2]));
%             ecx = sort(electrode_corners(i,[3,4]));
%             xc = ecx(j);
%             zc = ecz(k);
            xc = electrode_corners(i,j+2);
            zc = electrode_corners(i,k);
            pm_sign = sign(j-1.5)*sign(k-1.5);
            
            Ex = Ex + 1/(2*pi)*y*(z-zc)/(((x-xc)^2+y^2)*sqrt((x-xc)^2+y^2+(z-zc)^2))*electrode_voltages(i)*pm_sign;
            Ey = Ey - 1/(2*pi)*(x-xc)*(z-zc)*((x-xc)^2 + 2*y^2 + (z-zc)^2)/(((x-xc)^2+y^2)*((z-zc)^2+y^2)*sqrt((x-xc)^2+y^2+(z-zc)^2))*electrode_voltages(i)*pm_sign;
            Ez = Ez + 1/(2*pi)*y*(x-xc)/(((z-zc)^2+y^2)*sqrt((x-xc)^2+y^2+(z-zc)^2))*electrode_voltages(i)*pm_sign;
        end
    end
end

dc = [Ex,Ey,Ez];