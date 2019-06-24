function [ voltage_noise ] = filtered_noise( settings )
%FILTERED_NOISE Summary of this function goes here
%   Detailed explanation goes here
datapts = settings.duration/settings.time_step;
Fs = 1/settings.time_step;                  % Sampling Frequency (Hz)
Fn = Fs/2;                                  % Nyquist Frequency (Hz)
Fco = 50e3;                                 % Cutoff Frequency (Hz)
Wp = Fco/Fn;                                % Normalised Cutoff Frequency (rad)
[b,a]   = butter(1,Wp);
voltage_noise = zeros(datapts,length(settings.dc_voltages));
for i = 1:length(settings.dc_voltages)
    noise = randn(datapts,1);
    noise = filter(b,a,noise);
    noise = noise/std(noise)*settings.noise_level;
    voltage_noise(:,i) = noise;
end

