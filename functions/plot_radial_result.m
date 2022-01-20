function [  ] = plot_radial_result( positions,settings,ion_number )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
    if ~exist('ion_number','var')
        ion_number = 1;
    end
    prefactor = settings.ions(ion_number).q/4/settings.ions(ion_number).m/(2*pi*settings.rf_frequency)^2;
    xs = (settings.min_point(3)-50e-6):1e-6:(settings.min_point(3)+50e-6);
    ys = (settings.min_point(2)-10e-6):1e-6:(settings.min_point(2)+90e-6);
    pot_rf = zeros(length(xs),length(ys));
    pot_dc = zeros(length(xs),length(ys));
    for i = 1:length(xs)
        for j = 1:length(ys)
            if strcmp(settings.potential_type,'surface')
                pot_rf(i,j) = sum(surf_trap_rf_gradient(settings.rail_dimensions,[0,ys(j),xs(i)]).^2);
                for k = 1:length(settings.dc_voltages)
                    pot_dc(i,j) = pot_dc(i,j) + surf_trap_dc_potentials([0,ys(j),xs(i)],settings.dc_electrode_positions(k,:),settings.dc_voltages(k));
                end
            elseif strcmp(settings.potential_type,'multipoles')
                pot_rf(i,j) = sum(get_rf_gradients([0,ys(j),xs(i)],settings.rf_multipoles).^2);
                pot_dc(i,j) = create_dc_potential(0,ys(j),xs(i),settings.fields,settings.curvatures,settings.min_point); 
            end
           
        end
    end
    pot_rf = prefactor*pot_rf*settings.rf_voltage^2;
    full_potential = pot_dc + pot_rf;
    if 1
        figure()
        contourf(xs,ys,full_potential',50)
        xax = get(gca,'XLim');
        yax = get(gca,'YLim');
        hold on
        for i = 1:length(settings.ions)
            plot(positions(:,i,2),positions(:,i,3),'r')
        end
        axis([xax,yax])
    end
end
