clear all
close all
clc
%% Input and Config
print_plots=1; % Whether or not to make pngs

% Load the mat file created by kart_data_master.m
% load 2015_Race_Data_Initial
load 2015_TrackUpdate

% start_date='02-27-2015';
% end_date='03-30-2015';
start_date=datestr(min(kart_data(:,4)));
end_date=datestr(max(kart_data(:,4)));

% AV_Racers = { racerID, racerName, plot_flag }
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

rank_basis=[.02:.01:.05];

racer_score_cutoff = 3000; 
%Any racers with scores higher than this value are assumed to be employees
%They are labeled as "pros" and may be removed from the comparison

RacerGroupFlag = 2;
% 1 - compare all racers
% 2 - compare only amateurs
% 3 - compare only pros

highest_kart_number = 26;
fastlim=20;
slowlim=25;

%% Other Code
all_racer_data      = kart_data;
amateur_racer_data  = kart_data(kart_data(:,6)<racer_score_cutoff,:);
pro_racer_data      = kart_data(kart_data(:,6)>=racer_score_cutoff,:);

num_pros=length(unique(pro_racer_data(:,5)))

switch RacerGroupFlag
    case 1
        Full_Kart_DB = all_racer_data;
    case 2
        Full_Kart_DB = amateur_racer_data;
    case 3
        Full_Kart_DB = pro_racer_data;
    otherwise
        warning('Don''t recognize that flag value, using all racers')
        Full_Kart_DB = all_racer_data;
end

%format: [kart heatID best_time datenum racer_ID]
colormap jet
cmap=colormap;
fillmap=colormap('flag');

%Scatterplot of karts entire history (i vector is the karts you want)
for i=[4,5,6,14,23,24]
    plot(Full_Kart_DB(Full_Kart_DB(:,1)==i,4),Full_Kart_DB(Full_Kart_DB(:,1)==i,3),'.','color',[rand(),rand(),rand()],'MarkerSize',20)
    hold on
end
legend('Kart 4','Kart 5','Kart 6','Kart 14','Kart 23','Kart 24')

%clean up date inputs
start_date=datestr(start_date,1);
end_date=datestr(end_date,1);
%Uncomment plot_racerID to highlight specific racer performance. Can be
%single value or vector.
%plot_racerID = 1073030;
%plot_racerID=[1073030 6376 1073028 26601 1003786 1098385 1071716 1084572 1075127 1113917 26605 25956 1117507];
%plot_racerID=[1073030 6376 1073028 1003786 1075127 1113917 1117507];

%Clean Up AV Racer List
AV_Racers = AV_Racers([AV_Racers{:,3}]==1,:);
plot_racerID=[AV_Racers{find([AV_Racers{:,3}]),1}];

Competitors_2013=[906;1448;6376;6544;32201;43121;79990;1003786;1038388;1054900;1071760;1073837;1075127;1098887;1099305;1113723;1113917;1114809;1116183;1116291;1116951;1116952;1117089;1117570;1117636;1118273;1118274;1118728;1118729;1118779;1118793;1118794;1118795;1118796;1118798;1118801;1118803;1118804;1118808;1118809;1118810;1118811;1118812;1118813;1118825;1118831;1119028;1119029;1119030;1119031;1119032;1119033;1119034;1119035;1119036];

