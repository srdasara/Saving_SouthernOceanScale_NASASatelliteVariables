
%% 
% This script is a continuation of how I saved my MAOD and Depolarization Ratio (or sea ice) values as timetables that I then use for data analysis and statistical testing.
% These variables are saved within my Variables folder in PhD_Phase_Two_SouthernOcean! Go check it out.
%%
% So what I will do is go through all Calipso_year.mat files, and save them
% as separate timetables. This is a bit clunky, but allows me to step through and make sure everything is getting encoded correctly.

% First start with a clean workspace, and navigate to the relevant data-housing directory:
clear; 
cd /Users/srishtidasarathy/Documents/'Documents - Srishti’s MacBook Pro '/Bowman/PhD_Phase_Two_SouthernOcean/Variables/CALIPSO_raw_data
% manually stepping through and uncommenting so that I can be really
% careful as to what I save: 

% load('Calipso_2007.mat')
% load('Calipso_2008.mat')
% load('Calipso_2009.mat')
% load('Calipso_2010.mat')
% load('Calipso_2011.mat')
% load('Calipso_2012.mat')
% load('Calipso_2013.mat')
% load('Calipso_2014.mat')
% load('Calipso_2015.mat')
% load('Calipso_2016.mat')
% load('Calipso_2017.mat')
% load('Calipso_2018.mat')
% load('Calipso_2019.mat')
% load('Calipso_2020.mat')

% load('Calipso_2020_11.mat')
load('Calipso_2020_12.mat')


% Total_Profile_Time_New_Surface = Total_Profile_Time_New; 
% clear Total_Profile_Time_New

% I had my altitudes variable saved earlier from my first PhD Chapter! This is important for specifically extracting lower tropospheric aerosol:
cd /Users/srishtidasarathy/Documents/'Documents - Srishti’s MacBook Pro '/Bowman/Updated_Code_Processing_PhdPhaseOne/Srishti/Analysis_and_Vars_For_Publication
load('Total_altitudes.mat')

% And let's now navigate to our new directory where we will keep these variables. I misnamed this as 2017_2020 instead of 2007_2020. Not a big deal though since the variables themselves are correct!
cd /Users/srishtidasarathy/Documents/'Documents - Srishti’s MacBook Pro '/Bowman/PhD_Phase_Two_SouthernOcean/Variables/2017_2020_vars/

% There was  a mistake when stepping through and getting to the last two months of 2020:
%% Only for 2020_11 and 2020_12.mat files, here's what I ran: 


        Total_count_n          = Master_count_n;
        Total_filename         = Master_filename;
        
        % data
        Total_Profile_Time         = Master_Profile_Time;
        Total_Latitude             = Master_Latitude;
        Total_Longitude            = Master_Longitude;
        Total_EC_532               = Master_EC_532;
        Total_Color_ratio          = Master_Color_ratio;
        Total_Part_Depol_Ratio     = Master_Part_Depol_Ratio ;
        Total_Day_Night_Flag       = Master_Day_Night_Flag;
        Total_COD_Cloud            = Master_COD_Cloud; 
   
        Total_Surface_Elevation_Statistics                = Master_Surface_Elevation_Statistics;
        Total_Surface_532_Integrated_Depolarization_Ratio = Master_Surface_532_Integrated_Depolarization_Ratio; 
        Total_Surface_Type                                = Master_Surface_Type;
        

Total_Profile_Time_New = datetime(Total_Profile_Time,'ConvertFrom',...
        'epochtime','Epoch','1993-01-01');

    

%% 0.0977KM TO 2.0137KM if not passing any filters, otherwise 
% 0.03779 km to 2.0137 km, if surface elev statistics permit it. 

% these correspond to altitude bins 358 to 391. 

%% Filter to only include Extinction Coefficients that are cloud free and nighttime only. 
% Total_COD_Cloud == 0 , DayNightFlag == 1

