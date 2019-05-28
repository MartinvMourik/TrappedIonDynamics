function [ total_fluorescence, binned_fluorescence, binned_times ] = get_fluorescence( speeds,settings )
%GET_FLUORESCENCE Summary of this function goes here
%   Detailed explanation goes here
max_fluorescence = 50; %Expected fluorescence on resonance;
binning = 1e-4;
hbar = 1.05457183e-34;
fluorescence = zeros(length(speeds),length(settings.ions));
for i = 1:length(settings.ions)
    velocity = squeeze(speeds(:,i,:));
    gamma = settings.ions(i).gamma;
    kvec = 2*pi/settings.ions(i).wavelength*settings.ions(i).laser_vec/norm(settings.ions(i).laser_vec);
    coupling = settings.ions(i).coupling;
    detuning = settings.ions(i).detuning;
    resonance = norm(gamma/2*coupling^2/2./(coupling^2/2+gamma^2/4)*hbar*kvec);
    damping_force = gamma/2*coupling^2/2./(coupling^2/2+gamma^2/4+(detuning-velocity*kvec').^2)*hbar*kvec;
    fluorescence(:,i) = sqrt(damping_force(:,1).^2+damping_force(:,2).^2+damping_force(:,3).^2)/resonance*max_fluorescence;
end
total_fluorescence = sum(fluorescence,2);
bin_nums = floor(settings.duration/binning);
bin_steps = round(binning/settings.time_step);
for i = 1:bin_nums
    binned_fluorescence(i) = sum(total_fluorescence(((i-1)*bin_steps+1):(i*bin_steps)))/bin_steps;
end
binned_times = binning:binning:settings.duration;