%plot_racerID=[plot_racerID,Competitors_2013'];

%Count #runs for each kart in the time span
for i=1:highest_kart_number
    kart_runs(i,1)=size(Full_Kart_DB((Full_Kart_DB(:,1)==i)&(Full_Kart_DB(:,4)>=datenum(start_date))&(Full_Kart_DB(:,4)<=datenum(end_date)+1),:),1);
end


%Plot Kart Performance
figure(2)
plot(Full_Kart_DB((Full_Kart_DB(:,4)>=datenum(start_date))&(Full_Kart_DB(:,4)<=datenum(end_date)+1),1),Full_Kart_DB((Full_Kart_DB(:,4)>=datenum(start_date))&(Full_Kart_DB(:,4)<=datenum(end_date)+1),3),'k*','MarkerSize',5)
if exist('plot_racerID')
    for racer_i = 1:length(plot_racerID)
        hold on
        if size(Full_Kart_DB((Full_Kart_DB(:,4)>=datenum(start_date))&(Full_Kart_DB(:,4)<=datenum(end_date)+1)&(Full_Kart_DB(:,5)==plot_racerID(racer_i)),3))>0
        plot(Full_Kart_DB((Full_Kart_DB(:,4)>=datenum(start_date))&(Full_Kart_DB(:,4)<=datenum(end_date)+1)&(Full_Kart_DB(:,5)==plot_racerID(racer_i)),1),...
             Full_Kart_DB((Full_Kart_DB(:,4)>=datenum(start_date))&(Full_Kart_DB(:,4)<=datenum(end_date)+1)&(Full_Kart_DB(:,5)==plot_racerID(racer_i)),3),...
             'o','LineWidth',2,'MarkerEdgeColor',cmap(floor(length(cmap)*racer_i/length(plot_racerID)),:),'MarkerFaceColor',fillmap(racer_i,:),'MarkerSize',10)
        else
            AV_Racers{racer_i,3}=0;
        end
    end
end
xlim([1,highest_kart_number])
ylim([fastlim,slowlim])
grid on
xlabel('KartNumber','FontSize',14,'FontWeight','b')
ylabel('Best Lap Time','FontSize',14,'FontWeight','b')
title({'Best Lap Times During Period';strcat([start_date,' to ',end_date])},'FontSize',16,'FontWeight','b')
legend('All Racers',AV_Racers{vertcat(AV_Racers{:,3}) > 0,2},'Location','EastOutside')



%Plot Kart Performance, color by date
figure(3)
scatter(Full_Kart_DB((Full_Kart_DB(:,4)>=datenum(start_date))&(Full_Kart_DB(:,4)<=datenum(end_date)+1),1),Full_Kart_DB((Full_Kart_DB(:,4)>=datenum(start_date))&(Full_Kart_DB(:,4)<=datenum(end_date)+1),3),55,Full_Kart_DB((Full_Kart_DB(:,4)>=datenum(start_date))&(Full_Kart_DB(:,4)<=datenum(end_date)+1),4),'filled')
% if exist('plot_racerID')
%     for racer_i = 1:length(plot_racerID)
%         hold on
%         plot(Full_Kart_DB((Full_Kart_DB(:,4)>=datenum(start_date))&(Full_Kart_DB(:,4)<=datenum(end_date)+1)&(Full_Kart_DB(:,5)==plot_racerID(racer_i)),1),Full_Kart_DB((Full_Kart_DB(:,4)>=datenum(start_date))&(Full_Kart_DB(:,4)<=datenum(end_date)+1)&(Full_Kart_DB(:,5)==plot_racerID(racer_i)),3),'o','LineWidth',2,'MarkerEdgeColor',cmap(floor(length(cmap)*racer_i/length(plot_racerID)),:),'MarkerFaceColor',fillmap(racer_i,:),'MarkerSize',10)
%     end
% end
xlim([1,highest_kart_number])
ylim([16,21])
grid on
xlabel('KartNumber','FontSize',14,'FontWeight','b')
ylabel('Best Lap Time','FontSize',14,'FontWeight','b')
title({'Best Lap Times During Period';strcat([start_date,' to ',end_date])},'FontSize',16,'FontWeight','b')
colorbar
cbar_vals=get(colorbar,'YTick');

cbar_label_struct={};
for i=1:length(cbar_vals)
    
    cbar_label_struct{1,i}=datestr(cbar_vals(i));
    
end
hcb = colorbar('YTickLabel',...
    cbar_label_struct);
set(hcb,'YTickMode','manual')

%Rate the karts
rankchanges=[];
plotrankdata=[];
plot_times=[];
for pct=rank_basis
    for i=1:highest_kart_number
        top_pct=pct;
        times=Full_Kart_DB((Full_Kart_DB(:,4)>=datenum(start_date))&(Full_Kart_DB(:,4)<=datenum(end_date)+1)&(Full_Kart_DB(:,1)==i),3);
        times=times(times>=16);
        if length(times)==0
            times=slowlim; %There were no times logged on this kart so set one slow race
        end
        times=sort(times);
        rank_time(i)=mean(times(1:max(1,round(length(times)*top_pct))));
    end
    ranks=sortrows([[1:highest_kart_number]',rank_time'],2);
    for i=1:highest_kart_number
        rankposition(i)=find(ranks(:,1)==i);
    end
    times_sorted_by_kart=sortrows(ranks,1);
    plot_times=[plot_times, times_sorted_by_kart(:,2)];
    plotrankdata=[plotrankdata, rankposition'];
    rankchanges=[rankchanges,ranks(:,1)];
end
rankchanges;

figure(5)
subplot(1,2,2)
for i=1:highest_kart_number
    ranking_color(i,:)=[rand(), rand(), rand()];
    plot(100*rank_basis,plotrankdata(i,:),'color',ranking_color(i,:),'LineWidth',4)
    hold on
    text(100*max(rank_basis),plotrankdata(i,end),num2str(i),'fontweight','b','fontsize',20)
end
grid on
xlabel('Rank Basis (what percent of top times)','FontSize',14,'FontWeight','b')
ylabel('Rank','FontSize',14,'FontWeight','b')
%title({'Sensitivity of Ranking';strcat(['From ',start_date,' to ',end_date])},'FontSize',16,'FontWeight','b')


%plot time on the vertical axis and basis on the horizontal
figure(5)
subplot(1,2,1)
for i=1:highest_kart_number
    plot(100*rank_basis,plot_times(i,:),'color',ranking_color(i,:),'LineWidth',4)
    hold on
    text(100*max(rank_basis),plot_times(i,end),num2str(i),'fontweight','b','fontsize',20)
end
grid on
xlabel('Rank Basis (what percent of top times)','FontSize',14,'FontWeight','b')
ylabel('Mean Best Time (s)','FontSize',14,'FontWeight','b')
figure(5)
title({'Sensitivity of Ranking';strcat(['From ',start_date,' to ',end_date])},'FontSize',16,'FontWeight','b')
h=figure(5);
set(h,'Position',[465 474 633 632])
set(h,'PaperPositionMode','auto')

%Plot time on the vertical axis and kart rank on the horizontal
plot_index=0;
for pct=rank_basis(end)
    plot_index = plot_index+1;
    for i=1:highest_kart_number
        top_pct=pct;
        times=Full_Kart_DB((Full_Kart_DB(:,4)>=datenum(start_date))&(Full_Kart_DB(:,4)<=datenum(end_date)+1)&(Full_Kart_DB(:,1)==i),3);
        times=times(times>=16);
        if length(times)==0
            times=slowlim; %There were no times logged on this kart so set one slow race
        end
        times=sort(times);
        rank_time(i)=mean(times(1:max(1,round(length(times)*top_pct))));
        std_time(i)=std(times(1:max(1,round(length(times)*top_pct))));
        max_time(i)=max(times(1:max(1,round(length(times)*top_pct))));
        min_time(i)=min(times(1:max(1,round(length(times)*top_pct))));
    end
    ranks=sortrows([[1:highest_kart_number]',rank_time',std_time',max_time',min_time'],2);
    figure(7)
    %subplot(1,4,plot_index)
    plot(ranks(:,2),'-bo','LineWidth',2,...
                'MarkerEdgeColor','k',...
                'MarkerFaceColor',[.49 1 .63],...
                'MarkerSize',5)
    hold on
    errorbar(ranks(:,2),ranks(:,3),'.r')
    hold on
    plot(ranks(:,4),'k*')
    hold on
    plot(ranks(:,5),'k*')
    for i=1:highest_kart_number
        text(i,ranks(i,2),num2str(ranks(i,1)),'color','m','fontweight','b','fontsize',12,'horizontalAlignment','right','verticalAlignment','baseline')
    end
    
    
end
xlim([1,highest_kart_number])
grid on
xlabel('Kart Rank','FontSize',12,'FontWeight','b')
ylabel('Mean Best Time (s)','FontSize',12,'FontWeight','b')
title({strcat(['Kart Ranking for Top ',num2str(100*rank_basis(end)),'% of Times']);strcat(['From ',start_date,' to ',end_date])},'FontSize',14,'FontWeight','b')
h=figure(7);
set(h,'Position',[6 683 458 423])
set(h,'PaperPositionMode','auto')

figure(2)
errorbar(rank_time,std_time,'.r')
h=figure(2);
set(h,'Position',[1100 474 659 632])
set(h,'PaperPositionMode','auto')

if print_plots==1
    figure(2)
    datestamp=datestr(date,29);
    eval(strcat(['print -dpng -r300 ''',datestamp,'_RacerPerformance.png''']))
    figure(5)
    eval(strcat(['print -dpng -r300 ''',datestamp,'_KartRankingSensitivity.png''']))
    figure(7)
    eval(strcat(['print -dpng -r300 ''',datestamp,'_KartTiers.png''']))
end


%TEST RACER RPM
figure(8)
scatter(Full_Kart_DB((Full_Kart_DB(:,4)>=datenum(start_date))&(Full_Kart_DB(:,4)<=datenum(end_date)+1),1),...
        Full_Kart_DB((Full_Kart_DB(:,4)>=datenum(start_date))&(Full_Kart_DB(:,4)<=datenum(end_date)+1),3),...
        55,...
        Full_Kart_DB((Full_Kart_DB(:,4)>=datenum(start_date))&(Full_Kart_DB(:,4)<=datenum(end_date)+1),6),...
        'filled')
    
xlim([1,highest_kart_number])
ylim([16,24])
grid on
xlabel('KartNumber','FontSize',14,'FontWeight','b')
ylabel('Best Lap Time','FontSize',14,'FontWeight','b')
title({'Best Lap Times During Period';strcat([start_date,' to ',end_date])},'FontSize',16,'FontWeight','b')
colorbar
% cbar_vals=get(colorbar,'YTick');
% 
% cbar_label_struct={};
% for i=1:length(cbar_vals)
%     
%     cbar_label_struct{1,i}=datestr(cbar_vals(i));
%     
% end
% hcb = colorbar('YTickLabel',...
%     cbar_label_struct);
% set(hcb,'YTickMode','manual')


%Plot last year's competitors
%Plot Kart Performance
figure(9)
h_all=plot(Full_Kart_DB((Full_Kart_DB(:,4)>=datenum(start_date))&(Full_Kart_DB(:,4)<=datenum(end_date)+1),1),...
     Full_Kart_DB((Full_Kart_DB(:,4)>=datenum(start_date))&(Full_Kart_DB(:,4)<=datenum(end_date)+1),3),...
     'k*','MarkerSize',5);
if exist('Competitors_2013')
    for racer_i = 1:length(Competitors_2013)
        hold on
        if size(Full_Kart_DB((Full_Kart_DB(:,4)>=datenum(start_date))&(Full_Kart_DB(:,4)<=datenum(end_date)+1)&(Full_Kart_DB(:,5)==Competitors_2013(racer_i)),3))>0
        h_Competitors=plot(Full_Kart_DB((Full_Kart_DB(:,4)>=datenum(start_date))&(Full_Kart_DB(:,4)<=datenum(end_date)+1)&(Full_Kart_DB(:,5)==Competitors_2013(racer_i)),1),...
             Full_Kart_DB((Full_Kart_DB(:,4)>=datenum(start_date))&(Full_Kart_DB(:,4)<=datenum(end_date)+1)&(Full_Kart_DB(:,5)==Competitors_2013(racer_i)),3),...
             'o','LineWidth',2,'MarkerEdgeColor','b','MarkerFaceColor','w','MarkerSize',10);
        end
    end
end
if exist('plot_racerID')
    for racer_i = 1:length(plot_racerID)
        hold on
        if size(Full_Kart_DB((Full_Kart_DB(:,4)>=datenum(start_date))&(Full_Kart_DB(:,4)<=datenum(end_date)+1)&(Full_Kart_DB(:,5)==plot_racerID(racer_i)),3))>0
        h_AV=plot(Full_Kart_DB((Full_Kart_DB(:,4)>=datenum(start_date))&(Full_Kart_DB(:,4)<=datenum(end_date)+1)&(Full_Kart_DB(:,5)==plot_racerID(racer_i)),1),...
             Full_Kart_DB((Full_Kart_DB(:,4)>=datenum(start_date))&(Full_Kart_DB(:,4)<=datenum(end_date)+1)&(Full_Kart_DB(:,5)==plot_racerID(racer_i)),3),...
             'o','LineWidth',2,'MarkerEdgeColor','r','MarkerFaceColor','r','MarkerSize',8);
        end
    end
end
xlim([1,highest_kart_number])
ylim([fastlim,slowlim])
grid on
xlabel('KartNumber','FontSize',14,'FontWeight','b')
ylabel('Best Lap Time','FontSize',14,'FontWeight','b')
title({'Best Lap Times During Period';strcat([start_date,' to ',end_date])},'FontSize',16,'FontWeight','b')
%legend('All Racers','2013 Competitors','Location','EastOutside')

legendhandles=[h_all(1)];
if exist('h_Competitors')
    legendhandles=[legendhandles,h_Competitors(1)];
end

if exist('h_AV')
    legendhandles=[legendhandles,h_AV(1)];
end

legend(legendhandles,'All Racers','2013 Competitors','AV Racers','fontweight','b','fontsize',12,'Location','EastOutside')


