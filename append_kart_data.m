function output = append_kart_data(filename,ending_heat)
% 
%   OUTPUT: a matrix of kart data with the following columns:
%       [kart heatID best_time heat_datenum driverID]
% 
%   INPUT:
%     filename - REQUIRED, string, filename to save the data:
%       'datafile.mat' is an example.
%     ending_heat - REQUIRED, integer, last heat ID of interest, code assumes
%       heats increase in increments of 1 from starting_heat to ending_heat

if ~exist(filename)
    error(strcat(['Can''t find the specified data file: ',filename])) 
end

load(filename)
starting_heat=max(kart_data(:,2))+1;

if starting_heat>=ending_heat
    % File is already up to date
    disp('The data file looks to be up-to-date')
    return
end

output = kart_data_master(starting_heat,ending_heat,0,filename);