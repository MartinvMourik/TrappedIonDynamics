function [ damping_force ] = get_damp_forces( velocity, ion_settings)
hbar = 1.05457183e-34;
gamma = ion_settings.gamma;
kvec = 2*pi/ion_settings.wavelength*ion_settings.laser_vec/norm(ion_settings.laser_vec);
coupling = ion_settings.coupling;
detuning = ion_settings.detuning;
damping_force = gamma/2*coupling^2/2/(coupling^2/2+gamma^2/4+(detuning-kvec*velocity)^2)*hbar*kvec;
end

