function [ axial_com_KE ] = get_axial_com_energy( speeds,settings,smoothing )
%GET_TOTAL_KINETIC_ENERGY Summary of this function goes here
%   Detailed explanation goes here
for i = 1:length(settings.ions)
    masses(i,1) = settings.ions(i).m;
end
if smoothing
    for i = 1:length(settings.ions)
        speeds_smooth(:,i) = smooth(speeds(:,i,1),round(2/settings.rf_frequency/settings.time_step));
    end
else
    speeds_smooth = squeeze(speeds(:,:,1));
end

av_speeds = speeds_smooth*masses/sum(masses);
axial_com_KE = 1/2*av_speeds.^2*mean(masses);
end

