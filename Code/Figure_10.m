% Figure_10.m: State Load Duration Curve Example
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
scenario = 16; % BEND scenario #1:18

% Set the data input and output directories:
data_input_dir = '/Users/burl878/OneDrive - PNNL/Desktop/BEND_GCAM_Paper_Data/Data/BEND_Runs/';
mapping_data_input_dir = '/Users/burl878/OneDrive - PNNL/Desktop/BEND_GCAM_Paper_Data/Data/Geolocation/';
data_output_dir = '/Users/burl878/OneDrive - PNNL/Desktop/BEND_GCAM_Paper_Data/Data/Data_Supporting_Figures/';
image_output_dir = '/Users/burl878/OneDrive - PNNL/Desktop/BEND_GCAM_Paper_Data/Figures/';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              END USER INPUT SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN PROCESSING SECTION               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if scenario == 1;  climate_index = 1; climate_string = 'RCP 4.5'; population_index = 1; population_string = 'Baseline'; technology_index = 1; technology_string = 'Baseline';            scenario_string = '01'; end
if scenario == 2;  climate_index = 1; climate_string = 'RCP 4.5'; population_index = 1; population_string = 'Baseline'; technology_index = 2; technology_string = 'Linear Conservative'; scenario_string = '02'; end
if scenario == 3;  climate_index = 1; climate_string = 'RCP 4.5'; population_index = 1; population_string = 'Baseline'; technology_index = 3; technology_string = 'Linear Aggressive';   scenario_string = '03'; end
if scenario == 4;  climate_index = 1; climate_string = 'RCP 4.5'; population_index = 2; population_string = 'SSP3';     technology_index = 1; technology_string = 'Baseline';            scenario_string = '04'; end
if scenario == 5;  climate_index = 1; climate_string = 'RCP 4.5'; population_index = 2; population_string = 'SSP3';     technology_index = 2; technology_string = 'Linear Conservative'; scenario_string = '05'; end
if scenario == 6;  climate_index = 1; climate_string = 'RCP 4.5'; population_index = 2; population_string = 'SSP3';     technology_index = 3; technology_string = 'Linear Aggressive';   scenario_string = '06'; end
if scenario == 7;  climate_index = 1; climate_string = 'RCP 4.5'; population_index = 3; population_string = 'SSP5';     technology_index = 1; technology_string = 'Baseline';            scenario_string = '07'; end
if scenario == 8;  climate_index = 1; climate_string = 'RCP 4.5'; population_index = 3; population_string = 'SSP5';     technology_index = 2; technology_string = 'Linear Conservative'; scenario_string = '08'; end
if scenario == 9;  climate_index = 1; climate_string = 'RCP 4.5'; population_index = 3; population_string = 'SSP5';     technology_index = 3; technology_string = 'Linear Aggressive';   scenario_string = '09'; end
if scenario == 10; climate_index = 2; climate_string = 'RCP 8.5'; population_index = 1; population_string = 'Baseline'; technology_index = 1; technology_string = 'Baseline';            scenario_string = '10'; end
if scenario == 11; climate_index = 2; climate_string = 'RCP 8.5'; population_index = 1; population_string = 'Baseline'; technology_index = 2; technology_string = 'Linear Conservative'; scenario_string = '11'; end
if scenario == 12; climate_index = 2; climate_string = 'RCP 8.5'; population_index = 1; population_string = 'Baseline'; technology_index = 3; technology_string = 'Linear Aggressive';   scenario_string = '12'; end
if scenario == 13; climate_index = 2; climate_string = 'RCP 8.5'; population_index = 2; population_string = 'SSP3';     technology_index = 1; technology_string = 'Baseline';            scenario_string = '13'; end
if scenario == 14; climate_index = 2; climate_string = 'RCP 8.5'; population_index = 2; population_string = 'SSP3';     technology_index = 2; technology_string = 'Linear Conservative'; scenario_string = '14'; end
if scenario == 15; climate_index = 2; climate_string = 'RCP 8.5'; population_index = 2; population_string = 'SSP3';     technology_index = 3; technology_string = 'Linear Aggressive';   scenario_string = '15'; end
if scenario == 16; climate_index = 2; climate_string = 'RCP 8.5'; population_index = 3; population_string = 'SSP5';     technology_index = 1; technology_string = 'Baseline';            scenario_string = '16'; end
if scenario == 17; climate_index = 2; climate_string = 'RCP 8.5'; population_index = 3; population_string = 'SSP5';     technology_index = 2; technology_string = 'Linear Conservative'; scenario_string = '17'; end
if scenario == 18; climate_index = 2; climate_string = 'RCP 8.5'; population_index = 3; population_string = 'SSP5';     technology_index = 3; technology_string = 'Linear Aggressive';   scenario_string = '18'; end

