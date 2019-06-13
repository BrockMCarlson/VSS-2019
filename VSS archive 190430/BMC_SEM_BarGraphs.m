% BMC_SEM_Bargraphs

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


%% Sink average
cutACE.biNOsoaPS	= biNOsoaPS.ACE(38:55,:);
cutACE.diNOsoa      = diNOsoa.ACE(38:55,:);  
cutACE.biWsoaPS     = biWsoaPS.ACE(38:55,:); 
cutACE.diWsoaPS     = diWsoaPS.ACE(38:55,:);

sinkAvg.biNOsoaPS	= mean(cutACE.biNOsoaPS(12:13,:),1);
sinkAvg.diNOsoa     = mean(cutACE.diNOsoa(12:13,:),1);  
sinkAvg.biWsoaPS	= mean(cutACE.biWsoaPS(12:13,:),1); 
sinkAvg.diWsoaPS     = mean(cutACE.diWsoaPS(12:13,:),1);

barAvg = nan(4,4,3); %(timepoint,condition,plus/avg/min)
barAvg(1,1,2) = abs(mean(sinkAvg.biNOsoaPS(1,pre+50:pre+150)));
barAvg(1,2,2) = abs(mean(sinkAvg.diNOsoa(1,pre+50:pre+150)));
barAvg(1,3,2) = abs(mean(sinkAvg.biWsoaPS(1,pre+50:pre+150)));
barAvg(1,4,2) = abs(mean(sinkAvg.diWsoaPS(1,pre+50:pre+150)));

barAvg(2,1,2) = abs(mean(sinkAvg.biNOsoaPS(1,pre+600:pre+700)));
barAvg(2,2,2) = abs(mean(sinkAvg.diNOsoa(1,pre+600:pre+700)));
barAvg(2,3,2) = abs(mean(sinkAvg.biWsoaPS(1,pre+600:pre+700)));
barAvg(2,4,2) = abs(mean(sinkAvg.diWsoaPS(1,pre+600:pre+700)));

barAvg(3,1,2) = abs(mean(sinkAvg.biNOsoaPS(1,pre+850:pre+950)));
barAvg(3,2,2) = abs(mean(sinkAvg.diNOsoa(1,pre+850:pre+950)));
barAvg(3,3,2) = abs(mean(sinkAvg.biWsoaPS(1,pre+850:pre+950)));
barAvg(3,4,2) = abs(mean(sinkAvg.diWsoaPS(1,pre+850:pre+950)));

barAvg(4,1,2) = abs(mean(sinkAvg.biNOsoaPS(1,pre+1400:pre+1500)));
barAvg(4,2,2) = abs(mean(sinkAvg.diNOsoa(1,pre+1400:pre+1500)));
barAvg(4,3,2) = abs(mean(sinkAvg.biWsoaPS(1,pre+1400:pre+1500)));
barAvg(4,4,2) = abs(mean(sinkAvg.diWsoaPS(1,pre+1400:pre+1500)));

%SEM
sinkstd = nan(4,4); %(timepoint, condition)
sinkstd(1,1) = std(sinkAvgAllCSDaligned.biNOsoaPS(1,pre+50:pre+150));
sinkstd(1,2) = std(sinkAvgAllCSDaligned.diNOsoa(1,pre+50:pre+150));
sinkstd(1,3) = std(sinkAvgAllCSDaligned.biWsoaPS(1,pre+50:pre+150));
sinkstd(1,4) = std(sinkAvgAllCSDaligned.diWsoaPS(1,pre+50:pre+150));

sinkstd(2,1) = std(sinkAvgAllCSDaligned.biNOsoaPS(1,pre+600:pre+700));
sinkstd(2,2) = std(sinkAvgAllCSDaligned.diNOsoa(1,pre+600:pre+700));
sinkstd(2,3) = std(sinkAvgAllCSDaligned.biWsoaPS(1,pre+600:pre+700));
sinkstd(2,4) = std(sinkAvgAllCSDaligned.diWsoaPS(1,pre+600:pre+700));

sinkstd(3,1) = std(sinkAvgAllCSDaligned.biNOsoaPS(1,pre+850:pre+950));
sinkstd(3,2) = std(sinkAvgAllCSDaligned.diNOsoa(1,pre+850:pre+950));
sinkstd(3,3) = std(sinkAvgAllCSDaligned.biWsoaPS(1,pre+850:pre+950));
sinkstd(3,4) = std(sinkAvgAllCSDaligned.diWsoaPS(1,pre+850:pre+950));

