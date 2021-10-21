
%% I read these data from the CALIPSO server!!
%% Preprocessing of 5kmApro Files
s       = struct() ;
mat_dir = '/SCF8/CALIPSO/Users/sdasarat';
% '/Volumes/Chip Data Disk/CALIPSO_LID_L2_05kmAPro-Standard-V4-20'; %% use volumes to access hard drive
f       = dir(fullfile(mat_dir, 'Calipso*.mat'));

for n = 1 : length(f)
    disp(n)
    
    name         = fullfile(mat_dir, f(n).name);
    
    load(name, 'Master_COD_Cloud');
    load(name, 'Master_Color_ratio'); 
    load(name, 'Master_count_n'); 
    load(name, 'Master_Day_Night_Flag'); 
    load(name, 'Master_EC_532'); 
    load(name, 'Master_filename'); 
    load(name, 'Master_Latitude'); 
    load(name, 'Master_Longitude'); 
    load(name, 'Master_Part_Depol_Ratio'); 
    load(name, 'Master_Profile_Time'); 
   
    load(name, 'Master_Surface_Elevation_Statistics');
    load(name, 'Master_Surface_532_Integrated_Depolarization_Ratio');
    load(name, 'Master_Surface_Type');
    
    if n == 1
        
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
        
    else
         % counter
        Total_count_n          = cat(1, Total_count_n, Master_count_n);
        Total_filename         = cat(1, Total_filename, Master_filename);
        
        % data
        Total_Profile_Time         = cat(1, Total_Profile_Time, Master_Profile_Time);
        Total_Latitude             = cat(1, Total_Latitude, Master_Latitude);
        Total_Longitude            = cat(1, Total_Longitude, Master_Longitude);
        Total_EC_532               = cat(1, Total_EC_532, Master_EC_532) ;
        Total_Color_ratio          = cat(1, Total_Color_ratio, Master_Color_ratio);
        Total_Part_Depol_Ratio     = cat(1, Total_Part_Depol_Ratio, Master_Part_Depol_Ratio);
        Total_Day_Night_Flag       = cat(1, Total_Day_Night_Flag, Master_Day_Night_Flag); 
        Total_COD_Cloud            = cat(1, Total_COD_Cloud, Master_COD_Cloud); 
      
        Total_Surface_Elevation_Statistics                = cat(1, Total_Surface_Elevation_Statistics, Master_Surface_Elevation_Statistics);
        Total_Surface_532_Integrated_Depolarization_Ratio = cat(1, Total_Surface_532_Integrated_Depolarization_Ratio, Master_Surface_532_Integrated_Depolarization_Ratio);
        Total_Surface_Type                                = cat(1, Total_Surface_Type, Master_Surface_Type);
   
    end
    
  
end

Total_Profile_Time_New = datetime(Total_Profile_Time,'ConvertFrom',...
        'epochtime','Epoch','1993-01-01');
   
% This is a good rough code for how to do this. In reality, this was way too much to process, and instead I stepped through each individual year from 2007 to 2020.
save('Calipso_2007_2020.mat',...
     'Total_count_n',...
     'Total_filename',...
     'Total_Profile_Time',...
     'Total_Profile_Time_New',...
     'Total_Latitude' ,...
     'Total_Longitude',...
     'Total_EC_532',...
     'Total_Color_ratio',...
     'Total_Part_Depol_Ratio',...
     'Total_Day_Night_Flag' ,...
     'Total_COD_Cloud',...
     'Total_Surface_Elevation_Statistics',...
     'Total_Surface_532_Integrated_Depolarization_Ratio',...
     'Total_Surface_Type',...
      '-v7.3')


  
  
  
  