clear
addpath('functions\');
addpath('surface electrodes\');

% Select ion chain
ions = {'Ca','Ca','Sr'};

% Choose how the RF potential is generated.
% 'multipole' uses a basis of spherical harmonics
% 'surface' uses an analytic solution of a surface trap with two RF rails
% For 'multipole': Choose the file that defines the RF potential. This is a vector that
% contains 25 values, corresponding to the first 25 spherical harmonic
% potentials. Index 9 corresponds to an x^2 - y^2 potential, the typical RF
% saddle-type potential. The 'multipoles_harmonic' file contains only this.
% For 'surface': define the widths of the electrode rails:
% [space between rails, width rail 1, width rail 2];

settings.potential_type = 'multipoles'; %'multipoles' or 'surface'
if strcmp(settings.potential_type,'multipoles')
    settings.multipole_file = 'multipoles\multipoles_harmonic.mat';
    load(settings.multipole_file)
    settings.rf_multipoles = multipoles;
elseif strcmp(settings.potential_type,'surface')
    load('surface electrodes\rf_electrode_positions.mat')
    load('surface electrodes\dc_electrode_positions.mat')
    settings.rail_dimensions = rf_electrodes;
    settings.dc_electrode_positions = electrode_positions;
end


% The following settings need to be set
settings.coulomb = 1; %Boolean. Turn coulomb potential on or off
settings.rf_voltage = 60;
settings.rf_frequency = 35e6;
settings.rf_phase = 0;
settings.duration = 1e-5;
settings.time_step = 1e-9; % Not a simulation step, but returned values
settings.fields = [0,0,0]; % Field potentials in V/m
settings.curvatures = [0,0,1.2e7/2,0,-1e7]; % Curvatures in V/m^2
settings.precool = 1; % Boolean. Does a non-physical damping, to help get ions in equilibrium positions
settings.precool_str = [1e6;1e6;1e6];
settings.precool_time = 5e-6;
ion_positions = [-4.2,0,4.2]*1e-6; % Initial positions along trap axis
% The following finds the RF minimum point of the chosen multipole file.
% The DC spherical harmonics are build around this point.
if strcmp(settings.potential_type,'multipoles')
    minfunc = @(x)sum((get_rf_gradients(x,settings.rf_multipoles).^2));
    settings.min_point = fminunc(minfunc,[0,0,0]);
elseif strcmp(settings.potential_type,'surface')
    minfunc = @(x)sum((surf_trap_rf_gradient(settings.rail_dimensions,x).^2));
    min_point = fminunc(minfunc,[0,70e-6,0]);
    settings.min_point(1) = 0;
    settings.min_point(2) = min_point(2);
    settings.min_point(3) = min_point(1);
    voltages_matrix = get_electrode_voltages_matrix(settings.dc_electrode_positions,settings.rail_dimensions);
    settings.dc_voltages = voltages_matrix*[settings.fields';settings.curvatures';];
    %draw_electrodes(settings.dc_electrode_positions,settings.rail_dimensions,settings.dc_voltages);
    settings.voltage_noise = filtered_noise(settings);
end


% Ions are defined. This includes cooling parameters, unique for each ion.
% The start positions should be defined here. By default, ions are put in
% the RF null
for i = 1:length(ions)
    settings.ions(i) = create_ion(ions{i});
    settings.ions(i).start_pos(1) = ion_positions(i);
    settings.ions(i).start_pos(2) = settings.min_point(2);
    settings.ions(i).start_pos(3) = settings.min_point(3);
%     settings.ions(i).start_vel(1) = ion_speeds(1);
%     settings.ions(i).start_vel(2) = ion_speeds(2);
%     settings.ions(i).start_vel(3) = ion_speeds(3);
    settings.ions(i).coupling = 25*2*pi*1e6;%200*2*pi*1e6;
    settings.ions(i).detuning = -22*2*pi*1e6;%-150*2*pi*1e6;
end
%settings.ions(1).start_vel = [1,1,1]*50;
% Get motional frequencies (optional)
%IonTrajectory_frequencies(settings);

% Starts scan
[t,y] = IonTrajectory_function(settings);
% y is a vector that contains [3 positions, 3 velocities, 3 positions, 3
% velocities...] alternating through ions.

% Sort y into nicer vectors of dimension [number of points,number of ions,3
% dimension], for speed and position
[positions,speeds] = get_position_and_speed(y,settings);

% en = get_total_energy(y,settings);
