figure(101);
clf;
x=[1,1,1; 2,2,2;3,3,3];
Gains = [0.03, 0.01, 0.02; 0.95, 0.96, 1.01; 0.98, 0.99, 1.00];
%error = [0.90; 0.09; 0.11; 0.07; 0.12; 0.05; 0.11; 0.09 ];
interval_lower= [0.03, 0.03, 0.02; 0.06, 0.05, 0.05; 0.00, 0.00, 0.00];
interval_upper=[ 0.02, 0.03, 0.03; 0.07, 0.06, 0.05; 0.00, 0.00, 0.00];
width=0.8;
bar(x,Gains,width,'FaceColor',[1.0,1.0,1.0],'EdgeColor',[0 .01 .01],'LineWidth',8);
% set('BarWidth',0.8); 
ylabel('KGain/SDRegression slope values');
%xlabel('5% MCA vs 20% MCA vs 2AFC','fontweight', 'bold','fontsize', 32); 
ylim([0, 1.1])
Labels = {'Regression slope', 'Modelled KGains', 'Predicted KGains'};
set(gca, 'XTick', 1:3, 'XTickLabel', Labels, 'fontweight', 'bold','fontsize', 32);
%legend ('Fitted weights 5% contrast experiment one');
hold on
numgroups=size(Gains,1);
numbars=size(Gains,3);
groupwidth=min(2, numbars/(numbars+2));
%x=[1-width/2,1+width/2;2-width/2, 2+width/2];
x=[.85,1.15, 1.45; 2.45, 2.75, 3.05; 4.05, 4.35, 4.75];

errorbar(x, Gains, interval_lower, interval_upper, 'k','linestyle', 'none','linewidth', 8);

box off



