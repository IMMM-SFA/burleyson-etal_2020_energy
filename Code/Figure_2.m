% Figure_2.m: Weather Workflow
% 20200623
% Casey D. Burleyson
% Pacific Northwest National Laboratory

warning off all; clear all; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN USER INPUT SECTION               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set some processing flags:
process_data = 1; % (1 = Yes)
save_images = 1; % (1 = Yes)
base_t = 18.3; % Base temperature in C for calculating CDD and HDD

% Set the data input and output directories:
mapping_data_input_dir = '/Users/burl878/OneDrive - PNNL/Desktop/BEND_GCAM_Paper_Data/Data/Geolocation/';
temperature_data_input_dir = '/Users/burl878/OneDrive - PNNL/Desktop/BEND_GCAM_Paper_Data/Data/HDD_CDD_Projections/';
data_output_dir = '/Users/burl878/OneDrive - PNNL/Desktop/BEND_GCAM_Paper_Data/Data/Data_Supporting_Figures/';
image_output_dir = '/Users/burl878/OneDrive - PNNL/Desktop/BEND_GCAM_Paper_Data/Figures/';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              END USER INPUT SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN PROCESSING SECTION               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if process_data == 1
   load([mapping_data_input_dir,'Weather_Stations_by_IECC_Climate_Zone.mat'],'County_Metadata_Table','County_Metadata');
   Sites = unique(County_Metadata_Table(:,10));
   Sites = Sites(find(isnan(Sites(:,1)) == 0),1);
   for row = 1:size(Sites,1)
       Sites(row,2:3) = County_Metadata_Table(min(find(County_Metadata_Table(:,10) == Sites(row,1))),11:12);
   end
   clear row

   load([temperature_data_input_dir,'Sites_Daily_Mean_Temperature_RCP85_2007.mat'],'Sites_Mean_T','Mean_T_Time','Sites');
   Sites_T = Sites_Mean_T; Time = Mean_T_Time;
   clear Sites_Mean_T Mean_T_Time

   load([temperature_data_input_dir,'States_Daily_Mean_Temperature_RCP85_2007.mat'],'States_Mean_T','Mean_T_Time','States');
   CDD = 0.*States_Mean_T; CDD(find(States_Mean_T > base_t)) = round(States_Mean_T(find(States_Mean_T > base_t)) - base_t);
   HDD = 0.*States_Mean_T; HDD(find(States_Mean_T < base_t)) = round(base_t - States_Mean_T(find(States_Mean_T < base_t)));
   States_T = States_Mean_T; States_HDD = HDD; States_CDD = CDD;
   clear States_Mean_T Mean_T_Time HDD CDD

   County_Metadata_Table(:,15) = roundn(County_Metadata_Table(:,1),3);
   County_Metadata_Table(find(County_Metadata_Table(:,15) == 52000),15) = 51000;
   County_Metadata_Table(find(County_Metadata_Table(:,1) == 48501),15) = 48000;
   County_Metadata_Table(find(County_Metadata_Table(:,1) == 48503),15) = 48000;
   County_Metadata_Table(find(County_Metadata_Table(:,1) == 48505),15) = 48000;
   County_Metadata_Table(find(County_Metadata_Table(:,1) == 48507),15) = 48000;

   for row = 1:size(County_Metadata,1)
       if isnan(County_Metadata_Table(row,10)) == 0
          County_T(row,:) = Sites_T(find(Sites(:,1) == County_Metadata_Table(row,10)),:);
       else
          County_T(row,:) = NaN.*0;
       end
       State_T(row,:) = States_T(find(States(:,1) == County_Metadata_Table(row,15)),:);
       State_CDD(row,:) = States_CDD(find(States(:,1) == County_Metadata_Table(row,15)),:);
       State_HDD(row,:) = States_HDD(find(States(:,1) == County_Metadata_Table(row,15)),:);
   end
   clear row Sites_T States States_CDD States_HDD States_T
   
   save([data_output_dir,'Figure_2_Data.mat'],'base_t','County_Metadata','County_Metadata_Table','County_T','Sites','State_CDD','State_HDD','State_T','Time');
else
   load([data_output_dir,'Figure_2_Data.mat']);    
end

load([mapping_data_input_dir,'worldlo.mat']);
clear DNline DNpatch POpatch POtext PPpoint PPtext description disclaimer gazette source

