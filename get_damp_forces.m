function [ damping_force ] = get_damp_forces( velocity, ion_settings)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
hbar = 1.05457183e-34;
gamma = ion_settings.gamma;
kvec = 2*pi/ion_settings.wavelength*ion_settings.laser_vec/norm(ion_settings.laser_vec);
coupling = ion_settings.coupling;
detuning = ion_settings.detuning;

% 
% F01 = hbar*kvec*gamma1*coupling1^2/(4*detuning1^2+gamma1);
% F02 = hbar*kvec*gamma2*coupling2^2/(4*detuning2^2+gamma2);
% 
% beta1 = hbar*gamma1*k^2*2^4*coupling1^2*detuning1/(m1*(detuning1^2+gamma1^2/4));
% beta2 = hbar*gamma2*k^2*2^4*coupling2^2*detuning2/(m2*(detuning2^2+gamma2^2/4));
% 
% Fp1 = F01 - m1*beta1*kvec/2/k^2*(kvec*v1');
% Fp2 = F02 - m2*beta2*kvec/2/k^2*(kvec*v2');
damping_force = gamma/2*coupling^2/2/(coupling^2/2+gamma^2/4+(detuning-kvec*velocity)^2)*hbar*kvec;

end

