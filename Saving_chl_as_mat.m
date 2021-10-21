

%%%%%% VARIABLES WERE SAVED USING FIREFOX GUI DOWNTHEMALL
%%%%%% This was done after logging into NASA Earthdata, and navigating to this link: https://oceandata.sci.gsfc.nasa.gov/directaccess/MODIS-Aqua/Mapped/Monthly/4km/chlor_a/
%%%%%%, I wrote a pdftutorial for myself in the Documents/Bowman folder

%% Southern Ocean 2007 - 2019 

%% Here is how I read chl-a data and saved out the variables needed! 


% function [stat] = Read_hdf_from_server(year_run, month_run)
% 
% Year          = {'2006', '2007', '2008', '2009', '2010', '2011', '2012','2013', '2014', '2015','2016','2017', '2018', '2019'};
% Month         =  {'01', '02', '03', '04', '05', '06', '07', '08', '09', '10','11', '12'};

% script home path
cd /Users/srishtidasarathy/Documents/Bowman/PhD_Phase_Two_SouthernOcean/Code/ServerCode

% new ocean color data path
cd /Users/srishtidasarathy/Documents/Bowman/PhD_Phase_Two_SouthernOcean/Variables

Chl_data_dir = '/Users/srishtidasarathy/Documents/Bowman/PhD_Phase_Two_EOF_Analysis_Southern_Ocean/Ocean_Color_Data/' ;


nc_files     = dir([Chl_data_dir '*4km.nc']);

% file_with_data_in_range = 0;

% Southern Ocean Spatial Subset
 LatLims  = [-90  -50];
 LonLims  = [-180 180];

%%
  Master_count_n   = [];
  Master_filename  = [];
        
% data
  Master_Latitude  = [];
  Master_Longitude = [];
  Master_chl_a     = [];
  inRange_Lon      = [];
    
  %%
  for n = 1:length(nc_files)
      
      disp(n)
      myFileName   = nc_files(n,:).name;
      fullFileName = fullfile(Chl_data_dir, myFileName);
      
      product_name        = 'lat';
      Latitude            = ncread( fullFileName , product_name );
      
      inRange_Lat = Latitude >= LatLims(1) & Latitude < LatLims(end); 
      
      product_name        = 'lon';
      Longitude           = ncread( fullFileName , product_name );
      
      inRange_Lon = Longitude >= LonLims(1) & Longitude < LonLims(end) ; 

      % sum(inRange) >= 1 so we have data
      %tracking number of file with data in range
%       file_with_data_in_range         = file_with_data_in_range +1;
      
      product_name        = 'chlor_a';
      chlor_a             = ncread( fullFileName, product_name) ;
      
      
      Latitude_subset   = Latitude(inRange_Lat) ;
      Longitude_subset  = Longitude(inRange_Lon) ;
      chl_a_subset      = chlor_a(inRange_Lon, inRange_Lat);
      time              = nc_files(n).name(2:15);  % filename has year followed by number of days from first day of year 
                      % to year then end of number of days from first day of year
     
      if  n == 1          
          % counter
          Master_count_n   = n ;
          Master_filename  = fullFileName;
          Master_time      = time ; 
          Master_chl_a     = chl_a_subset ;          
      else
          % counter          
          Master_count_n   = cat(1, Master_count_n, n);
          Master_filename  = cat(1, Master_filename, fullFileName);
          Master_time      = cat(1, Master_time, time) ; 
          Master_chl_a     = cat(3, Master_chl_a, chl_a_subset);    %% concatenated along the third dimension
      end    
      
  end
  
    
% Master_chl_a_mean = mean(Master_chl_a, 3, 'omitnan'); 
% Master_chl_a_median = median(Master_chl_a, 3, 'omitnan'); 
 


%%% CHANGE DIRECTORY!!!!!

cd /Users/srishtidasarathy/Documents/Bowman/PhD_Phase_Two_SouthernOcean/Variables

%  Renaming the variables here

Latitude_Subset_SouthernOcean = Latitude_subset; 
Longitude_Subset_SouthernOcean = Longitude_subset;
Master_chl_a_full_res_SouthernOcean = Master_chl_a;

clear Master_chl_a Longitude_subset Latitude_subset
% save('Aqua_Latitude_SouthernOcean.mat', 'Latitude_subset', '-v7.3') 
% save('Aqua_Longitude_SouthernOcean.mat', 'Longitude_subset', '-v7.3') 
% save('Master_chl_a_full_res_SouthernOcean.mat', 'Master_chl_a', '-v7.3') 

t1 = datetime(2007,01,01);
t2 = datetime(2020,12,31);
times = t1:calmonths(1):t2; 

clear t1 t2

times_seasons = times(3) : calmonths(3) : times(167); 


save('Aqua.mat',...
    'Master_time',...
    'Master_count_n', ...
    'Master_filename',...
    'Master_chl_a_full_res_SouthernOcean',...
    'Latitude_Subset_SouthernOcean',...
    'Longitude_Subset_SouthernOcean',...
    '-v7.3');


% I constructed a video to confirm that my reading of chlorophyll data was correct: 
%%
figure(1), clf

vidfile = VideoWriter('chl_var_save_TEST_1by1.mp4','MPEG-4');
vidfile.FrameRate = 1;
open(vidfile);

% times_for_plot = times(229:end);

for i = 1 : 168
    disp(i)
    
    plot_SO_figure(Master_chl_a_full_res_SouthernOcean(:,:,i),...
        Longitude_Subset_SouthernOcean,...
        Latitude_Subset_SouthernOcean,...
        'algae',...
        [0 1],...
        (['chl: ', datestr(Master_time(i))]))
    
    
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

