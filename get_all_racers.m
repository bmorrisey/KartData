function [all_racers]=get_all_racers(start_race,end_race)

all_racers=[];

for race_ID = start_race : end_race
    disp(race_ID)
    racer_IDs = get_racers_from_race(race_ID);
    if ~isnan(racer_IDs)
        all_racers = [all_racers racer_IDs];
    end
    
end

all_racers = unique(all_racers);