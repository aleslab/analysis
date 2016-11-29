clc;
clf;
clear all;

Y= [305 126 1220 184 507 310 550 494 466 651 968; 102 80 137 75 201 175 94 105 183 72 244; 78 80 137 63 136 126 133 104 173 49 326]';%contarst values

groups ={'0.05' '0.10' '0.20'};%groups

[p,table, stats]=anova1(Y, groups);
[c, m, h, nms]=multcompare(stats, 'alpha',.05, 'ctype','hsd');



