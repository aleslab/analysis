x=[1; 2];
Gains = [141.66;38.50];
%error = [0.90; 0.09; 0.11; 0.07; 0.12; 0.05; 0.11; 0.09 ];
interval_lower= [30; 20];
interval_upper=[50; 30];
width=0.7;
bar(Gains,width,'FaceColor',[1.0,1.0,1.0],'EdgeColor',[0 .01 .01],'LineWidth',8);
% set('BarWidth',0.8); 
ylabel('Proximal variance');
xlabel('Contrast condition'); 
ylim([0, 200])
Labels = {'5% ',    '20%'};
set(gca, 'XTick', 1:2, 'XTickLabel', Labels, 'fontweight', 'bold','fontsize', 32);
hold on
numgroups=size(Gains,1);
numbars=size(Gains,2);
groupwidth=min(2, numbars/(numbars+2));
errorbar(x, Gains, interval_lower, interval_upper, 'k','linestyle', 'none','linewidth', 8);
box off



