% Figure_3.m: State HDD and CDD Projections
% 20200622
% Casey D. Burleyson
% Pacific Northwest National Laboratory

warning off all; clear all; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN USER INPUT SECTION               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set some processing flags:
process_data = 0; % (1 = Yes)
save_images = 0; % (1 = Yes)

% Set the data input and output directories:
data_input_dir = '/Users/burl878/OneDrive - PNNL/Desktop/BEND_GCAM_Paper_Data/Data/HDD_CDD_Projections/';
data_output_directory = '/Users/burl878/OneDrive - PNNL/Desktop/BEND_GCAM_Paper_Data/Data/Data_Supporting_Figures/';
image_output_dir = '/Users/burl878/OneDrive - PNNL/Desktop/BEND_GCAM_Paper_Data/Figures/';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              END USER INPUT SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%             BEGIN PROCESSING SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if process_data == 1
   WECC_States = [4000;6000;8000;16000;30000;32000;35000;41000;49000;53000;56000];
 
   load([data_input_dir,'Annual_State_HDD_and_CDD_RCP45_2000_to_2050.mat']);
   for row = 1:size(WECC_States,1)
       CDD_Subset(row,:) = States_CDD_Sum(find(States(:,1) == WECC_States(row,1)),:);
       HDD_Subset(row,:) = States_HDD_Sum(find(States(:,1) == WECC_States(row,1)),:);
   end
   RCP45_CDD = CDD_Subset; RCP45_HDD = HDD_Subset;
   clear States_CDD_Sum States_HDD_Sum CDD_Subset HDD_Subset row

   load([data_input_dir,'Annual_State_HDD_and_CDD_RCP85_2000_to_2050.mat']);
   for row = 1:size(WECC_States,1)
       CDD_Subset(row,:) = States_CDD_Sum(find(States(:,1) == WECC_States(row,1)),:);
       HDD_Subset(row,:) = States_HDD_Sum(find(States(:,1) == WECC_States(row,1)),:);
   end
   RCP85_CDD = CDD_Subset; RCP85_HDD = HDD_Subset; States = WECC_States;
   clear WECC_States States_CDD_Sum States_HDD_Sum CDD_Subset HDD_Subset row

   for row = 1:size(States)
       Year_Matrix(row,:) = Year(1,:);
   end
   clear row

   RCP45_CDD_Linear = RCP45_CDD(:);
   RCP45_HDD_Linear = RCP45_HDD(:);
   RCP85_CDD_Linear = RCP85_CDD(:);
   RCP85_HDD_Linear = RCP85_HDD(:);
   Year_Linear = Year_Matrix(:);

   RCP45_CDD_P = polyfit(Year_Linear,RCP45_CDD_Linear,1);
   RCP45_CDD_Slope = round(RCP45_CDD_P(1,1));
   RCP45_CDD_Trend = polyval(RCP45_CDD_P,Year); 

   RCP45_HDD_P = polyfit(Year_Linear,RCP45_HDD_Linear,1);
   RCP45_HDD_Slope = round(RCP45_HDD_P(1,1));
   RCP45_HDD_Trend = polyval(RCP45_HDD_P,Year);

   RCP85_CDD_P = polyfit(Year_Linear,RCP85_CDD_Linear,1);
   RCP85_CDD_Slope = round(RCP85_CDD_P(1,1));
   RCP85_CDD_Trend = polyval(RCP85_CDD_P,Year);

   RCP85_HDD_P = polyfit(Year_Linear,RCP85_HDD_Linear,1);
   RCP85_HDD_Slope = round(RCP85_HDD_P(1,1));
   RCP85_HDD_Trend = polyval(RCP85_HDD_P,Year);
   clear RCP85_HDD_P RCP85_HDD_Linear RCP85_CDD_P RCP85_CDD_Linear RCP45_HDD_P RCP45_HDD_Linear RCP45_CDD_P RCP45_CDD_Linear Year_Linear Year_Matrix
   
   save([data_output_directory,'Figure_3_Data.mat'],'States','Year','RCP45_CDD','RCP45_CDD_Slope','RCP45_CDD_Trend','RCP45_HDD','RCP45_HDD_Slope',...
                                                    'RCP45_HDD_Trend','RCP85_CDD','RCP85_CDD_Slope','RCP85_CDD_Trend','RCP85_HDD','RCP85_HDD_Slope','RCP85_HDD_Trend');
else
   load([data_output_directory,'Figure_3_Data.mat']);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              END PROCESSING SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN PLOTTING SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a = figure('Color',[1 1 1]); set(a,'Position',get(0,'Screensize')); C = jet(11);
subplot(4,7,[1 2 8 9]); hold on; 
for row = 1:size(States,1)
    line(Year(1,:),RCP45_CDD(row,:),'Color',C(row,:),'LineWidth',3);
