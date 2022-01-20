electrode_length = 100; %length along axis
electrode_width = 200; 
number_of_electrodes = 7; %per side, exl central
rf_width = 50;
central_width = 100;
central_length = 2000;
x_ext = central_width/2 + rf_width + electrode_width;
y_ext = number_of_electrodes*electrode_length/2;

electrode_positions = zeros(number_of_electrodes*2+1,4);
for i = 1:number_of_electrodes
    electrode_positions(i,1) = -x_ext;
    electrode_positions(i,2) = -x_ext+electrode_width;
    electrode_positions(i,3) = -y_ext+(i-1)*electrode_length;
    electrode_positions(i,4) = -y_ext+i*electrode_length;
end
for i = (number_of_electrodes+1):number_of_electrodes*2
    electrode_positions(i,1) = x_ext-electrode_width;
    electrode_positions(i,2) = x_ext;
    electrode_positions(i,3) = -y_ext+(i-1-number_of_electrodes)*electrode_length;
    electrode_positions(i,4) = -y_ext+(i-number_of_electrodes)*electrode_length;
end
electrode_positions(end,1) = -central_width/2;
electrode_positions(end,2) = central_width/2;
electrode_positions(end,3) = -central_length/2;
electrode_positions(end,4) = central_length/2;

electrode_positions = electrode_positions*1e-6;
rf_electrodes = [central_width,rf_width,rf_width]*1e-6;
save('dc_electrode_positions.mat','electrode_positions');
save('rf_electrode_positions.mat','rf_electrodes');

draw_electrodes(electrode_positions,rf_electrodes,1);