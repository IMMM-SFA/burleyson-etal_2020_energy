% Figure_S3_S4.m: Model Validation Exercise
% 20200623
% Casey D. Burleyson
% Pacific Northwest National Laboratory

warning off all; clear all; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN USER INPUT SECTION               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set some processing flags:
save_images = 1; % (1 = Yes)

% Set the data input and output directories:
data_input_dir = '/Users/burl878/OneDrive - PNNL/Desktop/BEND_GCAM_Paper_Data/Data/Model_Validation_Exercise/';
image_output_dir = '/Users/burl878/OneDrive - PNNL/Desktop/BEND_GCAM_Paper_Data/Figures/';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              END USER INPUT SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN PROCESSING SECTION               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
load([data_input_dir,'BEND_State_Loads_2007_and_2010.mat']);
load([data_input_dir,'OBSV_State_Loads_2005_to_2010.mat']);
load([data_input_dir,'GCAM_State_Loads_2005_and_2010.mat']);
   
Data_2005(:,1) = OBSV_States;
Data_2005(:,2) = OBSV_State_Res_Loads(:,find(OBSV_State_Time(1,:) == 2005));
Data_2005(:,3) = OBSV_State_Com_Loads(:,find(OBSV_State_Time(1,:) == 2005));
Data_2005(:,4) = OBSV_State_Res_Loads(:,find(OBSV_State_Time(1,:) == 2005)) + OBSV_State_Com_Loads(:,find(OBSV_State_Time(1,:) == 2005));
for row = 1:size(Data_2005,1)
    Data_2005(row,5) = Electricity(find(Electricity_Table(:,1) == Data_2005(row,1)),1).Res_Total_2005;
    Data_2005(row,6) = Electricity(find(Electricity_Table(:,1) == Data_2005(row,1)),1).Com_Total_2005;
    Data_2005(row,7) = Electricity(find(Electricity_Table(:,1) == Data_2005(row,1)),1).All_Total_2005;
    Data_2005(row,8:10) = NaN.*0;
end
clear row

Data_2007(:,1) = OBSV_States;
Data_2007(:,2) = OBSV_State_Res_Loads(:,find(OBSV_State_Time(1,:) == 2007));
Data_2007(:,3) = OBSV_State_Com_Loads(:,find(OBSV_State_Time(1,:) == 2007));
Data_2007(:,4) = OBSV_State_Res_Loads(:,find(OBSV_State_Time(1,:) == 2007)) + OBSV_State_Com_Loads(:,find(OBSV_State_Time(1,:) == 2007));
for row = 1:size(Data_2005,1)
    Data_2007(row,5:7) = NaN.*0;
    Data_2007(row,8) = BEND_State_Loads(find(BEND_State_Loads(:,1) == Data_2007(row,1)),2);
    Data_2007(row,9) = BEND_State_Loads(find(BEND_State_Loads(:,1) == Data_2007(row,1)),3);
    Data_2007(row,10) = Data_2007(row,8) + Data_2007(row,9);
end
clear row

Data_2010(:,1) = OBSV_States;
Data_2010(:,2) = OBSV_State_Res_Loads(:,find(OBSV_State_Time(1,:) == 2010));
Data_2010(:,3) = OBSV_State_Com_Loads(:,find(OBSV_State_Time(1,:) == 2010));
Data_2010(:,4) = OBSV_State_Res_Loads(:,find(OBSV_State_Time(1,:) == 2010)) + OBSV_State_Com_Loads(:,find(OBSV_State_Time(1,:) == 2010));
for row = 1:size(Data_2010,1)
    Data_2010(row,5) = Electricity(find(Electricity_Table(:,1) == Data_2010(row,1)),1).Res_Total_2010;
    Data_2010(row,6) = Electricity(find(Electricity_Table(:,1) == Data_2010(row,1)),1).Com_Total_2010;
    Data_2010(row,7) = Electricity(find(Electricity_Table(:,1) == Data_2010(row,1)),1).All_Total_2010;
    Data_2010(row,8) = BEND_State_Loads(find(BEND_State_Loads(:,1) == Data_2010(row,1)),4);
    Data_2010(row,9) = BEND_State_Loads(find(BEND_State_Loads(:,1) == Data_2010(row,1)),5);
    Data_2010(row,10) = Data_2010(row,8) + Data_2010(row,9);
end
clear row