if process_data == 1
   load([data_input_dir,'BEND_County_Calibration_Data_and_Scaling_Factors.mat'],'BEND_County_Metadata','BEND_County_Metadata_Table');
   load([mapping_data_input_dir,'County_Metadata.mat']);
   BEND_County_Metadata_Table(find(BEND_County_Metadata_Table(:,1) == 32510),2) = 32000;
   County_Metadata_Table(find(County_Metadata_Table(:,1) == 32510),2) = 32000;

   States = unique(BEND_County_Metadata_Table(:,2));
   for row = 1:size(States,1)
       County_Metadata_Subset = County_Metadata_Table(find(County_Metadata_Table(:,2) == States(row,1)),:);
       BEND_County_Metadata_Subset = BEND_County_Metadata_Table(find(BEND_County_Metadata_Table(:,2) == States(row,1)),:);
       States(row,2) = sum(BEND_County_Metadata_Subset(:,6));
       States(row,3) = sum(County_Metadata_Subset(:,6));
       States(row,4) = States(row,3)./States(row,2);
       clear County_Metadata_Subset BEND_County_Metadata_Subset
   end
   clear row County_Metadata County_Metadata_Table
   
   for interval = 1:8
       if interval == 1; start_year = 2010; end_year = 2014; end
       if interval == 2; start_year = 2015; end_year = 2019; end
       if interval == 3; start_year = 2020; end_year = 2024; end
       if interval == 4; start_year = 2025; end_year = 2029; end
       if interval == 5; start_year = 2030; end_year = 2034; end
       if interval == 6; start_year = 2035; end_year = 2039; end
       if interval == 7; start_year = 2040; end_year = 2044; end
       if interval == 8; start_year = 2045; end_year = 2049; end
       
       i = 0;
       for year = start_year:1:end_year
           i = i + 1;
           load([data_input_dir,'BEND_Scenarios_',scenario_string,'_',num2str(year),'.mat'],'Res_Load','Com_Load');
           Tot_Load = Res_Load + Com_Load;
           for state = 1:size(States,1)
               State_Com(state,:) = nansum(Com_Load(find(BEND_County_Metadata_Table(:,2) == States(state,1)),:),1).*States(state,4);
               State_Res(state,:) = nansum(Res_Load(find(BEND_County_Metadata_Table(:,2) == States(state,1)),:),1).*States(state,4);
               State_Tot(state,:) = nansum(Tot_Load(find(BEND_County_Metadata_Table(:,2) == States(state,1)),:),1).*States(state,4);
           end
           if i == 1
              State_Com_Comp = State_Com;
              State_Res_Comp = State_Res;
              State_Tot_Comp = State_Tot;
           else
              State_Com_Comp = cat(2,State_Com_Comp,State_Com);
              State_Res_Comp = cat(2,State_Res_Comp,State_Res);
              State_Tot_Comp = cat(2,State_Tot_Comp,State_Tot);
           end
           clear state Com_Load State_Com Res_Load State_Res Tot_Load State_Tot
       end
       clear i year
       
       for state = 1:size(States,1)
           State_Com_Curve(:,state,interval) = sortrows(State_Com_Comp(state,:)');
           State_Res_Curve(:,state,interval) = sortrows(State_Res_Comp(state,:)');
           State_Tot_Curve(:,state,interval) = sortrows(State_Tot_Comp(state,:)');
       end
       clear state start_year end_year State_Com_Comp State_Res_Comp State_Tot_Comp
   end
   clear interval BEND_County_Metadata BEND_County_Metadata_Table

   save([data_output_dir,'Figure_10_Data.mat'],'State_Com_Curve','State_Res_Curve','State_Tot_Curve','States');
else
   load([data_output_dir,'Figure_10_Data.mat']);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               END PROCESSING SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN PLOTTING SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 2
    [State_Abbreviation,State_String] = State_Information_From_State_FIPS(States(i,1));
       
    for year = 1:8
        Com(:,year) = State_Com_Curve(:,i,year);
        Res(:,year) = State_Res_Curve(:,i,year);
        Tot(:,year) = State_Tot_Curve(:,i,year);
    end
    Com_Norm = Com./Com(:,1);
    Res_Norm = Res./Res(:,1);
    Tot_Norm = Tot./Tot(:,1);
    clear year
       
    Time_Vector(:,1) = [size(Com,1):-1:1]';
    Time_Vector(:,2) = Time_Vector(:,1)./5;
       
    a = figure('Color',[1 1 1]); set(a,'Position',get(0,'Screensize')); C = jet(8);
    subplot(1,2,1); hold on;
    for col = 1:8;
        line(Time_Vector(:,2),Tot(:,col)./1000,'Color',[C(col,1),C(col,2),C(col,3)],'LineWidth',3,'LineStyle','-');
    end
    legend('2010-2014','2015-2019','2020-2024','2025-2029','2030-2034','2035-2039','2040-2044','2045-2049','Location','NorthEast');
    xlim([0 8760]);
    xlabel('Hours','FontSize',21);
    ylim([0 120]);
    ylabel('Total Building Load [10^3 MWh]','FontSize',21);
    set(gca,'LineWidth',3,'FontSize',21,'Box','on','Layer','top');
    title([State_String,': Total Load Duration Curve'],'FontSize',24);
    text(-0.05,1.05,['(a)'],'FontSize',21,'Units','normalized');
       
    subplot(1,2,2); hold on;
    for col = 1:8;
        line(Time_Vector(:,2),Tot_Norm(:,col),'Color',[C(col,1),C(col,2),C(col,3)],'LineWidth',3,'LineStyle','-');
    end
    xlim([0 8760]);
    xlabel('Hours','FontSize',21);
    ylim([0.985 1.95]);
    ylabel('Total Building Load Relative to 2010-2014','FontSize',21);
    set(gca,'LineWidth',3,'FontSize',21,'Box','on','Layer','top');
    title([State_String,': Load Duration Curve Normalized'],'FontSize',24);
    text(-0.05,1.05,['(b)'],'FontSize',21,'Units','normalized');
       
    if save_images == 1
       set(gcf,'Renderer','zbuffer'); set(gcf,'PaperPositionMode','auto');
       print(a,'-dpng','-r600',[image_output_dir,'Figure_10.png']);
       close(a);
    end
    clear a C col

    clear State_Abbreviation State_String Com Com_Norm Res Res_Norm Tot Tot_Norm
end
clear i
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               END PLOTTING SECTION                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                BEGIN CLEANUP SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear data_input_dir climate_index climate_string data_output_dir image_output_dir mapping_data_input_dir plot_images population_index population_string
clear process_data save_images scenario scenario_string technology_index technology_string
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 END CLEANUP SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%