Cloud_Free                                          = Total_COD_Cloud(:, 1) == 0; 
Total_Latitude_Cloud_Free                           = Total_Latitude(Cloud_Free); 
Total_Longitude_Cloud_Free                          = Total_Longitude(Cloud_Free); 
Total_Profile_Time_New_Cloud_Free                   = Total_Profile_Time_New(Cloud_Free);
Total_Surface_Elevation_Statistics_Cloud_Free       = Total_Surface_Elevation_Statistics(Cloud_Free);
Total_Surface_Type_Cloud_Free                       = Total_Surface_Type(Cloud_Free); 

Total_EC_532_Cloud_Free                             = Total_EC_532(Cloud_Free, :) ; 
Total_Color_ratio_Cloud_Free                        = Total_Color_ratio(Cloud_Free, :);
Total_Part_Depol_ratio_Cloud_Free                   = Total_Part_Depol_Ratio(Cloud_Free, :);

% Clear variables because I'm just trying to make space for it to run more smoothly
clear Total_EC_532 Total_Color_ratio Total_Part_Depol_Ratio Total_COD_Cloud

Total_Day_Night_Flag_Cloud_Free                     = Total_Day_Night_Flag(Cloud_Free,:); 
Night_Cloud_Free                                    = Total_Day_Night_Flag_Cloud_Free(:,1) == 1 ; 
Total_Latitude_Night_Cloud_Free                     = Total_Latitude_Cloud_Free(Night_Cloud_Free); 
Total_Longitude_Night_Cloud_Free                    = Total_Longitude_Cloud_Free(Night_Cloud_Free); 
Total_Profile_Time_New_Night_Cloud_Free             = Total_Profile_Time_New_Cloud_Free(Night_Cloud_Free); 


Total_EC_532_Night_Cloud_Free                       = Total_EC_532_Cloud_Free(Night_Cloud_Free, :); 
Total_Color_ratio_Night_Cloud_Free                  = Total_Color_ratio_Cloud_Free(Night_Cloud_Free, :);
Total_Part_Depol_ratio_Night_Cloud_Free             = Total_Part_Depol_ratio_Cloud_Free(Night_Cloud_Free, :);

Total_Surface_Elevation_Statistics_Night_Cloud_Free = Total_Surface_Elevation_Statistics_Cloud_Free(Night_Cloud_Free);
Total_Surface_Type_Night_Cloud_Free                 = Total_Surface_Type_Cloud_Free(Night_Cloud_Free);


clear Total_EC_532_Cloud_Free Total_Color_ratio_Cloud_Free Total_Part_Depol_ratio_Cloud_Free

% 0.03779 km to 2.0137 km, if surface elev statistics & Surface type permit it. 

% Good Surface Type and Surface Elev Stats:

Total_Surface_Good                  = Total_Surface_Type_Night_Cloud_Free(:,1) == 17 & Total_Surface_Elevation_Statistics_Night_Cloud_Free(:,1) == 0 ; 

Total_EC_532_Surface_Good           = Total_EC_532_Night_Cloud_Free(Total_Surface_Good,:); 
Total_Color_ratio_Surface_Good      = Total_Color_ratio_Night_Cloud_Free(Total_Surface_Good, :);
Total_Part_Depol_ratio_Surface_Good = Total_Part_Depol_ratio_Night_Cloud_Free(Total_Surface_Good, :);

Total_Profile_Time_New_Surface_Good = Total_Profile_Time_New_Night_Cloud_Free(Total_Surface_Good); 
Total_Latitude_Surface_Good         = Total_Latitude_Night_Cloud_Free(Total_Surface_Good); 
Total_Longitude_Surface_Good        = Total_Longitude_Night_Cloud_Free(Total_Surface_Good);

