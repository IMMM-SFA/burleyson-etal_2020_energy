% Figure_4.m: Floor Space Changes
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

% Set the data input and output directories:
mapping_data_input_dir = '/Users/burl878/OneDrive - PNNL/Desktop/BEND_GCAM_Paper_Data/Data/Geolocation/';
floor_space_data_input_dir = '/Users/burl878/OneDrive - PNNL/Desktop/BEND_GCAM_Paper_Data/Data/GCAM_Runs/';
population_data_input_dir = '/Users/burl878/OneDrive - PNNL/Desktop/BEND_GCAM_Paper_Data/Data/Population_Projections/';
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
   County_Metadata_Table(:,15) = roundn(County_Metadata_Table(:,1),3);
   County_Metadata_Table(find(County_Metadata_Table(:,15) == 52000),15) = 51000;
   County_Metadata_Table(find(County_Metadata_Table(:,1) == 48501),15) = 48000;
   County_Metadata_Table(find(County_Metadata_Table(:,1) == 48503),15) = 48000;
   County_Metadata_Table(find(County_Metadata_Table(:,1) == 48505),15) = 48000;
   County_Metadata_Table(find(County_Metadata_Table(:,1) == 48507),15) = 48000;

   load([population_data_input_dir,'SSP_Population_Projections.mat']);
   SSP3_County_Population = UD.SSP3_County_Populations(:,1:5);
   SSP5_County_Population = UD.SSP5_County_Populations(:,1:5);
   Population_Years = UD.Years(1,1:5);
   clear UD

   load([floor_space_data_input_dir,'SSP3_4p5_CCI_Floorspace.mat']);
   SSP3_State_Residential_Floorspace = Residential;
   SSP3_State_Commercial_Floorspace = Commercial;
   Floorspace_Years = Years; States = State_FIPS;
   load([floor_space_data_input_dir,'SSP5_4p5_CCI_Floorspace.mat']);
   SSP5_State_Residential_Floorspace = Residential;
   SSP5_State_Commercial_Floorspace = Commercial;
   clear Years Commercial Residential State_FIPS

   County_Metadata_Subset = County_Metadata(find(County_Metadata_Table(:,15) == 4000 |...
                                              County_Metadata_Table(:,15) == 6000 |...
                                              County_Metadata_Table(:,15) == 8000 |...
                                              County_Metadata_Table(:,15) == 16000 |...
                                              County_Metadata_Table(:,15) == 30000 |...
                                              County_Metadata_Table(:,15) == 32000 |...
                                              County_Metadata_Table(:,15) == 35000 |...
                                              County_Metadata_Table(:,15) == 41000 |...
                                              County_Metadata_Table(:,15) == 49000 |...
                                              County_Metadata_Table(:,15) == 53000 |...
                                              County_Metadata_Table(:,15) == 56000),1);

   County_Metadata_Table_Subset = County_Metadata_Table(find(County_Metadata_Table(:,15) == 4000 |...
                                                          County_Metadata_Table(:,15) == 6000 |...
                                                          County_Metadata_Table(:,15) == 8000 |...
                                                          County_Metadata_Table(:,15) == 16000 |...
                                                          County_Metadata_Table(:,15) == 30000 |...
                                                          County_Metadata_Table(:,15) == 32000 |...
                                                          County_Metadata_Table(:,15) == 35000 |...
                                                          County_Metadata_Table(:,15) == 41000 |...
                                                          County_Metadata_Table(:,15) == 49000 |...
                                                          County_Metadata_Table(:,15) == 53000 |...
                                                          County_Metadata_Table(:,15) == 56000),:);
                                                      
   SSP3_County_Population_Subset = SSP3_County_Population(find(County_Metadata_Table(:,15) == 4000 |...
                                                            County_Metadata_Table(:,15) == 6000 |...
                                                            County_Metadata_Table(:,15) == 8000 |...
                                                            County_Metadata_Table(:,15) == 16000 |...
                                                            County_Metadata_Table(:,15) == 30000 |...
                                                            County_Metadata_Table(:,15) == 32000 |...
                                                            County_Metadata_Table(:,15) == 35000 |...
                                                            County_Metadata_Table(:,15) == 41000 |...
                                                            County_Metadata_Table(:,15) == 49000 |...
                                                            County_Metadata_Table(:,15) == 53000 |...
                                                            County_Metadata_Table(:,15) == 56000),:);
                                                                        
   SSP5_County_Population_Subset = SSP5_County_Population(find(County_Metadata_Table(:,15) == 4000 |...
                                                            County_Metadata_Table(:,15) == 6000 |...
                                                            County_Metadata_Table(:,15) == 8000 |...
                                                            County_Metadata_Table(:,15) == 16000 |...
                                                            County_Metadata_Table(:,15) == 30000 |...
                                                            County_Metadata_Table(:,15) == 32000 |...
                                                            County_Metadata_Table(:,15) == 35000 |...
                                                            County_Metadata_Table(:,15) == 41000 |...
                                                            County_Metadata_Table(:,15) == 49000 |...
                                                            County_Metadata_Table(:,15) == 53000 |...
                                                            County_Metadata_Table(:,15) == 56000),:);
                                                                        
   SSP3_State_Commercial_Floorspace_Subset = SSP3_State_Commercial_Floorspace(find(States(:,1) == 4000 |...
                                                                                States(:,1) == 6000 |...
                                                                                States(:,1) == 8000 |...
                                                                                States(:,1) == 16000 |...
                                                                                States(:,1) == 30000 |...
                                                                                States(:,1) == 32000 |...
                                                                                States(:,1) == 35000 |...
                                                                                States(:,1) == 41000 |...
                                                                                States(:,1) == 49000 |...
                                                                                States(:,1) == 53000 |...
                                                                                States(:,1) == 56000),:);

   SSP3_State_Residential_Floorspace_Subset = SSP3_State_Residential_Floorspace(find(States(:,1) == 4000 |...
                                                                                  States(:,1) == 6000 |...
                                                                                  States(:,1) == 8000 |...
                                                                                  States(:,1) == 16000 |...
                                                                                  States(:,1) == 30000 |...
                                                                                  States(:,1) == 32000 |...
                                                                                  States(:,1) == 35000 |...
                                                                                  States(:,1) == 41000 |...
                                                                                  States(:,1) == 49000 |...
                                                                                  States(:,1) == 53000 |...
                                                                                  States(:,1) == 56000),:);                                                                     

   SSP5_State_Commercial_Floorspace_Subset = SSP5_State_Commercial_Floorspace(find(States(:,1) == 4000 |...
                                                                                States(:,1) == 6000 |...
                                                                                States(:,1) == 8000 |...
                                                                                States(:,1) == 16000 |...
                                                                                States(:,1) == 30000 |...
                                                                                States(:,1) == 32000 |...
                                                                                States(:,1) == 35000 |...
                                                                                States(:,1) == 41000 |...
                                                                                States(:,1) == 49000 |...
                                                                                States(:,1) == 53000 |...
                                                                                States(:,1) == 56000),:);

   SSP5_State_Residential_Floorspace_Subset = SSP5_State_Residential_Floorspace(find(States(:,1) == 4000 |...
                                                                                  States(:,1) == 6000 |...
                                                                                  States(:,1) == 8000 |...
                                                                                  States(:,1) == 16000 |...
                                                                                  States(:,1) == 30000 |...
                                                                                  States(:,1) == 32000 |...
                                                                                  States(:,1) == 35000 |...
                                                                                  States(:,1) == 41000 |...
                                                                                  States(:,1) == 49000 |...
                                                                                  States(:,1) == 53000 |...
                                                                                  States(:,1) == 56000),:); 

   SSP3_Pop = SSP3_County_Population_Subset;
   SSP3_Pop_Norm = SSP3_Pop./SSP3_Pop(:,1);
   SSP3_Pop_Delta = SSP3_Pop(:,5) - SSP3_Pop(:,1);
   SSP5_Pop = SSP5_County_Population_Subset;
   SSP5_Pop_Norm = SSP5_Pop./SSP5_Pop(:,1);
   SSP5_Pop_Delta = SSP5_Pop(:,5) - SSP5_Pop(:,1);
   clear SSP3_County_Population SSP3_County_Population_Subset SSP5_County_Population SSP5_County_Population_Subset

   SSP3_Res_FS = SSP3_State_Residential_Floorspace_Subset;
   SSP3_Res_FS_Norm = SSP3_Res_FS./SSP3_Res_FS(:,1);
   SSP3_Res_FS_Delta = SSP3_Res_FS(:,9) - SSP3_Res_FS(:,1);
   SSP3_Com_FS = SSP3_State_Commercial_Floorspace_Subset;
   SSP3_Com_FS_Norm = SSP3_Com_FS./SSP3_Com_FS(:,1);
   SSP3_Com_FS_Delta = SSP3_Com_FS(:,9) - SSP3_Com_FS(:,1);
   SSP5_Res_FS = SSP5_State_Residential_Floorspace_Subset;
   SSP5_Res_FS_Norm = SSP5_Res_FS./SSP5_Res_FS(:,1);
   SSP5_Res_FS_Delta = SSP5_Res_FS(:,9) - SSP5_Res_FS(:,1);
   SSP5_Com_FS = SSP5_State_Commercial_Floorspace_Subset;
   SSP5_Com_FS_Norm = SSP5_Com_FS./SSP5_Com_FS(:,1);
   SSP5_Com_FS_Delta = SSP5_Com_FS(:,9) - SSP5_Com_FS(:,1);
   clear SSP3_State_Commercial_Floorspace SSP3_State_Commercial_Floorspace_Subset SSP3_State_Residential_Floorspace SSP3_State_Residential_Floorspace_Subset
   clear SSP5_State_Commercial_Floorspace SSP5_State_Commercial_Floorspace_Subset SSP5_State_Residential_Floorspace SSP5_State_Residential_Floorspace_Subset

   Counties = County_Metadata_Subset;
   Counties_Table = County_Metadata_Table_Subset;
   clear County_Metadata County_Metadata_Subset County_Metadata_Table County_Metadata_Table_Subset

   States = States([4,5,6,14,27,34,33,38,45,48,51],:);
   states_shapefile = shaperead('usastatelo');
   for i = 1:size(States,1)
       [state_string,state_abbreviation] = State_Strings(States(i,1));
       index = find(strcmpi({states_shapefile.Name},state_string) == 1);
       states_shapefile(index,1).FIPS = States(i,1);
       States(i,2) = index;
       clear state_string state_abbreviation index
   end
   States_Table = States; States = states_shapefile;
   clear i states_shapefile

   save([data_output_dir,'Figure_4_Data.mat'],'Counties','Counties_Table','Floorspace_Years','Population_Years','SSP3_Com_FS','SSP3_Com_FS_Delta','SSP3_Com_FS_Norm',...
                                              'SSP3_Pop','SSP3_Pop_Delta','SSP3_Pop_Norm','SSP3_Res_FS','SSP3_Res_FS_Delta','SSP3_Res_FS_Norm','SSP5_Com_FS',...
                                              'SSP5_Com_FS_Delta','SSP5_Com_FS_Norm','SSP5_Pop','SSP5_Pop_Delta','SSP5_Pop_Norm','SSP5_Res_FS','SSP5_Res_FS_Delta',...
                                              'SSP5_Res_FS_Norm','States','States_Table');
