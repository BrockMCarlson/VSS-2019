%% BMC_PlotACD - Average CSD Difference
% barplots
% no monocular. See recent 190429 archive for barplot with monocualr
% compares differences of timecourses
clear
close all

stimtm1 = 100;
stimtm2 = 900;

pre = 100;
post = 1600;
TM = -pre:1:post;
AnalyzeSink = 'lower'; % 'lower' or 'upper' % Why would you analyze the upper here?

clrA = [194,165,207]/255;
clrB = [166,219,160]/255;
clrC = [123,50,148]/255 ;
clrD = [0,136,55]/255;


% load and create structures based on conditions
cd('E:\LaCie\VSS 2019 figs\190429 figs post MC meeting\filteredMatVar')
    biNOsoaPS	= load('biPSNOsoafiltered.mat');
    diNOsoa     = load('dicopNOsoafiltered.mat');

    biWsoaPS    = load('biPSWsoafiltered.mat');
    diWsoaPS    = load('dichopWsoa_fullTrialPSfiltered.mat');


cutAllCSDaligned.biNOsoaPS	= biNOsoaPS.AllCSDaligned(38:55,:,:);
cutAllCSDaligned.diNOsoa      = diNOsoa.AllCSDaligned(38:55,:,:);  
cutAllCSDaligned.biWsoaPS     = biWsoaPS.AllCSDaligned(38:55,:,:); 
cutAllCSDaligned.diWsoaPS     = diWsoaPS.AllCSDaligned(38:55,:,:);

%% Compare Sink Lineplots,
% cutACE row 13 is sink bottom, cortical depth of 0
% cutACE row 12 is also the sink(??), cortical depth of 0.1
switch AnalyzeSink
    case 'lower'
        sinkAllCSDaligned.biNOsoaPS	= cutAllCSDaligned.biNOsoaPS(12:13,:,:);
        sinkAllCSDaligned.diNOsoa     = cutAllCSDaligned.diNOsoa(12:13,:,:);  
        sinkAllCSDaligned.biWsoaPS	= cutAllCSDaligned.biWsoaPS(12:13,:,:); 
        sinkAllCSDaligned.diWsoaPS     = cutAllCSDaligned.diWsoaPS(12:13,:,:); 
        
        for i = 1:size(sinkAllCSDaligned.biNOsoaPS,3)
           sinkAvgAllCSDaligned.biNOsoaPS(i,:) = mean(sinkAllCSDaligned.biNOsoaPS(1:2,:,i),1);
           sinkAvgAllCSDaligned.diNOsoa(i,:) = mean(sinkAllCSDaligned.diNOsoa(1:2,:,i),1);
           sinkAvgAllCSDaligned.biWsoaPS(i,:) = mean(sinkAllCSDaligned.biWsoaPS(1:2,:,i),1);
           sinkAvgAllCSDaligned.diWsoaPS(i,:) = mean(sinkAllCSDaligned.diWsoaPS(1:2,:,i),1);
        end
        titletext = {'CSD of lower sink. Cortical depth of 0 & 0.1 averaged.','monoc Vs binocular PS flash Vs dichoptic PS flash.',' Same percept different stim.'};
    case 'upper'
        sinkAvgAllCSDaligned.biNOsoaPS	= squeeze(cutAllCSDaligned.biNOsoaPS(6,:,:))';
        sinkAvgAllCSDaligned.diNOsoa     = squeeze(cutAllCSDaligned.diNOsoa(6,:,:))';  
        sinkAvgAllCSDaligned.biWsoaPS	= squeeze(cutAllCSDaligned.biWsoaPS(6,:,:))'; 
        sinkAvgAllCSDaligned.diWsoaPS     = squeeze(cutAllCSDaligned.diWsoaPS(6,:,:))';  
        titletext = {'CSD of upper sink. Cortical depth of 0.7 averaged.','monoc Vs binocular PS flash Vs dichoptic PS flash.',' Same percept different stim.'};      
end

%% Baseline for 2nd stim (already 1st stim baseline corrected.) 900 is 2nd stim onset.
blWin1.biNOsoaPS	= sinkAvgAllCSDaligned.biNOsoaPS;	
blWin1.diNOsoa    = sinkAvgAllCSDaligned.diNOsoa;    


