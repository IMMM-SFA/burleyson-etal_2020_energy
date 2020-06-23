% Figure_3.m: BEND GCAM-USA Conceptual Diagram
% 20200622
% Casey D. Burleyson
% Pacific Northwest National Laboratory

warning off all; clear all; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN USER INPUT SECTION               %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Set some processing flags:
save_images = 0; % (1 = Yes)

% Set the data input and output directories:
image_output_dir = '/Users/burl878/OneDrive - PNNL/Desktop/BEND_GCAM_Paper_Data/Figures/';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              END USER INPUT SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%              BEGIN PLOTTING SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a = figure('Color',[1 1 1]); set(a,'Position',get(0,'Screensize')); hold on;
patch([1 2 2 1],[0 0 1.5 1.5],'r','FaceAlpha',0.5,'EdgeColor','k','LineWidth',1);
patch([0 1.5 1.5 0],[-0.5 -0.5 1 1],'b','FaceAlpha',0.5,'EdgeColor','k','LineWidth',1);
scatter(1,0,1500,[0.7 0.7 0.7],'filled','MarkerEdgeColor','k','LineWidth',1);
patch([1 2 2 1],[0 0 1.5 1.5],'r','FaceAlpha',0.15,'EdgeColor','k','LineWidth',5);
patch([0 1.5 1.5 0],[-0.5 -0.5 1 1],'b','FaceAlpha',0.15,'EdgeColor','k','LineWidth',5);
scatter(1,0,1500,[0.7 0.7 0.7],'filled','MarkerEdgeColor','k','LineWidth',5);
xlim([-1.1 2.1]); set(gca,'xtick',[-1.0,-0.5,0.0,0.5,1.0,1.5,2.0]); set(gca,'xticklabel',{'Seconds','Minutes','Hours','Months','Years','Decades','Centuries'});
ylim([-1.1 1.6]); set(gca,'ytick',[-1.0 -0.5 0.0 0.5 1.0 1.5]); set(gca,'yticklabel',{'Cities','Counties','States','Regions','Nations','Global'});
legend('GCAM-USA','BEND','Resolution of This Analysis','Location','NorthWest');
grid on;
set(gca,'LineWidth',3,'FontSize',21,'Box','on');
title('Building Electricity Model Parameter Space','FontSize',24);
if save_images == 1
   set(gcf,'Renderer','zbuffer'); set(gcf,'PaperPositionMode','auto');
   print(a,'-dpng','-r600',[image_output_directory,'Figure_1.png']);
   close(a);
end
clear a
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%               END PLOTTING SECTION                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                BEGIN CLEANUP SECTION                %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear image_output_dir save_images
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                 END CLEANUP SECTION                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%