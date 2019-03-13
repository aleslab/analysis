x=[1, 1; 2,2];
Gains = [0.96, 1.16; .87, 1.03];
%error = [0.90; 0.09; 0.11; 0.07; 0.12; 0.05; 0.11; 0.09 ];
% interval_lower= [0.1,0.1; 0.13, 0.1];
% interval_upper= [0.08, 0.1; 0.16, 0.1];
width=0.7;
bar(Gains,width,'FaceColor',[1.0,1.0,1.0],'EdgeColor',[0 .01 .01],'LineWidth',8);
% set('BarWidth',0.8); 
ylabel('Kalman gain');
%xlabel('5% MCA vs 20% MCA vs 2AFC','fontweight', 'bold','fontsize', 32); 
ylim([0,1.25])
Labels = {'35.7 step (degs)', '18.6 step (degs)'};
set(gca, 'XTick', 1:2, 'XTickLabel', Labels, 'fontweight', 'bold','fontsize', 32);
%legend ('Proxmal variance levels from main experiments and 2AFC');
hold on
numgroups=size(Gains,1);
numbars=size(Gains,2);
groupwidth=min(2, numbars/(numbars+2));
%errorbar(x, Gains, interval_lower, interval_upper, 'k','linestyle', 'none','linewidth', 8);
box off



