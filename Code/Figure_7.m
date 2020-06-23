% Figure_7.m: Floor Space Relationships
% 20200623
% Casey D. Burleyson
% Pacific Northwest National Laboratory

warning off all; clear all; close all; 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN USER INPUT SECTION               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set some processing flags:
process_data = 1; % (1 = yes)
gcam_run = 3; % (1 = raw, 2 = fixed service demands, 3 = controlled electricity prices)
save_images = 1; % (1 = yes)
axis_lim = 2.15; % x- and y-axis limits

% Set the data input and output directories:
bend_data_input_dir = '/Users/burl878/OneDrive - PNNL/Desktop/BEND_GCAM_Paper_Data/Data/BEND_Runs/';
gcam_data_input_dir = '/Users/burl878/OneDrive - PNNL/Desktop/BEND_GCAM_Paper_Data/Data/GCAM_Runs/';
floor_space_data_input_dir = '/Users/burl878/OneDrive - PNNL/Desktop/BEND_GCAM_Paper_Data/Data/GCAM_Runs/';
mapping_data_input_dir = '/Users/burl878/OneDrive - PNNL/Desktop/BEND_GCAM_Paper_Data/Data/Geolocation/';
data_output_dir = '/Users/burl878/OneDrive - PNNL/Desktop/BEND_GCAM_Paper_Data/Data/Data_Supporting_Figures/';
image_output_dir = '/Users/burl878/OneDrive - PNNL/Desktop/BEND_GCAM_Paper_Data/Figures/';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              END USER INPUT SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN PROCESSING SECTION               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if process_data == 1
   load([floor_space_data_input_dir,'SSP3_4p5_CCI_Floorspace.mat']);   Res_FS(:,:,1) = Residential; clear Residential; Com_FS(:,:,1) = Commercial; clear Commercial;
   load([floor_space_data_input_dir,'SSP5_4p5_CCI_Floorspace.mat']);   Res_FS(:,:,2) = Residential; clear Residential; Com_FS(:,:,2) = Commercial; clear Commercial;
   load([floor_space_data_input_dir,'SSP5_8p5_CCI_Floorspace.mat']);   Res_FS(:,:,3) = Residential; clear Residential; Com_FS(:,:,3) = Commercial; clear Commercial;
   load([floor_space_data_input_dir,'SSP5_8p5_NoCCI_Floorspace.mat']); Res_FS(:,:,4) = Residential; clear Residential; Com_FS(:,:,4) = Commercial; clear Commercial;
   Res_FS = Res_FS(find(State_FIPS(:,1) == 4000  | State_FIPS(:,1) == 6000  | State_FIPS(:,1) == 8000 | ...
                        State_FIPS(:,1) == 16000 | State_FIPS(:,1) == 30000 | State_FIPS(:,1) == 32000 | ...
                        State_FIPS(:,1) == 35000 | State_FIPS(:,1) == 41000 | State_FIPS(:,1) == 49000 | ...
                        State_FIPS(:,1) == 53000 | State_FIPS(:,1) == 56000),:,:);
   Com_FS = Com_FS(find(State_FIPS(:,1) == 4000  | State_FIPS(:,1) == 6000  | State_FIPS(:,1) == 8000 | ...
                        State_FIPS(:,1) == 16000 | State_FIPS(:,1) == 30000 | State_FIPS(:,1) == 32000 | ...
                        State_FIPS(:,1) == 35000 | State_FIPS(:,1) == 41000 | State_FIPS(:,1) == 49000 | ...
                        State_FIPS(:,1) == 53000 | State_FIPS(:,1) == 56000),:,:);
   for row = 1:size(Res_FS,1)
       for scenario = 1:size(Res_FS,3)
           Res = Res_FS(row,:,scenario); Res_FS_Interpolated(row,:,scenario) = interp1(Years,Res,[2010:1:2050]); clear Res
           Com = Com_FS(row,:,scenario); Com_FS_Interpolated(row,:,scenario) = interp1(Years,Com,[2010:1:2050]); clear Com
       end
       clear scenario
   end
   BEND_Res_FS = Res_FS_Interpolated;
   BEND_Com_FS = Com_FS_Interpolated;
   GCAM_Res_FS = Res_FS;
   GCAM_Com_FS = Com_FS;
   clear row Res_FS_Interpolated Com_FS_Interpolated State_FIPS Years
   
   for run = 1:12
       if run == 1;  run_name = 'SSP3_4p5_CCI';       end
       if run == 2;  run_name = 'SSP5_4p5_CCI';       end
       if run == 3;  run_name = 'SSP5_8p5_CCI';       end
       if run == 4;  run_name = 'SSP5_8p5_NoCCI';     end
       if run == 5;  run_name = 'SSP3_4p5_CCI_FSD';   end
       if run == 6;  run_name = 'SSP5_4p5_CCI_FSD';   end
       if run == 7;  run_name = 'SSP5_8p5_CCI_FSD';   end
       if run == 8;  run_name = 'SSP5_8p5_NoCCI_FSD'; end
       if run == 9;  run_name = 'SSP3_4p5_CCI_CEP';   end
       if run == 10; run_name = 'SSP5_4p5_CCI_CEP';   end
       if run == 11; run_name = 'SSP5_8p5_CCI_CEP';   end
       if run == 12; run_name = 'SSP5_8p5_NoCCI_CEP'; end
    
       load([gcam_data_input_dir,run_name,'_State_Electricity.mat']);
       
       State_FIPS = Electricity_Table(:,1);
       
       for row = 1:size(Electricity,1)
           Res(row,:) = Electricity(row,1).Res_Total;
           Com(row,:) = Electricity(row,1).Com_Total;
       end
       clear row Electricity Electricity_Table
       
       Res = Res.*(10^18); Res = Res./(3.6*10^6); Res = Res./1000000;
       Com = Com.*(10^18); Com = Com./(3.6*10^6); Com = Com./1000000;
       Res = Res(find(State_FIPS(:,1) == 4000  | State_FIPS(:,1) == 6000  | State_FIPS(:,1) == 8000 | ...
                      State_FIPS(:,1) == 16000 | State_FIPS(:,1) == 30000 | State_FIPS(:,1) == 32000 | ...
                      State_FIPS(:,1) == 35000 | State_FIPS(:,1) == 41000 | State_FIPS(:,1) == 49000 | ...
                      State_FIPS(:,1) == 53000 | State_FIPS(:,1) == 56000),:,:);
       Com = Com(find(State_FIPS(:,1) == 4000  | State_FIPS(:,1) == 6000  | State_FIPS(:,1) == 8000 | ...
                      State_FIPS(:,1) == 16000 | State_FIPS(:,1) == 30000 | State_FIPS(:,1) == 32000 | ...
                      State_FIPS(:,1) == 35000 | State_FIPS(:,1) == 41000 | State_FIPS(:,1) == 49000 | ...
                      State_FIPS(:,1) == 53000 | State_FIPS(:,1) == 56000),:,:);
       GCAM_Res(:,:,run) = Res;
       GCAM_Com(:,:,run) = Com;
       clear row Com Res run_name State_FIPS States
   end
   clear run
      
   load([mapping_data_input_dir,'BEND_Geolocation_Data.mat']); clear Groupings Sites
   i = 0;
   for scenario = [4,7,16,34]
       i = i + 1;
       if scenario == 4;  scenario_string = '04'; end
       if scenario == 7;  scenario_string = '07'; end
       if scenario == 16; scenario_string = '16'; end
       if scenario == 34; scenario_string = '34'; end
       
       j = 0;
       for year = 2010:1:2050
           j = j + 1;
           load([bend_data_input_dir,'BEND_Scenarios_',scenario_string,'_',num2str(year),'.mat']);
           for row = 1:size(States,1)
               Res_Load_Subset = Res_Load(find(BEND_County_Metadata_Table(:,2) == States(row,1)),:);
               Com_Load_Subset = Com_Load(find(BEND_County_Metadata_Table(:,2) == States(row,1)),:);
               BEND_Res(row,j,i) = nansum(Res_Load_Subset(:)).*States(row,4);
               BEND_Com(row,j,i) = nansum(Com_Load_Subset(:)).*States(row,4);
               clear Res_Load_Subset Com_Load_Subset
           end
           clear row Res_Load Com_Load Time
       end
       clear j year scenario_string
   end
   clear i scenario BEND_County_Metadata BEND_County_Metadata_Table

   BEND_Time = [2010:1:2050]; GCAM_Time = [2010:5:2050];
   
   save([data_output_dir,'Figure_7_Data.mat'],'BEND_Com','BEND_Res','BEND_Com_FS','GCAM_Com','GCAM_Res','GCAM_Com_FS','BEND_Res_FS','GCAM_Res_FS','States','BEND_Time','GCAM_Time');
