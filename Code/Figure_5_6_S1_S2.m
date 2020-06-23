% Figure_5_6_S1_S2.m: GCAM and BEND_Time Series
% 20200623
% Casey D. Burleyson
% Pacific Northwest National Laboratory

warning off all; clear all; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN USER INPUT SECTION               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set some processing flags:
process_data = 1; % (1 = Yes)
save_images = 0; % (1 = Yes)
gcam_run = 3; % (1 = raw, 2 = fixed service demands, 3 = controlled electricity prices)

bend_data_input_dir = '/Users/burl878/OneDrive - PNNL/Desktop/BEND_GCAM_Paper_Data/Data/BEND_Runs/';
gcam_data_input_dir = '/Users/burl878/OneDrive - PNNL/Desktop/BEND_GCAM_Paper_Data/Data/GCAM_Runs/';
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
              
       load([gcam_data_input_dir,run_name,'_State_Electricity.mat']);
    
       if run == 1; GCAM_States = Electricity_Table(:,1); GCAM_Years = Electricity(1,1).Years; end
    
       for row = 1:size(Electricity,1)
           Com_Temp = Electricity(row,1).Com_Total; Com_Temp = Com_Temp.*(10^18); Com_Temp = Com_Temp./(3.6*10^6); Com_Temp = Com_Temp.*0.001; Com_Temp = Com_Temp./10000;
           Res_Temp = Electricity(row,1).Res_Total; Res_Temp = Res_Temp.*(10^18); Res_Temp = Res_Temp./(3.6*10^6); Res_Temp = Res_Temp.*0.001; Res_Temp = Res_Temp./10000;
           Tot_Temp = Electricity(row,1).All_Total; Tot_Temp = Tot_Temp.*(10^18); Tot_Temp = Tot_Temp./(3.6*10^6); Tot_Temp = Tot_Temp.*0.001; Tot_Temp = Tot_Temp./10000;
           Com(row,:,run) = Com_Temp;
           Res(row,:,run) = Res_Temp;
           Tot(row,:,run) = Tot_Temp;
           clear Com_Temp Res_Temp Tot_Temp
       end
       clear row Electricity Electricity_Table run_name
   end
   clear run
   
   for run = 1:12
       Com_Temp = Com(:,:,run); Com_Norm(:,:,run) = Com_Temp./Com_Temp(:,1); clear Com_Temp
       Res_Temp = Res(:,:,run); Res_Norm(:,:,run) = Res_Temp./Res_Temp(:,1); clear Res_Temp
       Tot_Temp = Tot(:,:,run); Tot_Norm(:,:,run) = Tot_Temp./Tot_Temp(:,1); clear Tot_Temp
   end
   clear run

   GCAM_Com = Com;
   GCAM_Com_Norm = Com_Norm;
   GCAM_Res = Res;
   GCAM_Res_Norm = Res_Norm;
   GCAM_Tot = Tot;
   GCAM_Tot_Norm = Tot_Norm;
   clear Com Com_Norm Res Res_Norm Tot Tot_Norm

   i = 0;
   for scenario = [4,7,16,34]
       i = i + 1;
       if scenario == 4;  scenario_string = '04'; end
       if scenario == 7;  scenario_string = '07'; end
       if scenario == 16; scenario_string = '16'; end
       if scenario == 34; scenario_string = '34'; end
    
       load([bend_data_input_dir,'BEND_Annual_State_Time_Series_',scenario_string,'_2010_to_2050.mat']);
    
       BEND_Com(:,:,i) = Commercial./10000;
       BEND_Com_Norm(:,:,i) = BEND_Com(:,:,i)./BEND_Com(:,1,i);
       BEND_Res(:,:,i) = Residential./10000;
       BEND_Res_Norm(:,:,i) = BEND_Res(:,:,i)./BEND_Res(:,1,i);
       BEND_Tot(:,:,i) = Total./10000;
       BEND_Tot_Norm(:,:,i) = BEND_Tot(:,:,i)./BEND_Tot(:,1,i);
       BEND_States = States;
       BEND_Years = Years;
       clear Commercial Residential Total scenario_string States Years
   end
   clear scenario i

   save([data_output_dir,'Figure_5_6_S1_S2_Data.mat'],'BEND_Com','BEND_Com_Norm','BEND_Res','BEND_Res_Norm','BEND_States','BEND_Tot','BEND_Tot_Norm','BEND_Years',...
         'GCAM_Com','GCAM_Com_Norm','GCAM_Res','GCAM_Res_Norm','GCAM_States','GCAM_Tot','GCAM_Tot_Norm','GCAM_Years');
