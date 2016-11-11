clc;
clf;
clear all;

Y= [305 126 1220 184; 102 80 137 75; 78 80 137 63]';%contarst values

groups ={'A' 'B' 'C'};%groups

[p,table, stats]=anova1(Y, groups);
[c, m, h, nms]=multcompare(stats, 'alpha',.05, 'ctype','hsd');



