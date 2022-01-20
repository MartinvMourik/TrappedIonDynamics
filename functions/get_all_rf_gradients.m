function [ gradients ] = get_all_rf_gradients(positions,settings)
if strcmp(settings.potential_type,'surface')
   gradients = surf_trap_rf_gradient_all(settings.rail_dimensions,positions);
   gradients = gradients*settings.rf_voltage;
end
if strcmp(settings.potential_type,'multipoles')

    multipole_terms = settings.rf_multipoles;
    x = positions(:,1);
    y = positions(:,2);
    z = positions(:,3);
    E = zeros(length(positions),25,3);


    E(:,1,1) = 0;
    E(:,1,2) = 0;
    E(:,1,3) = 0;

    E(:,2,1) = 0;
    E(:,2,2) = 0;
    E(:,2,3) = 1;
    E(:,3,1) = 1;
    E(:,3,2) = 0;
    E(:,3,3) = 0;
    E(:,4,1) = 0;
    E(:,4,2) = 1;
    E(:,4,3) = 0;

    E(:,5,1) = 0;
    E(:,5,2) = z;
    E(:,5,3) = y;
    E(:,6,1) = z;
    E(:,6,2) = 0;
    E(:,6,3) = x;
    E(:,7,1) = 4*x;
    E(:,7,2) = -2*y;
    E(:,7,3) = -2*z;
    E(:,8,1) = y; 
    E(:,8,2) = x;
    E(:,8,3) = 0;
    E(:,9,1) = 0;
    E(:,9,2) = 2*y;
    E(:,9,3) = -2*z;

    E(:,10,1) = 0;
    E(:,10,2) = 6*y.*z;
    E(:,10,3) = 3*y.^2 - 3*z.^2;
    E(:,11,1) = y.*z;
    E(:,11,2) = x.*z;
    E(:,11,3) = x.*y;
    E(:,12,1) = 8*x.*z;
    E(:,12,2) = -2*y.*z;
    E(:,12,3) = 4*x.^2 - y.^2 - 3*z.^2;
    E(:,13,1) = 6*x.^2 - 3*y.^2 - 3*z.^2; 
    E(:,13,2) = -3*y.*x;
    E(:,13,3) = -3*x.*z;
    E(:,14,1) = 8*x.*y;
    E(:,14,2) = 4*x.^2 - 3*y.^2 - z.^2;
    E(:,14,3) = -2*z.*y;
    E(:,15,1) = y.^2 - z.^2; 
    E(:,15,2) = 2*y.*x;
    E(:,15,3) = -2*x.*z;
    E(:,16,1) = 0;
    E(:,16,2) = 3*y.^2 - 3*z.^2;
    E(:,16,3) = -6*z.*y;

    E(:,17,1) = 0;
    E(:,17,2) = 3*y.^2.*z - z.^3;
    E(:,17,3) = y.^3 - 3.*y.*z.^2;
    E(:,18,1) = 3.*y.^2.*z - z.^3;
    E(:,18,2) = 6*x.*y.*z;
    E(:,18,3) = 3*x.*(y.^2 - z.^2);
    E(:,19,1) = 12*x.*y.*z;
    E(:,19,2) = -z.*(-6*x.^2 + 3*y.^2 + z.^2);
    E(:,19,3) = -y.*(-6*x.^2 + y.^2 + 3*z.^2);
    E(:,20,1) = -3*z.*(-4*x.^2 + y.^2 + z.^2); 
    E(:,20,2) = -6*x.*y.*z;
    E(:,20,3) = x.*(4*x.^2 - 3*(y.^2 + 3*z.^2));
    E(:,21,1) = 16*x.*(2*x.^2 - 3*(y.^2 + z.^2));
    E(:,21,2) = 12*y.*(-4*x.^2 + y.^2 + z.^2);
    E(:,21,3) = 12*z.*(-4*x.^2 + y.^2 + z.^2);
    E(:,22,1) = -3*y.*(-4*x.^2 + y.^2 + z.^2); 
    E(:,22,2) = x.*(4*x.^2 - 3*(3*y.^2 + z.^2));
    E(:,22,3) = -6*x.*y.*z;
    E(:,23,1) = 12*x.*(y.^2 - z.^2);
    E(:,23,2) = -4*(-3*x.^2.*y + y.^3);
    E(:,23,3) = 4*(-3*x.^2.*z + z.^3);
    E(:,24,1) = y.^3 - 3*y.*z.^2;
    E(:,24,2) = 3*x.*(y.^2-z.^2);
    E(:,24,3) = -6*x.*y.*z;
    E(:,25,1) = 0;
    E(:,25,2) = 4*(y.^3 - 3*y.*z.^2);
    E(:,25,3) = 4*z.*(-3*y.^2 + z.^2);

    gradients = zeros(length(positions),3);
    for i = 1:25
        gradients = gradients + squeeze(E(:,i,:))*multipole_terms(i);
    end
    gradients = gradients*settings.rf_voltage;
end

