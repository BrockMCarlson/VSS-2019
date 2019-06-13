%% BMC_PlotACE
clear
close all


corticaldepth = (1.2:-0.1:-0.5);
pre = 100;
post = 1600;
TM = [-pre:1:post];

newPre = 100;
newPost = 800;
newTM = 800-newPre:800+newPost;

%% load
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


%% plot postSOA timecourse

postSOASinkAvg.biWsoaPS = sinkAvg.biWsoaPS(:,newTM);
postSOASinkAvg.diWsoaPS = sinkAvg.diWsoaPS(:,newTM);

difference = postSOASinkAvg.biWsoaPS - postSOASinkAvg.diWsoaPS;


% plot sinkAvg
figure

    plot(newTM,postSOASinkAvg.biWsoaPS,'DisplayName','biWsoaPS','color',[123,50,148]/255)
    hold on
    plot(newTM,postSOASinkAvg.diWsoaPS,'DisplayName','diWsoaPS','color',[0,136,55]/255)
    hold on
    plot(newTM,difference,'DisplayName','difference','color','k')
    
    xlim([700 1600])
    vline(800)
    hline(0)
    legend('Location','best')
    title('SOAdifference')
