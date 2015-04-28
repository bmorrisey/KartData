function [racers, qual_times] = get_qualtimes_from_race(race_ID)
%[racer_list, lap_table] = get_laptimes_from_race(race_ID)
%
%   OUTPUT:
%     racers - array with IDs of the racers from the heat
%     qual_times - array with qual times. Qual time is avg of 3 fast laps
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
table_order=[];

for racer = 2:num_racers+1
    %Table numbers start at 2 and there is one per racer (go to racers+1)
    
    racer_table = getTableFromWeb_mod(url_name,racer);
    %Parse the table to get the actual laptimes
    laptimes=strsplit([racer_table{3:size(racer_table,1),2}],{' ','[',']'});
    current_racer_place=str2num(laptimes{2});
    table_order=[table_order, current_racer_place];
    laptimes=laptimes(1,1:2:end-1);
    laptimes=strjoin(laptimes,' ');
    laptimes=str2num(laptimes);
    if length(laptimes)<size(lap_table,2)
        %not enough laps for this racer, need to pad times
        laptimes=[laptimes,100*ones(1,size(lap_table,2)-length(laptimes))];
    end
    
    if length(laptimes)>size(lap_table,2)
        %this racer had more laps than other racers
        lap_table=[lap_table,100*ones(size(lap_table,1),length(laptimes)-size(lap_table,2))];
    end
    lap_table=[lap_table;laptimes];
end

if num_racers>1
    lap_table=sortrows(lap_table,table_order);
end

%Sort each row of the lap table individually from fastest to slowest.
lap_table=sort(lap_table,2);

%make array of avg of best 3 laptimes
qual_times=mean(lap_table(:,1:3),2);
