function energy = analyze_energy(y,settings,smoothing)
for i = 1:length(settings.ions)
    positions = (4:6)+6*(i-1);
    energy(:,i) = sum(1/2*settings.ions(i).m*y(:,positions).^2,2);
end
if exist('smoothing')
    for i = 1:length(settings.ions)
        energy(:,i) = smooth(energy(:,i).^2,smoothing);
    end
    energy = sqrt(energy);
end