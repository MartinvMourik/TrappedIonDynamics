function [positions,speeds] = get_position_and_speed( y,settings )
%GET_POSITION_AND_SPEED Summary of this function goes here
%   Detailed explanation goes here
no_of_ions = length(settings.ions);

positions = zeros(length(y),no_of_ions,3);
speeds = zeros(length(y),no_of_ions,3);

positionnumbers = 1:6:6*length(settings.ions);
positions(:,:,1) = y(:,positionnumbers);
positions(:,:,2) = y(:,positionnumbers+1);
positions(:,:,3) = y(:,positionnumbers+2);
speeds(:,:,1) = y(:,positionnumbers+3);
speeds(:,:,2) = y(:,positionnumbers+4);
speeds(:,:,3) = y(:,positionnumbers+5);