end
line(Year(1,:),RCP45_CDD_Trend(1,:),'Color','k','LineWidth',5);
for year = 2010:10:2050
    line([year year],[0 3100],'Color',[0.5 0.5 0.5],'LineWidth',1.5)
end
xlim([2000 2050]);
set(gca,'xtick',[2000:10:2050]);
set(gca,'xticklabel',{'','','','','',''});
ylim([0 3100]);
ylabel('Cooling Degree Days','FontSize',24);
set(gca,'LineWidth',3,'FontSize',21,'Box','on','Layer','top');
title(['RCP 4.5 CDD [+',num2str(RCP45_CDD_Slope),' year^-^1]'],'FontSize',27);
text(0.02,0.95,['(a)'],'FontSize',27,'Units','normalized');

subplot(4,7,[3.5 4.5 10.5 11.5]); hold on; 
for row = 1:size(States,1)
    line(Year(1,:),RCP45_HDD(row,:),'Color',C(row,:),'LineWidth',3);
end
line(Year(1,:),RCP45_HDD_Trend(1,:),'Color','k','LineWidth',5);
for year = 2010:10:2050
    line([year year],[0 4500],'Color',[0.5 0.5 0.5],'LineWidth',1.5)
end
xlim([2000 2050]);
set(gca,'xtick',[2000:10:2050]);
set(gca,'xticklabel',{'','','','','',''});
ylim([0 4600]);
ylabel('Heating Degree Days','FontSize',24);
set(gca,'LineWidth',3,'FontSize',21,'Box','on','Layer','top');
title(['RCP 4.5 HDD [',num2str(RCP45_HDD_Slope),' year^-^1]'],'FontSize',27);
text(0.89,0.95,['(b)'],'FontSize',27,'Units','normalized');

subplot(4,7,[15 16 22 23]); hold on; 
for row = 1:size(States,1)
    line(Year(1,:),RCP85_CDD(row,:),'Color',C(row,:),'LineWidth',3);
end
line(Year(1,:),RCP85_CDD_Trend(1,:),'Color','k','LineWidth',5);
for year = 2010:10:2050
    line([year year],[0 3100],'Color',[0.5 0.5 0.5],'LineWidth',1.5)
end
xlim([2000 2050]);
set(gca,'xtick',[2000:10:2050]);
set(gca,'xticklabel',{'2000','2010','2020','2030','2040','2050'});
ylim([0 3100]);
ylabel('Cooling Degree Days','FontSize',24);
set(gca,'LineWidth',3,'FontSize',21,'Box','on','Layer','top');
title(['RCP 8.5 CDD [+',num2str(RCP85_CDD_Slope),' year^-^1]'],'FontSize',27);
text(0.02,0.95,['(c)'],'FontSize',27,'Units','normalized');

subplot(4,7,[17.5 18.5 24.5 25.5]); hold on; 
for row = 1:size(States,1)
    line(Year(1,:),RCP85_HDD(row,:),'Color',C(row,:),'LineWidth',3);
end
line(Year(1,:),RCP85_HDD_Trend(1,:),'Color','k','LineWidth',5);
for year = 2010:10:2050
    line([year year],[0 4500],'Color',[0.5 0.5 0.5],'LineWidth',1.5)
end
xlim([2000 2050]);
set(gca,'xtick',[2000:10:2050]);
set(gca,'xticklabel',{'2000','2010','2020','2030','2040','2050'});
ylim([0 4600]);
ylabel('Heating Degree Days','FontSize',24);
set(gca,'LineWidth',3,'FontSize',21,'Box','on','Layer','top');
title(['RCP 8.5 HDD [',num2str(RCP85_HDD_Slope),' year^-^1]'],'FontSize',27);
text(0.89,0.95,['(d)'],'FontSize',27,'Units','normalized');

subplot(4,7,[5.5 12.5 19.5 26.5]); hold on; axis off
for row = 1:size(States,1)
    line(Year(1,:),NaN.*RCP85_CDD(row,:),'Color',C(row,:),'LineWidth',3);
end
legend('AZ','CA','CO','ID','MT','NV','NM','OR','UT','WA','WY','Location','WestOutside');
set(gca,'LineWidth',3,'FontSize',27,'Box','off');

if save_images == 1
   set(gcf,'Renderer','zbuffer'); set(gcf,'PaperPositionMode','auto');
   print(a,'-dpng','-r600',[image_output_dir,'Figure_3.png']);
   close(a);
end
clear a C row year
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               END PLOTTING SECTION                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                BEGIN CLEANUP SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear data_input_dir image_output_dir save_images process_data data_output_directory
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 END CLEANUP SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%