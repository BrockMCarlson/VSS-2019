%% BMC_CheckAllCSDSinkBtm
clear
close all

%% 1. Editable Variables
condition = 'dicopNOsoa'; %'biPS','biNPS','dichopWsoa_NPSadapt&PSflash','dicopNOsoa', 'dicopWsoa_PSflash', 'dicopWsoa_NPSflash'
savetitle = strcat(condition,'_full time course');
pre = 100;
post = 1600;
sinkAllocate = 'BMC_DfS'; %'BMC_DfS','BMC_ChanNum','Old_DfS','Old_ChanNum'
baseDirectory = 'E:\LaCie';
stepDirectory = 'E:\LaCie\all BRFS';


%% 2. Load SessionParams AND establish EvalSink. (or anything else in SessionParams)
cd(baseDirectory)
load('SessionParams.mat')
switch sinkAllocate
    case 'BMC_DfS'
        SessionParams.EvalSink = SessionParams.BMC_DfS;
    case 'Old_DfS'
        SessionParams.EvalSink = SessionParams.Old_DfS;
    case 'BMC_ChanNum'
        SessionParams.EvalSink = SessionParams.BMC_ChanNum;
    case 'Old_ChanNum'
        SessionParams.EvalSink = SessionParams.Old_ChanNum;
end

%% 3. Loop through available sessions for selected condition
cd(stepDirectory)
allfolders = dir(stepDirectory);
allfolders = allfolders(3:size(allfolders,1)); % cuts out the first two Dir outputs. Unnecessary '.' and '..'



% 3.a. establish recursive loop
    % 3.a.i. get the SessionParams data down to the conditions for each sessionDay 
    count = 0;
    switch condition
        case 'dicopNOsoa'
            for x = 1:size(SessionParams.dCOSexist,1)
                if SessionParams.dCOSexist(x)
                    count = count+1;
                    SessionParamsForCondition.Date(count,1) = SessionParams.Date(x);
                    SessionParamsForCondition.el(count,1)   = SessionParams.el(x);
                    SessionParamsForCondition.sortdirection(count,1) = SessionParams.SortDirection(x);
                    SessionParamsForCondition.EvalSink(count,1) = SessionParams.EvalSink(x);
                    SessionParamsForCondition.PS(count,1) = SessionParams.PS(x);
                    SessionParamsForCondition.NPS(count,1) = SessionParams.NPS(x);
                end
            end   
        case 'dicopWsoa_PSflash'
            for x = 1:size(SessionParams.PSexist,1)
                if SessionParams.PSexist(x)
                    count = count+1;
                    SessionParamsForCondition.Date(count,1) = SessionParams.Date(x);
                    SessionParamsForCondition.el(count,1)   = SessionParams.el(x);
                    SessionParamsForCondition.sortdirection(count,1) = SessionParams.SortDirection(x);
                    SessionParamsForCondition.EvalSink(count,1) = SessionParams.EvalSink(x);
                    SessionParamsForCondition.PS(count,1) = SessionParams.PS(x);
                    SessionParamsForCondition.NPS(count,1) = SessionParams.NPS(x);                    
                end
            end 
        case 'dicopWsoa_NPSflash'
            for x = 1:size(SessionParams.NPSexist,1)
                if SessionParams.NPSexist(x) && ~eq(SessionParams.Date(x),[151231])
                    count = count+1;
                    SessionParamsForCondition.Date(count,1) = SessionParams.Date(x);
                    SessionParamsForCondition.el(count,1)   = SessionParams.el(x);
                    SessionParamsForCondition.sortdirection(count,1) = SessionParams.SortDirection(x);
                    SessionParamsForCondition.EvalSink(count,1) = SessionParams.EvalSink(x);
                    SessionParamsForCondition.PS(count,1) = SessionParams.PS(x);
                    SessionParamsForCondition.NPS(count,1) = SessionParams.NPS(x);                    
                end
            end 
    end
    
    % 3.a.ii. Full Loop for each condition
timerange = [-pre:post];
AllCSDaligned(:,:,:) = nan(100,[size(timerange,2)],[size(SessionParamsForCondition.Date,1)]);

for a = 1:size(SessionParamsForCondition.Date,1) %big loop
    clearvars -except savetitle AllCSDaligned a allfolders condition pre post SessionParamsForCondition 
    
% 3.b. enter folder
for b = 1:size(allfolders,1)
    folderFound = strfind(allfolders(b).name,string(SessionParamsForCondition.Date(a)));
    if ~isempty(folderFound)
       sessionDay = strcat(allfolders(b).folder,filesep,allfolders(b).name,filesep);
       filenameGrating = strcat(allfolders(b).name,'_brfs001.gBrfsGratings');
       filenameNEV = strcat(allfolders(b).name,'_brfs001.nev');
       filenameNs2 = strcat(allfolders(b).name,'_brfs001'); % no extension b/c added on getLFP ==> ??
    end
end
cd(sessionDay)

% 3.c. load grating, NEV, 
    % 3.c.i. load grating
        grating = readBRFS(filenameGrating);
    % 3.c.ii. load NEV
        NEV = openNEV(filenameNEV,'noread','nomat','nosave'); 
        EventCodes = NEV.Data.SerialDigitalIO.UnparsedData - 128;
        EventTimes = double(NEV.Data.SerialDigitalIO.TimeStamp); 
        evtFs = double(NEV.MetaTags.SampleRes);
        [pEvC,pEvT] = parsEventCodesML(EventCodes,EventTimes);

