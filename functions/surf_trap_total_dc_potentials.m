function [ potential ] = surf_trap_total_dc_potentials(positions,settings)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
potential = zeros(length(positions),1);
min_potential = 0;
electrode_corners = settings.dc_electrode_positions;

for k = 1:length(settings.ions)
    x = settings.min_point(1);
    y = settings.min_point(2);
    z = settings.min_point(3);
    for m = 1:length(settings.dc_voltages)
        electrode_potential = 0;
        ecz = sort(electrode_corners(m,[1,2]));
        ecx = sort(electrode_corners(m,[3,4]));
        for i = 1:2
            for j = 1:2
                xc = ecx(i);
                zc = ecz(j);
                pm_sign = sign(i-1.5)*sign(j-1.5);
                electrode_potential = electrode_potential + pm_sign/2/pi*(atan((xc - x).*(zc - z)./(y.*sqrt(y.^2 + (xc - x).^2 + (zc - z).^2))));
            end
        end
        min_potential = min_potential + electrode_potential*settings.dc_voltages(m)*settings.ions(k).q;
    end
end

for k = 1:length(settings.ions)
    x = positions(:,k,1);
    y = positions(:,k,2);
    z = positions(:,k,3);   
    for m = 1:length(settings.dc_voltages)
        electrode_potential = zeros(size(potential));
        ecz = sort(electrode_corners(m,[1,2]));
        ecx = sort(electrode_corners(m,[3,4]));
        for i = 1:2
            for j = 1:2
                xc = ecx(i);
                zc = ecz(j);
                pm_sign = sign(i-1.5)*sign(j-1.5);
                electrode_potential = electrode_potential + pm_sign/2/pi*(atan((xc - x).*(zc - z)./(y.*sqrt(y.^2 + (xc - x).^2 + (zc - z).^2))));
            end
        end
        potential = potential + electrode_potential*settings.dc_voltages(m)*settings.ions(k).q;
    end
end
potential = potential - min_potential;