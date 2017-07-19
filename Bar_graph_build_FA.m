model_series = [0.74; 0.95];
model_error = [0.22; 0.32];
bar(model_series,'FaceColor',[0.4,0.4,0.4],'EdgeColor',[0 .01 .01],'LineWidth',0.5);
%set('BarWidth',0.6); 
ylabel('Mean fitted Kalman gain');
xlabel('Contrast condition'); 
Labels = {'5%', '20%'};
set(gca, 'XTick', 1:4, 'XTickLabel', Labels);
hold on
for i = 1:numbars
      % Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
      x = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
      errorbar(x, model_series(:,i), model_error(:,i), 'k', 'linestyle', 'none');
end