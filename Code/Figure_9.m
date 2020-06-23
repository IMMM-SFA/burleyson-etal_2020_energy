% Figure_9.m: BEND Total Maps
% 20200623
% Casey D. Burleyson
% Pacific Northwest National Laboratory

warning off all; clear all; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN USER INPUT SECTION               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set some processing flags:
process_data = 1;
save_images = 1;

% Set the data input and output directories:
mapping_data_input_dir = '/Users/burl878/OneDrive - PNNL/Desktop/BEND_GCAM_Paper_Data/Data/Geolocation/';
data_input_dir = '/Users/burl878/OneDrive - PNNL/Desktop/BEND_GCAM_Paper_Data/Data/BEND_Runs/';
data_output_dir = '/Users/burl878/OneDrive - PNNL/Desktop/BEND_GCAM_Paper_Data/Data/Data_Supporting_Figures/';
image_output_dir = '/Users/burl878/OneDrive - PNNL/Desktop/BEND_GCAM_Paper_Data/Figures/';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              END USER INPUT SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN PROCESSING SECTION               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if process_data == 1
   counter = 0;
   for scenario = [4,7,16,34]
       counter = counter + 1;
       if scenario == 4;  scenario_string = '04'; end
       if scenario == 7;  scenario_string = '07'; end
       if scenario == 16; scenario_string = '16'; end
       if scenario == 34; scenario_string = '34'; end

       load([mapping_data_input_dir,'BEND_Geolocation_Data.mat']);
       clear Groupings Sites States
       
       i = 0;
       for year = 2010:1:2050
           i = i + 1;
           Years(1,i) = year;
           load([data_input_dir,'BEND_Scenarios_',scenario_string,'_',num2str(year),'.mat']);
           Tot_Load = Res_Load + Com_Load;
           Res_Sum(:,i) = nansum(Res_Load,2);
           Com_Sum(:,i) = nansum(Com_Load,2);
           Tot_Sum(:,i) = nansum(Tot_Load,2);
           clear Res_Load Com_Load Time Tot_Load
       end
       clear year i
   
       for row = 1:size(Com_Sum,1)
            for column = 1:size(Com_Sum,2)
                Res_Sum_Norm(row,column) = Res_Sum(row,column)./Res_Sum(row,1);
                Com_Sum_Norm(row,column) = Com_Sum(row,column)./Com_Sum(row,1);
                Tot_Sum_Norm(row,column) = Tot_Sum(row,column)./Tot_Sum(row,1);
            end
       end
       clear row column
   
       for row = 1:size(Com_Sum,1)
           Res_Sum_Difference(row,counter) = Res_Sum(row,41) - Res_Sum(row,1);
           Com_Sum_Difference(row,counter) = Com_Sum(row,41) - Com_Sum(row,1);
           Tot_Sum_Difference(row,counter) = Tot_Sum(row,41) - Tot_Sum(row,1);
           Res_Sum_Norm_Difference(row,counter) = 1 + Res_Sum_Norm(row,41) - Res_Sum_Norm(row,1);
           Com_Sum_Norm_Difference(row,counter) = 1 + Com_Sum_Norm(row,41) - Com_Sum_Norm(row,1);
           Tot_Sum_Norm_Difference(row,counter) = 1 + Tot_Sum_Norm(row,41) - Tot_Sum_Norm(row,1);
       end
       
       Tot_Sum_All(:,:,counter) = Res_Sum + Com_Sum;
       
       clear row Res_Sum Com_Sum Res_Sum_Norm Com_Sum_Norm Tot_Sum_Norm Years scenario_string
   end
   clear scenario i counter
   
   save([data_output_dir,'Figure_9_Data.mat'],'BEND_County_Metadata','BEND_County_Metadata_Table','Com_Sum_Difference','Com_Sum_Norm_Difference',...
        'Res_Sum_Difference','Res_Sum_Norm_Difference','Tot_Sum_Difference','Tot_Sum_Norm_Difference','Tot_Sum_All');
else
   load([data_output_dir,'Figure_9_Data.mat']);
end

Climate_Impact = 100.*(Tot_Sum_All(:,41,3) - Tot_Sum_All(:,41,4))./Tot_Sum_All(:,41,4);

lat_min = 31; lat_max = 49.5; lon_min = -125; lon_max = -101.5;