lat_min = 24.4; lat_max = 50; lon_min = -125.9; lon_max = -65.6; column = 185;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               END PROCESSING SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN PLOTTING SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a = figure('Color',[1 1 1]); set(a,'Position',get(0,'Screensize')); 
subplot(2,2,1); hold on;
ax1 = usamap([lat_min lat_max],[lon_min lon_max]); colormap(ax1,jet(18));
states = shaperead('usastatelo','UseGeoCoords',true,'Selector',{@(name)~any(strcmp(name,{'Alaska','Hawaii'})),'Name'});
faceColors = makesymbolspec('Polygon',{'INDEX',[1 numel(states)],'FaceColor',polcmap(numel(states))});
faceColors.FaceColor{1,3} = faceColors.FaceColor{1,3}./faceColors.FaceColor{1,3};
geoshow(ax1,states,'DisplayType','polygon','SymbolSpec',faceColors,'LineWidth',1,'LineStyle','-');
for i = 1:size(County_Metadata,1)
    patchm(County_Metadata(i,1).Latitude_Vector,County_Metadata(i,1).Longitude_Vector,0,'FaceVertexCData',County_Metadata_Table(i,7),'FaceColor','flat')
end
for i = 1:size(County_Metadata,1)
    linem([County_Metadata_Table(i,2) County_Metadata_Table(i,11)],[County_Metadata_Table(i,3) County_Metadata_Table(i,12)],'Color','k','LineWidth',0.25);
end
for row = 1:size(Sites,1)
    scatterm(Sites(row,2),Sites(row,3),50,'filled','MarkerFaceColor','w','MarkerEdgeColor','k','LineWidth',1.5);
end
set(gca,'clim',[1,19]);
colo1 = colorbar('ytick',[1.5:1:18.5],'YTickLabel',{'1A','1C','2A','2B','3A','3B','3C','4A','4B','4C','5A','5B','6A','6B','7A','7B','7C','8C'});
set(get(colo1,'ylabel'),'String',{'IECC Climate Zone'},'FontSize',21);
tightmap; framem on; gridm off; mlabel off; plabel off;
set(gca,'LineWidth',3,'FontSize',21,'Box','on','Layer','top');
title(['BEND Weather Stations'],'FontSize',27);
text(-0.05,1.10,['(a)'],'FontSize',24,'Units','normalized');

subplot(2,2,2); hold on;
ax2 = usamap([lat_min lat_max],[lon_min lon_max]); colormap(ax2,jet(40));
states = shaperead('usastatelo','UseGeoCoords',true,'Selector',{@(name)~any(strcmp(name,{'Alaska','Hawaii'})),'Name'});
faceColors = makesymbolspec('Polygon',{'INDEX',[1 numel(states)],'FaceColor',polcmap(numel(states))});
faceColors.FaceColor{1,3} = faceColors.FaceColor{1,3}./faceColors.FaceColor{1,3};
geoshow(ax2,states,'DisplayType','polygon','SymbolSpec',faceColors,'LineWidth',1,'LineStyle','-');
for i = 1:size(County_Metadata,1)
    patchm(County_Metadata(i,1).Latitude_Vector,County_Metadata(i,1).Longitude_Vector,0,'FaceVertexCData',County_T(i,column),'FaceColor','flat')
end
for row = 1:size(Sites,1)
    scatterm(Sites(row,2),Sites(row,3),50,'filled','MarkerFaceColor','w','MarkerEdgeColor','k','LineWidth',1.5);
end
set(gca,'clim',[0,40]);
colo2 = colorbar('ytick',[0:5:40],'YTickLabel',{['0',setstr(176),'C'],'',['10',setstr(176),'C'],'',['20',setstr(176),'C'],'',['30',setstr(176),'C'],'',['40',setstr(176),'C']});
set(get(colo2,'ylabel'),'String',{'Daily Mean Temperature'},'FontSize',21);
tightmap; framem on; gridm off; mlabel off; plabel off;
set(gca,'LineWidth',3,'FontSize',21,'Box','on','Layer','top');
title(['Weather Station Temperatures'],'FontSize',27);
text(-0.05,1.10,['(b)'],'FontSize',24,'Units','normalized');