else
   load([data_output_dir,'Figure_5_6_S1_S2_Data.mat']);
end

for run = 1:4
    Res_Norm_Table(:,1) = BEND_States(:,1);
    Res_Norm_Table(:,2*run) = BEND_Res_Norm(:,41,run);
    for row = 1:size(Res_Norm_Table,1)
        if run == 1
           Res_Norm_Table(row,3) = GCAM_Res_Norm(find(GCAM_States(:,1) == BEND_States(row,1)),9,9);
        elseif run == 2
           Res_Norm_Table(row,5) = GCAM_Res_Norm(find(GCAM_States(:,1) == BEND_States(row,1)),9,10);
        elseif run == 3
           Res_Norm_Table(row,7) = GCAM_Res_Norm(find(GCAM_States(:,1) == BEND_States(row,1)),9,11);
        elseif run == 4
           Res_Norm_Table(row,9) = GCAM_Res_Norm(find(GCAM_States(:,1) == BEND_States(row,1)),9,12);
        end
    end
    clear row
end
clear run

for run = 1:4
    Res_Table(:,1) = BEND_States(:,1);
    Res_Table(:,2*run) = BEND_Res(:,41,run) - BEND_Res(:,1,run);
    for row = 1:size(Res_Table,1)
        if run == 1
           Res_Table(row,3) = GCAM_Res(find(GCAM_States(:,1) == BEND_States(row,1)),9,9) - GCAM_Res(find(GCAM_States(:,1) == BEND_States(row,1)),1,9);
        elseif run == 2
           Res_Table(row,5) = GCAM_Res(find(GCAM_States(:,1) == BEND_States(row,1)),9,10) - GCAM_Res(find(GCAM_States(:,1) == BEND_States(row,1)),1,10);
        elseif run == 3
           Res_Table(row,7) = GCAM_Res(find(GCAM_States(:,1) == BEND_States(row,1)),9,11) - GCAM_Res(find(GCAM_States(:,1) == BEND_States(row,1)),1,11);
        elseif run == 4
           Res_Table(row,9) = GCAM_Res(find(GCAM_States(:,1) == BEND_States(row,1)),9,12) - GCAM_Res(find(GCAM_States(:,1) == BEND_States(row,1)),1,12);
        end
    end
    clear row
end
clear run

for run = 1:4
    Com_Norm_Table(:,1) = BEND_States(:,1);
    Com_Norm_Table(:,2*run) = BEND_Com_Norm(:,41,run);
    for row = 1:size(Com_Norm_Table,1)
        if run == 1
           Com_Norm_Table(row,3) = GCAM_Com_Norm(find(GCAM_States(:,1) == BEND_States(row,1)),9,9);
        elseif run == 2
           Com_Norm_Table(row,5) = GCAM_Com_Norm(find(GCAM_States(:,1) == BEND_States(row,1)),9,10);
        elseif run == 3
           Com_Norm_Table(row,7) = GCAM_Com_Norm(find(GCAM_States(:,1) == BEND_States(row,1)),9,11);
        elseif run == 4
           Com_Norm_Table(row,9) = GCAM_Com_Norm(find(GCAM_States(:,1) == BEND_States(row,1)),9,12);
        end
    end
    clear row
end
clear run

for run = 1:4
    Com_Table(:,1) = BEND_States(:,1);
    Com_Table(:,2*run) = BEND_Com(:,41,run) - BEND_Com(:,1,run);
    for row = 1:size(Com_Table,1)
        if run == 1
           Com_Table(row,3) = GCAM_Com(find(GCAM_States(:,1) == BEND_States(row,1)),9,9) - GCAM_Com(find(GCAM_States(:,1) == BEND_States(row,1)),1,9);
        elseif run == 2
           Com_Table(row,5) = GCAM_Com(find(GCAM_States(:,1) == BEND_States(row,1)),9,10) - GCAM_Com(find(GCAM_States(:,1) == BEND_States(row,1)),1,10);
        elseif run == 3
           Com_Table(row,7) = GCAM_Com(find(GCAM_States(:,1) == BEND_States(row,1)),9,11) - GCAM_Com(find(GCAM_States(:,1) == BEND_States(row,1)),1,11);
        elseif run == 4
           Com_Table(row,9) = GCAM_Com(find(GCAM_States(:,1) == BEND_States(row,1)),9,12) - GCAM_Com(find(GCAM_States(:,1) == BEND_States(row,1)),1,12);
        end
    end
    clear row
end
clear run

