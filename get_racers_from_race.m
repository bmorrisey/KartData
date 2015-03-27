%MB2 Data Scraping


function racer_IDs = get_racers_from_race(race_ID)

racer_IDs=[nan];

% Open connection to MB2 heat results page
% url_name = strcat('http://www.clubspeed.com/mb21000oaks/HeatDetails.aspx?HeatNo=',  num2str(race_ID));
url_name = strcat('http://mb21000oaks.clubspeedtiming.com/sp_center/HeatDetails.aspx?HeatNo=',  num2str(race_ID));


url     = java.net.URL(url_name);        % Construct a URL object
is      = openStream(url);              % Open a connection to the URL
isr     = java.io.InputStreamReader(is);
br      = java.io.BufferedReader(isr);

% Cycle through the source code 
racer_n=1;
while 1
    line_buff = char(readLine(br));
    ptr       = strfind(line_buff, 'RacerHistory.aspx?CustID=');
    end_ptr       = strfind(line_buff, '/html');
    error_ptr       = strfind(line_buff, 'Server Error');
    
    if length(error_ptr) > 0
        break;
    end
    
    % ...And process when we find it
    if length(ptr) > 0
        current_line   = line_buff(ptr:end);
        start_of_number = strfind(current_line,'=')+1;
        end_of_number = strfind(current_line,'''>')-1;
        racer_IDs(racer_n)=str2num(current_line(start_of_number:end_of_number));
        racer_n=racer_n+1;
    end
    
    
    if length(end_ptr) > 0
        break;
    end
end

