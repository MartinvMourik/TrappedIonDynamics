function [ pseudo_potential ] = get_total_pseudopotential( position, settings )
%GET_PSEUDOPOTENTIAL Summary of this function goes here
%   Detailed explanation goes here
trap_freq = settings.rf_frequency;
phi = zeros(length(position),length(settings.ions));
for k = 1:length(position)
    for i = 1:length(settings.ions)
        q = settings.ions(i).q;
        mass = settings.ions(i).m;
        fields = get_rf_gradients(position(k,i,:),settings.rf_multipoles);
        fields = fields*settings.rf_voltage;
        phi(k,i) = q^2/(4*mass*(2*pi*trap_freq)^2)*norm(fields)^2;
    end
end
pseudo_potential = sum(phi,2);
