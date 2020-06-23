% Figure_3.m: GCAM Total Maps
% 20200623
% Casey D. Burleyson
% Pacific Northwest National Laboratory

warning off all; clear all; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN USER INPUT SECTION               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set some processing flags:
process_data = 1; % (1 = Yes)
gcam_run = 3; % (1 = raw, 2 = fixed service demands, 3 = controlled electricity prices)
save_images = 0; % (1 = Yes)

% Set the data input and output directories:
data_input_dir = '/Users/burl878/OneDrive - PNNL/Desktop/BEND_GCAM_Paper_Data/Data/GCAM_Runs/';
data_output_dir = '/Users/burl878/OneDrive - PNNL/Desktop/BEND_GCAM_Paper_Data/Data/Data_Supporting_Figures/';
image_output_dir = '/Users/burl878/OneDrive - PNNL/Desktop/BEND_GCAM_Paper_Data/Figures/';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              END USER INPUT SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN PROCESSING SECTION               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if process_data == 1
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
       if run == 13; run_name = 'SSP5_8p5_SF_CCI_CEP'; end
    
       load([data_input_dir,run_name,'_State_Electricity.mat']);
       
       if run == 1; GCAM_States = Electricity_Table(:,1); end
       
       for row = 1:size(Electricity,1)
           Commercial_Electricity(row,:) = Electricity(row,1).Com_Total;
           Residential_Electricity(row,:) = Electricity(row,1).Res_Total;
           Total_Electricity(row,:) = Electricity(row,1).All_Total;
       end
       clear row Electricity Electricity_Table
       
       Commercial_Electricity = Commercial_Electricity.*(10^18); Commercial_Electricity = Commercial_Electricity./(3.6*10^6); Commercial_Electricity = Commercial_Electricity./1000000;
       Residential_Electricity = Residential_Electricity.*(10^18); Residential_Electricity = Residential_Electricity./(3.6*10^6); Residential_Electricity = Residential_Electricity./1000000;
       Total_Electricity = Total_Electricity.*(10^18); Total_Electricity = Total_Electricity./(3.6*10^6); Total_Electricity = Total_Electricity./1000000;
    
       for row = 1:size(Commercial_Electricity,1)
           for column = 1:size(Commercial_Electricity,2)
               Commercial_Electricity_Normalized(row,column) = Commercial_Electricity(row,column)./Commercial_Electricity(row,1);
               Residential_Electricity_Normalized(row,column) = Residential_Electricity(row,column)./Residential_Electricity(row,1);
               Total_Electricity_Normalized(row,column) = Total_Electricity(row,column)./Total_Electricity(row,1);
           end
       end
    
       Com(:,:,run) = Commercial_Electricity;
       Com_Norm(:,:,run) = Commercial_Electricity_Normalized;
       Res(:,:,run) = Residential_Electricity;
       Res_Norm(:,:,run) = Residential_Electricity_Normalized;
       Tot(:,:,run) = Total_Electricity;
       Tot_Norm(:,:,run) = Total_Electricity_Normalized;
       clear Commercial_Electricity Commercial_Electricity_Normalized Residential_Electricity Residential_Electricity_Normalized run_name row column Total_Electricity Total_Electricity_Normalized
   end
   clear run

   for row = 1:size(Com,1)
       for run = 1:size(Com,3)
           Com_Difference(row,run) = Com(row,9,run) - Com(row,1,run);
           Com_Norm_Difference(row,run) = 1 + Com_Norm(row,9,run) - Com_Norm(row,1,run);
           Res_Difference(row,run) = Res(row,9,run) - Res(row,1,run);
           Res_Norm_Difference(row,run) = 1 + Res_Norm(row,9,run) - Res_Norm(row,1,run);
           Tot_Difference(row,run) = Tot(row,9,run) - Tot(row,1,run);
           Tot_Norm_Difference(row,run) = 1 + Tot_Norm(row,9,run) - Tot_Norm(row,1,run);
       end
       clear run
   end
   clear row

   Climate_Impact = 100.*(Tot(:,:,3) - Tot(:,:,4))./Tot(:,:,4);
   Climate_Impact_FSD = 100.*(Tot(:,:,7) - Tot(:,:,8))./Tot(:,:,8);
   Climate_Impact_CEP = 100.*(Tot(:,:,11) - Tot(:,:,12))./Tot(:,:,12);

   States = GCAM_States([4,5,6,14,27,34,33,38,45,48,51],:);
   Tot_Norm_Difference = Tot_Norm_Difference([4,5,6,14,27,34,33,38,45,48,51],:);
   Climate_Impact = Climate_Impact([4,5,6,14,27,34,33,38,45,48,51],9);
   Climate_Impact_FSD = Climate_Impact_FSD([4,5,6,14,27,34,33,38,45,48,51],9);
   Climate_Impact_CEP = Climate_Impact_CEP([4,5,6,14,27,34,33,38,45,48,51],9);
   
   save([data_output_dir,'Figure_8_Data.mat'],'Climate_Impact','Climate_Impact_FSD','Climate_Impact_CEP','States','Tot_Norm_Difference');
   clear Com Com_Difference Com_Norm Com_Norm_Difference Res Res_Difference Res_Norm Res_Norm_Difference GCAM_States Tot Tot_Difference Tot_Norm
