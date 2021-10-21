%%
%%%%%% VARIABLES WERE SAVED BY NAVIGATING TO THIS LINK: https://www.remss.com/measurements/wind/
%%%%%% Afterwards, I clicked on 'FTP Access to Merged 1-deg Monthly Winds'
%%%%%% Here now follows the code on reading and processing these monthly wind speed data metrics.
%%%%%% Southern Ocean 2007 - 2019 


% Wherever the directory with all the nc files is:

clear; 
file_mask_dir = '/Users/srishtidasarathy/Documents/Bowman/PhD_Phase_Two_SouthernOcean/Variables/windspeed_raw_data/';
nc_files     = dir([file_mask_dir '*nc4.nc']);


% cd /Users/srishtidasarathy/Documents/Bowman/PhD_Phase_Two_EOF_Analysis_Southern_Ocean/2015_mat_files

% calipso_data_dir = '/Users/srishtidasarathy/Documents/Bowman/PhD_Phase_Two_EOF_Analysis_Southern_Ocean/2015_Data/';
% hdf_files     = dir([calipso_data_dir '*.hdf']);


file_with_data_in_range = 0; % I'll be keeping track of the number of files the loop has rolled through by this variable

% % This Southern Ocean Scale dataset only needs subsetting on the Latitude
% side of things.
%
LatLims  = [-90  -50];
LatLims = LatLims';
%    LonLims  = [0 360];
%    LonLims = LonLims';


t1 = datetime(1988,01,01);
t2 = datetime(2020,12,31);
times = t1:calmonths(1):t2; 

clear t1 t2
%
%%

% for b = 1:length(nc_files)
    
    b = 1;
    %for n = 1:3
    %     try
    disp(b)
    
    
    myFileName   = nc_files(b,:).name;
    fullFileName = fullfile(file_mask_dir, myFileName);
    % ---- Read in the relevant arrays from the file ---- %
    
    product_name        = 'latitude';
    Latitude_wind       = ncread( fullFileName , product_name );
    
    
    product_name        = 'longitude';
    Longitude_wind      = ncread( fullFileName , product_name );
    
    
    product_name = 'time';
    time = ncread( fullFileName , product_name );
    
    %     % the midpoint column of Lat/Lon
    %     Latitude_wind            = Latitude_wind(:, 2);
    % %     Longitude_wind           = Longitude_wind(:, 2);
    %     %
    %         inRange = Latitude_wind >= LatLims(1) & Latitude_wind < LatLims(end)...
    %             & Longitude_wind >= LonLims(1) & Longitude_wind < LonLims(end);
    
%     disp(i)
%     inRange = Latitude_wind >= LatLims(1) & Latitude_wind < LatLims(end);
    
%     if sum(inRange) == 0
%         continue
%     end
%     
    % sum(inRange) >= 1 so we have data
    
    %tracking number of file with data in range
    file_with_data_in_range = (b-1) + 1;
    
    
    product_name         = 'wind_speed';
    wind_speed           = ncread( fullFileName , product_name); % this is a gridded monthly one degree dataset
    
    
    product_name = 'wind_speed_climatology';
    wind_speed_climatology = ncread( fullFileName , product_name);
    
    
    %     product_name            = 'time';
    %     time_wind            = ncread( fullFileName , product_name );
    
    
    
     Latitude_wind         = Latitude_wind(inRange) ;
