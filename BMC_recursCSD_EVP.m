clear 
close all
% github test
%% EDITABLE VARIABLES
%brfs vs evp
%ns2 vs ns6
searchExpression = '_evp001'; % do brfs001, brfs002, and evp001 and evp002 (check for more?)
ext = '.ns2';
baseDir = 'E:\LaCie\all BRFS completed Workspace Variables\evp';

%% 1. LOOP FILES TO PROCESS 
cd(baseDir)
allFiles = dir(baseDir);
allFiles = allFiles(3:size(allFiles,1));


expressionINFO  = 'INFO\w*';
expressionLFP   = 'LFP\w*';
hCounterINFO = 0;
hCounterLFP = 0;
for h = 1:size(allFiles,1) %split INFO and LFP vars
   
	str = allFiles(h).name;
    if regexp(str,expressionINFO) == 1
        hCounterINFO = hCounterINFO +1;
        varName(hCounterINFO).INFO = regexp(str,expressionINFO,'match');
    elseif regexp(str,expressionLFP) == 1
        hCounterLFP = hCounterLFP +1;
        varName(hCounterLFP).LFP = regexp(str,expressionLFP,'match');
    else
        disp('error in h loop')
    end
    
end

%%

for i = 1:size(varName,2) %big loop
	clear    EV LFP fileForNSx % the saved variables
    
    nameINFO	= string(strcat(varName(i).INFO,    '.ns2_2019-01-08.mat'));
    nameLFP     = string(strcat(varName(i).LFP,     '.ns2_2019-01-08.mat'));
    load(nameINFO); 
    load(nameLFP);
    
    clearvars -except EV LFP fileForNSx varName i

    %% 4. PROCESS
    clear stimLFP
    pre = 100;   % pre-stim time (baseline) in ms
    post = 500; % post-stim time in ms

    % TRIGGER MUA & LFP TO STIM ON
    for tr = 1:length(EV.tp) % trigger to stim-on times for all trials
    % % % %     %%% use for ns6 files
    % % % %     stimtm = round(EV.tp(tr,1)/30) ;% divide by 30 to convert to 1kHz. Note, LFP and MUA already in 1kHZ 

    % % %     %%% use for ns2 files
        stimtm = round(EV.tp(tr,1)/30) ;% divide by 30 to convert to 1kHz. Note, LFP and MUA already in 1kHZ
        refwin = stimtm-pre:stimtm+post;
        stimLFP(tr,:,:) = LFP(refwin,:);
    end

    % COMPUTE AVERAGE ACROSS TRIALS
    avgLFP = squeeze(mean(stimLFP,1));
    avgLFP_elC = avgLFP(:,1:size(avgLFP,2));
    %%%%% 190108 END EDIT HERE.
    %%%%% Must account for different electrode sizes.

    % COMPUTE AVERAGE ACROSS TRIALS
    avgLFP = squeeze(mean(stimLFP,1));
    avgLFP_elC = avgLFP(:,1:24);
    avgLFP_elD = avgLFP(:,25:48);

    tvec = (-pre:post);
    figure(1),cla
    title('161005 elC CSDline');
        for chanC = 1:size(avgLFP_elC,2)
           plC = subplot(24,1,chanC);plot(tvec,avgLFP_elC(:,chanC));vline(0);hline(0);  
        end


        figure(2),
        title('161005 elD CSDline');
        for chanD = 1:size(avgLFP_elD,2)
            subplot(24,1,chanD);plot(tvec,avgLFP_elD(:,chanD));vline(0);hline(0);
        end

    %% Get CSD
    CSD_elC = calcCSD(avgLFP_elC).*0.4; 
    CSD_elD = calcCSD(avgLFP_elD).*0.4;

    bl =1:50;
    bl_CSD_elC = mean(CSD_elC(:,bl),2);
    bl_CSD_elD = mean(CSD_elD(:,bl),2);
    blCSD_elC = (CSD_elC-bl_CSD_elC); 
    blCSD_elD = (CSD_elD-bl_CSD_elD);

    gauss_sigma = 0.1;
    padCSD_elC = padarray(blCSD_elC,[1 0],NaN,'replicate');
    padCSD_elD = padarray(blCSD_elD,[1 0],NaN,'replicate');
    fCSD_elC = filterCSD(padCSD_elC(2:23,:),gauss_sigma);
    fCSD_elD = filterCSD(padCSD_elD(2:24,:),gauss_sigma);

    %% Plot CSD
    tvec = (-pre:post);
    chanvec_elC = linspace(2,23,size(fCSD_elC,2));
    chanvec_elD = linspace(2,24,size(fCSD_elD,2));

    figure(3)
    subplot(1,2,1); 
    imagesc(tvec,chanvec_elC,fCSD_elC);
    colormap(flipud(jet)); colorbar; vline(0);
    mn1 = min(min(fCSD_elC)); mx1 = max(max(fCSD_elC));
    maxval1 = max([abs(mn1) abs(mx1)]);
    caxis([-maxval1 maxval1]);
    title('161007 sinkbtm 15');

    subplot(1,2,2);
    imagesc(tvec,chanvec_elD,fCSD_elD);
    colormap(flipud(jet)); colorbar; vline(0);
    mn2 = min(min(fCSD_elD)); mx2 = max(max(fCSD_elD)); 
    maxval2 = max([abs(mn2) abs(mx2)]);
    caxis([-maxval2 maxval2]);
    title('161007 sinkbtm 16');

% % % 
% % % 
% % %     dateFormatOut = 'yyyy-mm-dd';
% % %     saveDate = datestr(now,dateFormatOut);
% % %     saveName = strcat('fig_CSD_',Filename,'_',saveDate);
% % %     clear dateFormatOut saveDate
% % %     saveas(figure(3),saveName)
% % % 

    % 4. SAVE OUTPUT

            cd(baseDir)
            %Final variable exports are 'EV', 'LFP', 'Unq_cond' 'fileForNSx'
            dateFormatOut = 'yyyy-mm-dd';
            saveDate = datestr(now,dateFormatOut);
            saveNameCSD = strcat('INFOofBRFS','_',fileForNSx(1).name,'_',saveDate);
            saveNameCSD(strcat(saveNameINFO,'.mat'),'EV','fileForNSx');

            saveNameLFP = strcat('LFPofBRFS','_',fileForNSx(1).name,'_',saveDate);
            saveNameCSD(strcat(saveNameLFP,'.mat'),'LFP','-v7.3');

            clear dateFormatOut saveDate
       
end             % end of allFiles loop

        %notification sound
        load gong
        sound(y,Fs)
