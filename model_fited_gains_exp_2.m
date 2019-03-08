x=[1; 2];
Gains = [0.74; 1.02];
interval_lower= [0.11; 0.03];
interval_upper=[0.14; 0.03];
width=0.8;
bar(Gains,width,'FaceColor',[1.0,1.0,1.0],'EdgeColor',[0 .01 .01],'LineWidth',8);
% set('BarWidth',0.8); 
ylabel('Modelled Kalman Gains');
xlabel('Contrast condition'); 
ylim([0, 1.1])
Labels = {'5% ',    '20%'};
set(gca, 'XTick', 1:2, 'XTickLabel', Labels, 'fontweight', 'bold','fontsize', 32);
hold on
numgroups=size(Gains,1);
numbars=size(Gains,2);
groupwidth=min(2, numbars/(numbars+2));
errorbar(x, Gains, interval_lower, interval_upper, 'k','linestyle', 'none','linewidth', 8);
box off