else
   load([data_output_dir,'Figure_4_Data.mat']);
end

lat_min = 31; lat_max = 49.5; lon_min = -125; lon_max = -101.5;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               END PROCESSING SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN PLOTTING SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a = figure('Color',[1 1 1]); set(a,'Position',get(0,'Screensize'));
subplot(4,6,[1 2 7 8]); hold on;
ax1 = usamap([lat_min lat_max],[lon_min lon_max]); colormap(ax1,jet(15));
for i = 1:size(Counties,1)
    patchm(Counties(i,1).Latitude_Vector,Counties(i,1).Longitude_Vector,0,'FaceVertexCData',SSP3_Pop_Norm(i,5),'FaceColor','flat')
end
set(ax1,'clim',[1,1.75]);
tightmap; framem on; gridm off; mlabel off; plabel off;
set(gca,'LineWidth',3,'FontSize',21,'Box','on','Layer','top');
title('SSP3 Population','FontSize',27);
text(0.035,0.10,['(a)'],'FontSize',24,'Units','normalized');

subplot(4,6,[3 4 9 10]); hold on;
ax2 = usamap([lat_min lat_max],[lon_min lon_max]); colormap(ax2,jet(15));
for i = 1:size(Counties,1)
    patchm(Counties(i,1).Latitude_Vector,Counties(i,1).Longitude_Vector,0,'FaceVertexCData',SSP5_Pop_Norm(i,5),'FaceColor','flat')
