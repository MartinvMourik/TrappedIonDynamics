function [ total_KE ] = get_total_kinetic_energy( speeds,settings,smoothing )
%GET_TOTAL_KINETIC_ENERGY Summary of this function goes here
%   Detailed explanation goes here
for i = 1:length(settings.ions)
    masses(i,1) = settings.ions(i).m;
end
if smoothing
    for i = 1:length(settings.ions)
        speeds(:,i,1) = smooth(speeds(:,i,1),round(2/settings.rf_frequency/settings.time_step));
        speeds(:,i,2) = smooth(speeds(:,i,2),round(2/settings.rf_frequency/settings.time_step));
        speeds(:,i,3) = smooth(speeds(:,i,3),round(2/settings.rf_frequency/settings.time_step));
    end
end
av_speeds_sq = sum(speeds.^2,3);
total_KE = 1/2*av_speeds_sq*masses;


end