Res_Norm_Difference(:,1) = abs(Res_Norm_Table(:,2) - Res_Norm_Table(:,3));
Res_Norm_Difference(:,2) = abs(Res_Norm_Table(:,4) - Res_Norm_Table(:,5));
Res_Norm_Difference(:,3) = abs(Res_Norm_Table(:,6) - Res_Norm_Table(:,7));
Res_Norm_Difference(:,4) = abs(Res_Norm_Table(:,8) - Res_Norm_Table(:,9));
Res_Statistics(1,1) = 100.*nanmean(Res_Norm_Difference(:));
Res_Statistics(1,2) = 100.*(size(find(Res_Norm_Difference(:) <= 0.15),1)/size(find(isnan(Res_Norm_Difference(:)) == 0),1))
Res_Difference_Significance(1,1) = ttest2(Res_Norm_Table(:,2),Res_Norm_Table(:,3),'Vartype','unequal','Alpha',0.05);
Res_Difference_Significance(1,2) = ttest2(Res_Norm_Table(:,4),Res_Norm_Table(:,5),'Vartype','unequal','Alpha',0.05);
Res_Difference_Significance(1,3) = ttest2(Res_Norm_Table(:,6),Res_Norm_Table(:,7),'Vartype','unequal','Alpha',0.05);
Res_Difference_Significance(1,4) = ttest2(Res_Norm_Table(:,8),Res_Norm_Table(:,9),'Vartype','unequal','Alpha',0.05);
clear Res_Norm_Difference

Com_Norm_Difference(:,1) = abs(Com_Norm_Table(:,2) - Com_Norm_Table(:,3));
Com_Norm_Difference(:,2) = abs(Com_Norm_Table(:,4) - Com_Norm_Table(:,5));
Com_Norm_Difference(:,3) = abs(Com_Norm_Table(:,6) - Com_Norm_Table(:,7));
Com_Norm_Difference(:,4) = abs(Com_Norm_Table(:,8) - Com_Norm_Table(:,9));
Com_Statistics(1,1) = 100.*nanmean(Com_Norm_Difference(:));
Com_Statistics(1,2) = 100.*(size(find(Com_Norm_Difference(:) <= 0.15),1)/size(find(isnan(Com_Norm_Difference(:)) == 0),1))
Com_Difference_Significance(1,1) = ttest2(Com_Norm_Table(:,2),Com_Norm_Table(:,3),'Vartype','unequal','Alpha',0.05);
Com_Difference_Significance(1,2) = ttest2(Com_Norm_Table(:,4),Com_Norm_Table(:,5),'Vartype','unequal','Alpha',0.05);
Com_Difference_Significance(1,3) = ttest2(Com_Norm_Table(:,6),Com_Norm_Table(:,7),'Vartype','unequal','Alpha',0.05);
Com_Difference_Significance(1,4) = ttest2(Com_Norm_Table(:,8),Com_Norm_Table(:,9),'Vartype','unequal','Alpha',0.05);
clear Com_Norm_Difference
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               END PROCESSING SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN PLOTTING SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a = figure('Color',[1 1 1]); set(a,'Position',get(0,'Screensize'));
for i = 1:size(BEND_States,1)
    if i == 1; label = '(a)'; end; if i == 7;  label = '(g)'; end; if i == 2; label = '(b)'; end; if i == 8;  label = '(h)'; end;
    if i == 3; label = '(c)'; end; if i == 9;  label = '(i)'; end; if i == 4; label = '(d)'; end; if i == 10; label = '(j)'; end;
    if i == 5; label = '(e)'; end; if i == 11; label = '(k)'; end; if i == 6; label = '(f)'; end;
    subplot(4,3,i); hold on;
    [state_string,state_abbreviation] = State_Strings(BEND_States(i,1));
    if gcam_run == 1
       line(GCAM_Years(1,:),GCAM_Res_Norm(find(GCAM_States(:,1) == BEND_States(i,1)),:,1),'Color','r','LineWidth',3,'LineStyle','-');
       line(GCAM_Years(1,:),GCAM_Res_Norm(find(GCAM_States(:,1) == BEND_States(i,1)),:,2),'Color',[1,0.44,0],'LineWidth',3,'LineStyle','-');
       line(GCAM_Years(1,:),GCAM_Res_Norm(find(GCAM_States(:,1) == BEND_States(i,1)),:,3),'Color','b','LineWidth',3,'LineStyle','-');
       line(GCAM_Years(1,:),GCAM_Res_Norm(find(GCAM_States(:,1) == BEND_States(i,1)),:,4),'Color','c','LineWidth',3,'LineStyle','-');
    elseif gcam_run == 2
       line(GCAM_Years(1,:),GCAM_Res_Norm(find(GCAM_States(:,1) == BEND_States(i,1)),:,5),'Color','r','LineWidth',3,'LineStyle','-');
       line(GCAM_Years(1,:),GCAM_Res_Norm(find(GCAM_States(:,1) == BEND_States(i,1)),:,6),'Color',[1,0.44,0],'LineWidth',3,'LineStyle','-');
       line(GCAM_Years(1,:),GCAM_Res_Norm(find(GCAM_States(:,1) == BEND_States(i,1)),:,7),'Color','b','LineWidth',3,'LineStyle','-');
       line(GCAM_Years(1,:),GCAM_Res_Norm(find(GCAM_States(:,1) == BEND_States(i,1)),:,8),'Color','c','LineWidth',3,'LineStyle','-');
    elseif gcam_run == 3
       line(GCAM_Years(1,:),GCAM_Res_Norm(find(GCAM_States(:,1) == BEND_States(i,1)),:,9),'Color','r','LineWidth',3,'LineStyle','-');
       line(GCAM_Years(1,:),GCAM_Res_Norm(find(GCAM_States(:,1) == BEND_States(i,1)),:,10),'Color',[1,0.44,0],'LineWidth',3,'LineStyle','-');
       line(GCAM_Years(1,:),GCAM_Res_Norm(find(GCAM_States(:,1) == BEND_States(i,1)),:,11),'Color','b','LineWidth',3,'LineStyle','-');
       line(GCAM_Years(1,:),GCAM_Res_Norm(find(GCAM_States(:,1) == BEND_States(i,1)),:,12),'Color','c','LineWidth',3,'LineStyle','-');
    end
    line(BEND_Years(1,:),BEND_Res_Norm(i,:,1),'Color','r','LineWidth',3,'LineStyle','--');
    line(BEND_Years(1,:),BEND_Res_Norm(i,:,2),'Color',[1,0.44,0],'LineWidth',3,'LineStyle','--');
    line(BEND_Years(1,:),BEND_Res_Norm(i,:,3),'Color','b','LineWidth',3,'LineStyle','--');
    line(BEND_Years(1,:),BEND_Res_Norm(i,:,4),'Color','c','LineWidth',3,'LineStyle','--');
    xlim([2010 2050]); set(gca,'xtick',[2000:5:2050]); set(gca,'xticklabel',{'2000','','2010','','2020','','2030','','2040','','2050'});
    ylim([1 2.5]); set(gca,'ytick',[0:0.5:3]); set(gca,'yticklabel',{'0.0','0.5','1.0','1.5','2.0','2.5','3.0'});
    if i == 1 | i == 4 | i == 7 | i == 10; ylabel('Delta vs. 2010','FontSize',18); end
    set(gca,'LineWidth',3,'FontSize',18,'Box','on','Layer','top');
    title([state_string,' Residential'],'FontSize',21);
    text(0.015,0.900,label,'FontSize',18,'Units','normalized');
    clear state_string state_abbreviation label
