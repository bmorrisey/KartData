%Get all the kart data

load all_racers
load kart_database_update
%Full_Kart_DB=[0 0 0 0 0];
starting=i;
%format: [kart heatID best_time datenum racer_ID]

for i=starting+2:length(all_racers)
    %for i=1:5
    disp(strcat('Progress(%): ',num2str(100*(i-1)/length(all_racers))))
    [kart_data] = get_karts_from_racer(all_racers(i));
    kart_data = cat(2,kart_data,all_racers(i)*ones(size(kart_data,1),1));
    Full_Kart_DB = cat(1,Full_Kart_DB,kart_data);
    save('kart_database_update.mat','Full_Kart_DB','i');
    clear kart_data
    clc
end

disp(strcat('Progress(%): ',num2str(100*(i-1)/length(all_racers))))