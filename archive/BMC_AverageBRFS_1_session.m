% BMC Average BRFS across session

clear 
close all

%% EDITABLE VARIABLES

baseDir = 'E:\LaCie\all BRFS completed Workspace Variables';
stepDir = 'E:\LaCie\all BRFS completed Workspace Variables\brfs_analyzable';
pre           = 100;
post          = 500;
flag_subtractbasline = true;
flag_halfwaverectify = false;
SinkAllocate = 'BMC';
dateWorkspaceCreated = '.ns2_2019-02-21.mat';

StimAnalyzed = 'dCOS'; % 'dCOS', 'PSbrfs' 'NPSbrfs';

%% 1. Load newSessionParams and create other variables
cd(baseDir)
load('SessionParams.mat')

SAVEALLCSD = nan(8,100,601);
%% 2. Get the Sink to use. 
% BMC allocations are new because the probe may have mobed over the course
% of the day.

switch SinkAllocate
    case 'BMC'
        SessionParams.EvalSink = SessionParams.BMC_ChanNum;
    case 'Old'
        SessionParams.EvalSink = SessionParams.Old_ChanNum;
end

%% 3. Establish the files to get averages for.
cd(stepDir)
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

%% 4. Establish big loop for all files

for i = 1:size(varName,2) %big loop
	clearvars -except SAVEALLCSD dateWorkspaceCreated newSessionParams varName i pre post flag_subtractbasline flag_halfwaverectify   % the saved variables
    
    % 2.a. Load the INFO and LFP for this iteration  
    
    nameINFO	= string(strcat(varName(i).INFO, dateWorkspaceCreated));
    nameLFP     = string(strcat(varName(i).LFP,  dateWorkspaceCreated));
    load(nameINFO); 
    load(nameLFP);
    


    
   % 2.b. get event code times based on the conditional 
  
   switch StimAnalyzed  % 'dCOS', 'PSbrfs' 'NPSbrfs';
        case 'dCOS'
        for gd = 1:size(Grating.stim,1)
            if strcmp('dCOS',Grating.stim(gd)) && Grating.soa(gd) == 0 
                dCOS(tr).trial     = Grating.trial(gd);
                dCOS(tr).timestamp = Grating.timestamp(gd);
                stimtm = round(Grating.timestamp(tr,1)/30) ;% divide by 30 to convert to 1kHz. Note, LFP and MUA already in 1kHZ
                refwin = stimtm-pre:stimtm+post;
                stimLFP(tr,:,:) = LFP(refwin,:); % LFP is (time,chan) stimLFP is (trial,timepoints,chan)
            end
        end            

       case 'PSbrfs'
        for PSbrfs = 1:size(Grating.stim,1)
            if strcmp('dCOS',Grating.stim(PSbrfs)) && Grating.soa(PSbrfs) == 800 && ...
                Grating.s2_tilt(PSbrfs) == PS
                PSbrfs(tr).trial     = Grating.trial(PSbrfs);
                PSbrfs(tr).timestamp = Grating.timestamp(PSbrfs);        
                stimtm = round(EV.B(tr,1)/30) ;% divide by 30 to convert to 1kHz. Note, LFP and MUA already in 1kHZ
                refwin = stimtm-pre:stimtm+post;
                stimLFP(tr,:,:) = LFP(refwin,:); % LFP is (time,chan) stimLFP is (trial,timepoints,chan)                      
            end
        end
        
       case 'NPSbrfs'
           
   end

    % 2.c. average
    avgLFP = squeeze(mean(stimLFP,1)); %avgLFP is (timepoints,chan)


    % 2.d. CSD
    CSD = calcCSD(avgLFP); %CSD is (chan[reduced by 1 on each end],timepionts)
    if flag_subtractbasline
            bl =1:50;
            bl_CSD = mean(CSD(:,bl),2);
            blCSD = (CSD-bl_CSD); 
    end
    if flag_halfwaverectify
        CSD(CSD > 0) = 0;
    end
    CSD = padarray(CSD,[1 0],NaN,'replicate'); %figure out how to get rid of this, (BMC note on 190328)
    
% 2.e. save CSD for each day
    % 2.e.i. find the sinkbtm
        for j = 1:size(newSessionParams.Datestr,1)
      
        pattern = string(newSessionParams.Datestr(j));
        dateFound = strfind(string(varName(i).INFO),pattern);
            if isempty(dateFound) == 0
                idxnewSessionParams = j;
            end
        end
        s = newSessionParams.EvalSink(idxnewSessionParams);
        t = 50-s;
        u = t+32;
    % 2.e.ii. save in Array.
        for k = 1:size(CSD,1)
            SAVEALLCSD(i,t,:) = CSD(k,:); %SAVEALLCSD is (session,aligned-chan,timepoints)
            t = t+1;
        end
     AlignedCSD = permute(SAVEALLCSD,[2,3,1]);
    
end             % end of allFiles loop
   