States = unique(BEND_County_Metadata_Table(:,2));
for row = 1:size(States,1)
    Subset(:,1) = BEND_County_Metadata_Table(find(BEND_County_Metadata_Table(:,2) == States(row,1)),1);
    Subset(:,2) = Tot_Sum_Norm_Difference(find(BEND_County_Metadata_Table(:,2) == States(row,1)),3);
    Variations(row,1) = States(row,1);
    Variations(row,2) = nanmean(Subset(:,2));
    Variations(row,3) = nanstd(Subset(:,2));
    Variations(row,4) = nanmax(Subset(:,2)) - nanmin(Subset(:,2));
    clear Subset
end
clear States row

California_Climate_Change = Climate_Impact(find(BEND_County_Metadata_Table(:,2) == 6000),1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               END PROCESSING SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN PLOTTING SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a = figure('Color',[1 1 1]); set(a,'Position',get(0,'Screensize'));
subplot(2,7,[1 2]); hold on;
ax1 = usamap([lat_min lat_max],[lon_min lon_max]); colormap(ax1,jet(30));
states = shaperead('usastatelo','UseGeoCoords',true,'Selector',{@(name)~any(strcmp(name,{'Alaska','Hawaii'})),'Name'});
faceColors = makesymbolspec('Polygon',{'INDEX',[1 numel(states)],'FaceColor',polcmap(numel(states))}); faceColors.FaceColor{1,3} = faceColors.FaceColor{1,3}./faceColors.FaceColor{1,3};
geoshow(ax1,states,'DisplayType','polygon','SymbolSpec',faceColors,'LineWidth',1,'LineStyle','-');
for row = 1:size(BEND_County_Metadata_Table,1)
    patchm(BEND_County_Metadata(row,1).Latitude_Vector,BEND_County_Metadata(row,1).Longitude_Vector,0,'FaceVertexCData',Tot_Sum_Norm_Difference(row,1),'FaceColor','flat');
end
set(gca,'clim',[1 2.5]); tightmap; framem on; gridm off; mlabel off; plabel off; set(gca,'LineWidth',3,'FontSize',21,'Box','on','Layer','top');
title(['LowRF-LowPop'],'FontSize',24);
text(0.035,0.10,['(a)'],'FontSize',21,'Units','normalized');

subplot(2,7,[3 4]); hold on;
ax2 = usamap([lat_min lat_max],[lon_min lon_max]); colormap(ax2,jet(30));
states = shaperead('usastatelo','UseGeoCoords',true,'Selector',{@(name)~any(strcmp(name,{'Alaska','Hawaii'})),'Name'});
faceColors = makesymbolspec('Polygon',{'INDEX',[1 numel(states)],'FaceColor',polcmap(numel(states))}); faceColors.FaceColor{1,3} = faceColors.FaceColor{1,3}./faceColors.FaceColor{1,3};
geoshow(ax2,states,'DisplayType','polygon','SymbolSpec',faceColors,'LineWidth',1,'LineStyle','-');
for row = 1:size(BEND_County_Metadata_Table,1)
    patchm(BEND_County_Metadata(row,1).Latitude_Vector,BEND_County_Metadata(row,1).Longitude_Vector,0,'FaceVertexCData',Tot_Sum_Norm_Difference(row,2),'FaceColor','flat');
end
set(gca,'clim',[1 2.5]); tightmap; framem on; gridm off; mlabel off; plabel off; set(gca,'LineWidth',3,'FontSize',21,'Box','on','Layer','top');
title(['LowRF-HighPop'],'FontSize',24);
text(0.035,0.10,['(b)'],'FontSize',21,'Units','normalized');

subplot(2,7,[8 9]); hold on;
ax3 = usamap([lat_min lat_max],[lon_min lon_max]); colormap(ax3,jet(30));
states = shaperead('usastatelo','UseGeoCoords',true,'Selector',{@(name)~any(strcmp(name,{'Alaska','Hawaii'})),'Name'});
faceColors = makesymbolspec('Polygon',{'INDEX',[1 numel(states)],'FaceColor',polcmap(numel(states))}); faceColors.FaceColor{1,3} = faceColors.FaceColor{1,3}./faceColors.FaceColor{1,3};
geoshow(ax3,states,'DisplayType','polygon','SymbolSpec',faceColors,'LineWidth',1,'LineStyle','-');
for row = 1:size(BEND_County_Metadata_Table,1)
    patchm(BEND_County_Metadata(row,1).Latitude_Vector,BEND_County_Metadata(row,1).Longitude_Vector,0,'FaceVertexCData',Tot_Sum_Norm_Difference(row,3),'FaceColor','flat');
end
set(gca,'clim',[1 2.5]); tightmap; framem on; gridm off; mlabel off; plabel off; set(gca,'LineWidth',3,'FontSize',21,'Box','on','Layer','top');
title(['HighRF-HighPop'],'FontSize',24);
text(0.035,0.10,['(c)'],'FontSize',21,'Units','normalized');

subplot(2,7,[10 11]); hold on;
ax4 = usamap([lat_min lat_max],[lon_min lon_max]); colormap(ax4,jet(30));
states = shaperead('usastatelo','UseGeoCoords',true,'Selector',{@(name)~any(strcmp(name,{'Alaska','Hawaii'})),'Name'});
faceColors = makesymbolspec('Polygon',{'INDEX',[1 numel(states)],'FaceColor',polcmap(numel(states))}); faceColors.FaceColor{1,3} = faceColors.FaceColor{1,3}./faceColors.FaceColor{1,3};
geoshow(ax4,states,'DisplayType','polygon','SymbolSpec',faceColors,'LineWidth',1,'LineStyle','-');
for row = 1:size(BEND_County_Metadata_Table,1)
    patchm(BEND_County_Metadata(row,1).Latitude_Vector,BEND_County_Metadata(row,1).Longitude_Vector,0,'FaceVertexCData',Tot_Sum_Norm_Difference(row,4),'FaceColor','flat');
end
set(gca,'clim',[1 2.5]); tightmap; framem on; gridm off; mlabel off; plabel off; set(gca,'LineWidth',3,'FontSize',21,'Box','on','Layer','top');
title(['NoCCI-HighPop'],'FontSize',24);
text(0.035,0.10,['(d)'],'FontSize',21,'Units','normalized');

subplot(2,7,[12 13]); hold on;
ax5 = usamap([lat_min lat_max],[lon_min lon_max]); colormap(ax5,redblue(28));
states = shaperead('usastatelo','UseGeoCoords',true,'Selector',{@(name)~any(strcmp(name,{'Alaska','Hawaii'})),'Name'});
faceColors = makesymbolspec('Polygon',{'INDEX',[1 numel(states)],'FaceColor',polcmap(numel(states))}); faceColors.FaceColor{1,3} = faceColors.FaceColor{1,3}./faceColors.FaceColor{1,3};
geoshow(ax5,states,'DisplayType','polygon','SymbolSpec',faceColors,'LineWidth',1,'LineStyle','-');
for row = 1:size(BEND_County_Metadata_Table,1)
    patchm(BEND_County_Metadata(row,1).Latitude_Vector,BEND_County_Metadata(row,1).Longitude_Vector,0,'FaceVertexCData',Climate_Impact(row,1),'FaceColor','flat');
end
set(gca,'clim',[-7 7]);
tightmap; framem on; gridm off; mlabel off; plabel off;
set(gca,'LineWidth',3,'FontSize',21,'Box','on','Layer','top');
title(['HighRF Climate Change Impact'],'FontSize',24);
text(0.035,0.10,['(e)'],'FontSize',21,'Units','normalized');

subplot(4,7,[5 6]); colormap(gca,jet(30)); axis off
set(gca,'clim',[1 2.5]);
colo = colorbar('xtick',[0:0.25:4],'xTickLabel',{'0.00','0.25','0.50','0.75','1.00','1.25','1.50','1.75','2.00','2.25','2.50','2.75','3.00','3.25','3.50','3.75','4.00'},'Location','South');
set(get(colo,'xlabel'),'String',{'Total Building Electricity Change'},'FontSize',21);
set(gca,'LineWidth',3,'FontSize',21,'Box','on','Layer','top');

subplot(4,7,[12 13]); colormap(gca,redblue(28)); axis off
set(gca,'clim',[-7 7]);
colo = colorbar('xtick',[-8:2:8],'xTickLabel',{'-8','-6','-4','-2','0','+2','+4','+6','+8'},'Location','North');
set(get(colo,'xlabel'),'String',{'Climate Change Impact [%]'},'FontSize',21);
set(gca,'LineWidth',3,'FontSize',21,'Box','on','Layer','top');

if save_images == 1
   set(gcf,'Renderer','zbuffer'); set(gcf,'PaperPositionMode','auto');
   print(a,'-dpng','-r600',[image_output_dir,'Figure_9.png']);
   close(a);
end
clear a ax1 ax2 ax3 ax4 ax5 i colo faceColors row states
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               END PLOTTING SECTION                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                BEGIN CLEANUP SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear data_input_dir image_output_dir save_images lat_min lat_max lon_min lon_max data_output_dir mapping_data_input_dir process_data 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 END CLEANUP SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%