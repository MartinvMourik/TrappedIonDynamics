function [ pseudo_potential ] = get_total_pseudopotential( position, settings )
%GET_PSEUDOPOTENTIAL Summary of this function goes here
%   Detailed explanation goes here
trap_freq = settings.rf_frequency;
phi = zeros(length(position),length(settings.ions));

for i = 1:length(settings.ions)
    q = settings.ions(i).q;
    mass = settings.ions(i).m;
    fields = get_all_rf_gradients(squeeze(position(:,i,:)),settings);
    phi(:,i) = q^2/(4*mass*(2*pi*trap_freq)^2)*sum(fields.^2,2);
end

pseudo_potential = sum(phi,2);
