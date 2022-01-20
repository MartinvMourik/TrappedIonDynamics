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
    if settings.coulomb == 1
        coulomb(i,:) = get_coulomb_force(positions,i,settings.ions);
    end
    
    if isfield(settings,'curvatures_lims')
        curvatures = (settings.curvatures_lims(2,:)-settings.curvatures_lims(1,:))/settings.duration*t + settings.curvatures_lims(1,:);
    else
        curvatures = settings.curvatures;
    end

    if ~isfield(settings,'pseudopotential')
        settings.pseudopotential = 0;
    end
    if strcmp(settings.potential_type,'multipoles')
        if settings.pseudopotential
            efields = 8*settings.rf_multipoles(9)^2*settings.rf_voltage^2*[0,positions(2,i),positions(3,i)];
            rf(i,:) = settings.ions(i).q/(4*settings.ions(i).m*(2*pi*settings.rf_frequency)^2)*efields;
            dc(i,:) = create_dc_gradient(positions(:,i),settings.fields,curvatures,settings.min_point);
        else        
            rf(i,:) = get_rf_gradients( positions(:,i),settings.rf_multipoles);
            dc(i,:) = create_dc_gradient(positions(:,i),settings.fields,curvatures,settings.min_point);
        end
    elseif strcmp(settings.potential_type,'surface')
        % TODO: include pseudopotential option
        rf(i,:) = surf_trap_rf_gradient(settings.rail_dimensions,positions(:,i));
        %dc(i,:) = create_dc_gradient(positions(:,i),settings.fields,curvatures,settings.min_point);
        dc(i,:) = surf_trap_dc_gradient(positions(:,i),settings.dc_electrode_positions,settings.dc_voltages);
    end
    
    if settings.precool && settings.precool_time > t
        damping(i,:) = -settings.ions(i).m*transpose(settings.precool_str.*velocities(:,i));
    else
        damping(i,:) = get_damp_forces(velocities(:,i),settings.ions(i));
    end
end
if ~settings.pseudopotential
    rf = rf*settings.rf_voltage*cos(2*pi*settings.rf_frequency*t + settings.rf_phase);
end
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
if max(abs(positions(:)))>1e-3
    output = NaN(length(output),1);
end