function output = ion_diff_equation(x,t,settings)
no_of_ions = length(x)/6;
x_rsh = reshape(x,[6,no_of_ions]);
positions = x_rsh(1:3,:);
velocities = x_rsh(4:6,:);

coulomb = zeros(no_of_ions,3);
dc = zeros(no_of_ions,3);
rf = zeros(no_of_ions,3);
damping = zeros(no_of_ions,3);
force = zeros(no_of_ions,3);

for i = 1:no_of_ions
    coulomb(i,:) = get_coulomb_force(positions,i,settings.ions);
    dc(i,:) = create_dc_gradient(positions(:,i),settings.fields,settings.curvatures,settings.min_point);
    rf(i,:) = get_rf_gradients( positions(:,i),settings.rf_multipoles);
    if settings.precool && settings.precool_time > t
        damping(i,:) = -settings.ions(i).m*transpose(settings.precool_str.*velocities(:,i));
    else
        damping(i,:) = get_damp_forces(velocities(:,i),settings.ions(i));
    end
end    
rf = rf*settings.rf_voltage*cos(2*pi*settings.rf_frequency*t);
etot = -dc - rf;
for i = 1:no_of_ions
    force(i,:) = etot(i,:) * settings.ions(i).q / settings.ions(i).m...
        + damping(i,:) / settings.ions(i).m...
        + coulomb(i,:) / settings.ions(i).m;
end
out_mat = zeros(6,no_of_ions);
out_mat(1:3,:) = velocities;
out_mat(4:6,:) = force';

output = out_mat(:);
