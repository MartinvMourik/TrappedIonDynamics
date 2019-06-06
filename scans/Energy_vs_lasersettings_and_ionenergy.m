clear
addpath('..\functions\');

% Select ion chain
ions = {'Ca','Ca'};
initial_vel = 140;%linspace(100,140,20);
couplings = [10];
detunings = [-20];
initial_phase = 0;%linspace(0,1,30);

kb = 1.38064852e-23;

% Choose the file that defines the RF potential. This is a vector that
% contains 25 values, corresponding to the first 25 spherical harmonic
% potentials. Index 9 corresponds to an x^2 - y^2 potential, the typical RF
% saddle-type potential. The 'multipoles_harmonic' file contains only this.
% TODO: files should be allowed to be arbitrarily long.
settings.multipole_file = '..\multipoles\multipoles_sandia.mat';
load(settings.multipole_file)
settings.rf_multipoles = multipoles;

% The following settings need to be set
settings.coulomb = 1; %Boolean. Turn coulomb potential on or off
settings.rf_voltage = 50;
settings.rf_frequency = 35e6;
settings.rf_phase = 0;
settings.duration = 1e-2;
settings.time_step = 1e-9; % Not a simulation step, but returned values
settings.fields = [0,0,0]; % Field potentials in V/m
settings.curvatures = [0,0,1.2e7/4,0,1e7]; % Curvatures in V/m^2
settings.precool = 0; % Boolean. Does a non-physical damping, to help get ions in equilibrium positions
settings.precool_str = [1e6;1e6;1e6];
settings.precool_time = 1e-6;
ion_positions = [-3.1,3.1]*1e-6; % Initial positions along trap axis
% The following finds the RF minimum point of the chosen multipole file.
% The DC spherical harmonics are build around this point.
minfunc = @(x)sum((get_rf_gradients(x,settings.rf_multipoles).^2));
settings.min_point = fminunc(minfunc,[0,0,0]);

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
    settings.ions(i).coupling = 25*2*pi*1e6;
    settings.ions(i).detuning = -22*2*pi*1e6;
end

energy_decay = zeros(length(initial_vel),length(couplings),length(detunings),length(initial_phase));
energy_start = zeros(length(initial_vel),length(couplings),length(detunings),length(initial_phase));

figure()
for i = 1:length(initial_vel)
    for j = 1:length(couplings)
        for k = 1:length(detunings)
            for n = 1:length(initial_phase)
                settings.ions(1).start_vel = [1,1,1]*initial_vel(i);
                settings.rf_phase = 2*pi*initial_phase(n);
                for m = 1:length(ions)
                    settings.ions(m).coupling = couplings(j)*2*pi*1e6;
                    settings.ions(m).detuning = detunings(k)*2*pi*1e6;
                end
                % Starts scan
                [t,y] = IonTrajectory_function(settings);
                en = get_total_energy(y,settings);
                %fitres = fit(t,en/kb,'exp1','StartPoint',[1e-3,-1e-4]);
                fitres = polyfit(t,en/kb,1);
                energy_start(i,j,k,n) = fitres(2);
                energy_decay(i,j,k,n) = fitres(1);
                clf
                hold on
                plot(t,en/kb);
                plot(t,polyval(fitres,t),'--')
                drawnow
                % y is a vector that contains [3 positions, 3 velocities, 3 positions, 3
                % velocities...] alternating through ions.

                % Sort y into nicer vectors of dimension [number of points,number of ions,3
                % dimension], for speed and position
                %[positions,speeds] = get_position_and_speed(y,settings);
            end
        end
    end
end

% en = get_total_energy(y,settings);