Total_EC_532_Surface_Bad            = Total_EC_532_Night_Cloud_Free(~Total_Surface_Good, :); 
Total_Color_ratio_Surface_Bad       = Total_Color_ratio_Night_Cloud_Free(~Total_Surface_Good, :);
Total_Part_Depol_ratio_Surface_Bad  = Total_Part_Depol_ratio_Night_Cloud_Free(~Total_Surface_Good, :);

Total_Profile_Time_New_Surface_Bad  = Total_Profile_Time_New_Night_Cloud_Free(~Total_Surface_Good);
Total_Latitude_Surface_Bad          = Total_Latitude_Night_Cloud_Free(~Total_Surface_Good);
Total_Longitude_Surface_Bad         = Total_Longitude_Night_Cloud_Free(~Total_Surface_Good); 


Total_EC_532_Surface_Good_adjusted_alt           = Total_EC_532_Surface_Good(:, 358:391) ; % 0.03779 km to 2.0137 km, if surface elev statistics permit it. 
Total_Color_ratio_Surface_Good_adjusted_alt      = Total_Color_ratio_Surface_Good(:, 358:391) ;
Total_Part_Depol_ratio_Surface_Good_adjusted_alt = Total_Part_Depol_ratio_Surface_Good(:, 358:391) ;
Total_adjusted_alt_Surface_Good                  = Total_altitudes(358:391, :) ; 


