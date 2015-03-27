function [rpm_data] = get_rpm_from_racer(racer_ID)

rpm_data=[nan];
%[rpm]

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
    rpm_ptr       = strfind(line_buff, 'lblSpeedLimit" class="Head">');
    end_ptr       = strfind(line_buff, '/html');
    error_ptr       = strfind(line_buff, 'Server Error');
    
    if length(error_ptr) > 0
        break;
    end
    
    
    if length(end_ptr) > 0
        break;
    end
    
    % ...And process when we find it
    if length(rpm_ptr) > 0
        %Get Kart Number
        rpm_line   = line_buff(rpm_ptr:end);
        start_of_number = 29;
        end_of_number = strfind(rpm_line,'</span>')-1;
        rpm_data(racer_n)=str2num(rpm_line(start_of_number:end_of_number));
        
        
        racer_n=racer_n+1;
        
    end
    
end

rpm_data=rpm_data';
