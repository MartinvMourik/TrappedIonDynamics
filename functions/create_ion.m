function ion_object = create_ion(type)
% Main settings for ions
if strcmp(type,'Ca')
    ion_object.q = 1.60217662e-19;
    ion_object.m = 1.67e-27*40;
    ion_object.gamma = 2*pi*22.3e6; % Spontaneous decay rate
    ion_object.coupling = 25*pi*5e6;
    ion_object.detuning = -40*pi*20e6;
    ion_object.start_pos = [-.002,0,-1.75e-6]*1e-3;
    ion_object.start_vel = [0,0,0];
    ion_object.wavelength = 397e-9;
<<<<<<< .mine
    ion_object.laser_vec = [1,1,.1];

=======
<<<<<<< Updated upstream
    ion_object.laser_vec = [1,.1,1];
>>>>>>> .theirs
=======
    ion_object.laser_vec = [1,1,1];
>>>>>>> Stashed changes
elseif strcmp(type,'Sr')
    ion_object.q = 1.60217662e-19;
    ion_object.m = 1.67e-27*88;
    ion_object.gamma = 2*pi*20.35e6; % Spontaneous decay rate
    ion_object.coupling = 25*pi*5e6;
    ion_object.detuning = -40*pi*20e6;
    ion_object.start_pos = [.002,0,-1.75e-6]*1e-3;
    ion_object.start_vel = [0,0,0];
    ion_object.wavelength = 422e-9;
    ion_object.laser_vec = [1,.1,1];
elseif strcmp(type,'Al')
    ion_object.q = 1.60217662e-19;
    ion_object.m = 1.67e-27*27;
    ion_object.gamma = 0; % Spontaneous decay rate
    ion_object.coupling = 0;
    ion_object.detuning = 0;
    ion_object.start_pos = [.002,0,-1.75e-6]*1e-3;
    ion_object.start_vel = [0,0,0];
    ion_object.wavelength = 1;
    ion_object.laser_vec = [1,0,0];
else
    disp('Incorrect ion type')
    ion_object = [];
end