subplot(2,2,4); hold on;
ax3 = usamap([lat_min lat_max],[lon_min lon_max]); colormap(ax3,jet(40));
states = shaperead('usastatelo','UseGeoCoords',true,'Selector',{@(name)~any(strcmp(name,{'Alaska','Hawaii'})),'Name'});
faceColors = makesymbolspec('Polygon',{'INDEX',[1 numel(states)],'FaceColor',polcmap(numel(states))});
faceColors.FaceColor{1,3} = faceColors.FaceColor{1,3}./faceColors.FaceColor{1,3};
geoshow(ax3,states,'DisplayType','polygon','SymbolSpec',faceColors,'LineWidth',1,'LineStyle','-');
for i = 1:size(County_Metadata,1)
    patchm(County_Metadata(i,1).Latitude_Vector,County_Metadata(i,1).Longitude_Vector,0,'FaceVertexCData',State_T(i,column),'FaceColor','flat')
end
for row = 1:size(Sites,1)
    scatterm(Sites(row,2),Sites(row,3),50,'filled','MarkerFaceColor','w','MarkerEdgeColor','k','LineWidth',1.5);
end
set(gca,'clim',[0,40]);
colo3 = colorbar('ytick',[0:5:40],'YTickLabel',{['0',setstr(176),'C'],'',['10',setstr(176),'C'],'',['20',setstr(176),'C'],'',['30',setstr(176),'C'],'',['40',setstr(176),'C']});
set(get(colo3,'ylabel'),'String',{'Daily Mean Temperature'},'FontSize',21);
tightmap; framem on; gridm off; mlabel off; plabel off;
set(gca,'LineWidth',3,'FontSize',21,'Box','on','Layer','top');
title(['State Temperatures'],'FontSize',27);
text(-0.05,1.10,['(c)'],'FontSize',24,'Units','normalized');

subplot(2,2,3); hold on;
ax4 = usamap([lat_min lat_max],[lon_min lon_max]); colormap(ax4,jet(15));
states = shaperead('usastatelo','UseGeoCoords',true,'Selector',{@(name)~any(strcmp(name,{'Alaska','Hawaii'})),'Name'});
faceColors = makesymbolspec('Polygon',{'INDEX',[1 numel(states)],'FaceColor',polcmap(numel(states))});
faceColors.FaceColor{1,3} = faceColors.FaceColor{1,3}./faceColors.FaceColor{1,3};
geoshow(ax4,states,'DisplayType','polygon','SymbolSpec',faceColors,'LineWidth',1,'LineStyle','-');
for i = 1:size(County_Metadata,1)
    patchm(County_Metadata(i,1).Latitude_Vector,County_Metadata(i,1).Longitude_Vector,0,'FaceVertexCData',State_CDD(i,column),'FaceColor','flat')
end
set(gca,'clim',[0,15]);
colo4 = colorbar('ytick',[0:3:15],'YTickLabel',{'0','3','6','9','12','15'});
set(get(colo4,'ylabel'),'String',{'Cooling Degree Days'},'FontSize',21);
tightmap; framem on; gridm off; mlabel off; plabel off;
set(gca,'LineWidth',3,'FontSize',21,'Box','on','Layer','top');
title(['State Cooling Degree Days'],'FontSize',27);
text(-0.05,1.10,['(d)'],'FontSize',24,'Units','normalized');

annotation('arrow',[0.492 0.542],[0.750 0.750],'Color','k','LineWidth',15,'HeadStyle','plain','HeadWidth',25);
annotation('arrow',[0.542 0.492],[0.280 0.280],'Color','k','LineWidth',15,'HeadStyle','plain','HeadWidth',25);
annotation('arrow',[0.722 0.722],[0.545 0.495],'Color','k','LineWidth',15,'HeadStyle','plain','HeadWidth',25);

if save_images == 1
   set(gcf,'Renderer','zbuffer'); set(gcf,'PaperPositionMode','auto');
   print(a,'-dpng','-r600',[image_output_dir,'Figure_2.png']);
   close(a);
end
clear a ax1 ax2 ax3 ax4 colo1 colo2 colo3 colo4 faceColors i row states column
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               END PLOTTING SECTION                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                BEGIN CLEANUP SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear base_t column data_output_dir image_output_dir lat_max lat_min lon_max lon_min mapping_data_input_dir POline process_data save_images temperature_data_input_dir
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 END CLEANUP SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%