end
subplot(4,3,12); hold on; axis off;
line(GCAM_Years(1,:),NaN.*GCAM_Tot_Norm(1,:,1),'Color','r','LineWidth',3,'LineStyle','-'); line(GCAM_Years(1,:),NaN.*GCAM_Tot_Norm(1,:,2),'Color',[1,0.44,0],'LineWidth',3,'LineStyle','-');
line(GCAM_Years(1,:),NaN.*GCAM_Tot_Norm(1,:,3),'Color','b','LineWidth',3,'LineStyle','-'); line(GCAM_Years(1,:),NaN.*GCAM_Tot_Norm(1,:,4),'Color','c','LineWidth',3,'LineStyle','-');
line(GCAM_Years(1,:),NaN.*GCAM_Tot_Norm(1,:,1),'Color','k','LineWidth',3,'LineStyle','-'); line(GCAM_Years(1,:),NaN.*GCAM_Tot_Norm(1,:,1),'Color','k','LineWidth',3,'LineStyle','--');
legend(['LowRF-LowPop'],['LowRF-HighPop'],['HighRF-HighPop'],['NoCCI-HighPop'],'GCAM-USA (Solid Lines)','BEND (Dashed Lines)','Location','WestOutside');
legend boxoff; set(gca,'LineWidth',3,'FontSize',24,'Box','on','Layer','top');
if save_images == 1
   set(gcf,'Renderer','zbuffer'); set(gcf,'PaperPositionMode','auto');
   print(a,'-dpng','-r600',[image_output_dir,'Figure_5.png']);
   close(a);