else
   load([data_output_dir,'Figure_8_Data.mat']);
end

states_shapefile = shaperead('usastatelo');
for row = 1:size(States,1)
    [state_string,state_abbreviation] = State_Strings(States(row,1));
    index = find(strcmpi({states_shapefile.Name},state_string) == 1);
    states_shapefile(index,1).FIPS = States(row,1);
    States(row,2) = index;
    clear state_string state_abbreviation index
end
clear row

lat_min = 31; lat_max = 49.5; lon_min = -125; lon_max = -101.5;
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
for row = 1:size(States,1)
    if gcam_run == 1
       patchm(states_shapefile(States(row,2),1).Y,states_shapefile(States(row,2),1).X,0,'FaceVertexCData',Tot_Norm_Difference(row,1),'FaceColor','flat');
    elseif gcam_run == 2
       patchm(states_shapefile(States(row,2),1).Y,states_shapefile(States(row,2),1).X,0,'FaceVertexCData',Tot_Norm_Difference(row,5),'FaceColor','flat');
    elseif gcam_run == 3
       patchm(states_shapefile(States(row,2),1).Y,states_shapefile(States(row,2),1).X,0,'FaceVertexCData',Tot_Norm_Difference(row,9),'FaceColor','flat');
    end
end
set(gca,'clim',[1 2.5]);
tightmap; framem on; gridm off; mlabel off; plabel off;
set(gca,'LineWidth',3,'FontSize',21,'Box','on','Layer','top');
title(['LowRF-LowPop'],'FontSize',24);
text(0.035,0.10,['(a)'],'FontSize',21,'Units','normalized');

subplot(2,7,[3 4]); hold on;
ax2 = usamap([lat_min lat_max],[lon_min lon_max]); colormap(ax2,jet(30));
states = shaperead('usastatelo','UseGeoCoords',true,'Selector',{@(name)~any(strcmp(name,{'Alaska','Hawaii'})),'Name'});
faceColors = makesymbolspec('Polygon',{'INDEX',[1 numel(states)],'FaceColor',polcmap(numel(states))}); faceColors.FaceColor{1,3} = faceColors.FaceColor{1,3}./faceColors.FaceColor{1,3};
geoshow(ax2,states,'DisplayType','polygon','SymbolSpec',faceColors,'LineWidth',1,'LineStyle','-');
for row = 1:size(States,1)
    if gcam_run == 1
       patchm(states_shapefile(States(row,2),1).Y,states_shapefile(States(row,2),1).X,0,'FaceVertexCData',Tot_Norm_Difference(row,2),'FaceColor','flat');
    elseif gcam_run == 2
       patchm(states_shapefile(States(row,2),1).Y,states_shapefile(States(row,2),1).X,0,'FaceVertexCData',Tot_Norm_Difference(row,6),'FaceColor','flat');
    elseif gcam_run == 3
       patchm(states_shapefile(States(row,2),1).Y,states_shapefile(States(row,2),1).X,0,'FaceVertexCData',Tot_Norm_Difference(row,10),'FaceColor','flat');
    end
end
set(gca,'clim',[1 2.5]);
tightmap; framem on; gridm off; mlabel off; plabel off;
set(gca,'LineWidth',3,'FontSize',21,'Box','on','Layer','top');
title(['LowRF-HighPop'],'FontSize',24);
text(0.035,0.10,['(b)'],'FontSize',21,'Units','normalized');

subplot(2,7,[8 9]); hold on;
ax3 = usamap([lat_min lat_max],[lon_min lon_max]); colormap(ax3,jet(30));
states = shaperead('usastatelo','UseGeoCoords',true,'Selector',{@(name)~any(strcmp(name,{'Alaska','Hawaii'})),'Name'});
faceColors = makesymbolspec('Polygon',{'INDEX',[1 numel(states)],'FaceColor',polcmap(numel(states))}); faceColors.FaceColor{1,3} = faceColors.FaceColor{1,3}./faceColors.FaceColor{1,3};
geoshow(ax3,states,'DisplayType','polygon','SymbolSpec',faceColors,'LineWidth',1,'LineStyle','-');
for row = 1:size(States,1)
    if gcam_run == 1
       patchm(states_shapefile(States(row,2),1).Y,states_shapefile(States(row,2),1).X,0,'FaceVertexCData',Tot_Norm_Difference(row,3),'FaceColor','flat');
    elseif gcam_run == 2
       patchm(states_shapefile(States(row,2),1).Y,states_shapefile(States(row,2),1).X,0,'FaceVertexCData',Tot_Norm_Difference(row,7),'FaceColor','flat');
    elseif gcam_run == 3
       patchm(states_shapefile(States(row,2),1).Y,states_shapefile(States(row,2),1).X,0,'FaceVertexCData',Tot_Norm_Difference(row,11),'FaceColor','flat');
    end
