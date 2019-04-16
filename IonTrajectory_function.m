function [t,y] = IonTrajectory_function(settings)

start_vec = zeros(6,length(settings.ions));
for i = 1:length(settings.ions)
    start_vec(1,i) = settings.ions(i).start_pos(1);
    start_vec(2,i) = settings.ions(i).start_pos(2);
    start_vec(3,i) = settings.ions(i).start_pos(3);
    start_vec(4,i) = settings.ions(i).start_vel(1);
    start_vec(5,i) = settings.ions(i).start_vel(2);
    start_vec(6,i) = settings.ions(i).start_vel(3);
end

% SID: This section finds the RF null. Right now it's finding it using some
% potential file, but should be updated to find the minimum using the
% supplied multipole file

% data = importdata('electrodePotentialsRFWide.txt');
% [X,~,~] = meshgrid(unique(data(:,1))*1e-3,unique(data(:,2))*1e-3,unique(data(:,3))*1e-3);
% grid_size = size(X);
% X = reshape(data(:,1),grid_size)*1e-3;
% Y = reshape(data(:,2),grid_size)*1e-3;
% Z = reshape(data(:,3),grid_size)*1e-3;
% 
% rf_potential = reshape(data(:,4),grid_size);
% min_point = find_rf_min(X,Y,Z,rf_potential);
% settings.min_point = min_point;
minfunc = @(x)sum((get_rf_gradients(x,settings.rf_multipoles).^2));
settings.min_point = fminunc(minfunc,[0,0,0]);
disp("RF null at: ")
disp(settings.min_point)

tic
diff_eq = @(t,x) ion_diff_equation(x,t,settings);
[t,y] = ode113(diff_eq,[0:settings.time_step:settings.duration],start_vec(:));
toc