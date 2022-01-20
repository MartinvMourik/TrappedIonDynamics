clear
addpath('..\functions\');
addpath('..\surface electrodes\');
detuning_vals = -0:-10:-200; %MHz
coupling_vals = [20,40,100];


% 
% settings.potential_type = 'multipoles'; %'multipoles' or 'surface'
% if strcmp(settings.potential_type,'multipoles')
%     settings.multipole_file = '..\multipoles\multipoles_harmonic.mat';
%     load(settings.multipole_file)
%     settings.rf_multipoles = multipoles;
% elseif strcmp(settings.potential_type,'surface')
%     load('..\surface electrodes\rf_electrode_positions.mat')
%     load('..\surface electrodes\dc_electrode_positions.mat')
%     settings.rail_dimensions = rf_electrodes;
%     settings.dc_electrode_positions = electrode_positions;
% end
% 
% settings.coulomb = 1; %Boolean
% settings.rf_voltage = 60;
% settings.rf_phase = 0;
% settings.rf_frequency = 35e6;
% settings.duration = 1e-3;
% settings.time_step = 1e-9; % Not a simulation step, but returned values
% settings.fields = [0,0,0]; % Field potentials in V/m
% settings.curvatures = [0,0,1.0e7/2,0,-1e7]; % Curvatures in V/m^2
% settings.precool = 0;
% settings.precool_str = [1e6;1e6;1e6];
% settings.precool_time = 1e-5;
% ion_positions = [-2.6,2.6]*1e-6;
load('detuning_scan_settings.mat')
settings = rmfield(settings,'ions');
ions = {'Ca','Ca'}; % Make sure this matches what is being loaded in the settings file
ion_positions = [-2.6,2.6]*1e-6;
settings.potential_type = 'multipoles'; %'multipoles' or 'surface'
settings.duration = 1e-3;
if strcmp(settings.potential_type,'multipoles')
    settings.multipole_file = '..\multipoles\multipoles_harmonic.mat';
    load(settings.multipole_file)
    settings.rf_multipoles = multipoles;
elseif strcmp(settings.potential_type,'surface')
    load('..\surface electrodes\rf_electrode_positions.mat')
    load('..\surface electrodes\dc_electrode_positions.mat')
    settings.rail_dimensions = rf_electrodes;
    settings.dc_electrode_positions = electrode_positions;
    settings.rf_voltage = settings.rf_voltage*71/60; % Approximate correction factor to match rf_voltage between multipole and surface methods, to get similar radial frequencies
end

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
    %settings.voltage_noise = filtered_noise(settings);
end

for i = 1:length(ions)
    settings.ions(i) = create_ion(ions{i});
    settings.ions(i).start_pos(1) = ion_positions(i);
    settings.ions(i).start_pos(2) = settings.min_point(2);
    settings.ions(i).start_pos(3) = settings.min_point(3);
    settings.ions(i).coupling = 100*2*pi*1e6;
    settings.ions(i).detuning = -40*2*pi*1e6;
    settings.ions(i).laser_vec = [1,1,1];
end
settings.ions(1).start_vel = [1,1,1]*100; % Gives the ion an instantaneous kick

y_res = zeros(length(0:settings.time_step:settings.duration),length(ions)*6,length(detuning_vals));
mean_time = linspace(0,settings.duration,1e4);

for k = 1:length(coupling_vals)
    mean_en = zeros(length(mean_time),length(detuning_vals));
    for i = 1:length(detuning_vals)
        curr_sets = settings;
        for j = 1:length(ions)
            curr_sets.ions(j).detuning = detuning_vals(i)*2*pi*1e6;
            curr_sets.ions(j).coupling = coupling_vals(k)*2*pi*1e6;
        end
        [t,y] = IonTrajectory_function(curr_sets);
        savename = ['detuning_',num2str(detuning_vals(i)),'.mat'];
        %save(savename,'t','y','settings');
        en = get_total_energy(y,curr_sets);
        mean_en(:,i) = interp1(t,en,mean_time);

        y_res(:,:,i) = y;
    end
    savename = ['Detuning_scanCaCa_HighExc_',num2str(coupling_vals(k)),'.mat'];
    save(savename,'detuning_vals','mean_en','settings');
end