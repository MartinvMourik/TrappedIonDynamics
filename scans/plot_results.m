addpath('C:\Users\marti\Documents\SQIP\Simulation\MathieuIonTrajectory\v2\');
set(0,'DefaultAxesFontSize',16,'DefaultLineLineWidth',2)
close all

date = '20190411';
load([date, ' coupling_scan.mat'])
coupling_vals_str = {};
coupling_vals = settings.scan_params;
t = 0:1e-6:5e-4;
for i = 1:length(settings.scan_params)
    coupling_vals_str{i} = num2str(coupling_vals(i));
    y = y_res(:,:,i);
    hold on
    en = analyze_energy(y,settings,100)/1.06e-19;
    plot(t,en(:,1))
end
legend(coupling_vals_str)
xlabel('Time (ms)')
ylabel('Energy (meV)')
title('Cooling beam coupling')

load([date, ' detuning_scan.mat'])
detuning_vals_str = {};
detuning_vals = settings.scan_params;
t = 0:1e-6:5e-4;
figure()
for i = 1:length(settings.scan_params)
    detuning_vals_str{i} = num2str(detuning_vals(i));
    y = y_res(:,:,i);
    hold on
    en = analyze_energy(y,settings,100)/1.06e-19;
    plot(t,en(:,1))
end
legend(detuning_vals_str)
xlabel('Time (ms)')
ylabel('Energy (meV)')
title('Cooling beam detuning')

load([date ' rf_scan.mat'])
rf_vals_str = {};
rf_vals = settings.scan_params;
t = 0:1e-6:1e-3;
figure()
for i = 1:(length(settings.scan_params)-2)
    rf_vals_str{i} = num2str(rf_vals(i));
    y = y_res(:,:,i);
    hold on
    en = analyze_energy(y,settings,100)/1.06e-19;
    plot(t,en(:,1))
end
legend(rf_vals_str)
xlabel('Time (ms)')
ylabel('Energy (meV)')
title('RF Voltage')