%     Longitude_wind        = Longitude_wind(inRange) ;
    %         time_wind     = time_wind(inRange) ;
    for i = 1:396
        wind_speed_correct(:,:,i)   = wind_speed(:, 1:40, i) ;
    end
    
    wind_speed_correct_time = wind_speed_correct(:,:,229:end);
    
    for k = 1:12
        wind_speed_climatology_correct(:,:,k) = wind_speed_climatology(:, 1:40, k);
    end
    
     % long1 is the longitude varying from -180 to 180 or 180W-180E
     % long3 is the longitude variable from 0 to 360 (all positive)
     % To convert longitude from (0-360) to (-180 to 180)
     % long1 = -180: 1 : 180;
     
     Longitude_wind = mod((Longitude_wind + 180),360)-180;
     
     
    if  file_with_data_in_range == 1
        
        % counter
        Master_count_n           = b ;
        Master_filename         = myFileName(11:end); % this is me saving the monthly averaged time point from the file name
        
        % data
        %         Master_time_wind        = time_wind;
        Master_Latitude_wind    = Latitude_wind;
        Master_Longitude_wind   = Longitude_wind; 
        Master_wind_speed       = wind_speed_correct_time;
        Master_wind_speed_climatology = wind_speed_climatology_correct;
        
    else
        % counter
        Master_count_n          = cat(1, Master_count_n, b);
        Master_filename         = cat(1, Master_filename, myFileName(11:end));
        
        % data
        %         Master_time_wind         = cat(1, Master_time_wind, time_wind);
        Master_Latitude_wind             = cat(2, Master_Latitude_wind, Latitude_wind);
        Master_Longitude_wind            = cat(2, Master_Longitude_wind, Longitude_wind);
        Master_wind_speed                = cat(3, Master_wind_speed, wind_speed) ;
        
    end
    

%%


% I want longitudes to go from - 180 : 180 so I need to index and apply the
% indices to the array 
[B,I] = sort(Longitude_wind);

Master_longitude_wind = Master_Longitude_wind(I, :); 


Master_wind_speed_lonlat_adjusted = Master_wind_speed; 



%%
for i = 1: 168 
    disp(i)
    Master_wind_speed_lonlat_adjusted(:,:,i) = Master_wind_speed_lonlat_adjusted(I,:,i); 
end

% So now longitude goes from -180 to 180 in this array. 

% I flipped it left right so that the latitude can go from 50S to 90S.
% Inititally Latitude was going from 90 to 50. This corresponded to the
% second dimension of my wind speed array. 

latitude_wind = flipud(Latitude_wind); 
Master_wind_speed_lonlat_adjusted = fliplr(Master_wind_speed_lonlat_adjusted); 

%% Last I have to transpose, so that my array becomes Lat x Lon x Month. 
Master_Wind_Speed = permute(Master_wind_speed_lonlat_adjusted, [2 1 3]); 

%%
LAT_wind = latitude_wind; 
LON_wind = Master_longitude_wind(:,1); 

%%

% I had the Master_Latitude and Master_Longitude present just as a check on
% these data. I actually need only the first column.
%%
cd /Users/srishtidasarathy/Documents/Bowman/PhD_Phase_Two_SouthernOcean/Variables/2017_2020_vars

save('Southern_Ocean_Wind_Speed_Data_ONEDEGREERES.mat',...
    'LAT_wind',...
    'LON_wind',...
    'Master_Wind_Speed',...
    'Master_filename',...
    '-v7.3');

%%

% I constructed a video to confirm that my reading of wind speed data was correct: 

figure(1), clf

vidfile = VideoWriter('winds_var_save_TEST_1by1.mp4','MPEG-4');
vidfile.FrameRate = 1;
open(vidfile);

times_for_plot = times(229:end);

for i = 1 : 168
    disp(i)
    
    plot_SO_figure(Master_Wind_Speed(:,:,i),...
        LON_wind,...
        LAT_wind,...
        'amp',...
        [0 12],...
        (['wind speed: ', datestr(times_for_plot(i))]))
    
    
%     hold on;
%     [C, h] = m_contour(step_Lon, step_Lat, contour_array(i,:), 'linewi', 5.5, 'LineColor', [0 1 0.6]);
%     h.LevelList = 0.65  ;
%     %     clabel(C, h,'fontsize',13);
%     
%     
%     
%     hp4 = get(subplot(3,1, 3),'Position');
%     h = colorbar('Position', [hp4(1)+(hp4(3)-0.2)  0.33  0.02  0.4]);
%     h.FontWeight = 'bold';
%     h.FontSize = 15;
%     
    
    
    
    drawnow
    
    F(i) = getframe(gcf);
    writeVideo(vidfile,F(i));
    
    
    
end

close(vidfile)












