fileToLoad = uigetfile; load(fileToLoad); % loads up file you want 

%this is one (bad) way to get stuff out of a cell so you can plot it
% will come up with something much better once i remind myself how to work
% with cell arrays. iv just chosen random cell fields but you can make your
% own fields etc. we can do more as we decide what is interetsing later

con_1_predshape=data{1,1}.predShape; % just pred for 
hold on
figure (101)
plot(con_1_predshape)

con_1_reaction_times=data{1,1}.RT;
hold on
figure (201)
plot (con_1_reaction_times);


con_2_predshape=data{1,2}.predShape;
hold on
figure (301)
plot(con_1_predshape)

con_2_reaction_times=data{1,2}.RT;
hold on
figure (401)
plot (con_1_reaction_times);

figure(501)
plot(con_1_reaction_times)
hold on
plot (con_2_reaction_times)

%below is just a basic example of how you might get variables of interest using a for loop -
%iv just looked at reaction time diffs here for fun but as we learn more we
%can extend and do much more

for i= 2:length (con_1_reaction_times);
    
    time_diff = (con_1_reaction_times-con_2_reaction_times);
    
end 

figure(601)
plot (time_diff)

mean_time_diff=mean(time_diff);% just little examples of variables of interest 
var=