sinkstd(4,1) = std(sinkAvgAllCSDaligned.biNOsoaPS(1,pre+1400:pre+1500));
sinkstd(4,2) = std(sinkAvgAllCSDaligned.diNOsoa(1,pre+1400:pre+1500));
sinkstd(4,3) = std(sinkAvgAllCSDaligned.biWsoaPS(1,pre+1400:pre+1500));
sinkstd(4,4) = std(sinkAvgAllCSDaligned.diWsoaPS(1,pre+1400:pre+1500));

%(+)   (timepoint,condition,plus/avg/min) vs (timepoint, condition)
barAvg(1,1,1) = barAvg(1,1,2) + (sinkstd(1,1)/sqrt(8));
barAvg(1,2,1) = barAvg(1,2,2) + (sinkstd(1,2)/sqrt(8));
barAvg(1,3,1) = barAvg(1,3,2) + (sinkstd(1,3)/sqrt(8));
barAvg(1,4,1) = barAvg(1,4,2) + (sinkstd(1,4)/sqrt(8));

barAvg(2,1,1) = barAvg(2,1,2) + (sinkstd(2,1)/sqrt(8));
barAvg(2,2,1) = barAvg(2,2,2) + (sinkstd(2,2)/sqrt(8));
barAvg(2,3,1) = barAvg(2,3,2) + (sinkstd(2,3)/sqrt(8));
barAvg(2,4,1) = barAvg(2,4,2) + (sinkstd(2,4)/sqrt(8));

barAvg(3,1,1) = barAvg(3,1,2) + (sinkstd(3,1)/sqrt(8));
barAvg(3,2,1) = barAvg(3,2,2) + (sinkstd(3,2)/sqrt(8));
barAvg(3,3,1) = barAvg(3,3,2) + (sinkstd(3,3)/sqrt(8));
barAvg(3,4,1) = barAvg(3,4,2) + (sinkstd(3,4)/sqrt(8));

barAvg(4,1,1) = barAvg(4,1,2) + (sinkstd(4,1)/sqrt(8));
barAvg(4,2,1) = barAvg(4,2,2) + (sinkstd(4,2)/sqrt(8));
barAvg(4,3,1) = barAvg(4,3,2) + (sinkstd(4,3)/sqrt(8));
barAvg(4,4,1) = barAvg(4,4,2) + (sinkstd(4,4)/sqrt(8));
%  (-)
barAvg(1,1,3) = barAvg(1,1,2) - (sinkstd(1,1)/sqrt(8));
barAvg(1,2,3) = barAvg(1,2,2) - (sinkstd(1,2)/sqrt(8));
barAvg(1,3,3) = barAvg(1,3,2) - (sinkstd(1,3)/sqrt(8));
barAvg(1,4,3) = barAvg(1,4,2) - (sinkstd(1,4)/sqrt(8));

barAvg(2,1,3) = barAvg(2,1,2) - (sinkstd(2,1)/sqrt(8));
barAvg(2,2,3) = barAvg(2,2,2) - (sinkstd(2,2)/sqrt(8));
barAvg(2,3,3) = barAvg(2,3,2) - (sinkstd(2,3)/sqrt(8));
barAvg(2,4,3) = barAvg(2,4,2) - (sinkstd(2,4)/sqrt(8));

barAvg(3,1,3) = barAvg(3,1,2) - (sinkstd(3,1)/sqrt(8));
barAvg(3,2,3) = barAvg(3,2,2) - (sinkstd(3,2)/sqrt(8));
barAvg(3,3,3) = barAvg(3,3,2) - (sinkstd(3,3)/sqrt(8));
barAvg(3,4,3) = barAvg(3,4,2) - (sinkstd(3,4)/sqrt(8));

barAvg(4,1,3) = barAvg(4,1,2) - (sinkstd(4,1)/sqrt(8));
barAvg(4,2,3) = barAvg(4,2,2) - (sinkstd(4,2)/sqrt(8));
barAvg(4,3,3) = barAvg(4,3,2) - (sinkstd(4,3)/sqrt(8));
barAvg(4,4,3) = barAvg(4,4,2) - (sinkstd(4,4)/sqrt(8));




%% plot
x= [1,2,3,4];
figure
bar(x,barAvg(1,:,2));
hold on
bar1 = errorbar(x,barAvg(1,:,2),barAvg(1,:,3),barAvg(1,:,1));

figure
bar2 = bar(barAvg(2,:,2));





