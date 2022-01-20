function [ voltages ] = get_electrode_voltages( dc_electrode_positions,rf_positions )
%GET_ELECTRODE_VOLTAGES Summary of this function goes here
%   Detailed explanation goes here
%addpath('..\functions\');
boxsize = 10e-6;
boxpoints = 21;
minfunc = @(x)sum((surf_trap_rf_gradient(rf_positions,x).^2));
min_point = fminunc(minfunc,[0,70e-6,0]);

[no_of_electrodes,~] = size(dc_electrode_positions);
voltages = zeros(no_of_electrodes,1);

[X,Y,Z] = meshgrid(linspace(-boxsize,boxsize,boxpoints),linspace(min_point(2)-boxsize,min_point(2)+boxsize,boxpoints),linspace(-boxsize,boxsize,boxpoints));
X = X(:);
Y = Y(:);
Z = Z(:);
electrode_potentials = zeros(length(X),no_of_electrodes);
multipole_potentials = zeros(length(X),9);
for i = 1:length(X)    
    for j = 1:no_of_electrodes
        electrode_potentials(i,j) = surf_trap_dc_potentials([X(i),Y(i),Z(i)],dc_electrode_positions(j,:),1);
    end
end
curvatures = eye(5);
fields = eye(3);
multipole_potentials(:,1) = 1;
for i = 1:3
    multipole_potentials(:,i+1) = create_dc_potential(X,Y,Z,fields(i,:),[0,0,0,0,0],min_point);
end
for i = 1:5
    multipole_potentials(:,i+4) = create_dc_potential(X,Y,Z,[0,0,0],curvatures(i,:),min_point);
end
mult_pot_inv = pinv(multipole_potentials);
mults = zeros(9,no_of_electrodes);
for i = 1:no_of_electrodes
    mults(:,i) = mult_pot_inv*electrode_potentials(:,i);
end
mults(1,:) = 0;
alpha = pinv(mults);
voltages = alpha(:,2:end);
% close all
% for i = 1:8
%     draw_electrodes(dc_electrode_positions,rf_positions,voltages(:,i))
% end

