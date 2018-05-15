x=[1; 2];
Gains = [136, 39];
%error = [0.90; 0.09; 0.11; 0.07; 0.12; 0.05; 0.11; 0.09 ];
interval_lower= [75; 19];
interval_upper=[74; 22];
width=0.7;
bar(Gains,width,'FaceColor',[1.0,1.0,1.0],'EdgeColor',[0 .01 .01],'LineWidth',8);
% set('BarWidth',0.8); 
ylabel('Error variance');
%xlabel('5% MCA vs 20% MCA vs 2AFC','fontweight', 'bold','fontsize', 32); 
ylim([0, 220])
Labels = {'5%', '20%'};
set(gca, 'XTick', 1:2, 'XTickLabel', Labels, 'fontweight', 'bold','fontsize', 32);
%legend ('Fitted weights 5% contrast experiment one');
hold on
numgroups=size(Gains,1);
numbars=size(Gains,2);
groupwidth=min(2, numbars/(numbars+2));
errorbar(x, Gains, interval_lower, interval_upper, 'k','linestyle', 'none','linewidth', 8);
box off



