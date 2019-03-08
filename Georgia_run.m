fileToLoad = uigetfile; load(fileToLoad); % loads up file you want 

%this is one (bad) way to get stuff out of a cell so you can plot it and
%play with it 
% will come up with something much better once i remind myself how to work
% with cell arrays! iv just chosen random cell fields but you can make your
% own fields etc. we can do more as we decide what is interetsing later.

% for i=1:length(data)
% tone={tone};
% % now go on
% % plot(curstate(1),curstate(2),'ro')
% end
% 
% % stimOri=data{1,1}.motion_direction; % just predshape for first block in 1 exeprimetal block  which has 4 sub blocks
% % error=data{1,1}.error;      
% % 
% % motion_direction (1) = 0;
% % error (1) = 0;
% % 
% % for i = length (motion_direction)
% %     RO(i) = (stimOri(i-1)-stimOri (i));
% % end
% % 
% % set(gca,'fontsize', 28);
% % hold on
% % scatter (RO, error,90,'k','filled');