else
   load([data_output_dir,'Figure_7_Data.mat']);
end

BEND_Res_Total = sum(BEND_Res,1); clear BEND_Res
BEND_Com_Total = sum(BEND_Com,1); clear BEND_Com
BEND_Res_FS_Total = sum(BEND_Res_FS,1); clear BEND_Res_FS
BEND_Com_FS_Total = sum(BEND_Com_FS,1); clear BEND_Com_FS
GCAM_Res_Total = sum(GCAM_Res,1); clear GCAM_Res
GCAM_Com_Total = sum(GCAM_Com,1); clear GCAM_Com
GCAM_Res_FS_Total = sum(GCAM_Res_FS,1); clear GCAM_Res_FS
GCAM_Com_FS_Total = sum(GCAM_Com_FS,1); clear GCAM_Com_FS

for column = 1:size(BEND_Res_Total,2)
    for run = 1:size(BEND_Res_Total,3);
        BEND_Res_Total_Norm(1,column,run) = BEND_Res_Total(1,column,run)./BEND_Res_Total(1,1,run);
        BEND_Com_Total_Norm(1,column,run) = BEND_Com_Total(1,column,run)./BEND_Com_Total(1,1,run);
        BEND_Res_FS_Total_Norm(1,column,run) = BEND_Res_FS_Total(1,column,run)./BEND_Res_FS_Total(1,1,run);
        BEND_Com_FS_Total_Norm(1,column,run) = BEND_Com_FS_Total(1,column,run)./BEND_Com_FS_Total(1,1,run);
    end
    clear run
