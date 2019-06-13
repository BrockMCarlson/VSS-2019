% BMC_SEM
clear
close all

pre = 100;
post = 1600;
TM = [-pre:1:post];

cd('E:\LaCie\VSS 2019 figs\190424 extended time CSDs\extended time matlab variables')
    biNOsoaPS	= load('biNOsoaPS_full time course_8sessionMatch.mat');
    diNOsoa     = load('dicopNOsoa_full time course_8sessionMatch.mat');

    biWsoaPS    = load('biWsoaPS_full time course_8sessionMatch.mat');
    diWsoaPS    = load('dichopWsoa_fullTrialPS_full time course_8sessionMatch.mat');

cutAllCSDaligned.biNOsoaPS	= biNOsoaPS.AllCSDaligned(38:55,:,:);
cutAllCSDaligned.diNOsoa      = diNOsoa.AllCSDaligned(38:55,:,:);  
cutAllCSDaligned.biWsoaPS     = biWsoaPS.AllCSDaligned(38:55,:,:); 
cutAllCSDaligned.diWsoaPS     = diWsoaPS.AllCSDaligned(38:55,:,:);

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

sinkACEsdf.biNOsoaPS = std(sinkAvgAllCSDaligned.biNOsoaPS);
sinkACEsdf.diNOsoa = std(sinkAvgAllCSDaligned.diNOsoa);
sinkACEsdf.biWsoaPS = std(sinkAvgAllCSDaligned.biWsoaPS);
sinkACEsdf.diWsoaPS = std(sinkAvgAllCSDaligned.diWsoaPS);

sinkACEsem.biNOsoaPS = sinkACEsdf.biNOsoaPS/sqrt(size(sinkAvgAllCSDaligned.biNOsoaPS,1));
sinkACEsem.diNOsoa = sinkACEsdf.diNOsoa/sqrt(size(sinkAvgAllCSDaligned.diNOsoa,1));
sinkACEsem.biWsoaPS = sinkACEsdf.biWsoaPS/sqrt(size(sinkAvgAllCSDaligned.biWsoaPS,1));
sinkACEsem.diWsoaPS = sinkACEsdf.diWsoaPS/sqrt(size(sinkAvgAllCSDaligned.diWsoaPS,1));



%% Sink average
cutACE.biNOsoaPS	= biNOsoaPS.ACE(38:55,:);
cutACE.diNOsoa      = diNOsoa.ACE(38:55,:);  
cutACE.biWsoaPS     = biWsoaPS.ACE(38:55,:); 
cutACE.diWsoaPS     = diWsoaPS.ACE(38:55,:);

sinkAvg.biNOsoaPS	= mean(cutACE.biNOsoaPS(12:13,:),1);
sinkAvg.diNOsoa     = mean(cutACE.diNOsoa(12:13,:),1);  
sinkAvg.biWsoaPS	= mean(cutACE.biWsoaPS(12:13,:),1); 
sinkAvg.diWsoaPS     = mean(cutACE.diWsoaPS(12:13,:),1);

sinkACEsem.plus.biNOsoaPS = sinkAvg.biNOsoaPS+sinkACEsem.biNOsoaPS;
sinkACEsem.plus.diNOsoa = sinkAvg.diNOsoa+sinkACEsem.diNOsoa;
sinkACEsem.plus.biWsoaPS = sinkAvg.biWsoaPS+sinkACEsem.biWsoaPS;
sinkACEsem.plus.diWsoaPS = sinkAvg.diWsoaPS+sinkACEsem.diWsoaPS;

sinkACEsem.minus.biNOsoaPS = sinkAvg.biNOsoaPS-sinkACEsem.biNOsoaPS;
sinkACEsem.minus.diNOsoa = sinkAvg.diNOsoa-sinkACEsem.diNOsoa;
sinkACEsem.minus.biWsoaPS = sinkAvg.biWsoaPS-sinkACEsem.biWsoaPS;
sinkACEsem.minus.diWsoaPS = sinkAvg.diWsoaPS-sinkACEsem.diWsoaPS;

%% Plot 

clrA = [194,165,207]/255;
clrB = [166,219,160]/255;
clrC = [123,50,148]/255 ;
clrD = [0,136,55]/255;

figure
    a = plot(TM,sinkAvg.biNOsoaPS,'color',clrA,'LineWidth',1,'DisplayName','biNOsoaPS');
    hold on
    plot(TM,sinkACEsem.plus.biNOsoaPS,':','color',clrA,'LineWidth',.3)
    hold on
    plot(TM,sinkACEsem.minus.biNOsoaPS,':','color',clrA,'LineWidth',.3)
    hold on
   
    b = plot(TM,sinkAvg.diNOsoa,'color',clrB,'LineWidth',1,'DisplayName','diNOsoa');
    hold on
    plot(TM,sinkACEsem.plus.diNOsoa,':','color',clrB,'LineWidth',.3)
    hold on
    plot(TM,sinkACEsem.minus.diNOsoa,':','color',clrB,'LineWidth',.3)
    hold on

    c = plot(TM,sinkAvg.biWsoaPS,'color',clrC,'LineWidth',1,'DisplayName','biWsoaPS');
    hold on
    plot(TM,sinkACEsem.plus.biWsoaPS,':','color',clrC,'LineWidth',.3)
    hold on
    plot(TM,sinkACEsem.minus.biWsoaPS,':','color',clrC,'LineWidth',.3)
    hold on

    d = plot(TM,sinkAvg.diWsoaPS,'color',clrD,'LineWidth',1,'DisplayName','diWsoaPS');
    hold on
    plot(TM,sinkACEsem.plus.diWsoaPS,':','color',clrD,'LineWidth',.3)
    hold on
    plot(TM,sinkACEsem.minus.diWsoaPS,':','color',clrD,'LineWidth',.3)
    hold on
    
    vline(0)
    hline(0)
    vline(800)
    subset = [a b c d];
    legend(subset,'Location','best')
    title('CSD of sinkAvg. Cortical depth of 0 and 0.1 averaged')
    set(gca,'TickDir','out');
    set(gca,'Box','off')
