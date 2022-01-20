function [ total_energy ] = get_total_energy( y, settings ,pos_noRF,spd_noRF)
%GET_TOTAL_ENERGY Summary of this function goes here
%   Detailed explanation goes here
if ~exist('pos_noRF','var')
    [positions,speeds] = get_position_and_speed(y,settings);
    if ~settings.pseudopotential
        [positions,speeds] = remove_rf(positions,speeds,settings);
    end
else
    positions = pos_noRF;
    speeds = spd_noRF;
end
pseudo = get_total_pseudopotential(positions,settings);
kinetic = get_total_kinetic_energy(speeds,settings,0);
coulomb = get_total_coulomb_energy(positions,settings,0);
dc = get_total_dc_energy(positions,settings);
total_energy = pseudo + kinetic + coulomb + dc;
end

