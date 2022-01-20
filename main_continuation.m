addpath('functions\');
addpath('surface electrodes\');

% Select ion chain, should match the ion config in 'last_scan'
ions = {'Ca','Ca'};

load('last_scan')

for i = 1:length(ions)
    settings.ions(i).start_pos(1) = pos_final(1,i,1);
    settings.ions(i).start_pos(2) = pos_final(1,i,2);
    settings.ions(i).start_pos(3) = pos_final(1,i,3);
    settings.ions(i).start_vel(1) = spd_final(1,i,1);
    settings.ions(i).start_vel(2) = spd_final(1,i,2);
    settings.ions(i).start_vel(3) = spd_final(1,i,3);
end
%TODO: Fix RF phase to match phase at end of previous scan

% Starts scan
[t,y] = IonTrajectory_function(settings);
q = 1.60217662e-19;
[positions,speeds] = get_position_and_speed(y,settings);
en = get_total_energy(y,settings)/q;
beep

if 1
    en_cmpr = [en_cmpr;en(1:100:end)];
    t_cmpr = [t_cmpr;t(1:100:end)+t_cmpr(end)];
    pos_final = positions(end,:,:);
    spd_final = speeds(end,:,:);
    save('last_scan','en_cmpr','t_cmpr','pos_final','spd_final')
end

