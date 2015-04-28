function [racer_list, lap_table] = get_laptimes_from_race(race_ID)
%[racer_list, lap_table] = get_laptimes_from_race(race_ID)
% 
%   OUTPUT:
%     racer_list - an nx1 cell array with names of the racers from the heat
%     lap_table - an nxm matrix with lap times.
%           n = racers, same order as racer_list
%           m = laps, first through last
% 
%   INPUT:
%     heat_ID - REQUIRED, integer, heat ID of interest

addpath(genpath(pwd))

url_name = strcat('http://mb21000oaks.clubspeedtiming.com/sp_center/HeatDetails.aspx?HeatNo=',  num2str(race_ID));
dead_rows = 7; %Number of rows in the first table that are not actual racers

racers = get_racers_from_race(race_ID); %The order of racers in this list is the finishing order
% out_table = getTableFromWeb_mod(url_name,1);

num_racers = length(racers);

lap_table=[];
racer_list={};

for racer = 2:num_racers+1
    %Table numbers start at 2 and there is one per racer (go to racers+1)
    
    racer_table = getTableFromWeb_mod(url_name,racer);
    racer_list{racer-1,1}=racer_table{1,1};
    %Parse the table to get the actual laptimes
    laptimes=strsplit([racer_table{3:size(racer_table,1),2}],{' ','[',']'});
    current_racer_place=laptimes{2};
    laptimes=laptimes(1,1:2:end-1);
    laptimes=strjoin(laptimes,' ');
    laptimes=str2num(laptimes);
    if length(laptimes)<size(lap_table,2)
        %not enough laps for this racer, need to pad times
        laptimes=[laptimes,100*ones(1,size(lap_table,2)-length(laptimes))];
    end
    
    if length(laptimes)>size(lap_table,2)
        %this racer had more laps than other racers
        lap_table=[lap_table,100*ones(size(lap_table,1),1)];
    end
    
    lap_table=[lap_table;laptimes];
end