% 3.d. get LFP for full session day (Channels x timepoints)
[xLFP,EventCodes,EventTimes] = getLFP(filenameNs2,'ns2','eD',SessionParamsForCondition.sortdirection(a),sessionDay);
LFP = xLFP'; %(Channels x tiempoints)

% 3.e. stimLFP (ConditionTrial x chan x timepoints)
%   if dicopNOsoa start_nosoa, if dicopWsoa_PSflash or dicopWsoa_NPSflash, start2.
%   MAJOR CONDITIONAL STATEMENT HERE. CALL FROM SESSIONPARAMS FOR PS/NPS
conditioncount = 0; 
clear gratingOnsets
switch condition
         case 'dicopNOsoa'
           for  e = 1:length(pEvC)
             if strcmp('dCOS',grating.stim(e))           && ... 
                    grating.soa(e)          ==  0       && ...
                    grating.s1_contrast(e)  >=  .8      && ...
                    grating.s2_contrast(e)  >=  .8
                if ~any(pEvC{e} == 96) 
                     continue
                end     
                stimon   =  pEvC{e} == 23;
                stimoff  =  pEvC{e} == 24;
                idx = find(stimon);
                if      numel(idx) == 1     % there is no soa.
                    start_noSoa  =  pEvT{e}(idx); 
                else
                    disp('error, please check idx loop')
                end
                stop    =  pEvT{e}(stimoff);
            	conditioncount = conditioncount +1;
                gratingOnsets(conditioncount,:) = [start_noSoa stop];
             end
            column = 1;  
           end
         case 'dicopWsoa_PSflash'
           for  e = 1:length(pEvC)
            if strcmp('dCOS',grating.stim(e))           && ... 
                    grating.soa(e)          ==  800     && ...
                    grating.s1_contrast(e)  >=  .8      && ...
                    grating.s2_contrast(e)  >=  .8      && ...
                    grating.s2_tilt(e)      ==  SessionParamsForCondition.PS(a)
                if ~any(pEvC{e} == 96) 
                     continue
                end     
                stimon   =  pEvC{e} == 23;
                stimoff  =  pEvC{e} == 24;
                idx = find(stimon);
                if	numel(idx) == 2     %there is indeed soa
                	start1  =  pEvT{e}(idx(1));
                	start2  =  pEvT{e}(idx(2));
                else
                    disp('error, please check idx loop')
                end
                stop    =  pEvT{e}(stimoff);
            	conditioncount = conditioncount +1;
                gratingOnsets(conditioncount,:) = [start1 start2 stop];
            end
            column = 2;  
           end
         case 'dicopWsoa_NPSflash'
           for  e = 1:length(pEvC)
            if strcmp('dCOS',grating.stim(e))           && ... 
                    grating.soa(e)          ==  800     && ...
                    grating.s1_contrast(e)  >=  .8      && ...
                    grating.s2_contrast(e)  >=  .8      && ...
                    grating.s2_tilt(e)      ==  SessionParamsForCondition.NPS(a)
                if ~any(pEvC{e} == 96) 
                     continue
                end     
                stimon   =  pEvC{e} == 23;
                stimoff  =  pEvC{e} == 24;
                idx = find(stimon);
                if	numel(idx) == 2     %there is indeed soa
                	start1  =  pEvT{e}(idx(1));
                	start2  =  pEvT{e}(idx(2));
                else
                    disp('error, please check idx loop')
                end
                stop    =  pEvT{e}(stimoff);
            	conditioncount = conditioncount +1;
                gratingOnsets(conditioncount,:) = [start1 start2 stop];
            end
            column = 2;   
           end
end

for y = 1:size(gratingOnsets,1)
    stimtm = round(gratingOnsets(y,column)/30);% divide by 30 to convert to 1kHz. Note, LFP already in 1kHZ
    refwin = stimtm-pre:stimtm+post;
    stimLFP(y,:,:) = LFP(:,refwin); % LFP is (chan x timepoints) stimLFP is (ConditionTrial x chan x timepoints)     

end

% 3.f. calcCSD (ConditionTrials x Chan x timepoints)
transLFP = permute(stimLFP,[1,3,2]); % flip for the correct calcCSD dimension
 for f = 1:size(transLFP,1)
     oneSessionLFP(:,:) = transLFP(f,:,:);
    CSD(f,:,:) = calcCSD(oneSessionLFP); %CSD is (chan[reduced by 1 on each end],timepionts)
 end
 
 % 3.g. Average CSD across trials (Chan x timepoints)
avgCSD = squeeze(nanmean(CSD,1));

% 3.h. baseline subtract (Chan x timepoints)
bl = pre-50:pre-1;
for h = 1:size(avgCSD,1)
    blofChan = nanmean(avgCSD(h,bl),2);
    blCSD(h,:) = (avgCSD(h,:)-blofChan); 
end

% 3.i. Align CSD outputs
sinkindex = SessionParamsForCondition.EvalSink(a);
alignedMatrixIndex = 50-sinkindex+1+1; %needs +1 so it is an inclusive count, and another +1 to account for the fact that the index was set up for padded arrays.
for n = 1:size(blCSD,1)
    AllCSDaligned(alignedMatrixIndex,:,a) = blCSD(n,:); %SAVEALLCSD is (session,aligned-chan,timepoints)
    alignedMatrixIndex = alignedMatrixIndex+1;
end


end %end of 'a' loop, #BigLoop.
clearvars -except savetitle AllCSDaligned a allfolders condition pre post SessionParamsForCondition 

% 5. Average CSD Effect (ACE)
ACE = squeeze(nanmean(AllCSDaligned,3));

cd('E:\LaCie\VSS 2019 figs\190424 extended time CSDs\extended time matlab variables')
save(strcat(savetitle,'.mat'))