% BMC Average BRFS across session

clear 
close all

%% EDITABLE VARIABLES

baseDir = 'E:\LaCie\all BRFS completed Workspace Variables';
sortdirection = 'descending'; %  descending (NN) or ascending (Uprobe)
chans         = [41:67]; 


%% 1. Avg across days
cd(baseDir)
load('grp1.mat') %SaveThis is (days,depth,timepoints)
avgThis = permute(SaveThis,[2 3 1]);

avgAccDays = nan(size(avgThis,1),size(avgThis,2)); %(depth,timepoints)
for i = 1:(size(avgThis,1))
    chanAccDays = squeeze(avgThis(i,:,:)); %chan 'i' dim(timepoints,days)
    avgAccDays(i,:) = permute(mean(chanAccDays,2,'omitnan'),[2 1]);
    
end
avgAccDays = squeeze(nanmean(SaveThis,1)); %avcAccDays is (depth,timepoints)

switch sortdirection
    case 'ascending' 
        corticaldepth = [chans] ;
    case 'descending'
        corticaldepth = fliplr([chans]);
end

%% 2. Plot CSD LINE

switch sortdirection
    case 'ascending' 
        corticaldepth = [chans] ;
    case 'descending'
        corticaldepth = fliplr([chans]);
end

load('TM.mat')

figure
subplot(1,2,1)
f_ShadedLinePlotbyDepth(avgAccDays,corticaldepth,TM,[],1)
title(BRdatafile,'interpreter','none')
set(gcf,'Position',[1 40 700 1200]); 

%% 3. Filter CSD and Plot colorplot