end
clear i a


a = figure('Color',[1 1 1]); set(a,'Position',get(0,'Screensize'));
for i = 1:size(BEND_States,1)
    if i == 1; label = '(a)'; end; if i == 7;  label = '(g)'; end; if i == 2; label = '(b)'; end; if i == 8;  label = '(h)'; end;
    if i == 3; label = '(c)'; end; if i == 9;  label = '(i)'; end; if i == 4; label = '(d)'; end; if i == 10; label = '(j)'; end;
    if i == 5; label = '(e)'; end; if i == 11; label = '(k)'; end; if i == 6; label = '(f)'; end;
    subplot(4,3,i); hold on;
    [state_string,state_abbreviation] = State_Strings(BEND_States(i,1));
    if gcam_run == 1
       line(GCAM_Years(1,:),GCAM_Com_Norm(find(GCAM_States(:,1) == BEND_States(i,1)),:,1),'Color','r','LineWidth',3,'LineStyle','-');
       line(GCAM_Years(1,:),GCAM_Com_Norm(find(GCAM_States(:,1) == BEND_States(i,1)),:,2),'Color',[1,0.44,0],'LineWidth',3,'LineStyle','-');
       line(GCAM_Years(1,:),GCAM_Com_Norm(find(GCAM_States(:,1) == BEND_States(i,1)),:,3),'Color','b','LineWidth',3,'LineStyle','-');
       line(GCAM_Years(1,:),GCAM_Com_Norm(find(GCAM_States(:,1) == BEND_States(i,1)),:,4),'Color','c','LineWidth',3,'LineStyle','-');
    elseif gcam_run == 2
       line(GCAM_Years(1,:),GCAM_Com_Norm(find(GCAM_States(:,1) == BEND_States(i,1)),:,5),'Color','r','LineWidth',3,'LineStyle','-');
       line(GCAM_Years(1,:),GCAM_Com_Norm(find(GCAM_States(:,1) == BEND_States(i,1)),:,6),'Color',[1,0.44,0],'LineWidth',3,'LineStyle','-');
       line(GCAM_Years(1,:),GCAM_Com_Norm(find(GCAM_States(:,1) == BEND_States(i,1)),:,7),'Color','b','LineWidth',3,'LineStyle','-');
       line(GCAM_Years(1,:),GCAM_Com_Norm(find(GCAM_States(:,1) == BEND_States(i,1)),:,8),'Color','c','LineWidth',3,'LineStyle','-');
    elseif gcam_run == 3
       line(GCAM_Years(1,:),GCAM_Com_Norm(find(GCAM_States(:,1) == BEND_States(i,1)),:,9),'Color','r','LineWidth',3,'LineStyle','-');
       line(GCAM_Years(1,:),GCAM_Com_Norm(find(GCAM_States(:,1) == BEND_States(i,1)),:,10),'Color',[1,0.44,0],'LineWidth',3,'LineStyle','-');
       line(GCAM_Years(1,:),GCAM_Com_Norm(find(GCAM_States(:,1) == BEND_States(i,1)),:,11),'Color','b','LineWidth',3,'LineStyle','-');
       line(GCAM_Years(1,:),GCAM_Com_Norm(find(GCAM_States(:,1) == BEND_States(i,1)),:,12),'Color','c','LineWidth',3,'LineStyle','-');
    end
    line(BEND_Years(1,:),BEND_Com_Norm(i,:,1),'Color','r','LineWidth',3,'LineStyle','--');
    line(BEND_Years(1,:),BEND_Com_Norm(i,:,2),'Color',[1,0.44,0],'LineWidth',3,'LineStyle','--');
    line(BEND_Years(1,:),BEND_Com_Norm(i,:,3),'Color','b','LineWidth',3,'LineStyle','--');
    line(BEND_Years(1,:),BEND_Com_Norm(i,:,4),'Color','c','LineWidth',3,'LineStyle','--');
    xlim([2010 2050]); set(gca,'xtick',[2000:5:2050]); set(gca,'xticklabel',{'2000','','2010','','2020','','2030','','2040','','2050'});
    ylim([1 2.5]); set(gca,'ytick',[0:0.5:3]); set(gca,'yticklabel',{'0.0','0.5','1.0','1.5','2.0','2.5','3.0'});
    if i == 1 | i == 4 | i == 7 | i == 10; ylabel('Delta vs. 2010','FontSize',18); end
    set(gca,'LineWidth',3,'FontSize',18,'Box','on','Layer','top');
    title([state_string,' Commercial'],'FontSize',21);
    text(0.015,0.900,label,'FontSize',18,'Units','normalized');
    clear state_string state_abbreviation label
