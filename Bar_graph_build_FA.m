x=[1; 2; 3; 4; 5; 6; 7; 8];
N_backs = [1.08; 0.01; 0.01; 0.00; 0.00; 0.00; 0.00; 0.00];
%error = [0.90; 0.09; 0.11; 0.07; 0.12; 0.05; 0.11; 0.09 ];
interval_lower= [1.00; -0.05; -0.04; -0.05; -0.03; -0.06; -0.07; -0.08];
interval_upper=[1.10; 0.03; 0.04; 0.03; 0.02; 0.01; 0.03; 0.01];
bar(N_backs,'FaceColor',[0.1,0.3,0.3],'EdgeColor',[0 .01 .01],'LineWidth',1);
%set('BarWidth',0.6); 
ylabel('weight on current trial');
xlabel('Contrast condition'); 
Labels = {'current',  'n-2', 'n-3', 'n-4', 'n-5', 'n-6','n-7', 'n-8'};
set(gca, 'XTick', 1:8, 'XTickLabel', Labels, 'fontsize', 22);
legend ('Fitted weights 5% contrast experiment one');
hold on
numgroups=size(N_backs,1);
numbars=size(N_backs,2);
groupwidth=min(0.2, numbars/(numbars+1.1));
% for i = 1:numbars
%       % Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
%       x = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
%       errorbar(x, N_backs,(:,i), error(:,i), 'k', 'linestyle', 'none');
% end
errorbar(x, N_backs, interval_lower, interval_upper, 'k','linestyle', 'none','linewidth', 2);