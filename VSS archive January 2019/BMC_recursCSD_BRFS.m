% BMC recursCSD BRFS

clear 
close all

%% EDITABLE VARIABLES
%brfs vs evp
%ns2 vs ns6
ext = '.ns2';
baseDir = 'E:\LaCie\all BRFS completed Workspace Variables\brfs';
cd('E:\LaCie\all BRFS completed Workspace Variables')
load('SessionParam.mat')
SessionParam.EvalSink = SessionParam.BMC_ChanNum;
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
	clearvars -except SessionParam varName i % the saved variables
    
    nameINFO	= string(strcat(varName(i).INFO,    '.ns2_2019-01-17.mat'));
    nameLFP     = string(strcat(varName(i).LFP,     '.ns2_2019-01-17.mat'));
    load(nameINFO); 
    load(nameLFP);
    
    for j = 1:size(SessionParam.Datestr,1)
      
        pattern = string(SessionParam.Datestr(j));
        dateFound = strfind(string(varName(i).INFO),pattern);
        if isempty(dateFound) == 0
            idxSessionParam = j;
        end
    end
    
   

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
    %   190109 NOTE: must account for different electrode sizes
    if size(LFP,2) == 48
        disp(strcat(fileForNSx.name,'......','two electrodes for this day.'))
        continue
    elseif size(LFP,2) <= 32 
        avgLFP = squeeze(mean(stimLFP,1));
    else
        disp('error, check electrode split condition')
    end
    
    % account for direction of electrode. If it is descending (like on the
    % NeuroNexus arrays, typically 32 chan) then the direction of the
    % channels along avgLFP's second dimension must be fliped so the
    % figures line up.
    if  strcmp(string(SessionParam.SortDirection(idxSessionParam)),'ascending')
        sinkBtm = SessionParam.EvalSink(idxSessionParam);
    elseif strcmp(string(SessionParam.SortDirection(idxSessionParam)),'descending')
       avgLFP = flip(avgLFP,2);
       electrodeLength = size(avgLFP,2);
       sinkBtm = electrodeLength - SessionParam.EvalSink(idxSessionParam) + 1; %The plus 1 is to count inclusively
    end
    
    %% Get CSD
    CSD = calcCSD(avgLFP).*0.4; 
    
    %% Plot CSD Line
    tvec = (-pre:post);
    figure(1),cla
        for chan = 1:size(CSD,1)
           plC = subplot(size(CSD,1),1,chan);
           plot(tvec,avgLFP(:,chan));
           vline(0);hline(0);
           if chan ==1
                  title(strcat(string(SessionParam.Datestr(idxSessionParam)),' BRFS CSD Line sinkBtm =',string(sinkBtm)));
           end
        end

    FIG1 = gcf;

    %%
    bl =1:50;
    bl_CSD = mean(CSD(:,bl),2);
    blCSD = (CSD-bl_CSD); 


    gauss_sigma = 0.1;
    padCSD = padarray(blCSD,[1 0],NaN,'replicate');
    fCSD = filterCSD(padCSD,gauss_sigma);


    %% Plot CSD
    tvec = (-pre:post);
    chanvec = linspace(1,size(padCSD,1),size(fCSD,2));

    figure(2)
    imagesc(tvec,chanvec,fCSD);
    colormap(flipud(jet)); colorbar; vline(0); hline(sinkBtm);
    mn1 = min(min(fCSD)); mx1 = max(max(fCSD));
    maxval1 = max([abs(mn1) abs(mx1)]);
    caxis([-maxval1 maxval1]);
    title(strcat(string(SessionParam.Datestr(idxSessionParam)),' BRFS CSD filt sinkBtm =',string(sinkBtm)));
    
    FIG2 = gcf;


    % 4. SAVE OUTPUT
        cd('E:\LaCie\all BRFS completed Workspace Variables\brfsSinkFigs')
        saveas(FIG1,strcat(string(SessionParam.Datestr(idxSessionParam)),'_BRFS_CSD_Line'),'jpeg')
        saveas(FIG2,strcat(string(SessionParam.Datestr(idxSessionParam)),'_BRFS_CSD_filt'),'jpeg')
  
        close all

end             % end of allFiles loop

        %notification sound
        load gong
        sound(y,Fs)