end
set(ax2,'clim',[1,1.75]);
colo2 = colorbar('ytick',[0:0.25:2.5],'YTickLabel',{'0.00','0.25','0.50','0.75','1.00','1.25','1.50','1.75','2.00','2.25','2.50'});
set(get(colo2,'ylabel'),'String',{'Total Population Relative to 2010'},'FontSize',21);
tightmap; framem on; gridm off; mlabel off; plabel off;
set(gca,'LineWidth',3,'FontSize',21,'Box','on','Layer','top');
title('SSP5 Population','FontSize',27);
text(0.035,0.10,['(b)'],'FontSize',24,'Units','normalized');

subplot(4,6,[13]); hold on; 
ax3 = usamap([lat_min lat_max],[lon_min lon_max]); colormap(ax3,jet(20));
for i = 1:size(States_Table,1)
    patchm(States(States_Table(i,2),1).Y,States(States_Table(i,2),1).X,0,'FaceVertexCData',SSP3_Res_FS_Norm(i,9),'FaceColor','flat')
end
set(ax3,'clim',[1,2]);
tightmap; framem on; gridm off; mlabel off; plabel off;
set(gca,'LineWidth',3,'FontSize',21,'Box','on','Layer','top');
title('Residential','FontSize',24);
text(0.03,0.15,['(c)'],'FontSize',18,'Units','normalized');