baselineWindow2.biWsoaPS(:,:) = mean(sinkAvgAllCSDaligned.biWsoaPS(:,850:900),2);
baselineWindow2.diWsoaPS(:,:) = mean(sinkAvgAllCSDaligned.diWsoaPS(:,850:900),2);

blWin2.biWsoaPS = sinkAvgAllCSDaligned.biWsoaPS - baselineWindow2.biWsoaPS;
blWin2.diWsoaPS = sinkAvgAllCSDaligned.diWsoaPS - baselineWindow2.diWsoaPS;


%% Pull pertinent timecourses
% for each timecourse, subtract PS from NPS or dichoptic from bi

% transient (50-150ms)

    %biNOsoaPS - diNOsoa ==> simultaneous
    meanOfWindow.a.simultBi = mean(blWin1.biNOsoaPS(:,stimtm1+50:stimtm1+100),2);
    meanOfWindow.a.stimulDi = mean(blWin1.diNOsoa(:,stimtm1+50:stimtm1+100),2);
    diff.a.binoc.idx = (meanOfWindow.a.simultBi - meanOfWindow.a.stimulDi)./(meanOfWindow.a.simultBi + meanOfWindow.a.stimulDi);
    diff.a.binoc.fullAvg = mean(diff.a.binoc.idx);
    diff.a.binoc.ci = bootci(4000,@mean,diff.a.binoc.idx);

    % biWsoaPS(post adaptation)-biWsoaPS(post adaptation)
    meanOfWindow.a.flashPS = mean(blWin2.biWsoaPS(:,stimtm2+50:stimtm2+100),2);
    meanOfWindow.a.flashNPS = mean(blWin2.diWsoaPS(:,stimtm2+50:stimtm2+100),2);    
    diff.a.flash.idx = (meanOfWindow.a.flashPS - meanOfWindow.a.flashNPS)./(meanOfWindow.a.flashPS + meanOfWindow.a.flashNPS);
	diff.a.flash.fullAvg = mean(diff.a.flash.idx);
    diff.a.flash.ci = bootci(4000,@mean,diff.a.flash.idx);  
    
  bar_a.data = [diff.a.binoc.fullAvg diff.a.flash.fullAvg];
  bar_a.cilow = [diff.a.binoc.ci(1) diff.a.flash.ci(1)];
  bar_a.cihigh = [diff.a.binoc.ci(2) diff.a.flash.ci(2)];  

% initial recovery (150-200ms)
    %biNOsoaPS - diNOsoa ==> simultaneous
    meanOfWindow.b.simultBi = mean(blWin1.biNOsoaPS(:,stimtm1+150:stimtm1+200),2);
    meanOfWindow.b.stimulDi = mean(blWin1.diNOsoa(:,stimtm1+150:stimtm1+200),2);
    diff.b.binoc.idx = (meanOfWindow.b.simultBi - meanOfWindow.b.stimulDi)./(meanOfWindow.b.simultBi + meanOfWindow.b.stimulDi);
    diff.b.binoc.fullAvg = mean(diff.b.binoc.idx);
    diff.b.binoc.ci = bootci(4000,@mean,diff.b.binoc.idx);
  
    % biWsoaPS(post adaptation)-biWsoaPS(post adaptation)
    meanOfWindow.b.flashPS = mean(blWin2.biWsoaPS(:,stimtm2+150:stimtm2+200),2);
    meanOfWindow.b.flashNPS = mean(blWin2.diWsoaPS(:,stimtm2+150:stimtm2+200),2);    
    diff.b.flash.idx = (meanOfWindow.b.flashPS - meanOfWindow.b.flashNPS)./(meanOfWindow.b.flashPS + meanOfWindow.b.flashNPS);
    diff.b.flash.fullAvg = mean(diff.b.flash.idx);
    diff.b.flash.ci = bootci(4000,@mean,diff.b.flash.idx);  
 
  bar_b.data = [diff.b.binoc.fullAvg diff.b.flash.fullAvg];
  bar_b.cilow = [diff.b.binoc.ci(1)  diff.b.flash.ci(1)];
  bar_b.cihigh = [diff.b.binoc.ci(2) diff.b.flash.ci(2)];    
  
    
