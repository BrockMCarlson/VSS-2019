% BMC getAllBRFSstartTimes

clear 
close all

%% EDITABLE VARIABLES
searchExpression = '_brfs001'; % do brfs001, brfs002, and evp001 and evp002 (check for more?)
ext = '.ns2';
baseDir = 'E:\LaCie\all BRFS';

%% Load necessary files
cd('E:\LaCie\all BRFS completed Workspace Variables')
load('SessionParams.mat')


%%  LOOP FILES TO PROCESS 
cd(baseDir)
allFiles = dir(baseDir);
allFiles = allFiles(3:size(allFiles,1));
for i = 1:size(allFiles,1) %big loop
    disp(i)
% 1. Step directory    
clear   fileForNSx % the saved variables
stepDir = strcat(baseDir,filesep,allFiles(i).name);
cd(stepDir)
      
% 2. READ NEV
fileForNEV = dir(strcat('*',searchExpression,'*','.nev'));
    if ~size(fileForNEV,1) == 1 % makes sure desired the file is a usable brfs day
        continue
    end
NEV = openNEV(fileForNEV(1).name,'noread','nomat','nosave'); %check NPMK version info
EventCodes = NEV.Data.SerialDigitalIO.UnparsedData - 128;
EventTimes = double(NEV.Data.SerialDigitalIO.TimeStamp); 
evtFs = double(NEV.MetaTags.SampleRes);
[pEvC,pEvT] = parsEventCodesML(EventCodes,EventTimes);


% 3. Get Grating, PS and NPS
fileForGrating = dir(strcat('*',searchExpression,'*','.gBrfsGratings'));
Grating = readBRFS(fileForGrating(1).name);

    for j = 1:size(SessionParams.Date,1)
        pattern = string(SessionParams.Date(j));
        dateFound = strfind(string(fileForNEV.name),pattern);
            if isempty(dateFound) == 0
                idxSessionParams = j;
            end
    end
    
    if ~exist('idxSessionParams','var') % makes sure desired the file is a usable brfs day
        continue
    end
	PS = SessionParams.PS(idxSessionParams);
    NPS = SessionParams.NPS(idxSessionParams);
    
% 4. Get times from NEV based on trialnumber and the conditions allocated
% in the Grating variable
dCOScond = 0;
PScond = 0;
NPScond = 0;
for tr = 1:length(pEvC) %length of all NEV event codes

    % 4.a. get rid of trials where animal was not rewarded.
    if ~any(pEvC{tr} == 96) 
        continue
    end     

    % 4.b. Find stimulus on and off times
    stimon   =  pEvC{tr} == 23;
    stimoff  =  pEvC{tr} == 24;

    % 4.c. Use number of onset times to indicate start and stop times.
    % NOTE: this could also be used to determine if conditions are split
    % into dCOS or PS/NPS at this point. However, I don't trust this and
    % would rather use the output from the Grating file. I trust that
    % indicator more, and it is more flexible for future use. --BMC 4/9/19
    idx = find(stimon);
    if      numel(idx) == 1     % there is no soa.
        start_noSoa  =  pEvT{tr}(idx); 
    elseif  numel(idx) == 2     %there is indeed soa
        start1  =  pEvT{tr}(idx(1));
        start2  =  pEvT{tr}(idx(2));
    else
        disp('error, please check idx loop')
    end
    stop    =  pEvT{tr}(stimoff);

    % 4.d. Use the logicals from the Grating variable determine condition.
    % NOTE: Grating and the NEV are both indexing based on the trial
    % number, as their onset times are off. Use Grating to figure out the
    % type of trial, and use the NEV to get the approiate trigger times.
    
    % 4.d.dCOS condition. This is essentially when there is conflict
    % between the eyes but no stimulus onset asynchrony. There is no
    % restriction based on eye, so the true stimulus presented on the
    % screen is not determinable. Nonetheless, this is always when the PS
    % appears in one eye and the NPS appears in the other, simultaneously.
	if strcmp('dCOS',Grating.stim(tr)) && Grating.soa(tr) == 0
        dCOScond = dCOScond+1;
        Cond(i).dCOS(dCOScond).s1_eye      = Grating.s1_eye(tr);
        Cond(i).dCOS(dCOScond).s2_eye      = Grating.s2_eye(tr);
        Cond(i).dCOS(dCOScond).s1_tilt     = Grating.s1_tilt(tr);
        Cond(i).dCOS(dCOScond).s2_tilt     = Grating.s2_tilt(tr);
        Cond(i).dCOS(dCOScond).s1_contrast = Grating.s1_contrast(tr);
        Cond(i).dCOS(dCOScond).s2_contrast = Grating.s2_contrast(tr);
        Cond(i).dCOS(dCOScond).soa         = Grating.soa(tr);
        Cond(i).dCOS(dCOScond).trial       = Grating.trial(tr);
        Cond(i).dCOS(dCOScond).EventTime       = [start_noSoa stop];
    
    % 4.d.PS condition. This is when BRFS happens and the PS is perceived
    % after flash. Essentially, the NPS is adapted (in either eye) and then
    % after soa = 800 the PS is flashed and subsequently perceived. 
	elseif strcmp('dCOS',Grating.stim(tr)) && Grating.soa(tr) == 800 ...
            && Grating.s2_tilt(tr) == PS
        PScond = PScond+1;
        Cond(i).PS(PScond).s1_eye      = Grating.s1_eye(tr);
        Cond(i).PS(PScond).s2_eye      = Grating.s2_eye(tr);
        Cond(i).PS(PScond).s1_tilt     = Grating.s1_tilt(tr);
        Cond(i).PS(PScond).s2_tilt     = Grating.s2_tilt(tr);
        Cond(i).PS(PScond).s1_contrast = Grating.s1_contrast(tr);
        Cond(i).PS(PScond).s2_contrast = Grating.s2_contrast(tr);
        Cond(i).PS(PScond).soa         = Grating.soa(tr);
        Cond(i).PS(PScond).trial       = Grating.trial(tr);
        Cond(i).PS(PScond).EventTime     = [start1 start2 stop];
    
    % 4.d.NPS condition. This is when BRFS happens and the NPS is perceived
    % after the flash. Essentially, the PS is adapted and then after the
    % soa the PS is flashed and therefore perceived.
	elseif strcmp('dCOS',Grating.stim(tr)) && Grating.soa(tr) == 800 ...
            && Grating.s2_tilt(tr) == NPS
        NPScond = NPScond+1;
        Cond(i).NPS(NPScond).s1_eye      = Grating.s1_eye(tr);
        Cond(i).NPS(NPScond).s2_eye      = Grating.s2_eye(tr);
        Cond(i).NPS(NPScond).s1_tilt     = Grating.s1_tilt(tr);
        Cond(i).NPS(NPScond).s2_tilt     = Grating.s2_tilt(tr);
        Cond(i).NPS(NPScond).s1_contrast = Grating.s1_contrast(tr);
        Cond(i).NPS(NPScond).s2_contrast = Grating.s2_contrast(tr);
        Cond(i).NPS(NPScond).soa         = Grating.soa(tr);
        Cond(i).NPS(NPScond).trial       = Grating.trial(tr);
        Cond(i).NPS(NPScond).EventTime      = [start1 start2 stop];

	end
Cond(i).Date = fileForGrating.name;

end % end of pEvC loop

clearvars -except Cond  fileForNSx allFiles baseDir ext searchExpression SessionParams

end % of all files loop



        %notification sound
        load gong
        sound(y,Fs)