end
clear column BEND_Res_Total BEND_Com_Total BEND_Res_FS_Total BEND_Com_FS_Total

for column = 1:size(GCAM_Res_Total,2)
    for run = 1:size(GCAM_Res_Total,3);
        GCAM_Res_Total_Norm(1,column,run) = GCAM_Res_Total(1,column,run)./GCAM_Res_Total(1,1,run);
        GCAM_Com_Total_Norm(1,column,run) = GCAM_Com_Total(1,column,run)./GCAM_Com_Total(1,1,run);
        if run == 1 | run == 2 | run == 3 | run == 4
           GCAM_Res_FS_Total_Norm(1,column,run) = GCAM_Res_FS_Total(1,column,run)./GCAM_Res_FS_Total(1,1,run);
           GCAM_Com_FS_Total_Norm(1,column,run) = GCAM_Com_FS_Total(1,column,run)./GCAM_Com_FS_Total(1,1,run);
        elseif run == 5 | run == 6 | run == 7 | run == 8
           GCAM_Res_FS_Total_Norm(1,column,run) = GCAM_Res_FS_Total(1,column,run-4)./GCAM_Res_FS_Total(1,1,run-4);
           GCAM_Com_FS_Total_Norm(1,column,run) = GCAM_Com_FS_Total(1,column,run-4)./GCAM_Com_FS_Total(1,1,run-4);
        elseif run == 9 | run == 10 | run == 11 | run == 12
           GCAM_Res_FS_Total_Norm(1,column,run) = GCAM_Res_FS_Total(1,column,run-8)./GCAM_Res_FS_Total(1,1,run-8);
           GCAM_Com_FS_Total_Norm(1,column,run) = GCAM_Com_FS_Total(1,column,run-8)./GCAM_Com_FS_Total(1,1,run-8);
        end
    end
    clear run