end
subplot(4,3,12); hold on; axis off;
line(GCAM_Years(1,:),NaN.*GCAM_Tot_Norm(1,:,1),'Color','r','LineWidth',3,'LineStyle','-'); line(GCAM_Years(1,:),NaN.*GCAM_Tot_Norm(1,:,2),'Color',[1,0.44,0],'LineWidth',3,'LineStyle','-');
line(GCAM_Years(1,:),NaN.*GCAM_Tot_Norm(1,:,3),'Color','b','LineWidth',3,'LineStyle','-'); line(GCAM_Years(1,:),NaN.*GCAM_Tot_Norm(1,:,4),'Color','c','LineWidth',3,'LineStyle','-');
line(GCAM_Years(1,:),NaN.*GCAM_Tot_Norm(1,:,1),'Color','k','LineWidth',3,'LineStyle','-'); line(GCAM_Years(1,:),NaN.*GCAM_Tot_Norm(1,:,1),'Color','k','LineWidth',3,'LineStyle','--');
legend(['LowRF-LowPop'],['LowRF-HighPop'],['HighRF-HighPop'],['NoCCI-HighPop'],'GCAM (Solid Lines)','BEND (Dashed Lines)','Location','WestOutside');
legend boxoff; set(gca,'LineWidth',3,'FontSize',24,'Box','on','Layer','top');
if save_images == 1
   set(gcf,'Renderer','zbuffer'); set(gcf,'PaperPositionMode','auto');
   print(a,'-dpng','-r600',[image_output_dir,'Figure_6.png']);
   close(a);
end
clear i a


a = figure('Color',[1 1 1]); set(a,'Position',get(0,'Screensize'));
for i = 1:size(BEND_States,1)
    if i == 1; label = '(a)'; end; if i == 7;  label = '(g)'; end; if i == 2; label = '(b)'; end; if i == 8;  label = '(h)'; end;
    if i == 3; label = '(c)'; end; if i == 9;  label = '(i)'; end; if i == 4; label = '(d)'; end; if i == 10; label = '(j)'; end;
    if i == 5; label = '(e)'; end; if i == 11; label = '(k)'; end; if i == 6; label = '(f)'; end;
    subplot(4,3,i); hold on;
    [state_string,state_abbreviation] = State_Strings(BEND_States(i,1));
    if gcam_run == 1
       line(GCAM_Years(1,:),GCAM_Res(find(GCAM_States(:,1) == BEND_States(i,1)),:,1),'Color','r','LineWidth',3,'LineStyle','-');
       line(GCAM_Years(1,:),GCAM_Res(find(GCAM_States(:,1) == BEND_States(i,1)),:,2),'Color',[1,0.44,0],'LineWidth',3,'LineStyle','-');
       line(GCAM_Years(1,:),GCAM_Res(find(GCAM_States(:,1) == BEND_States(i,1)),:,3),'Color','b','LineWidth',3,'LineStyle','-');
       line(GCAM_Years(1,:),GCAM_Res(find(GCAM_States(:,1) == BEND_States(i,1)),:,4),'Color','c','LineWidth',3,'LineStyle','-');
    elseif gcam_run == 2
       line(GCAM_Years(1,:),GCAM_Res(find(GCAM_States(:,1) == BEND_States(i,1)),:,5),'Color','r','LineWidth',3,'LineStyle','-');
       line(GCAM_Years(1,:),GCAM_Res(find(GCAM_States(:,1) == BEND_States(i,1)),:,6),'Color',[1,0.44,0],'LineWidth',3,'LineStyle','-');
       line(GCAM_Years(1,:),GCAM_Res(find(GCAM_States(:,1) == BEND_States(i,1)),:,7),'Color','b','LineWidth',3,'LineStyle','-');
       line(GCAM_Years(1,:),GCAM_Res(find(GCAM_States(:,1) == BEND_States(i,1)),:,8),'Color','c','LineWidth',3,'LineStyle','-');
    elseif gcam_run == 3
       line(GCAM_Years(1,:),GCAM_Res(find(GCAM_States(:,1) == BEND_States(i,1)),:,9),'Color','r','LineWidth',3,'LineStyle','-');
       line(GCAM_Years(1,:),GCAM_Res(find(GCAM_States(:,1) == BEND_States(i,1)),:,10),'Color',[1,0.44,0],'LineWidth',3,'LineStyle','-');
       line(GCAM_Years(1,:),GCAM_Res(find(GCAM_States(:,1) == BEND_States(i,1)),:,11),'Color','b','LineWidth',3,'LineStyle','-');
       line(GCAM_Years(1,:),GCAM_Res(find(GCAM_States(:,1) == BEND_States(i,1)),:,12),'Color','c','LineWidth',3,'LineStyle','-');
    end
    line(BEND_Years(1,:),BEND_Res(i,:,1),'Color','r','LineWidth',3,'LineStyle','--');
    line(BEND_Years(1,:),BEND_Res(i,:,2),'Color',[1,0.44,0],'LineWidth',3,'LineStyle','--');
    line(BEND_Years(1,:),BEND_Res(i,:,3),'Color','b','LineWidth',3,'LineStyle','--');
    line(BEND_Years(1,:),BEND_Res(i,:,4),'Color','c','LineWidth',3,'LineStyle','--');
    xlim([2010 2050]); set(gca,'xtick',[2000:5:2050]); set(gca,'xticklabel',{'2000','','2010','','2020','','2030','','2040','','2050'});
    if i == 1 | i == 4 | i == 7 | i == 10; ylabel('10^4 MWh','FontSize',18); end
    set(gca,'LineWidth',3,'FontSize',18,'Box','on','Layer','top');
    title([state_string,' Residential'],'FontSize',21);
    text(0.015,0.900,label,'FontSize',18,'Units','normalized');
    clear state_string state_abbreviation label
