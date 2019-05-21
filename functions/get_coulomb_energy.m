function coulomb_potential = get_coulomb_energy(positions,ion_number,ion_settings)
[~,no_of_ions] = size(positions);
ion_pos = positions(:,ion_number);

eps = 8.854e-12;
coulomb_potential = 0;
for i = 1:no_of_ions
    if i~=ion_number
        r = sqrt((ion_pos(1)-positions(1,i))^2+(ion_pos(2)-positions(2,i))^2 + ...
            (ion_pos(3)-positions(3,i))^2);
        coulomb_potential = coulomb_potential + 1/(4*pi*eps)*ion_settings(ion_number).q*ion_settings(i).q/(r);
    end
end