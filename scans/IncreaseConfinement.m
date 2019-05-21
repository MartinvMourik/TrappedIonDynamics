clear
close all
addpath('..\functions\');
%scan_param = 'coupling_vals';
%scan_vals = (5:30:300)*2*pi*1e6;
confinement_lims = [0,0,1.2e7/5,0,1e6;0,0,1.2e7*2,0,1e6];
number_of_repeats = 1; 
ions = {'Ca','Ca','Ca','Ca','Ca','Ca','Ca','Ca','Ca'};

settings.multipole_file = '..\multipoles\multipoles_harmonic.mat';
load(settings.multipole_file)
settings.rf_multipoles = multipoles;
%multipole_file = 'MultipoleExpansion\multipoles_harmonic.mat';

settings.coulomb = 1; %Boolean
settings.rf_voltage = 80;
settings.rf_frequency = 35e6;
settings.rf_phase = 0;
settings.duration = 1e-4;
settings.time_step = 1e-9; % Not a simulation step, but returned values
settings.fields = [0,0,0]; % Field potentials in V/m
settings.curvatures = [0,0,1.2e7/2,0,1e6]; % Curvatures in V/m^2
settings.curvatures_lims = confinement_lims;
settings.precool = 1;
settings.precool_str = [5e5;5e5;5e5];
settings.precool_time = 1e-2;
%ion_positions = [-3.35,0,3.35]*1e-6;
ion_positions = linspace(-13.123,13.123,9)*1e-6;

minfunc = @(x)sum((get_rf_gradients(x,settings.rf_multipoles).^2));
settings.min_point = fminunc(minfunc,[0,0,0]);
load('final_y.mat')
positionnumbers = 1:6:54;

for i = 1:length(ions)
    settings.ions(i) = create_ion(ions{i});
%     settings.ions(i).start_pos(1) = ion_positions(i);
%     settings.ions(i).start_pos(2) = settings.min_point(2);
%     settings.ions(i).start_pos(3) = settings.min_point(3);
    settings.ions(i).start_pos(1) = final_y(6*(i-1)+1);
    settings.ions(i).start_pos(2) = final_y(6*(i-1)+2);
    settings.ions(i).start_pos(3) = final_y(6*(i-1)+3);
    settings.ions(i).start_vel(1) = final_y(6*(i-1)+4);
    settings.ions(i).start_vel(2) = final_y(6*(i-1)+5);
    settings.ions(i).start_vel(3) = final_y(6*(i-1)+6);
    settings.ions(i).coupling = 20*2*pi*1e6;
    settings.ions(i).detuning = -20*2*pi*1e6;
end

[t,y] = IonTrajectory_function(settings);