end
subplot(4,3,12); hold on; axis off;
line(GCAM_Years(1,:),NaN.*GCAM_Tot_Norm(1,:,1),'Color','r','LineWidth',3,'LineStyle','-'); line(GCAM_Years(1,:),NaN.*GCAM_Tot_Norm(1,:,2),'Color',[1,0.44,0],'LineWidth',3,'LineStyle','-');
line(GCAM_Years(1,:),NaN.*GCAM_Tot_Norm(1,:,3),'Color','b','LineWidth',3,'LineStyle','-'); line(GCAM_Years(1,:),NaN.*GCAM_Tot_Norm(1,:,4),'Color','c','LineWidth',3,'LineStyle','-');
line(GCAM_Years(1,:),NaN.*GCAM_Tot_Norm(1,:,1),'Color','k','LineWidth',3,'LineStyle','-'); line(GCAM_Years(1,:),NaN.*GCAM_Tot_Norm(1,:,1),'Color','k','LineWidth',3,'LineStyle','--');
legend(['LowRF-LowPop'],['LowRF-HighPop'],['HighRF-HighPop'],['NoCCI-HighPop'],'GCAM (Solid Lines)','BEND (Dashed Lines)','Location','WestOutside');
legend boxoff; set(gca,'LineWidth',3,'FontSize',24,'Box','on','Layer','top');
if save_images == 1
   set(gcf,'Renderer','zbuffer'); set(gcf,'PaperPositionMode','auto');
   print(a,'-dpng','-r600',[image_output_dir,'Figure_S1.png']);
   close(a);
end
clear i a


