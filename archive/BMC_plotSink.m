%BMC plot sink
clear
close all

cd('E:\LaCie\all BRFS completed Workspace Variables')
load('condBsink.mat')
    condB = SAVESINKVALCONDB;
load('condDsink.mat')
    condD = SAVESINKVALCONDD;
load('TM.mat')



%% Old
%ttest
ttestRangeB = condB(1,50:601);
ttestRangeD = condD(1,50:601);

[hOld,pOld] = ttest(ttestRangeB,ttestRangeD);

%plot
figure
subplot(2,1,1)
plot(TM,condB,'LineWidth',1)
hold on
plot(TM,condD,'LineWidth',1)

vline(0)
title(strcat('dCOS simul. vs. flash. Single baseline subtraction. h=',num2str(hOld),'p=', num2str(pOld)))
legend('dCOS simultaneous','dCOS 2nd stim after SOA, PS flashed')

%% New 
% 2nd baseline subtract
bl =1:50;
B = condB(1,50);
    bl_B = mean(condB(:,bl),2);
    subB = (condB-bl_B); 
D = condD(1,50);
    bl_D= mean(condD(:,bl),2);
    subD = (condD-bl_D); 

%ttest
ttestRangeB = condB(1,50:601);
ttestRangeD = condD(1,50:601);

[hNew,pNew] = ttest(ttestRangeB,ttestRangeD);

%plot
subplot(2,1,2)
plot(TM,subB,'LineWidth',1)
hold on
plot(TM,subD,'LineWidth',1)

vline(0)
title(strcat('dCOS simul. vs. flash. Double Baseline subtraction. h=',num2str(hNew),'p=', num2str(pNew)))
legend('dCOS simultaneous','dCOS 2nd stim after SOA, PS flashed')

