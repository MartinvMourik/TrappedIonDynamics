clear
addpath('functions\');
addpath('surface electrodes\');

% Select ion chain
ions = {'Ca','Sr','Ca'};

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

times = linspace(0,1e-4,1001);
conf = ones(1,length(times));
min_conf = 1;
max_field = .6e3;
conf(1:250) = linspace(1,min_conf,250);
conf(251:750) = min_conf;
conf(751:1000) = linspace(min_conf,1,250);
field = zeros(1,length(times));
field(251:500) = linspace(0,max_field,250);
field(501:750) = linspace(max_field,0,250);





% The following settings need to be set
settings.coulomb = 1; %Boolean. Turn coulomb potential on or off
settings.rf_voltage = 60;
settings.rf_frequency = 35e6;
settings.rf_phase = 0;
settings.duration = 1e-3;
settings.time_step = 1e-9; % Not a simulation step, but returned values
settings.fields = [0,0,0]; % Field potentials in V/m
settings.curvatures = [0,0,1.2e7/2,0,-1e7]; % Curvatures in V/m^2
settings.precool = 0; % Boolean. Does a non-physical damping, to help get ions in equilibrium positions
settings.precool_str = [1e6;1e6;1e6];
settings.precool_time = 5e-6;
ion_positions = [-4.2,0,4.2]*1e-6; % Initial positions along trap axis

settings.ramp_conf = conf*settings.curvatures(3);
settings.ramp_field = field;
settings.times = times;

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
    settings.ions(i).coupling = 200*2*pi*1e6;%200*2*pi*1e6;
    settings.ions(i).detuning = -4*80*2*pi*1e6;%-150*2*pi*1e6;
end
settings.ions(2).start_vel = [1,1,1]*50;
% Get motional frequencies (optional)
%IonTrajectory_frequencies(settings);

% Starts scan
myFitType = fittype('a*exp(-x/b)+c');
options = fitoptions(myFitType);
couplings = 50;
detunings = 50:50:100;
for i = 1:length(couplings)
    for j = 1:length(detunings)
        for k = 1:length(ions)
            settings.ions(k).coupling = couplings(i)*2*pi*1e6;%200*2*pi*1e6;
            settings.ions(k).detuning = -detunings(j)*2*pi*1e6;%-150*2*pi*1e6;
        end
        [t,y] = IonTrajectory_function(settings);
        t_small = t(1:100:end)*1e3;
        y_small = y(1:100:end);
        en = get_total_energy(y,settings)/1.06e-19;
        en_small = en(1:100:end)*1e3;
        options.StartPoint = [en_small(1),1,0];
        fitres = fit(t_small,en_small,myFitType,options);
        decay(i,j) = fitres.b;
        de = confint(fitres);
        decay_error(i,j,:) = de(:,2);
    end
end
% y is a vector that contains [3 positions, 3 velocities, 3 positions, 3
% velocities...] alternating through ions.

% Sort y into nicer vectors of dimension [number of points,number of ions,3
% dimension], for speed and position
[positions,speeds] = get_position_and_speed(y,settings);

% en = get_total_energy(y,settings);
