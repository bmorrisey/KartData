%% Intro
% This script creates a csv leaderboard of racers
clear all
close all
clc
%% Input and Config
% Load the mat file created by kart_data_master.m
load 2015_Race_Data_Initial
%kart_data: [kart heatID best_time datenum racer_ID RPM]

start_date='03-20-2015';
% start_date=datestr(min(kart_data(:,4)));

% end_date='03-30-2015';
end_date=datestr(max(kart_data(:,4)));

% AV_Racers = { racerID, racerName, unused }
AV_Racers={...
    1003786,    'Tyler Durden', 1;
    1024723,    'JeffRod',      1;
    1073028,    'TBall',        1;
    1113917,    'XPLRITT',      1;
    1150608,    'Kamil',        1;
    6390,       'Aeronaut',     1;
    1098385,    'LINZ',         1;
    1186403,    'Clint W',      1;
    73742,      'Master P',     1;
    25956,      'K Dub 217',    1;
    1073030,    'BMO',          1;
    1075125,    'Darkwing48',   1;
    6376,       'Dr. Drift',    1;
    26605,      'Podolski',     1;
    1152050,    'Loay',         1;
    1061761,    'Ruggi',        1;
    1153138,    'Rogdor',       1;
    1186656,    'rocketman',    1;
    1186655,    'April Fuelz',  1;
    1186654,    'Jomama',       1;
    1186404,    'Toaster',      1;
    1448,       'Snow Racer',   1};

%% 

%clean up date inputs
start_date=datestr(start_date,1);
end_date=datestr(end_date,1);

% Collect heats with AV Racers
heats=[];
heats=unique(kart_data(  ismember(kart_data(:,5),[AV_Racers{:,1}])&...
                                    kart_data(:,4)>=datenum(start_date)&...
                                    kart_data(:,4)<=(datenum(end_date)+1),...
                              2));

% Prepare the time variables in case a racer hasn't logged laps
Best_Three = 100*ones(size(AV_Racers,1),3);
Mean_Best = mean(Best_Three,2);

% Search through heats for laptimes
for i=1:length(heats)
    disp(strcat('Progress (%): ',num2str(100*(i-1)/length(heats))))
    [racer_list, lap_table] = get_laptimes_from_race(heats(i));
    
    % Check racer list from the heat for racers in our list
    for j=1:size(lap_table,1)
        racer_ind = find(any(strcmp(AV_Racers,racer_list{j}),2),1);
        if isempty(racer_ind)
            continue
        end
        
        % Save fastest 3 laptimes
        laps=sort([Best_Three(racer_ind,:),lap_table(j,:)],2);
        Best_Three(racer_ind,:)=laps(1:3);
    end
    
    clc
end
        
% Calculate qual time as average of best 3 laps in time period
Mean_Best = mean(Best_Three,2);

% Sort racer list, and times in order of best qual time
[Mean_Best,order]=sort(Mean_Best);
Best_Three = Best_Three(order,:);
Leaders = AV_Racers(order,:);


% Print Leaderboard to CSV
filename=strcat('leaderboard_',datestr(date,'YYmmdd'),'.csv');
fileID = fopen(filename,'w');
formatSpec = '%s,%5.3f,%5.3f,%5.3f,%5.3f\n';
fprintf(fileID,'%s,%s,%s,%s,%s\n','Racer','Qual Time (s)','Fast Lap 1','Fast Lap 2','Fast Lap 3');
for row = 1:length(Mean_Best)
    fprintf(fileID,formatSpec,Leaders{row,2},Mean_Best(row),Best_Three(row,:));
end
fclose(fileID);

disp(strcat(['Created file ',filename,' in current directory.']))