% feedbak initiation (250-300ms)
    %biNOsoaPS - diNOsoa ==> simultaneous
    meanOfWindow.c.simultBi = mean(blWin1.biNOsoaPS(:,stimtm1+250:stimtm1+300),2);
    meanOfWindow.c.stimulDi = mean(blWin1.diNOsoa(:,stimtm1+250:stimtm1+300),2);
    diff.c.binoc.idx = (meanOfWindow.c.simultBi - meanOfWindow.c.stimulDi)./(meanOfWindow.c.simultBi + meanOfWindow.c.stimulDi);
    diff.c.binoc.fullAvg = mean(diff.c.binoc.idx);
    diff.c.binoc.ci = bootci(4000,@mean,diff.c.binoc.idx);
 
    % biWsoaPS(post adaptation)-biWsoaPS(post adaptation)
    meanOfWindow.c.flashPS = mean(blWin2.biWsoaPS(:,stimtm2+250:stimtm2+300),2);
    meanOfWindow.c.flashNPS = mean(blWin2.diWsoaPS(:,stimtm2+250:stimtm2+300),2);    
    diff.c.flash.idx = (meanOfWindow.c.flashPS - meanOfWindow.c.flashNPS)./(meanOfWindow.c.flashPS + meanOfWindow.c.flashNPS);
    diff.c.flash.fullAvg = mean(diff.c.flash.idx);
    diff.c.flash.ci = bootci(4000,@mean,diff.c.flash.idx);  
    
  bar_c.data = [diff.c.binoc.fullAvg diff.c.flash.fullAvg];
  bar_c.cilow = [diff.c.binoc.ci(1)  diff.c.flash.ci(1)];
  bar_c.cihigh = [diff.c.binoc.ci(2)  diff.c.flash.ci(2)];  
    
% feedback efect (350-400ms)
    %biNOsoaPS - diNOsoa ==> simultaneous
    meanOfWindow.d.simultBi = mean(blWin1.biNOsoaPS(:,stimtm1+350:stimtm1+400),2);
    meanOfWindow.d.stimulDi = mean(blWin1.diNOsoa(:,stimtm1+350:stimtm1+400),2);
    diff.d.binoc.idx = (meanOfWindow.d.simultBi - meanOfWindow.d.stimulDi)./(meanOfWindow.d.simultBi + meanOfWindow.d.stimulDi);
    diff.d.binoc.fullAvg = mean(diff.d.binoc.idx);
    diff.d.binoc.ci = bootci(4000,@mean,diff.d.binoc.idx);
   
    % biWsoaPS(post adaptation)-biWsoaPS(post adaptation)
    meanOfWindow.d.flashPS = mean(blWin2.biWsoaPS(:,stimtm2+350:stimtm2+400),2);
    meanOfWindow.d.flashNPS = mean(blWin2.diWsoaPS(:,stimtm2+350:stimtm2+400),2);    
    diff.d.flash.idx = (meanOfWindow.d.flashPS - meanOfWindow.d.flashNPS)./(meanOfWindow.d.flashPS + meanOfWindow.d.flashNPS);
    diff.d.flash.fullAvg = mean(diff.d.flash.idx);
    diff.d.flash.ci = bootci(4000,@mean,diff.d.flash.idx);  
    
  bar_d.data = [diff.d.binoc.fullAvg diff.d.flash.fullAvg];
  bar_d.cilow = [diff.d.binoc.ci(1)  diff.d.flash.ci(1)];
  bar_d.cihigh = [diff.d.binoc.ci(2)  diff.d.flash.ci(2)];  

%% plot postSOA timecourse

x = 1:2;

figure
subplot(1,4,1)
bar(x,bar_a.data)
hold on
era = errorbar(x,bar_a.data,bar_a.cilow,bar_a.cihigh);
set(gca, 'YLim', [-6 6])

subplot(1,4,2)
bar(x,bar_b.data)
hold on
erb = errorbar(x,bar_b.data,bar_b.cilow,bar_b.cihigh);
set(gca, 'YLim', [-6 6])


subplot(1,4,3)
bar(x,bar_c.data)
hold on
erc = errorbar(x,bar_c.data,bar_c.cilow,bar_c.cihigh);
set(gca, 'YLim', [-6 6])


subplot(1,4,4)
bar(x,bar_d.data)
hold on
erd = errorbar(x,bar_d.data,bar_d.cilow,bar_d.cihigh);
set(gca, 'YLim', [-6 6])




