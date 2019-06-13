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
dateWorkspaceCreated = '.ns2_2019-01-17.mat';

StimAnalyzed = 'NPSbrfs'; % 'dCOS', 'PSbrfs' 'NPSbrfs';

%% 1. Load SessionParams and create other variables
cd(baseDir)
load('SessionParams.mat')
load('Cond.mat')

switch StimAnalyzed
    case 'dCOS'
        for c = 1:1:16
            Cond(c).EvalCond = Cond(c).dCOS;
            TimePoint = 1;
        end
    case 'PSbrfs'
        for c = 1:1:16
            Cond(c).EvalCond = Cond(c).PS;
            TimePoint = 2;
        end
    case 'NPSbrfs'
        for c = 1:1:16
            Cond(c).EvalCond = Cond(c).NPS;
            TimePoint = 2;
        end
end

SAVEALLCSD = nan(16,100,601);
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
allFiles = dir(stepDir);
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
	clearvars -except AlignedCSD test TimePoint Cond SAVEALLCSD dateWorkspaceCreated SessionParams varName i pre post flag_subtractbasline flag_halfwaverectify   % the saved variables
    
    % 2.a. Load the INFO and LFP for this iteration  
    
    nameINFO	= string(strcat(varName(i).INFO, dateWorkspaceCreated));
    nameLFP     = string(strcat(varName(i).LFP,  dateWorkspaceCreated));
    load(nameINFO); 
    load(nameLFP);
    


    
   % 2.b. index from Cond and SessionParams
    for j = 1:size(SessionParams.Date,1)
    pattern = string(SessionParams.Date(j));
    dateFound = strfind(string(varName(i).INFO),pattern);
        if isempty(dateFound) == 0
            idxSessionParams = j;
        end
    end
    
    for k = 1:size(Cond,2)
    pattern = string(Cond(1,k).Date);
    dateFound = strfind(string(varName(i).INFO),pattern);
        if isempty(dateFound) == 0
            idxCond = k;
        end
    end

   if isstruct(Cond(idxCond).EvalCond) == 0  
    continue 
   end

   

   for m = 1:size(Cond(idxCond).EvalCond,2)
    if Cond(idxCond).EvalCond(m).s1_contrast >= .8 && Cond(idxCond).EvalCond(m).s2_contrast >= .8
        stimtm = round(Cond(idxCond).EvalCond(m).EventTime(TimePoint)/30) ;% divide by 30 to convert to 1kHz. Note, LFP and MUA already in 1kHZ
        refwin = stimtm-pre:stimtm+post;
        stimLFP(m,:,:) = LFP(refwin,:); % LFP is (time,chan) stimLFP is (trial,timepoints,chan)     
    end
   end

   

    % 2.c. average
    avgLFP = squeeze(mean(stimLFP,1)); %avgLFP is (timepoints,chan)


    % 2.d. CSD Always before trial average
    CSD = calcCSD(avgLFP); %CSD is (chan[reduced by 1 on each end],timepionts)
    if flag_subtractbasline % always after you average.
        bl =1:50;
        for b = 1:size(CSD,1)
            bl_CSD = mean(CSD(b,bl),2);
            blCSD(b,:) = (CSD(b,:)-bl_CSD); 
        end
    end
    if flag_halfwaverectify
        CSD(CSD > 0) = 0;
    end
    CSD = padarray(CSD,[1 0],NaN,'replicate'); %figure out how to get rid of this, (BMC note on 190328)
    
    % 2.e. save CSD for each day
    % 2.e.i. find the sinkbtm
    switch SessionParams.SortDirection(idxSessionParams)
        case  'ascending' % probably dont need this.
            s = SessionParams.EvalSink(idxSessionParams);
            t = 50+s;
            u = t-24;
            % 2.e.ii. save in Array.
            for n = 1:size(CSD,1)
                SAVEALLCSD(i,t,:) = CSD(n,:); %SAVEALLCSD is (session,aligned-chan,timepoints)
                t = t-1;
            end
            
        case 'descending'
            s = SessionParams.EvalSink(idxSessionParams);
            t = 50-s;
            u = t+32;
            % 2.e.ii. save in Array.
            for n = 1:size(CSD,1)
                SAVEALLCSD(i,t,:) = CSD(n,:); %SAVEALLCSD is (session,aligned-chan,timepoints)
                t = t+1;
            end
        
    end
end             % end of allFiles loop
   
  AlignedCSD = permute(SAVEALLCSD,[2,3,1]);
