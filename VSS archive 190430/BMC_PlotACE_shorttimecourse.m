%% BMC_PlotACE
clear
close all


corticaldepth = (1.2:-0.1:-0.5);
pre = 100;
post = 1600;
TM = [-pre:1:post];

%% load
% load and create structures based on conditions
% load and create structures based on conditions
cd('E:\LaCie\VSS 2019 figs\190429 figs post MC meeting\filteredMatVar')
    biNOsoaPS	= load('biPSNOsoafiltered.mat');
    diNOsoa     = load('dicopNOsoafiltered.mat');

    biWsoaPS    = load('biPSWsoafiltered.mat');
    diWsoaPS    = load('dichopWsoa_fullTrialPSfiltered.mat');

%% process

cutACE.biNOsoaPS	= biNOsoaPS.ACE(38:55,:);
cutACE.diNOsoa      = diNOsoa.ACE(38:55,:);  
cutACE.biWsoaPS     = biWsoaPS.ACE(38:55,:); 
cutACE.diWsoaPS     = diWsoaPS.ACE(38:55,:);

%% Compare Sink Lineplots,
% cutACE row 13 is sink bottom, cortical depth of 0
% cutACE row 12 is also the sink(??), cortical depth of 0.1
sinkAvg.biNOsoaPS	= mean(cutACE.biNOsoaPS(12:13,:),1);
sinkAvg.diNOsoa     = mean(cutACE.diNOsoa(12:13,:),1);  
sinkAvg.biWsoaPS	= mean(cutACE.biWsoaPS(12:13,:),1); 
sinkAvg.diWsoaPS     = mean(cutACE.diWsoaPS(12:13,:),1);

sinkBtm.biNOsoaPS	= cutACE.biNOsoaPS(13,:);
sinkBtm.diNOsoa     = cutACE.diNOsoa(13,:);  
sinkBtm.biWsoaPS	= cutACE.biWsoaPS(13,:); 
sinkBtm.diWsoaPS     = cutACE.diWsoaPS(13,:);


%% plot short timecourse


newPre = 100;
newPost = 150;
newTM = 0-newPre:0+newPost;
shortSinkAvg.biNOsoaPS = sinkAvg.biNOsoaPS(:,1:length(newTM));
shortSinkAvg.diNOsoa = sinkAvg.diNOsoa(:,1:length(newTM));
shortSinkAvg.biWsoaPS = sinkAvg.biWsoaPS(:,1:length(newTM));
shortSinkAvg.diWsoaPS = sinkAvg.diWsoaPS(:,1:length(newTM));
% plot sinkAvg
figure(5)
    plot(newTM,shortSinkAvg.biNOsoaPS,'LineWidth',1,'DisplayName','biNOsoaPS')
    hold on
    plot(newTM,shortSinkAvg.diNOsoa,'LineWidth',1,'DisplayName','diNOsoa')
    hold on
    plot(newTM,shortSinkAvg.biWsoaPS,'LineWidth',1,'DisplayName','biWsoaPS')
    hold on
    plot(newTM,shortSinkAvg.diWsoaPS,'LineWidth',1,'DisplayName','diWsoaPS')
    
    vline(0)
    hline(0)
    legend('Location','best')
    title('CSD of sinkAvg. Cortical depth of 0 and 0.1 averaged')
