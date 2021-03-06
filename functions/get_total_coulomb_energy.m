function coulomb_potential = get_total_coulomb_energy(positions,settings,smoothing)
eps = 8.854e-12;
ion_settings = settings.ions;
no_of_ions = length(ion_settings);
if ndims(positions) == 3
    coulomb_potential = zeros(1,length(positions));
    for l = 1:length(positions)
        for k = 1:no_of_ions
            ion_pos = positions(l,k,:);
            %for i = 1:no_of_ions
            for i = (k+1):no_of_ions
                if i~=k
                    r = sqrt((ion_pos(1)-positions(l,i,1))^2+(ion_pos(2)-positions(l,i,2))^2 + ...
                        (ion_pos(3)-positions(l,i,3))^2);
                    coulomb_potential(l) = coulomb_potential(l) + 1/(4*pi*eps)*ion_settings(k).q*ion_settings(i).q/(r);
                end
            end
        end
    end
else
    coulomb_potential = 0;
    for k = 1:no_of_ions
        ion_pos = positions(:,k);
        for i = 1:no_of_ions
            if i~=k
                r = sqrt((ion_pos(1)-positions(1,i))^2+(ion_pos(2)-positions(2,i))^2 + ...
                    (ion_pos(3)-positions(3,i))^2);
                coulomb_potential = coulomb_potential + 1/(4*pi*eps)*ion_settings(k).q*ion_settings(i).q/(r);
            end
        end
    end
end
%coulomb_potential = coulomb_potential'/2;
coulomb_potential = transpose(coulomb_potential);
if smoothing
    coulomb_potential = smooth(coulomb_potential,round(2/settings.rf_frequency/settings.time_step));
end