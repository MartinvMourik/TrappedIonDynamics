function [t,y] = IonTrajectory_function(settings)

start_vec = zeros(6,length(settings.ions));
for i = 1:length(settings.ions)
    start_vec(1,i) = settings.ions(i).start_pos(1);
    start_vec(2,i) = settings.ions(i).start_pos(2);
    start_vec(3,i) = settings.ions(i).start_pos(3);
    start_vec(4,i) = settings.ions(i).start_vel(1);
    start_vec(5,i) = settings.ions(i).start_vel(2);
    start_vec(6,i) = settings.ions(i).start_vel(3);
end


tic
diff_eq = @(t,x) ion_diff_equation(x,t,settings);
[t,y] = ode113(diff_eq,[0:settings.time_step:settings.duration],start_vec(:));
toc