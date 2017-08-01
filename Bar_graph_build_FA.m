Proximal_variance = [355.20; 247.90; 141];
error = [75; 85; 28];
bar(Proximal_variance,'FaceColor',[0.4,0.4,0.4],'EdgeColor',[0 .01 .01],'LineWidth',0.5);
%set('BarWidth',0.6); 
ylabel('Mean proximal variance');
xlabel('Contrast condition'); 
Labels = {'5%', '20%', '10%'};
set(gca, 'XTick', 1:4, 'XTickLabel', Labels, 'fontsize', 22);
hold on
numgroups=size(Proximal_variance,1);
numbars=size(Proximal_variance,2);
groupwidth=min(0.4, numbars/(numbars+1.1));
for i = 1:numbars
      % Based on barweb.m by Bolu Ajiboye from MATLAB File Exchange
      x = (1:numgroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numbars);  % Aligning error bar with individual bar
      errorbar(x, Proximal_variance(:,i), error(:,i), 'k', 'linestyle', 'none');
end