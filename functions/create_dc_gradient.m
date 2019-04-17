function [ dc ] = create_dc_gradient( position,field,curvatures,center)
%CREATE_DC_POTENTIAL Summary of this function goes here
%   Detailed explanation goes here
    X = position(1) - center(1);
    Y = position(2) - center(2);
    Z = position(3) - center(3);
    dc_E_x = field(1) + curvatures(2)*Z + curvatures(3)*4*X + curvatures(4)*Y;
    dc_E_y = field(2) + curvatures(1)*Z - curvatures(3)*2*Y + curvatures(4)*X + curvatures(5)*2*Y;
    dc_E_z = field(3) + curvatures(1)*Y + curvatures(2)*X - curvatures(3)*2*Z - curvatures(5)*2*Z;
    dc = [dc_E_x,dc_E_y,dc_E_z];
end

