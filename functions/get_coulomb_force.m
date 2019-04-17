function coulomb_force = get_coulomb_force(positions,ion_number,ion_settings)
[~,no_of_ions] = size(positions);
ion_pos = positions(:,ion_number);

coul_x = 0;
coul_y = 0;
coul_z = 0;
eps = 8.854e-12;
for i = 1:no_of_ions
    if i~=ion_number
        r = sqrt((ion_pos(1)-positions(1,i))^2+(ion_pos(2)-positions(2,i))^2 + ...
            (ion_pos(3)-positions(3,i))^2);
        coulomb = 1/(4*pi*eps)*ion_settings(ion_number).q*ion_settings(i).q/(r^2);
        coul_x = coul_x + coulomb*(ion_pos(1)-positions(1,i))/r;
        coul_y = coul_y + coulomb*(ion_pos(1)-positions(1,i))/r;
        coul_z = coul_z + coulomb*(ion_pos(1)-positions(1,i))/r;
    end
end
coulomb_force = [coul_x,coul_y,coul_z];