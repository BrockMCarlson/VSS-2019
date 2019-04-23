% BMC recursCSD BRFS

clear 
close all

%% EDITABLE VARIABLES
%brfs vs evp
%ns2 vs ns6
ext = '.ns2';
baseDir = 'E:\LaCie\all BRFS completed Workspace Variables\brfs';
cd('E:\LaCie\all BRFS completed Workspace Variables')
load('ALIGN (1).mat')
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
	clearvars -except TuneList varName i reference sinkBtm% the saved variables
    
    nameINFO	= string(strcat(varName(i).INFO,    '.ns2_2019-01-17.mat'));
    nameLFP     = string(strcat(varName(i).LFP,     '.ns2_2019-01-17.mat'));
    load(nameINFO); 
    load(nameLFP);
    
    for j = 1:size(TuneList.Datestr,1)
      
        pattern = string(TuneList.Datestr(j));
        dateFound = strfind(string(varName(i).INFO),pattern);
        if isempty(dateFound) == 0
            idxTuneList = j;
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
    if  strcmp(string(TuneList.SortDirection(idxTuneList)),'ascending')
        reference(i)=TuneList.SinkBtm(idxTuneList);
        sinkBtm(i) = TuneList.SinkBtm(idxTuneList);
    elseif strcmp(string(TuneList.SortDirection(idxTuneList)),'descending')
 
       electrodeLength = size(avgLFP,2);
       reference(i)=TuneList.SinkBtm(idxTuneList);
       sinkBtm(i) = electrodeLength - TuneList.SinkBtm(idxTuneList) + 1; %The plus 1 is to count inclusively
    end
    


end             % end of allFiles loop

