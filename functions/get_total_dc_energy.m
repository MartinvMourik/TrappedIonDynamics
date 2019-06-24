function [ dc_potential ] = get_total_dc_energy( positions,settings)
    if strcmp(settings.potential_type,'surface')
        dc_potential = surf_trap_total_dc_potentials(positions,settings);
    elseif strcmp(settings.potential_type,'multipoles')
        field = settings.fields;
        curvatures = settings.curvatures;
        charges = zeros(length(settings.ions),1);
        for i = 1:length(settings.ions)
            charges(i,1) = settings.ions(i).q;
        end

        X = positions(:,:,1) - settings.min_point(1);
        Y = positions(:,:,2) - settings.min_point(2);
        Z = positions(:,:,3) - settings.min_point(3);

        dc_potential = zeros(size(X));

        dc_potential = dc_potential + field(1)*X;
        dc_potential = dc_potential + field(2)*Y;
        dc_potential = dc_potential + field(3)*Z;
        dc_potential = dc_potential + curvatures(1)*(Y.*Z);
        dc_potential = dc_potential + curvatures(2)*(Z.*X);
        dc_potential = dc_potential + curvatures(3)*(2*X.^2 - Y.^2 - Z.^2);
        dc_potential = dc_potential + curvatures(4)*(Y.*X);
        dc_potential = dc_potential + curvatures(5)*(Y.^2 - Z.^2);
        dc_potential = dc_potential*charges;
    end
end