States = Data_2005(:,1);
states_shapefile = shaperead('usastatelo');
for row = 1:size(States,1)
    [state_string,state_abbreviation] = State_Strings(States(row,1));
    index = find(strcmpi({states_shapefile.Name},state_string) == 1);
    states_shapefile(index,1).FIPS = States(row,1);
    States(row,2) = index;
    clear state_string state_abbreviation index
end
clear row

lat_min = 24.4; lat_max = 50; lon_min = -125.9; lon_max = -65.6;

GCAM_Res_Bias = 100.*(Data_2010(:,5) - Data_2010(:,2))./Data_2010(:,2);
BEND_Res_Bias = 100.*(Data_2007(:,8) - Data_2007(:,2))./Data_2007(:,2);
GCAM_Com_Bias = 100.*(Data_2010(:,6) - Data_2010(:,3))./Data_2010(:,3);
BEND_Com_Bias = 100.*(Data_2007(:,9) - Data_2007(:,3))./Data_2007(:,3);

grids(1,:) = [0:0.1:100];
grids(2,:) = grids(1,:) - 0.1.*grids(1,:);
grids(3,:) = grids(1,:);
grids(4,:) = grids(1,:) + 0.1.*grids(1,:);

clear BEND_State_Loads Electricity Electricity_Table OBSV_State_Com_Loads OBSV_State_Res_Loads OBSV_State_Time OBSV_States
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               END PROCESSING SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN PLOTTING SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a = figure('Color',[1 1 1]); set(a,'Position',get(0,'Screensize')); 
subplot(2,2,1); hold on; 
scatter(Data_2005(:,2)./(10^7),Data_2005(:,5)./(10^7),50,'k','LineWidth',3);
scatter(Data_2010(:,2)./(10^7),Data_2010(:,5)./(10^7),250,'b','LineWidth',3);
line(grids(1,:),grids(3,:),'Color',[0.5 0.5 0.5],'LineWidth',1);
line(grids(1,:),grids(2,:),'Color',[0.5 0.5 0.5],'LineWidth',1,'LineStyle','--');
line(grids(1,:),grids(4,:),'Color',[0.5 0.5 0.5],'LineWidth',1,'LineStyle','--');
xlim([0,10]); ylim([0,10]); legend('Calibration Year','Evaluation Year','Location','NorthWest');
xlabel('Observed [10^7 MWh]','FontSize',21); ylabel('Simulated [10^7 MWh]','FontSize',24);
set(gca,'LineWidth',3,'FontSize',24,'Box','on');
title('GCAM-USA Residential Buildings','FontSize',27);
text(-0.05,1.1,['(a)'],'FontSize',24,'Units','normalized');
   
subplot(2,2,2); hold on; 
scatter(Data_2010(:,2)./(10^7),Data_2010(:,8)./(10^7),50,'k','LineWidth',3);
scatter(Data_2007(:,2)./(10^7),Data_2007(:,8)./(10^7),250,'r','LineWidth',3);
line(grids(1,:),grids(3,:),'Color',[0.5 0.5 0.5],'LineWidth',1);
line(grids(1,:),grids(2,:),'Color',[0.5 0.5 0.5],'LineWidth',1,'LineStyle','--');
line(grids(1,:),grids(4,:),'Color',[0.5 0.5 0.5],'LineWidth',1,'LineStyle','--');
xlim([0,10]); ylim([0,10]); legend('Calibration Year','Evaluation Year','Location','NorthWest');
xlabel('Observed [10^7 MWh]','FontSize',21); ylabel('Simulated [10^7 MWh]','FontSize',24);
set(gca,'LineWidth',3,'FontSize',24,'Box','on');
title('BEND Residential Buildings','FontSize',27);
text(-0.05,1.1,['(b)'],'FontSize',24,'Units','normalized');
   
subplot(2,2,3); hold on;
ax3 = usamap([lat_min lat_max],[lon_min lon_max]); colormap(ax3,redblue(24));
states = shaperead('usastatelo','UseGeoCoords',true,'Selector',{@(name)~any(strcmp(name,{'Alaska','Hawaii'})),'Name'});
faceColors = makesymbolspec('Polygon',{'INDEX',[1 numel(states)],'FaceColor',polcmap(numel(states))}); faceColors.FaceColor{1,3} = faceColors.FaceColor{1,3}./faceColors.FaceColor{1,3};
geoshow(ax3,states,'DisplayType','polygon','SymbolSpec',faceColors,'LineWidth',1,'LineStyle','-');
for row = 1:size(States,1)
    patchm(states_shapefile(States(row,2),1).Y,states_shapefile(States(row,2),1).X,0,'FaceVertexCData',GCAM_Res_Bias(row,1),'FaceColor','flat');
