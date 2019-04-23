%BMC_AverageBRFS_2_acrosssessions

% I dont feel like saving variables and establishing direcotry right now,
% so make sure you run after BMC_AvergeBRFS_1_session.m

%% 1. get important variables

clearvars -except AlignedCSD newSessionParams SAVEALLCSD Unq_cond varName

sortdirection = 'descending';
text = 'Non Pref Stim';
corticaldepth = (-.5:.1:1.2);

%do I need Cond?? Maybe I already threw this away because everything should
%be dicoptic. idk...

%% 2. nanmean
% note: ACE = Average CSD Effect
 ACE = nanmean(AlignedCSD,3);

%% 3. create depth vector and then crop the file at 1.2mm and -0.5mm
%   make sure you remember to flip the vector if it was done with all neuro
%   nexus probes (I think it was. For now perhps this doesn't need to be a
%   universial code)
% note: ACE = Average CSD Effect

cutACE = ACE(45:62,:);

chans = [1:size(cutACE,1)];

switch sortdirection
    case 'ascending' 
        corticaldepth = corticaldepth ;
    case 'descending'
        corticaldepth = fliplr(corticaldepth);
        cutACE = flipud(cutACE);
end

%% 4. Plot? Save variables so I can do subtraction?
%       Maybe tackle these in a more official capacity later. 

cd('E:\LaCie\all BRFS completed Workspace Variables');
load('TM.mat');

figure
subplot(1,2,1)
f_ShadedLinePlotbyDepth(cutACE,corticaldepth,TM,[],1)
title(text,'interpreter','none')
set(gcf,'Position',[1 40 700 1200]); 

CSDf = filterCSD(cutACE);

subplot(1,2,2)
switch sortdirection
    case 'ascending'
        y = [chans];
        ydir = 'reverse';
    case 'descending'
        y = fliplr([chans]);
        ydir = 'normal';
end
imagesc(TM,y,CSDf); colormap(flipud(jet));
climit = max(abs(get(gca,'CLim'))*.8);
set(gca,'CLim',[-climit climit],'Ydir',ydir,'Box','off','TickDir','out')
hold on;
plot([0 0], ylim,'k')
yticks(1.2:.2:-.5)
c = colorbar;
% caxis([-250 250])




