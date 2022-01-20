function [ amplitude ] = get_amplitude(y,settings,pos_noRF,spd_noRF)

% Only for two ions!

freqs = IonTrajectory_frequencies(settings)*2*pi;

if ~exist('pos_noRF','var')
    [positions,speeds] = get_position_and_speed(y,settings);
    [pos_noRF,spd_noRF] = remove_rf(positions,speeds,settings);
end

spd_noRF_w = zeros(size(spd_noRF));
for i = 1:3
    spd_noRF_w(:,:,i) = spd_noRF(:,:,i)/freqs(i);
end
amplitude = sqrt(pos_noRF.^2+spd_noRF_w.^2);
end