end
clear column GCAM_Res_Total GCAM_Com_Total GCAM_Res_FS_Total GCAM_Com_FS_Total

if gcam_run == 1
   GCAM_Res_FS_Total_Norm = GCAM_Res_FS_Total_Norm(:,:,1:4);
   GCAM_Com_FS_Total_Norm = GCAM_Com_FS_Total_Norm(:,:,1:4);
   GCAM_Res_Total_Norm = GCAM_Res_Total_Norm(:,:,1:4);
   GCAM_Com_Total_Norm = GCAM_Com_Total_Norm(:,:,1:4);
elseif gcam_run == 2
   GCAM_Res_FS_Total_Norm = GCAM_Res_FS_Total_Norm(:,:,5:8);
   GCAM_Com_FS_Total_Norm = GCAM_Com_FS_Total_Norm(:,:,5:8);
   GCAM_Res_Total_Norm = GCAM_Res_Total_Norm(:,:,5:8);
   GCAM_Com_Total_Norm = GCAM_Com_Total_Norm(:,:,5:8);
elseif gcam_run == 3
   GCAM_Res_FS_Total_Norm = GCAM_Res_FS_Total_Norm(:,:,9:12);
   GCAM_Com_FS_Total_Norm = GCAM_Com_FS_Total_Norm(:,:,9:12);
   GCAM_Res_Total_Norm = GCAM_Res_Total_Norm(:,:,9:12);
   GCAM_Com_Total_Norm = GCAM_Com_Total_Norm(:,:,9:12);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               END PROCESSING SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN PLOTTING SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a = figure('Color',[1 1 1]); set(a,'Position',get(0,'Screensize'));
