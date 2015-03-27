function [kart_data,rpm] = get_karts_from_racer(racer_ID)

kart_data=[nan nan nan nan];
%[kart heatID best_time datenum]

% Open connection to MB2 heat results page
% url_name = strcat('http://www.clubspeed.com/mb21000oaks/RacerHistory.aspx?CustID=',  num2str(racer_ID));
url_name = strcat('http://mb21000oaks.clubspeedtiming.com/sp_center/RacerHistory.aspx?CustID=',  num2str(racer_ID));

url     = java.net.URL(url_name);        % Construct a URL object
is      = openStream(url);              % Open a connection to the URL
isr     = java.io.InputStreamReader(is);
br      = java.io.BufferedReader(isr);

% Cycle through the source code
racer_n=1;
while 1
    line_buff = char(readLine(br));
    kart_ptr       = strfind(line_buff, 'Kart ');
    race_ptr       = strfind(line_buff, 'HeatDetails.aspx?HeatNo=');
    rpm_ptr       = strfind(line_buff, 'lblSpeedLimit" class="Head">');
    end_ptr       = strfind(line_buff, '/html');
    error_ptr       = strfind(line_buff, 'Server Error');
    
    if length(error_ptr) > 0
        break;
    end
    
    
    if length(end_ptr) > 0
        break;
    end
    
    if length(rpm_ptr) > 0
        %Get Kart Number
        rpm_line   = line_buff(rpm_ptr:end);
        start_of_number = 29;
        end_of_number = strfind(rpm_line,'</span>')-1;
        rpm=str2num(rpm_line(start_of_number:end_of_number));
    end
    
    % ...And process when we find it
    if length(kart_ptr) > 0
        %Get Kart Number
        kart_line   = line_buff(kart_ptr:end);
        start_of_number = 6;
        end_of_number = strfind(kart_line,'</a>')-1;
        kart_data(racer_n,1)=str2num(kart_line(start_of_number:end_of_number));
        
        if length(race_ptr) > 0
            %Get Heat ID
            race_line   = line_buff(race_ptr:end);
            start_of_number = strfind(race_line,'=')+1;
            end_of_number = strfind(race_line,'">')-1;
            kart_data(racer_n,2)=str2num(race_line(start_of_number:end_of_number));
        end
        
        %Get Date
        line_buff = char(readLine(br));
        kart_data(racer_n,4)=datenum(line_buff);
        
        %Get best time
        line_buff = char(readLine(br));
        %There are two of these table cells, so cut off the first and take the second
        time_ptr       = strfind(line_buff, '>');
        line_buff = line_buff(time_ptr(4):end);
        start_of_number = strfind(line_buff,'>')+1;
        end_of_number = strfind(line_buff,'</td>')-1;
        kart_data(racer_n,3)=str2num(line_buff(start_of_number:end_of_number));
        
        
        racer_n=racer_n+1;
        
    end
    
end