subplot(4,6,[14]); hold on; 
ax4 = usamap([lat_min lat_max],[lon_min lon_max]); colormap(ax4,jet(20));
for i = 1:size(States_Table,1)
    patchm(States(States_Table(i,2),1).Y,States(States_Table(i,2),1).X,0,'FaceVertexCData',SSP3_Com_FS_Norm(i,9),'FaceColor','flat')
end
set(ax4,'clim',[1,2]);
tightmap; framem on; gridm off; mlabel off; plabel off;
set(gca,'LineWidth',3,'FontSize',21,'Box','on','Layer','top');
title('Commercial','FontSize',24);
text(0.03,0.15,['(d)'],'FontSize',18,'Units','normalized');

subplot(4,6,[15]); hold on; 
ax5 = usamap([lat_min lat_max],[lon_min lon_max]); colormap(ax5,jet(20));
for i = 1:size(States_Table,1)
    patchm(States(States_Table(i,2),1).Y,States(States_Table(i,2),1).X,0,'FaceVertexCData',SSP5_Res_FS_Norm(i,9),'FaceColor','flat')
end
set(ax5,'clim',[1,2]);
tightmap; framem on; gridm off; mlabel off; plabel off;
set(gca,'LineWidth',3,'FontSize',21,'Box','on','Layer','top');
title('Residential','FontSize',24);
text(0.03,0.15,['(e)'],'FontSize',18,'Units','normalized');

subplot(4,6,[16]); hold on; 
ax6 = usamap([lat_min lat_max],[lon_min lon_max]); colormap(ax6,jet(20));
for i = 1:size(States_Table,1)
    patchm(States(States_Table(i,2),1).Y,States(States_Table(i,2),1).X,0,'FaceVertexCData',SSP5_Com_FS_Norm(i,9),'FaceColor','flat')
end
set(ax6,'clim',[1,2]);
tightmap; framem on; gridm off; mlabel off; plabel off;
set(gca,'LineWidth',3,'FontSize',21,'Box','on','Layer','top');
title('Commercial','FontSize',24);
text(0.03,0.15,['(f)'],'FontSize',18,'Units','normalized');

subplot(4,6,[19 20 21 22]); hold on; axis off; colormap(gca,jet(20));
set(gca,'clim',[1,2]);
colo6 = colorbar('xtick',[0:0.25:2.5],'xTickLabel',{'0.00','0.25','0.50','0.75','1.00','1.25','1.50','1.75','2.00','2.25','2.50'},'Location','NorthOutside');
set(get(colo6,'xlabel'),'String',{'Total Floor Space Relative to 2010'},'FontSize',21);
set(gca,'LineWidth',3,'FontSize',21,'Box','on','Layer','top');

annotation('line',[0.250 0.180],[0.545 0.505],'Color','k','LineWidth',3);
annotation('line',[0.250 0.320],[0.545 0.505],'Color','k','LineWidth',3);
annotation('line',[0.510 0.440],[0.545 0.505],'Color','k','LineWidth',3);
annotation('line',[0.510 0.580],[0.545 0.505],'Color','k','LineWidth',3);

if save_images == 1
   set(gcf,'Renderer','zbuffer'); set(gcf,'PaperPositionMode','auto');
   print(a,'-dpng','-r600',[image_output_directory,'Figure_4.png']);
   close(a);
end
clear a C i ax1 ax2 ax3 ax4 ax5 ax6 colo1 colo2 colo3 colo4 colo5 colo6
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               END PLOTTING SECTION                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                BEGIN CLEANUP SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear data_output_dir floor_space_data_input_dir image_output_dir lat_max lat_min lon_max lon_min mapping_data_input_dir population_data_input_dir process_data save_images
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 END CLEANUP SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%