for i = 1:4
    if i == 1; label_string = '(a)'; end; if i == 2; label_string = '(b)'; end; if i == 3; label_string = '(c)'; end; if i == 4; label_string = '(d)'; end;
    
    fitobject = fit(GCAM_Res_FS_Total_Norm(1,:,i)',GCAM_Res_Total_Norm(1,:,i)','poly1');
    ci = confint(fitobject,0.95); Slope_Ranges(1,1) = ci(1,1); Slope_Ranges(1,2) = ci(2,1); clear ci
    Mean_Parameters(1,i) = fitobject.p1; GCAM_Res_Trend = feval(fitobject,GCAM_Res_FS_Total_Norm(1,:,i))'; clear fitobject
    
    fitobject = fit(GCAM_Com_FS_Total_Norm(1,:,i)',GCAM_Com_Total_Norm(1,:,i)','poly1');
    ci = confint(fitobject,0.95); Slope_Ranges(2,1) = ci(1,1); Slope_Ranges(2,2) = ci(2,1); clear ci
    Mean_Parameters(3,i) = fitobject.p1; GCAM_Com_Trend = feval(fitobject,GCAM_Com_FS_Total_Norm(1,:,i))'; clear fitobject
        
    fitobject = fit(BEND_Res_FS_Total_Norm(1,:,i)',BEND_Res_Total_Norm(1,:,i)','poly1');
    ci = confint(fitobject,0.95); Slope_Ranges(3,1) = ci(1,1); Slope_Ranges(3,2) = ci(2,1); clear ci
    Mean_Parameters(2,i) = fitobject.p1; BEND_Res_Trend = feval(fitobject,BEND_Res_FS_Total_Norm(1,:,i))'; clear fitobject
    
    fitobject = fit(BEND_Com_FS_Total_Norm(1,:,i)',BEND_Com_Total_Norm(1,:,i)','poly1');
    ci = confint(fitobject,0.95); Slope_Ranges(4,1) = ci(1,1); Slope_Ranges(4,2) = ci(2,1); clear ci
    Mean_Parameters(4,i) = fitobject.p1; BEND_Com_Trend = feval(fitobject,BEND_Com_FS_Total_Norm(1,:,i))'; clear fitobject

    subplot(2,2,i); hold on;
    scatter(GCAM_Res_FS_Total_Norm(1,:,i),GCAM_Res_Total_Norm(1,:,i),200,'r','filled');
    scatter(BEND_Res_FS_Total_Norm(1,:,i),BEND_Res_Total_Norm(1,:,i),100,'r','LineWidth',2);
    scatter(GCAM_Com_FS_Total_Norm(1,:,i),GCAM_Com_Total_Norm(1,:,i),200,'b','filled');
    scatter(BEND_Com_FS_Total_Norm(1,:,i),BEND_Com_Total_Norm(1,:,i),100,'b','LineWidth',2);
    line(GCAM_Res_FS_Total_Norm(1,:,i),GCAM_Res_Trend,'Color','r','LineWidth',3);
    line(GCAM_Com_FS_Total_Norm(1,:,i),GCAM_Com_Trend,'Color','b','LineWidth',3);
    line(BEND_Res_FS_Total_Norm(1,:,i),BEND_Res_Trend,'Color','r','LineWidth',3,'LineStyle','--');
    line(BEND_Com_FS_Total_Norm(1,:,i),BEND_Com_Trend,'Color','b','LineWidth',3,'LineStyle','--');
    line([1 3],[1 3],'Color',[0.5 0.5 0.5],'LineWidth',1.5,'LineStyle','-');
    legend(['GCAM Res.,',num2str(roundn(Mean_Parameters(1,i),-2)),':1'],['BEND Res.,',num2str(roundn(Mean_Parameters(2,i),-2)),':1'],...
           ['GCAM Com.,',num2str(roundn(Mean_Parameters(3,i),-2)),':1'],['BEND Com.,',num2str(roundn(Mean_Parameters(4,i),-2)),':1'],'Location','NorthWest');
    xlim([1 axis_lim]); set(gca,'xtick',[1:0.25:3],'xticklabel',{'1.00','1.25','1.50','1.75','2.00','2.25','2.50','2.75','3.00'});
    xlabel('Total Floor Space Relative to 2010','FontSize',21);
    ylim([1 axis_lim]); set(gca,'ytick',[1:0.25:3],'yticklabel',{'1.00','1.25','1.50','1.75','2.00','2.25','2.50','2.75','3.00'});
    ylabel('Total Electricity Relative to 2010','FontSize',21);
    set(gca,'LineWidth',3,'FontSize',18,'Box','on');
    text(-0.02,1.10,[label_string],'FontSize',21,'Units','normalized');
    if i == 1; title('LowRF-LowPop','FontSize',24); end
    if i == 2; title('LowRF-HighPop','FontSize',24); end
    if i == 3; title('HighRF-HighPop','FontSize',24); end
    if i == 4; title('NoCCI-HighPop','FontSize',24); end
    clear GCAM_Res_Trend GCAM_Com_Trend BEND_Res_Trend BEND_Com_Trend label_string Slope_Ranges
end
if save_images == 1
   set(gcf,'Renderer','zbuffer'); set(gcf,'PaperPositionMode','auto');
   print(a,'-dpng','-r600',[image_output_dir,'Figure_7.png']);
   close(a);
end
clear i a
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               END PLOTTING SECTION                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                BEGIN CLEANUP SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear bend_data_input_dir data_output_dir image_output_dir bend_metadata_input_dir plot_images process_data save_images floor_space_data_input_dir gcam_data_input_dir States axis_lim
clear BEND_Time GCAM_Time gcam_run mapping_data_input_dir
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 END CLEANUP SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%