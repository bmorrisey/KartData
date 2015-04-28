%% Intro
% This script creates a csv leaderboard of racers
% clear all
close all
clc
%% Input and Config
% Load the mat file created by kart_data_master.m
% load 2015_Race_Data_Initial
load 2015_TrackUpdate
%kart_data: [kart heatID best_time datenum racer_ID RPM]

% start_date='03-20-2015';
start_date=datestr(min(kart_data(:,4)));

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
    1430,       'Linz',         1;
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
    1127814,    'Maverick',     1;
    1075127,    'Perci',        1;
    1190047,    '01134MRE',     1;
    1117507,    'Dierks Bently',1;
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
%kart_data: [kart heatID best_time datenum racer_ID RPM]

% Prepare the time variables in case a racer hasn't logged laps
qual_table_alldata=[];

% Search through heats for laptimes, and make a qual_table
% [kart heatID best_time datenum racer_ID RPM qual_time]
for i=1:length(heats)
    disp(strcat('Progress (%): ',num2str(100*(i-1)/length(heats))))
    
    [racers, qual_times] = get_qualtimes_from_race(heats(i));
    for n_racer=1:length(racers)
        qual_table_alldata=[qual_table_alldata;[kart_data(kart_data(:,2)==heats(i)&...
            kart_data(:,5)==racers(n_racer),:), qual_times(n_racer)]];
    end
    
    clc
end

%Trim Qual Table to AV Racers and Applicable Dates
qual_table_alldata=qual_table_alldata(  ismember(qual_table_alldata(:,5),[AV_Racers{:,1}])&...
    qual_table_alldata(:,4)>=datenum(start_date)&...
    qual_table_alldata(:,4)<=(datenum(end_date)+1),...
    :);
%Get list of unique AV Racers
qual_racers=unique(qual_table_alldata(:,5));

%Build a list of [racer date kart qualtime]
qual_table=qual_table_alldata(:,[5,4,1,7]);
qual_table=sortrows(qual_table);



% Print Qual Times to CSV
filename=strcat('qualtimes_',datestr(date,'YYmmdd'),'.csv');
fileID = fopen(filename,'w');
formatSpec = '%s,%u,%s,%u,%5.3f\n';
fprintf(fileID,'%s,%s,%s,%s,%s\n','Racer Name','Racer ID','Date','Kart','QualTime');
for row = 1:size(qual_table,1)
    %     fprintf(fileID,formatSpec,Leaders{row,2},Mean_Best(row),Best_Three(row,:));
    fprintf(fileID,formatSpec,AV_Racers{[AV_Racers{:,1}]==qual_table(row,1),2},...
        qual_table(row,1),...
        datestr(qual_table(row,2),29),...
        qual_table(row,3),...
        qual_table(row,4));
end
fclose(fileID);

disp(strcat(['Created file ',filename,' in current directory.']))


%% Process the Qual table to apply constraints

leaderboard=[]; %
for i=1:length(qual_racers)
    
    %For this racer, make table of qual times, sort by time, then find top
    %three that meet requirements
    data=qual_table(qual_table(:,1)==qual_racers(i),:);
    
    num_races = size(data,1);
    
    % sort by time
    data=[sortrows(data,4),zeros(num_races,1)];
    
    %The first time will be accepted
    times(1)=data(1,4);
    data(1,5)=1;    % Set "choose flag"
    
    if num_races>1
        for nrace=2:num_races
            %if in a different kart, accept the time
            if ~ismember(data(nrace,3),data(data(:,5)==1,3))
                times=[times,data(nrace,4)];
                data(nrace,5)=1;
                
            end
            
            if sum(data(:,5))>=3
                break;
            end
        end
    end
    
    leaderboard=[leaderboard;[qual_racers(i),mean(times),sum(data(:,5))]];
    clear times
    
end
leaderboard = sortrows(leaderboard,2);

% Print Leaderboard to CSV
filename=strcat('leaderboard_',datestr(date,'YYmmdd'),'.csv');
fileID = fopen(filename,'w');
formatSpec = '%s,%u,%5.3f,%u\n';
fprintf(fileID,'%s,%s,%s,%s\n','Racer Name','Racer ID','QualTime','Num Races');
for row = 1:size(leaderboard,1)
    %     fprintf(fileID,formatSpec,Leaders{row,2},Mean_Best(row),Best_Three(row,:));
    fprintf(fileID,formatSpec,AV_Racers{[AV_Racers{:,1}]==leaderboard(row,1),2},...
        leaderboard(row,1),...
        leaderboard(row,2),...
        leaderboard(row,3));
end
fclose(fileID);

disp(strcat(['Created file ',filename,' in current directory.']))