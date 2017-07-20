gains = [0.74; 0.95; 0.65];
error_gains = [0.22; 0.32; 0.22];
bar(gains,'FaceColor',[0.4,0.4,0.4],'EdgeColor',[0 .01 .01],'LineWidth',0.5);
%set('BarWidth',0.6); 
ylabel('Mean fitted Kalman gain');
xlabel('Contrast condition'); 
Labels = {'5%', '20%', '10%'};
set(gca, 'XTick', 1:4, 'XTickLabel', Labels, 'fontsize', 22);
hold on
numgroups=size(gains,1);
numbars=size(gains,2);
groupwidth=min(0.3, numbars/(numbars+1.1));
for i = 1:numbars
      % Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
      x = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
      errorbar(x, gains(:,i), error_gains(:,i), 'k', 'linestyle', 'none');
end