Total_EC_532_Surface_Bad_adjusted_alt           = Total_EC_532_Surface_Bad(:, 358:390); 
Total_Color_ratio_Surface_Bad_adjusted_alt      = Total_Color_ratio_Surface_Bad(:, 358:390);
Total_Part_Depol_ratio_Surface_Bad_adjusted_alt = Total_Part_Depol_ratio_Surface_Bad(:, 358:390);
Total_adjusted_alt_Surface_Bad                  = Total_altitudes(358:390, :);

  
%% Color ratio, which informs us on the size of an aerosol particle, 
% and particulate depolarization ratio (THIS IS A DIFFERENT VARIABLE THAN 
% SEA ICE or SURFACE INTEGRATED DEPOLARIZATION RATIO) informs us on the shape 
% of an aerosol particle (i.e., these numbers are important to look at because 
% we expect marine aerosol to be large and spherical, so it's a good sanity check!)
 

Total_Color_ratio_good_averaged = zeros(length(Total_Color_ratio_Surface_Good_adjusted_alt(:,1)) , 1) ; 

for p = 1:length(Total_Color_ratio_Surface_Good_adjusted_alt(:,1))
%      disp(p)
    Total_Color_ratio_good_averaged(p) = nanmean(Total_Color_ratio_Surface_Good_adjusted_alt(p, : )) ;
end


    
Total_Color_ratio_bad_averaged = zeros(length(Total_Color_ratio_Surface_Bad_adjusted_alt(:,1)) , 1) ; 

for p = 1:length(Total_Color_ratio_Surface_Bad_adjusted_alt(:,1))
%      disp(p)
    Total_Color_ratio_bad_averaged(p) = nanmean(Total_Color_ratio_Surface_Bad_adjusted_alt(p, : )) ;
end



Total_Part_Depol_ratio_good_averaged = zeros(length(Total_Part_Depol_ratio_Surface_Good_adjusted_alt(:,1)) , 1) ; 

for p = 1:length(Total_Part_Depol_ratio_Surface_Good_adjusted_alt(:,1))
%      disp(p)
    Total_Part_Depol_ratio_good_averaged(p) = nanmean(Total_Part_Depol_ratio_Surface_Good_adjusted_alt(p, : )) ;
end



Total_Part_Depol_ratio_bad_averaged = zeros(length(Total_Part_Depol_ratio_Surface_Bad_adjusted_alt(:,1)) , 1) ; 

for p = 1:length(Total_Part_Depol_ratio_Surface_Bad_adjusted_alt(:,1))
%      disp(p)
    Total_Part_Depol_ratio_bad_averaged(p) = nanmean(Total_Part_Depol_ratio_Surface_Bad_adjusted_alt(p, : )) ;
end

% And now let's move forward to our MAOD analysis, which integrates extinction coefficients @ 532 nm:

clear Total_Part_Depol_ratio_Surface_Bad_adjusted_alt Total_Part_Depol_ratio_Surface_Good_adjusted_alt Total_Color_ratio_Surface_Bad_adjusted_alt Total_Color_ratio_Surface_Good_adjusted_alt
% Convert NaNs to 0 for trapz function:

 Total_EC_532_Surface_Good_adjusted_alt(isnan(Total_EC_532_Surface_Good_adjusted_alt)) = 0 ; % 0 is clear air, NaN has been filtered out by quality screening
 Total_EC_532_Surface_Bad_adjusted_alt(isnan(Total_EC_532_Surface_Bad_adjusted_alt)) = 0; 
 %  Total_EC_532_Night_Cloud_Free(Total_EC_532_Night_Cloud_Free == 0) = NaN ; % Converting all zeros in sigma to NaNs. 

 % to keep NaN or not keep NaN?
 
%% These variables with the term CMOD_Surface correspond to MAOD!!! 
clear CMOD_Surface_Good
CMOD_Surface_Good = zeros(length(Total_EC_532_Surface_Good_adjusted_alt(:,1)), 1); 

for i = 1:length(Total_EC_532_Surface_Good_adjusted_alt(:,1))
%     disp(i)
    CMOD_Surface_Good(i) = -1 .* (trapz(Total_adjusted_alt_Surface_Good, Total_EC_532_Surface_Good_adjusted_alt(i,:))) ; 
    % -1 in equation above was to flip in consideration of the fact that altitudes start from 2.0137 km and end at 0.0977km
end


clear CMOD_Surface_Bad
CMOD_Surface_Bad = zeros(length(Total_EC_532_Surface_Bad_adjusted_alt(:,1)), 1); 

for i = 1:length(Total_EC_532_Surface_Bad_adjusted_alt(:,1)) 
   
    CMOD_Surface_Bad(i) = -1 .* (trapz(Total_adjusted_alt_Surface_Bad, Total_EC_532_Surface_Bad_adjusted_alt(i,:)));
    % -1 in equation above was to flip in consideration of the fact that altitudes start from 2.0137 km and end at 0.0977km

end

clear Total_EC_532_Surface_Bad_adjusted_alt Total_EC_532_Surface_Good_adjusted_alt


% Make a time table with all of these values, 3 separate ones: CMOD, Ice, and Winds
    Total_Profile_Time_New_Surface = Total_Profile_Time_New_Surface_Good;
    Total_Latitude_Surface = Total_Latitude_Surface_Good; 
    Total_Longitude_Surface = Total_Longitude_Surface_Good; 
    CMOD_Surface = CMOD_Surface_Good;
    Color_Ratio = Total_Color_ratio_good_averaged;
    PDR = Total_Part_Depol_ratio_good_averaged;
    
    Total_table_CMOD_Surface_Good = table(Total_Profile_Time_New_Surface,...
        Total_Latitude_Surface,...
        Total_Longitude_Surface,...
        CMOD_Surface,...
        Color_Ratio,...
        PDR); 

    Total_table_CMOD_Surface_Good            = sortrows(Total_table_CMOD_Surface_Good,'Total_Profile_Time_New_Surface','ascend'); % sort values with increasing time duration
    Total_timetable_CMOD_Surface_Good        = table2timetable(Total_table_CMOD_Surface_Good); % make table into a timetable

    
    
    
    Total_Profile_Time_New_Surface = Total_Profile_Time_New_Surface_Bad; 
    Total_Latitude_Surface = Total_Latitude_Surface_Bad;
    Total_Longitude_Surface = Total_Longitude_Surface_Bad; 
    CMOD_Surface = CMOD_Surface_Bad; 
    Color_Ratio = Total_Color_ratio_bad_averaged;
    PDR = Total_Part_Depol_ratio_bad_averaged;
    
    Total_table_CMOD_Surface_Bad = table(Total_Profile_Time_New_Surface,...
        Total_Latitude_Surface,...
        Total_Longitude_Surface,...
        CMOD_Surface,...
        Color_Ratio,...
        PDR); 
    
    Total_table_CMOD_Surface_Bad     = sortrows(Total_table_CMOD_Surface_Bad, 'Total_Profile_Time_New_Surface', 'ascend');
    Total_timetable_CMOD_Surface_Bad = table2timetable(Total_table_CMOD_Surface_Bad); % make table into a timetable

    %%

% Total_timetable_MOD = Total_timetable_SO_MOD(S,:);
    
    
    %%
    
    % For 2020_11, and next for 2020_12:
    Total_timetable_SO_MOD_NEW = [Total_timetable_SO_MOD_NEW; Total_timetable_CMOD_Surface_Good ; Total_timetable_CMOD_Surface_Bad];
    Total_timetable_SO_MOD_NEW = sortrows(Total_timetable_SO_MOD_NEW, 'Total_Profile_Time_New_Surface', 'ascend');
    
    S = timerange('01/01/2007','01/01/2021');

    Total_timetable_SO_MOD_NEW = Total_timetable_SO_MOD_NEW(S,:);
    Total_timetable_SO_MOD_NEW = unique(Total_timetable_SO_MOD_NEW);
    % Be sure to look through and confirm correct year and var names 
    % before saving 
    
   %%

save('Total_timetable_SO_MOD_NEW.mat', 'Total_timetable_SO_MOD_NEW', '-v7.3')
     
     
    %% I first have to filter for only good values of Ice 
    
    
    bad_Ice_values = Total_Surface_532_Integrated_Depolarization_Ratio <= -0.2 | Total_Surface_532_Integrated_Depolarization_Ratio > 1.2;
    Total_Surface_532_Integrated_Depolarization_Ratio(bad_Ice_values) = NaN; % I set these bad values to NaNs so I can easily index and remove them
    
    nan_ice        = isnan(Total_Surface_532_Integrated_Depolarization_Ratio(:,1));
    Total_Surface_532_Integrated_Depolarization_Ratio      = Total_Surface_532_Integrated_Depolarization_Ratio(~nan_ice) ;
    Total_Latitude_Ice  = Total_Latitude(~nan_ice);
    Total_Longitude_Ice  = Total_Longitude(~nan_ice);
    Total_Profile_Time_New_Ice = Total_Profile_Time_New(~nan_ice); 
    
    Total_table_Depol_Ratio = table(Total_Profile_Time_New_Ice,...
        Total_Latitude_Ice,...
        Total_Longitude_Ice,...
        Total_Surface_532_Integrated_Depolarization_Ratio);
    
    Total_table_Depol_Ratio = sortrows(Total_table_Depol_Ratio, 'Total_Profile_Time_New_Ice', 'ascend');
    
    %%
    
    % again, step through and MAKE SURE YOU HAVE THE RIGHT YEAR
    
%     Total_timetable_Depol_Ratio_2007 = table2timetable(Total_table_Depol_Ratio);
%     Total_timetable_Depol_Ratio_2008 = table2timetable(Total_table_Depol_Ratio);
%     Total_timetable_Depol_Ratio_2009 = table2timetable(Total_table_Depol_Ratio);
%     Total_timetable_Depol_Ratio_2010 = table2timetable(Total_table_Depol_Ratio);
%     Total_timetable_Depol_Ratio_2011 = table2timetable(Total_table_Depol_Ratio);
%     Total_timetable_Depol_Ratio_2012 = table2timetable(Total_table_Depol_Ratio);
%     Total_timetable_Depol_Ratio_2013 = table2timetable(Total_table_Depol_Ratio);
%     Total_timetable_Depol_Ratio_2014 = table2timetable(Total_table_Depol_Ratio);
%     Total_timetable_Depol_Ratio_2015 = table2timetable(Total_table_Depol_Ratio);
%     Total_timetable_Depol_Ratio_2016 = table2timetable(Total_table_Depol_Ratio);
%     Total_timetable_Depol_Ratio_2017 = table2timetable(Total_table_Depol_Ratio);
%     Total_timetable_Depol_Ratio_2018 = table2timetable(Total_table_Depol_Ratio);
%     Total_timetable_Depol_Ratio_2019 = table2timetable(Total_table_Depol_Ratio);
%     Total_timetable_Depol_Ratio_2020 = table2timetable(Total_table_Depol_Ratio);
   Total_timetable_Depol_Ratio_2020_11 = table2timetable(Total_table_Depol_Ratio);
   Total_timetable_Depol_Ratio_2020_12 = table2timetable(Total_table_Depol_Ratio);

% I ended up retiming my depolarization ratio variable so that it was going by the minute scale. There was just too much data to process otherwise...
   Total_timetable_Depol_Ratio_2020_12_2 = retime(Total_timetable_Depol_Ratio_2020_12_2, 'minutely', @nanmean);
   Total_timetable_SO_Depol_Ratio_NEW    = retime(Total_timetable_SO_Depol_Ratio_NEW, 'minutely', @nanmean);
   
   S = timerange('01/01/2007', '01/01/2021');
   Total_timetable_SO_Depol_Ratio = Total_timetable_SO_Depol_Ratio(S,:);
   Total_timetable_SO_Depol_Ratio = [Total_timetable_SO_Depol_Ratio ; Total_timetable_Depol_Ratio_2020_11];
%    Total_timetable_SO_Depol_Ratio_NEW = unique(Total_timetable_SO_Depol_Ratio);

Total_timetable_SO_Depol_Ratio_MINUTE = [Total_timetable_SO_Depol_Ratio_NEW ; Total_timetable_Depol_Ratio_2020_12_2];
   
   Total_timetable_SO_Depol_Ratio      = unique(Total_timetable_SO_Depol_Ratio); 
   
    Total_timetable_SO_Depol_Ratio_NEW = Total_timetable_SO_Depol_Ratio; 
   %%
    
    save('Total_timetable_SO_Depol_Ratio_NEW.mat', 'Total_timetable_SO_Depol_Ratio_NEW', '-v7.3') 
    
    %% CONCATENATE TIMETABLES
    
    % This is me tacking on the new december 2020 month:
    Total_timetable_SO_MOD_Suface_NEW = [Total_timetable_SO_MOD;...
        Total_timetable_CMOD_Surface_2020_12]; 
    
    Total_timetable_SO_MOD_Depol_Ratio_NEW = [Total_timetable_SO_Depol_Ratio;...
        Total_timetable_Depol_Ratio_2020_12];
    
    
    % this was the old(er) code:
    
%     
Total_timetable_MOD_Surface = [Total_timetable_CMOD_Surface_2007 ; ...
    Total_timetable_CMOD_Surface_2008;...
    Total_timetable_CMOD_Surface_2009;...
    Total_timetable_CMOD_Surface_2010;...
    Total_timetable_CMOD_Surface_2011;...
    Total_timetable_CMOD_Surface_2012;...
    Total_timetable_CMOD_Surface_2013;...
    Total_timetable_CMOD_Surface_2014;...
    Total_timetable_CMOD_Surface_2015;...
    Total_timetable_CMOD_Surface_2016;...
    Total_timetable_CMOD_Surface_2017;...
    Total_timetable_CMOD_Surface_2018;...
    Total_timetable_CMOD_Surface_2019;...
    Total_timetable_CMOD_Surface_2020_12];

Total_timetable_MOD_Surface = sortrows(Total_timetable_MOD_Surface, 'Total_Profile_Time_New_Surface', 'ascend');

%%

Total_timetable_ice = [Total_timetable_Depol_Ratio_2007 ; ...
    Total_timetable_Depol_Ratio_2008;...
    Total_timetable_Depol_Ratio_2009;...
    Total_timetable_Depol_Ratio_2010;...
    Total_timetable_Depol_Ratio_2011;...
    Total_timetable_Depol_Ratio_2012;...
    Total_timetable_Depol_Ratio_2013;...
    Total_timetable_Depol_Ratio_2014;...
    Total_timetable_Depol_Ratio_2015;...
    Total_timetable_Depol_Ratio_2016;...
    Total_timetable_Depol_Ratio_2017;...
    Total_timetable_Depol_Ratio_2018;...
    Total_timetable_Depol_Ratio_2019;...
    Total_timetable_Depol_Ratio_2020_12];

Total_timetable_ice = sortrows(Total_timetable_ice, 'Total_Profile_Time_New_Ice', 'ascend');


%%

Total_timetable_SO_MOD = Total_timetable_MOD_Surface; 
Total_timetable_SO_Depol_Ratio = Total_timetable_ice;
save('Total_timetable_SO_MOD.mat', 'Total_timetable_SO_MOD', '-v7.3')
save('Total_timetable_SO_Depol_Ratio.mat', 'Total_timetable_SO_Depol_Ratio', '-v7.3')

    %%
    
    timetable_CMOD_monthly_avg    = retime(Total_timetable_CMOD_Surface_2020_12, 'monthly', @nanmean); 
    CMOD_Monthly_avg_Surface = timetable_CMOD_monthly_avg.CMOD_Surface; 
    CMOD_Time_Months_Surface = timetable_CMOD_monthly_avg.Total_Profile_Time_New_Surface; 
    CMOD_Lat_Months_Surface  = timetable_CMOD_monthly_avg.Total_Latitude_Surface;
    CMOD_Lon_Months_Surface  = timetable_CMOD_monthly_avg.Total_Longitude_Surface;
        
    timetable_Depol_Ratio_monthly_avg = retime(Total_timetable_Depol_Ratio, 'monthly', @nanmean); 
    Depol_Ratio_Monthly_avg = timetable_Depol_Ratio_monthly_avg.Total_Surface_532_Integrated_Depolarization_Ratio;
    Depol_Ratio_Time_Months = timetable_Depol_Ratio_monthly_avg.Total_Profile_Time_New_Ice; 
    Depol_Ratio_Lat_Months = timetable_Depol_Ratio_monthly_avg.Total_Latitude_Ice; 
    Depol_Ratio_Lon_Months = timetable_Depol_Ratio_monthly_avg.Total_Longitude_Ice; 
    
%     timetable_amsrmf_monthly_avg = retime(Total_timetable_amsrmf, 'monthly', @nanmean); 
%     amsrmf_Monthly_avg = timetable_amsrmf_monthly_avg.Total_windamsrMF; 
%     amsrmf_Time_Months = timetable_amsrmf_monthly_avg.Total_Profile_Time_New_Wind; 
%     amsrmf_Lat_Months = timetable_amsrmf_monthly_avg.Total_Latitude_Wind;
%     amsrmf_Lon_Months = timetable_amsrmf_monthly_avg.Total_Longitude_Wind; 
%     
    save('CMOD_Monthly_avg_Vars_Surface.mat', ...
        'CMOD_Monthly_avg_Surface',...
        'CMOD_Time_Months_Surface',...
        'CMOD_Lat_Months_Surface',...
        'CMOD_Lon_Months_Surface',...
        '-v7.3') 
    
    save('Depol_Ratio_Monthly_avg_Vars.mat',...
        'Depol_Ratio_Monthly_avg',...
        'Depol_Ratio_Time_Months',...
        'Depol_Ratio_Lat_Months',...
        'Depol_Ratio_Lon_Months',...
        '-v7.3') 
    
%     save('amsrmf_Monthly_avg_Vars.mat',...
%         'amsrmf_Monthly_avg',...
%         'amsrmf_Time_Months',...
%         'amsrmf_Lat_Months',...
%         'amsrmf_Lon_Months',...
%         '-v7.3')
    
    
   
%%

% I've constructed all of the standard deviation values into timetables. 
        CMOD_no_zeros = Total_timetable_CMOD_Surface_2020_12.CMOD_Surface; 
        CMOD_no_zeros(CMOD_no_zeros==0) = nan;
        Total_timetable_CMOD_test = addvars(Total_timetable_CMOD_Surface_2020_12,CMOD_no_zeros); 
        
        CMOD_std = retime(Total_timetable_CMOD_test, 'monthly', @nanstd);
        
        
        
        CMOD_std = retime(Total_timetable_CMOD_test, 'monthly', @nanstd); 
        CMOD_mean = retime(Total_timetable_CMOD_test, 'monthly', @nanmean); 
        CMOD_mean_absol_dev = retime(Total_timetable_CMOD_test, 'monthly', @mad); 
        CMOD_median_absol_dev = retime(Total_timetable_CMOD_test, 'monthly', @mad_median); 
        
        
        Ice_median_absol_dev = retime(Total_timetable_Depol_Ratio, 'monthly', @mad); 
        Ice_mean = retime(Total_timetable_Depol_Ratio, 'monthly', @nanmean); 
        
        
%         CMOD_std = CMOD_std.CMOD;
        Wind_std = retime(Total_timetable_amsrmf, 'monthly', @std_timetable); 
%         Wind_std = Wind_std.Total_windamsrMF; 
        Ice_std = retime(Total_timetable_Depol_Ratio, 'monthly', @std_timetable); 
%         Ice_std = Ice_std.Total_Surface_532_Integrated_Depolarization_Ratio; 
    
% 
%         Chl_std_test = std(Master_chl_a, 0, [1 2], 'omitnan'); 
%         Chl_std = squeeze(Chl_std_test);  
%         
%         Total_table_chl_a_std = table(times, Chl_std);    
%         timetable_chl_a_std = sortrows(Total_table_chl_a_std, 'times', 'ascend'); 
    
        %%
        % I did this after loading Master_chlor_a_monthly_full_res.mat
        % Here is the mean absolute deviation across every page of
        % Master_chl_a 
        
        
        t1 = datetime(2006,06,01);
        t2 = datetime(2018,12,31);
        times = t1:calmonths(1):t2; 
        times = times';
    
    
        
        
        for i = 1:151 
            Total_chl_monthly_2(i) = nanmean(Master_chl_a(:,:,i), [1 2]); 
        end

        Total_chl_a_monthly = Total_chl_monthly_2'; 


        Total_chl_a_mad = mad(Master_chl_a, 0, [1 2]);
        
        Total_chl_a_std = nanstd(Master_chl_a, 0, [ 1 2]); 
        
        Total_chl_a_mad = squeeze(Total_chl_a_mad); 
        Total_chl_a_std = squeeze(Total_chl_a_std); 
        
        Total_timetable_chl_a_monthly_plus_mad = timetable(times, Total_chl_a_monthly,...
            Total_chl_a_mad, Total_chl_a_std);

        
        %%
        
        % Standard deviation test: 
         A = [4 -5 1 2 3 5 -9 1 7];
         std_A = std(A); 
         mean_A = mean(A); 
        
        
        % June 2006 example
        
        S = timerange('06/01/2006','07/01/2006');
        timetable_test = Total_timetable_CMOD(S,:); 
        
        CMOD_max_five = maxk(timetable_test.CMOD, 10); 
        edges = [0 0:0.0001:0.01 0.01];
        histogram(timetable_test.CMOD, edges) 
    
        
        
        
        
        
        
        
        
        
    