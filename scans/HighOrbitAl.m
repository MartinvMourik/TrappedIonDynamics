clear
addpath('..\functions\');
%scan_param = 'coupling_vals';
%scan_vals = (5:30:300)*2*pi*1e6;
scan_param = 'start_vel';
%scan_vals = 0;
%number_of_repeats = 100;
ions = {'Ca','Al'};

settings.multipole_file = '..\multipoles\multipoles_harmonic.mat';
load(settings.multipole_file)
settings.rf_multipoles = multipoles;
%multipole_file = 'MultipoleExpansion\multipoles_harmonic.mat';

settings.coulomb = 0; %Boolean
settings.rf_voltage = 50;
settings.rf_frequency = 35e6;
settings.rf_phase = 0;
settings.duration = 1e-3;
settings.time_step = 1e-9; % Not a simulation step, but returned values
settings.fields = [0,0,0]; % Field potentials in V/m
settings.curvatures = [0,0,1.2e7/4,0,1e6]; % Curvatures in V/m^2
settings.precool = 0;
settings.precool_str = [1e5;1e5;1e5];
settings.precool_time = 1e-2;
%ion_positions = [-3.35,0,3.35]*1e-6;
ion_positions = [0,200]*1e-6;

minfunc = @(x)sum((get_rf_gradients(x,settings.rf_multipoles).^2));
settings.min_point = fminunc(minfunc,[0,0,0]);

for i = 1:length(ions)
    settings.ions(i) = create_ion(ions{i});
    settings.ions(i).start_pos(1) = ion_positions(i);
    settings.ions(i).start_pos(2) = settings.min_point(2);
    settings.ions(i).start_pos(3) = settings.min_point(3);
    settings.ions(i).coupling = 20*2*pi*1e6;
    settings.ions(i).detuning = -40*2*pi*1e6;
end
%settings.ions(1).coupling = 20*2*pi*1e6;
%settings.ions(1).detuning = -100*2*pi*1e6;
%settings.ions(2).coupling = 0*2*pi*1e6;
%settings.ions(2).detuning = 0*-200*2*pi*1e6;
settings.ions(2).start_vel = [0,1,0]*1000; % Gives the ion an instantaneous kick
%y_res = zeros(length(0:settings.time_step:settings.duration),length(ions)*6,length(scan_vals));
[t,y] = IonTrajectory_function(settings);
%save(['Swap_vs_energy_results\swap_result_',num2str(scan_vals(i),5),'.mat'],'settings','swap_res');