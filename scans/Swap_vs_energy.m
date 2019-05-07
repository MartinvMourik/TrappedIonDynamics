clear
addpath('..\functions\');
%scan_param = 'coupling_vals';
%scan_vals = (5:30:300)*2*pi*1e6;
scan_param = 'start_vel';
scan_vals = logspace(log10(20),log10(150),15);
number_of_repeats = 100;
ions = {'Ca','Al'};

settings.multipole_file = '..\multipoles\multipoles_harmonic.mat';
load(settings.multipole_file)
settings.rf_multipoles = multipoles;
%multipole_file = 'MultipoleExpansion\multipoles_harmonic.mat';

settings.coulomb = 1; %Boolean
settings.rf_voltage = 50;
settings.rf_frequency = 35e6;
settings.rf_phase = 0;
settings.duration = 2e-5;
settings.time_step = 1e-9; % Not a simulation step, but returned values
settings.fields = [0,0,0]; % Field potentials in V/m
settings.curvatures = [0,0,1.2e7/4,0,1e6]; % Curvatures in V/m^2
settings.precool = 0;
settings.precool_str = [5e4;5e4;5e4];
settings.precool_time = 1e-2;
%ion_positions = [-3.35,0,3.35]*1e-6;
ion_positions = [-3.05,3.05]*1e-6;

minfunc = @(x)sum((get_rf_gradients(x,settings.rf_multipoles).^2));
settings.min_point = fminunc(minfunc,[0,0,0]);

for i = 1:length(ions)
    settings.ions(i) = create_ion(ions{i});
    settings.ions(i).start_pos(1) = ion_positions(i);
    settings.ions(i).start_pos(2) = settings.min_point(2);
    settings.ions(i).start_pos(3) = settings.min_point(3);
    settings.ions(i).coupling = 0.5*2*pi*1e6;
    settings.ions(i).detuning = -10*2*pi*1e6;
end
%settings.ions(1).coupling = 20*2*pi*1e6;
%settings.ions(1).detuning = -100*2*pi*1e6;
%settings.ions(2).coupling = 0*2*pi*1e6;
%settings.ions(2).detuning = 0*-200*2*pi*1e6;
%settings.ions(1).start_vel = [1,1,.1]*60; % Gives the ion an instantaneous kick
%y_res = zeros(length(0:settings.time_step:settings.duration),length(ions)*6,length(scan_vals));
swap = zeros(length(scan_vals),number_of_repeats);
for i = 1:length(scan_vals)
    for j = 1:number_of_repeats
        disp([scan_vals(i),j])
        rand_ion_number = randi(length(settings.ions));
        rand_direction = rand(3,1);
        rand_direction = rand_direction/norm(rand_direction);
        rand_phase = rand()*2*pi;
        settings.rf_phase = rand_phase;
        settings.ions(2).start_vel = rand_direction*scan_vals(i);
        [t,y] = IonTrajectory_function(settings);
        swap_res = zeros(1,number_of_repeats);
        if y(end,1)>y(end,7)
            swap(i,j) = 1;
            swap_res(j) = 1;
        end
    end
    %save(['Swap_vs_energy_results\swap_result_',num2str(scan_vals(i),5),'.mat'],'settings','swap_res');
end