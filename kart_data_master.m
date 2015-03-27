function output = kart_data_master(starting_heat,ending_heat,save_filename,add_to_file)
%output = kart_data_master(starting_heat,ending_heat,save_filename)
% 
%   OUTPUT: a matrix of kart data with the following columns:
%       [kart heatID best_time heat_datenum driverID]
% 
%   INPUT:
%     starting_heat - REQUIRED, integer, first (or only) heat ID of interest
%     ending_heat - OPTIONAL, integer, last heat ID of interest, code assumes
%       heats increase in increments of 1 from starting_heat to ending_heat
%     save_filename - OPTIONAL, string, filename to save the data:
%       'datafile.mat' is an example.

i=[];

if exist('temp_kart_db.mat')>0
    load temp_kart_db
    starting = i + 1;
else
    kart_data=[0 0 0 0 0 0];
    starting=0;
end

%format: [kart heatID best_time datenum racer_ID]


if nargin<2
    ending_heat = starting_heat;
end

if nargin<4
    add_to_file=[];
end

if ~exist('all_racers')
    all_racers=[];
    
    %Starting with heat of interest (assume incrementing by 1)
    for heat_i=starting_heat:ending_heat
        disp(strcat('Progress 1 of 2 (%): ',num2str(100*(heat_i-starting_heat)/(ending_heat-starting_heat))))
        %Get the racers from the heats
        racer_IDs = get_racers_from_race(heat_i);
        if ~isnan(racer_IDs)
            all_racers = unique([all_racers racer_IDs]);
        end
        
        clc
    end
end


%Get kart history from racers
for i=starting+1:length(all_racers)
    %for i=1:5
    disp(strcat('Progress 2 of 2 (%): ',num2str(100*(i-1)/length(all_racers))))
    [racers_karts,rpm] = get_karts_from_racer(all_racers(i));
    racers_karts = cat(2,racers_karts,...
                       all_racers(i)*ones(size(racers_karts,1),1),...
                       rpm*ones(size(racers_karts,1),1));
    kart_data = cat(1,kart_data,racers_karts);
    save('temp_kart_db.mat','kart_data','i','all_racers');
    clear racers_karts
    clc
end

disp(strcat('Progress(%): ',num2str(100*(i-1)/length(all_racers))))

%Chop kart history to only data we care about
if kart_data(1,1)==0
    kart_data = kart_data(2:end,:);
end
start_datenum=min(kart_data(kart_data(:,2)==starting_heat,4));
end_datenum=min(kart_data(kart_data(:,2)==ending_heat,4));
if size(end_datenum,1)<1
    end_datenum=datenum(date);
end
kart_data=kart_data((kart_data(:,4)>=start_datenum)&(kart_data(:,4)<=end_datenum),:);

%save if desired
if nargin==3
    save(save_filename,'kart_data','all_racers')
end

%cleanup
delete 'temp_kart_db.mat'

%output result
output=kart_data;


%add data to historical file
if add_to_file>0
    kart_data_new=kart_data;
    clear 'kart_data'
    racers_new=all_racers;
    clear 'all_racers'
%     if ~strcmp(add_to_file(end-2:end),'mat')
%         add_to_file=[add_to_file,'.mat'];
%     end
    
    eval(strcat(['load ',add_to_file]))
    
    kart_data=[kart_data;kart_data_new];
    if size(racers_new,1)<size(racers_new,2)
        racers_new=racers_new';
    end
    if size(all_racers,1)<size(all_racers,2)
        all_racers=all_racers';
    end
    all_racers=unique([all_racers;racers_new]);
    save(add_to_file,'kart_data','all_racers')
end