end
set(gca,'clim',[1 2.5]);
tightmap; framem on; gridm off; mlabel off; plabel off;
set(gca,'LineWidth',3,'FontSize',21,'Box','on','Layer','top');
title(['HighRF-HighPop'],'FontSize',24);
text(0.035,0.10,['(c)'],'FontSize',21,'Units','normalized');

subplot(2,7,[10 11]); hold on;
ax4 = usamap([lat_min lat_max],[lon_min lon_max]); colormap(ax4,jet(30));
states = shaperead('usastatelo','UseGeoCoords',true,'Selector',{@(name)~any(strcmp(name,{'Alaska','Hawaii'})),'Name'});
faceColors = makesymbolspec('Polygon',{'INDEX',[1 numel(states)],'FaceColor',polcmap(numel(states))}); faceColors.FaceColor{1,3} = faceColors.FaceColor{1,3}./faceColors.FaceColor{1,3};
geoshow(ax4,states,'DisplayType','polygon','SymbolSpec',faceColors,'LineWidth',1,'LineStyle','-');
for row = 1:size(States,1)
    if gcam_run == 1
       patchm(states_shapefile(States(row,2),1).Y,states_shapefile(States(row,2),1).X,0,'FaceVertexCData',Tot_Norm_Difference(row,4),'FaceColor','flat');
    elseif gcam_run == 2
       patchm(states_shapefile(States(row,2),1).Y,states_shapefile(States(row,2),1).X,0,'FaceVertexCData',Tot_Norm_Difference(row,8),'FaceColor','flat');
    elseif gcam_run == 3
       patchm(states_shapefile(States(row,2),1).Y,states_shapefile(States(row,2),1).X,0,'FaceVertexCData',Tot_Norm_Difference(row,12),'FaceColor','flat');
    end
end
set(gca,'clim',[1 2.5]);
tightmap; framem on; gridm off; mlabel off; plabel off;
set(gca,'LineWidth',3,'FontSize',21,'Box','on','Layer','top');
title(['NoCCI-HighPop'],'FontSize',24);
text(0.035,0.10,['(d)'],'FontSize',21,'Units','normalized');

subplot(2,7,[12 13]); hold on;
ax5 = usamap([lat_min lat_max],[lon_min lon_max]); colormap(ax5,redblue(28));
states = shaperead('usastatelo','UseGeoCoords',true,'Selector',{@(name)~any(strcmp(name,{'Alaska','Hawaii'})),'Name'});
faceColors = makesymbolspec('Polygon',{'INDEX',[1 numel(states)],'FaceColor',polcmap(numel(states))}); faceColors.FaceColor{1,3} = faceColors.FaceColor{1,3}./faceColors.FaceColor{1,3};
geoshow(ax5,states,'DisplayType','polygon','SymbolSpec',faceColors,'LineWidth',1,'LineStyle','-');
for row = 1:size(States,1)
    if gcam_run == 1
       patchm(states_shapefile(States(row,2),1).Y,states_shapefile(States(row,2),1).X,0,'FaceVertexCData',Climate_Impact(row,1),'FaceColor','flat');
    elseif gcam_run == 2
       patchm(states_shapefile(States(row,2),1).Y,states_shapefile(States(row,2),1).X,0,'FaceVertexCData',Climate_Impact_FSD(row,1),'FaceColor','flat');
    elseif gcam_run == 3
       patchm(states_shapefile(States(row,2),1).Y,states_shapefile(States(row,2),1).X,0,'FaceVertexCData',Climate_Impact_CEP(row,1),'FaceColor','flat');
    end
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
   print(a,'-dpng','-r300',[image_output_dir,'Figure_8.png']);
   close(a);
end
clear a ax1 ax2 ax3 ax4 ax5 i row colo faceColors states States
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               END PLOTTING SECTION                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                BEGIN CLEANUP SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear data_input_dir image_output_dir save_images lat_min lat_max lon_min lon_max states_shapefile process_data data_output_dir gcam_run
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 END CLEANUP SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%