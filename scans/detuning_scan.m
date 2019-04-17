clear
addpath('..\functions\');
detuning_vals = -200;%50:10:180; %MHz
ions = {'Ca','Ca','Ca'};

settings.multipole_file = '..\multipoles\multipoles_harmonic.mat';
load(settings.multipole_file)
settings.rf_multipoles = multipoles;
%multipole_file = 'MultipoleExpansion\multipoles_harmonic.mat';

settings.coulomb = 1; %Boolean
settings.rf_voltage = 100;
settings.rf_frequency = 35e6;
settings.duration = 5e-4;
settings.time_step = 1e-6; % Not a simulation step, but returned values
settings.fields = [0,0,0]; % Field potentials in V/m
settings.curvatures = [0,0,1.2e7,0,1e6]; % Curvatures in V/m^2
settings.precool = 0;
settings.precool_str = [1e6;1e6;1e6];
settings.precool_time = 1e-5;
ion_positions = [-3.35,0,3.35]*1e-6;

minfunc = @(x)sum((get_rf_gradients(x,settings.rf_multipoles).^2));
settings.min_point = fminunc(minfunc,[0,0,0]);

for i = 1:length(ions)
    settings.ions(i) = create_ion(ions{i});
    settings.ions(i).start_pos(1) = ion_positions(i);
    settings.ions(i).start_pos(2) = settings.min_point(2);
    settings.ions(i).start_pos(3) = settings.min_point(3);
    settings.ions(i).coupling = 25*2*pi*1e6;
    settings.ions(i).detuning = -40*2*pi*1e6;
end
settings.ions(1).start_vel = [1,.2,.1]*60; % Gives the ion an instantaneous kick
y_res = zeros(length(0:settings.time_step:settings.duration),length(ions)*6,length(detuning_vals));
for i = 1:length(detuning_vals)
    curr_sets = settings;
    for j = 1:length(ions)
        curr_sets.ions(j).detuning = detuning_vals(i)*2*pi*1e6;
    end
    [t,y] = IonTrajectory_function(curr_sets);
    savename = ['detuning_',num2str(detuning_vals(i)),'.mat'];
    %save(savename,'t','y','settings');
    y_res(:,:,i) = y;
end