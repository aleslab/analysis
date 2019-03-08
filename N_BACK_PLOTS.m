figure(101);
clf;
x=[1,; 2; 3; 4; 5; 6];
weights = [0.00; 0.00;  -0.00; -0.01; -0.01; 0.0];
%error = [0.90; 0.09; 0.11; 0.07; 0.12; 0.05; 0.11; 0.09 ];
interval_lower= [0.01; 0.02; 0.02; 0.02; 0.03; 0.03];
interval_upper=[0.01; 0.01; 0.02; 0.02; 0.01; 0.01];
width=0.6;
bar(x,weights,width,'FaceColor',[1.0,1.0,1.0],'EdgeColor',[0 .01 .01],'LineWidth',8);
% set('BarWidth',0.8); 
ylabel('Regression slope');
xlabel('Trial number','fontweight', 'bold','fontsize', 32); 
ylim([-0.07, 1.])
Labels = {'n-1', 'n-2', 'n-3', 'n-4', 'n-5','n-6' };
set(gca, 'XTick', 1:6, 'XTickLabel', Labels, 'fontweight', 'bold','fontsize', 32);
%legend ('Fitted weights 5% contrast experiment one');
hold on
numgroups=size(weights,1);
numbars=size(weights,3);
groupwidth=min(2, numbars/(numbars+2));
%x=[1-width/2,1+width/2;2-width/2, 2+width/2];
%x=[.85,1.15; 1.85, 2.15; 2.85, 3.15];

errorbar(x, weights, interval_lower, interval_upper, 'k','linestyle', 'none','linewidth', 8);

box off



