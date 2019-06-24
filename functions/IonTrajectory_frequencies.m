function [ freq ] = IonTrajectory_frequencies( settings )
%f Short simulation run to find motional
%frequencies
start_vec = zeros(6,1);
start_vec(1:3) = settings.min_point;
start_vec(4:6,1) = .1;

settings.ions = settings.ions(1);
settings.duration = 1e-4; 
settings.time_step = 1e-9;

diff_eq = @(t,x) ion_diff_equation(x,t,settings);
disp('Getting motional frequencies...')
[~,y] = ode113(diff_eq,0:settings.time_step:settings.duration,start_vec(:));
for i = 1:3
    data = y(:,i)-mean(y(:,i));
    fourier = abs(fft(data));
    [~,max_index] = max(fourier);
    freq(i) = max_index/10*settings.duration/settings.time_step;
end
display(freq)

