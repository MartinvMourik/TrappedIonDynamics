function [new_positions,new_speeds] = remove_rf(positions,speeds,settings,pos_it,spd_it)
%     % Doesn't work for removing only RF and not motional freqs. 
%     analysis_size = round(1/settings.rf_frequency/settings.time_step);
%     output = signal;
% 
%     for i = 1:length(signal)
%         if i > analysis_size
%             sig_in = sin(2*pi*settings.rf_frequency*t((i-analysis_size):i)).*signal((i-analysis_size):i);
%             sig_out = cos(2*pi*settings.rf_frequency*t((i-analysis_size):i)).*signal((i-analysis_size):i);
%             U_in = 1/(t(i)-t(i-analysis_size))*sum(sig_in)*settings.time_step;
%             U_out = 1/(t(i)-t(i-analysis_size))*sum(sig_out)*settings.time_step;
%             V_sig = sqrt(U_in^2 + U_out^2);
%             theta = atan(U_out/U_in);
%             rf_signal = 1/2*V_sig(i)*cos(theta(i));
%             output(i) = signal(i) - rf_signal(i);
%         end
%     end
% 
% end
if ~exist('pos_it','var')
    pos_it = positions;
end
if ~exist('spd_it','var')
    std_it = speeds;
end

t = (0:settings.time_step:settings.duration)';
new_positions = zeros(size(positions));
new_speeds = zeros(size(speeds));

for i = 1:length(settings.ions)
    gradients = get_all_rf_gradients(squeeze(pos_it(:,i,:)),settings);
    q = settings.ions(i).q;
    m = settings.ions(i).m;
    w_rf = 2*pi*settings.rf_frequency;
    pos_amplitudes = q*gradients/w_rf^2/m;
    spd_amplitudes = q*gradients/w_rf/m;
    for j = 1:3 
        new_positions(:,i,j) = positions(:,i,j) - pos_amplitudes(:,j).*cos(2*pi*settings.rf_frequency*t + settings.rf_phase);
        new_speeds(:,i,j) = speeds(:,i,j) + spd_amplitudes(:,j).*sin(2*pi*settings.rf_frequency*t + settings.rf_phase);
    end
end
        

        