a = figure('Color',[1 1 1]); set(a,'Position',get(0,'Screensize'));
for i = 1:size(BEND_States,1)
    if i == 1; label = '(a)'; end; if i == 7;  label = '(g)'; end; if i == 2; label = '(b)'; end; if i == 8;  label = '(h)'; end;
    if i == 3; label = '(c)'; end; if i == 9;  label = '(i)'; end; if i == 4; label = '(d)'; end; if i == 10; label = '(j)'; end;
    if i == 5; label = '(e)'; end; if i == 11; label = '(k)'; end; if i == 6; label = '(f)'; end;
    subplot(4,3,i); hold on;
    [state_string,state_abbreviation] = State_Strings(BEND_States(i,1));
    if gcam_run == 1
       line(GCAM_Years(1,:),GCAM_Com(find(GCAM_States(:,1) == BEND_States(i,1)),:,1),'Color','r','LineWidth',3,'LineStyle','-');
       line(GCAM_Years(1,:),GCAM_Com(find(GCAM_States(:,1) == BEND_States(i,1)),:,2),'Color',[1,0.44,0],'LineWidth',3,'LineStyle','-');
       line(GCAM_Years(1,:),GCAM_Com(find(GCAM_States(:,1) == BEND_States(i,1)),:,3),'Color','b','LineWidth',3,'LineStyle','-');
       line(GCAM_Years(1,:),GCAM_Com(find(GCAM_States(:,1) == BEND_States(i,1)),:,4),'Color','c','LineWidth',3,'LineStyle','-');
    elseif gcam_run == 2
       line(GCAM_Years(1,:),GCAM_Com(find(GCAM_States(:,1) == BEND_States(i,1)),:,5),'Color','r','LineWidth',3,'LineStyle','-');
       line(GCAM_Years(1,:),GCAM_Com(find(GCAM_States(:,1) == BEND_States(i,1)),:,6),'Color',[1,0.44,0],'LineWidth',3,'LineStyle','-');
       line(GCAM_Years(1,:),GCAM_Com(find(GCAM_States(:,1) == BEND_States(i,1)),:,7),'Color','b','LineWidth',3,'LineStyle','-');
       line(GCAM_Years(1,:),GCAM_Com(find(GCAM_States(:,1) == BEND_States(i,1)),:,8),'Color','c','LineWidth',3,'LineStyle','-');
    elseif gcam_run == 3
       line(GCAM_Years(1,:),GCAM_Com(find(GCAM_States(:,1) == BEND_States(i,1)),:,9),'Color','r','LineWidth',3,'LineStyle','-');
       line(GCAM_Years(1,:),GCAM_Com(find(GCAM_States(:,1) == BEND_States(i,1)),:,10),'Color',[1,0.44,0],'LineWidth',3,'LineStyle','-');
       line(GCAM_Years(1,:),GCAM_Com(find(GCAM_States(:,1) == BEND_States(i,1)),:,11),'Color','b','LineWidth',3,'LineStyle','-');
       line(GCAM_Years(1,:),GCAM_Com(find(GCAM_States(:,1) == BEND_States(i,1)),:,12),'Color','c','LineWidth',3,'LineStyle','-');
    end
    line(BEND_Years(1,:),BEND_Com(i,:,1),'Color','r','LineWidth',3,'LineStyle','--');
    line(BEND_Years(1,:),BEND_Com(i,:,2),'Color',[1,0.44,0],'LineWidth',3,'LineStyle','--');
    line(BEND_Years(1,:),BEND_Com(i,:,3),'Color','b','LineWidth',3,'LineStyle','--');
    line(BEND_Years(1,:),BEND_Com(i,:,4),'Color','c','LineWidth',3,'LineStyle','--');
    xlim([2010 2050]); set(gca,'xtick',[2000:5:2050]); set(gca,'xticklabel',{'2000','','2010','','2020','','2030','','2040','','2050'});
    if i == 1 | i == 4 | i == 7 | i == 10; ylabel('10^4 MWh','FontSize',18); end
    set(gca,'LineWidth',3,'FontSize',18,'Box','on','Layer','top');
    title([state_string,' Commercial'],'FontSize',21);
    text(0.015,0.900,label,'FontSize',18,'Units','normalized');
    clear state_string state_abbreviation label
end
subplot(4,3,12); hold on; axis off;
line(GCAM_Years(1,:),NaN.*GCAM_Tot_Norm(1,:,1),'Color','r','LineWidth',3,'LineStyle','-'); line(GCAM_Years(1,:),NaN.*GCAM_Tot_Norm(1,:,2),'Color',[1,0.44,0],'LineWidth',3,'LineStyle','-');
line(GCAM_Years(1,:),NaN.*GCAM_Tot_Norm(1,:,3),'Color','b','LineWidth',3,'LineStyle','-'); line(GCAM_Years(1,:),NaN.*GCAM_Tot_Norm(1,:,4),'Color','c','LineWidth',3,'LineStyle','-');
line(GCAM_Years(1,:),NaN.*GCAM_Tot_Norm(1,:,1),'Color','k','LineWidth',3,'LineStyle','-'); line(GCAM_Years(1,:),NaN.*GCAM_Tot_Norm(1,:,1),'Color','k','LineWidth',3,'LineStyle','--');
legend(['LowRF-LowPop'],['LowRF-HighPop'],['HighRF-HighPop'],['NoCCI-HighPop'],'GCAM (Solid Lines)','BEND (Dashed Lines)','Location','WestOutside');
legend boxoff; set(gca,'LineWidth',3,'FontSize',24,'Box','on','Layer','top');
if save_images == 1
   set(gcf,'Renderer','zbuffer'); set(gcf,'PaperPositionMode','auto');
   print(a,'-dpng','-r600',[image_output_dir,'Figure_S2.png']);
   close(a);
end
clear i a
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               END PLOTTING SECTION                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                BEGIN CLEANUP SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear bend_data_input_dir data_output_dir gcam_data_input_dir image_output_dir save_images process_data gcam_run
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 END CLEANUP SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%