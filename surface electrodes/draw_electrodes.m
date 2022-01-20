function draw_electrodes(electrode_positions,rf_electrodes,voltages)
    addpath('C:\Users\marti\Documents\MATLAB\colormaps\cbrewer\cbrewer');
    [no_of_electrodes,~] = size(electrode_positions);
    if length(voltages) == 1
        voltages = ones(1,no_of_electrodes);
    end
    figure()
    hold on
    colors = cbrewer('div','RdBu',64);
    for i = 1:no_of_electrodes
        color_no = ceil((0.98*voltages(i)/max(abs(voltages))+1)*32);
        rectangle('Position',[electrode_positions(i,1),electrode_positions(i,3),electrode_positions(i,2)-electrode_positions(i,1),electrode_positions(i,4)-electrode_positions(i,3)],'FaceColor',colors(color_no,:));
    end
    ext = max(electrode_positions(:,4));
    rectangle('Position',[-rf_electrodes(1)/2-rf_electrodes(2),-ext, rf_electrodes(2),2*ext],'FaceColor',[0.3010 0.7450 0.9330]);
    rectangle('Position',[rf_electrodes(1)/2,-ext, rf_electrodes(2),2*ext],'FaceColor',[0.3010 0.7450 0.9330]);
    boxmax = max([get(gca,'XLim'),get(gca,'YLim')]);
    axis([-boxmax,boxmax,-boxmax,boxmax])
    set(gca,'PlotBoxAspectRatio',[1,1,1])
end