end
set(gca,'clim',[-18 18]);
tightmap; framem on; gridm off; mlabel off; plabel off;
colo1 = colorbar('ytick',[-24:3:24],'yTickLabel',{'-24','','-18','','-12','','-6','','0','','+6','','+12','','+18','','+24'},'Location','EastOutside');
set(get(colo1,'ylabel'),'String',{'Relative Bias [%]'},'FontSize',24);
set(gca,'LineWidth',3,'FontSize',21,'Box','on','Layer','top');
title('GCAM-USA Evaluation Year Bias','FontSize',27);
text(-0.05,1.1,['(c)'],'FontSize',24,'Units','normalized');
   
subplot(2,2,4); hold on;
ax4 = usamap([lat_min lat_max],[lon_min lon_max]); colormap(ax4,redblue(24));
states = shaperead('usastatelo','UseGeoCoords',true,'Selector',{@(name)~any(strcmp(name,{'Alaska','Hawaii'})),'Name'});
faceColors = makesymbolspec('Polygon',{'INDEX',[1 numel(states)],'FaceColor',polcmap(numel(states))}); faceColors.FaceColor{1,3} = faceColors.FaceColor{1,3}./faceColors.FaceColor{1,3};
geoshow(ax4,states,'DisplayType','polygon','SymbolSpec',faceColors,'LineWidth',1,'LineStyle','-');
for row = 1:size(States,1)
    if isnan(BEND_Res_Bias(row,1)) == 0
       patchm(states_shapefile(States(row,2),1).Y,states_shapefile(States(row,2),1).X,0,'FaceVertexCData',BEND_Res_Bias(row,1),'FaceColor','flat');
    else
       patchm(states_shapefile(States(row,2),1).Y,states_shapefile(States(row,2),1).X,[0.65 0.65 0.65]);
    end
end
set(gca,'clim',[-18 18]);
tightmap; framem on; gridm off; mlabel off; plabel off;
colo2 = colorbar('ytick',[-24:3:24],'yTickLabel',{'-24','','-18','','-12','','-6','','0','','+6','','+12','','+18','','+24'},'Location','EastOutside');
set(get(colo2,'ylabel'),'String',{'Relative Bias [%]'},'FontSize',24);
set(gca,'LineWidth',3,'FontSize',21,'Box','on','Layer','top');
title('BEND Evaluation Year Bias','FontSize',27);
text(-0.05,1.1,['(d)'],'FontSize',24,'Units','normalized');
   
if save_images == 1
   set(gcf,'Renderer','zbuffer'); set(gcf,'PaperPositionMode','auto');
   print(a,'-dpng','-r600',[image_output_dir,'Figure_S3.png']);
   close(a);
end 
clear a ax3 ax4 colo1 colo2 faceColors row states 
   
   
a = figure('Color',[1 1 1]); set(a,'Position',get(0,'Screensize')); 
subplot(2,2,1); hold on; 
scatter(Data_2005(:,3)./(10^7),Data_2005(:,6)./(10^7),50,'k','LineWidth',3);
scatter(Data_2010(:,3)./(10^7),Data_2010(:,6)./(10^7),250,'b','LineWidth',3);
line(grids(1,:),grids(3,:),'Color',[0.5 0.5 0.5],'LineWidth',1);
line(grids(1,:),grids(2,:),'Color',[0.5 0.5 0.5],'LineWidth',1,'LineStyle','--');
line(grids(1,:),grids(4,:),'Color',[0.5 0.5 0.5],'LineWidth',1,'LineStyle','--');
xlim([0,6]); ylim([0,6]); legend('Calibration Year','Evaluation Year','Location','NorthWest');
xlabel('Observed [10^7 MWh]','FontSize',24); ylabel('Simulated [10^7 MWh]','FontSize',24);
set(gca,'LineWidth',3,'FontSize',21,'Box','on');
title('GCAM-USA Commercial Buildings','FontSize',27);
text(-0.05,1.1,['(a)'],'FontSize',24,'Units','normalized');
   
