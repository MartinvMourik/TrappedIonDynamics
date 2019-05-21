function [ total_energy ] = get_total_energy( y, settings )
%GET_TOTAL_ENERGY Summary of this function goes here
%   Detailed explanation goes here
[positions,speeds] = get_position_and_speed(y,settings);
pseudo = get_total_pseudopotential(positions,settings);
kinetic = get_total_kinetic_energy(speeds,settings,1);
coulomb = get_total_coulomb_energy(positions,settings.ions);
dc = get_total_dc_energy(positions,settings);
total_energy = pseudo + kinetic + coulomb + dc;
end

