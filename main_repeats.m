clear
addpath('functions\');
addpath('surface electrodes\');

% Select ion chain
ions = {'Ca','Ca'};

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
settings.rf_phase = 0;%rand*2*pi;
settings.pseudopotential = 0;
settings.duration = 2e-4;
settings.time_step = 1e-9  ; % Not a simulation step, but returned values
settings.fields = [0,0,0]; % Field potentials in V/m
settings.curvatures = [0,0,1.0e7/2,0,-1e7]; % Curvatures in V/m^2
settings.precool = 0; % Boolean. Does a non-physical damping, to help get ions in equilibrium positions
settings.precool_str = [1e5;1e5;1e5];
settings.precool_time = 1e-3;
ion_positions = [-2.4,2.4]*1e-6; %[-7,-4,0,4,7]*1e-6;


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
    settings.rf_voltage = settings.rf_voltage*71/60; % Approximate correction factor to match rf_voltage between multipole and surface methods, to get similar radial frequencies
end


% Ions are defined. This includes cooling parameters, unique for each ion.
% The start positions should be defined here. By default, ions are put in
% the RF null
for i = 1:length(ions)
    settings.ions(i) = create_ion(ions{i});
    settings.ions(i).start_pos(1) = ion_positions(i);
    settings.ions(i).start_pos(2) = settings.min_point(2);
    settings.ions(i).start_pos(3) = settings.min_point(3);

    settings.ions(i).coupling = 0*80*2*pi*1e6;%200*2*pi*1e6;
    settings.ions(i).detuning = -40*2*pi*1e6;%-150*2*pi*1e6;
end


% Starts scan
repeats = 2;
q = 1.60217662e-19;
settings.ions(1).start_vel = [0,200,0];
settings.ions(2).start_vel = [0,0,sqrt(2)*150];
for i = 1:repeats
    disp(i)
    settings.ions(2).start_vel(3) = sqrt(2)*150 + rand()*0.001;
    [t,y] = IonTrajectory_function(settings);
    [positions,speeds] = get_position_and_speed(y,settings);
    fin_pos(:,:,:,i) = positions;
end

