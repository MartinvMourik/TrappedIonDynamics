function [  ] = fourier_plots( positions,figure_number,ion_number)
%FOURIER_PLOTS Summary of this function goes here
%   Detailed explanation goes here
titles = {'Axial','Radial x','Radial y'};
hold on
if ~exist('figure_number','var')
    figure_number = 1;
end
if ~exist('ion_number','var')
    ion_number = 1;
end
figure(figure_number)
for i = 1:3
    subplot(2,3,i)
    title(titles{i});
    semilogy(linspace(0,1e3,length(positions(:,ion_number,1))),abs(fft(positions(:,ion_number,i))));
    hold on
    axis 'auto y'
    axis([0,45,0,1])
    subplot(2,3,i+3)
    semilogy(linspace(0,1e3,length(positions(:,ion_number,1))),abs(fft(positions(:,ion_number,i))));
    hold on
    axis 'auto y'
    axis([0,5,0,1])
    if i == 2
        xlabel('Frequency (MHz)');
    end
end

end

