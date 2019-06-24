vrf = [100,50,50,50];
y20 = [1.2e1/4,1.2e1/4,1.2e1/2,1.2e1/2];
y22 = [0,0,0,1];
fz = [0.86,0.86,1.22,1.22];
fx = [6.05,2.87,2.8,2.83];
fy = [6.05,2.87,2.8,2.78];

minfunc = @(c)get_calib_error(vrf,y20,y22,fz,fx,fy,c);
minres = fminunc(minfunc,[0.24,10,0,0]);
%minres(4) = minres(4)*2;
display(minfunc(minres))

set_freq = [0.82,1.176,1.355];
minfunc = @(c)get_freq_setting(set_freq,minres,c);
minres_2 = fminunc(minfunc,[30,2,0]);


function error = get_calib_error(vrf,y20,y22,fz,fx,fy,c)
for i = 1:length(vrf)
    fz_g(i) = sqrt(c(1)*y20(i));
    fy_g(i) = sqrt(c(2)*vrf(i)^2 + c(3)*y20(i) + c(4)*y22(i));
    fx_g(i) = sqrt(c(2)*vrf(i)^2 + c(3)*y20(i) - c(4)*y22(i));
end
error = sum((fz_g-fz).^2) + sum((fy_g-fy).^2) + sum((fx_g-fx).^2);
end

function error = get_freq_setting(set_freq,calib,c)
f(1) = sqrt(calib(1)*c(2));
f(2) = sqrt(calib(2)*c(1)^2 + calib(3)*c(2) + calib(4)*c(3));
f(3) = sqrt(calib(2)*c(1)^2 + calib(3)*c(2) - calib(4)*c(3));
error = sum((set_freq - f).^2);
end