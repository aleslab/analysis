N_backs = [1.08; 0.01; 0.01; 0.00; 0.00; 0.00; 0.00; 0.00];
error = [0.10; 0.09; 0.11; 0.07; 0.12; 0.05; 0.11; 0.09 ];
%bar(N_backs,'FaceColor',[0.3,0.3,0.3],'EdgeColor',[0 .01 .01],'LineWidth',0.5);
%set('BarWidth',0.6); 
boxplot(N_backs,'LineWidth',0.5);
ylabel('weight on current trial');
xlabel('Contrast condition'); 
Labels = {'n-1',  'n-2', 'n-3', 'n-4', 'n-5', 'n-6','n-7', 'n-8'};
set(gca, 'XTick', 1:8, 'XTickLabel', Labels, 'fontsize', 22);
legend ('Fitted weights 5% contrast experiment one');
hold on
numgroups=size(N_backs,1);
numbars=size(N_backs,2);
groupwidth=min(0.2, numbars/(numbars+1.1));
for i = 1:numbars
      % Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
      x = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
      errorbar(x, N_backs(:,i), error(:,i), 'k', 'linestyle', 'none');
end