subplot(2,2,2); hold on; 
scatter(Data_2010(:,3)./(10^7),Data_2010(:,9)./(10^7),50,'k','LineWidth',3);
scatter(Data_2007(:,3)./(10^7),Data_2007(:,9)./(10^7),250,'r','LineWidth',3);
line(grids(1,:),grids(3,:),'Color',[0.5 0.5 0.5],'LineWidth',1);
line(grids(1,:),grids(2,:),'Color',[0.5 0.5 0.5],'LineWidth',1,'LineStyle','--');
line(grids(1,:),grids(4,:),'Color',[0.5 0.5 0.5],'LineWidth',1,'LineStyle','--');
xlim([0,6]); ylim([0,6]); legend('Calibration Year','Evaluation Year','Location','NorthWest');
xlabel('Observed [10^7 MWh]','FontSize',24); ylabel('Simulated [10^7 MWh]','FontSize',24);
set(gca,'LineWidth',3,'FontSize',21,'Box','on');
title('BEND Commercial Buildings','FontSize',27);
text(-0.05,1.1,['(b)'],'FontSize',24,'Units','normalized');
 
subplot(2,2,3); hold on;
ax3 = usamap([lat_min lat_max],[lon_min lon_max]); colormap(ax3,redblue(24));
states = shaperead('usastatelo','UseGeoCoords',true,'Selector',{@(name)~any(strcmp(name,{'Alaska','Hawaii'})),'Name'});
faceColors = makesymbolspec('Polygon',{'INDEX',[1 numel(states)],'FaceColor',polcmap(numel(states))}); faceColors.FaceColor{1,3} = faceColors.FaceColor{1,3}./faceColors.FaceColor{1,3};
geoshow(ax3,states,'DisplayType','polygon','SymbolSpec',faceColors,'LineWidth',1,'LineStyle','-');
for row = 1:size(States,1)
    patchm(states_shapefile(States(row,2),1).Y,states_shapefile(States(row,2),1).X,0,'FaceVertexCData',GCAM_Com_Bias(row,1),'FaceColor','flat');
end
set(gca,'clim',[-18 18]);
tightmap; framem on; gridm off; mlabel off; plabel off;
colo1 = colorbar('ytick',[-24:3:24],'yTickLabel',{'-24','','-18','','-12','','-6','','0','','+6','','+12','','+18','','+24'},'Location','EastOutside');
set(get(colo1,'ylabel'),'String',{'Relative Bias [%]'},'FontSize',24);
set(gca,'LineWidth',3,'FontSize',21,'Box','on','Layer','top');
title('GCAM-USA Evaluation Year Bias','FontSize',27);
text(-0.05,1.1,['(c)'],'FontSize',24,'Units','normalized');
   
subplot(2,2,4); hold on;
ax4 = usamap([lat_min lat_max],[lon_min lon_max]); colormap(ax4,redblue(24));
states = shaperead('usastatelo','UseGeoCoords',true,'Selector',{@(name)~any(strcmp(name,{'Alaska','Hawaii'})),'Name'});
faceColors = makesymbolspec('Polygon',{'INDEX',[1 numel(states)],'FaceColor',polcmap(numel(states))}); faceColors.FaceColor{1,3} = faceColors.FaceColor{1,3}./faceColors.FaceColor{1,3};
geoshow(ax4,states,'DisplayType','polygon','SymbolSpec',faceColors,'LineWidth',1,'LineStyle','-');
for row = 1:size(States,1)
    if isnan(BEND_Com_Bias(row,1)) == 0
       patchm(states_shapefile(States(row,2),1).Y,states_shapefile(States(row,2),1).X,0,'FaceVertexCData',BEND_Com_Bias(row,1),'FaceColor','flat');
    else
       patchm(states_shapefile(States(row,2),1).Y,states_shapefile(States(row,2),1).X,[0.65 0.65 0.65]);
    end
end
set(gca,'clim',[-18 18]);
tightmap; framem on; gridm off; mlabel off; plabel off;
colo2 = colorbar('ytick',[-24:3:24],'yTickLabel',{'-24','','-18','','-12','','-6','','0','','+6','','+12','','+18','','+24'},'Location','EastOutside');
set(get(colo2,'ylabel'),'String',{'Relative Bias [%]'},'FontSize',24);
set(gca,'LineWidth',3,'FontSize',21,'Box','on','Layer','top');
title('BEND Evaluation Year Bias','FontSize',27);
text(-0.05,1.1,['(d)'],'FontSize',24,'Units','normalized');
   
if save_images == 1
   set(gcf,'Renderer','zbuffer'); set(gcf,'PaperPositionMode','auto');
   print(a,'-dpng','-r600',[image_output_dir,'Figure_S4.png']);
   close(a);
end 
clear a ax3 ax4 colo1 colo2 faceColors row states
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               END PLOTTING SECTION                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                BEGIN CLEANUP SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear data_input_dir grids image_output_dir lat_max lat_min lon_max lon_min save_images states_shapefile
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 END CLEANUP SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%