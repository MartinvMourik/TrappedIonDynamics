function [ fourier_result, energies ,amplitudes] = time_dep_fourier( positions,speeds,ion_number)
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
i = 1;
range = 1e4;
freq_range = range*1e-1;
if ~exist('ion_number','var')
    ion_number = 1;
end
while(i*range<length(positions(:,1,1)))
    for j = 1:3
        data = positions(((i-1)*range+1):i*range,ion_number,j);
        scaled_data = data/std(data);
        fftdata = abs(fft(scaled_data - mean(scaled_data)));
        fourier_result(:,i,j) = fftdata;
        energy = speeds(((i-1)*range+1):i*range,ion_number,j);
        amplitudes(i,j) = std(data);
        energies(i,j) = mean(energy.^2);
    end
    i = i+1;
end
figure()
for j = 1:3
    subplot(2,3,j)
    timescale = linspace(0,1e-9*length(positions(:,1,1)),i);
    freq_scale = linspace(0,freq_range,length(fourier_result(:,1,1)));
    imagesc(timescale,freq_scale,log(fourier_result(:,:,j)),[2,9])
    axis([0,timescale(end),0,40]);
    subplot(2,3,j+3)
    imagesc(timescale,freq_scale,log(fourier_result(:,:,j)),[2,9])
    axis([0,timescale(end),0,12]);  
end

