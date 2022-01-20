function [ damping_force ] = get_full_damping( speeds,settings,ion_number)
%GET_FLUORESCENCE Summary of this function goes here
%   Detailed explanation goes here
    hbar = 1.05457183e-34;
    velocity = squeeze(speeds(:,ion_number,:));
    gamma = settings.ions(ion_number).gamma;
    kvec = 2*pi/settings.ions(ion_number).wavelength*settings.ions(ion_number).laser_vec/norm(settings.ions(ion_number).laser_vec);
        coupling = settings.ions(ion_number).coupling;
    detuning = settings.ions(ion_number).detuning;
    damping_force = gamma/2*coupling^2/2./(coupling^2/2+gamma^2/4+(detuning-velocity*kvec').^2)*hbar*kvec;
end


