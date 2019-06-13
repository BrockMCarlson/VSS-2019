clear 
close all

%% EDITABLE VARIABLES
searchExpression = '_brfs003'; % do brfs001, brfs002, and evp001 and evp002 (check for more?)
ext = '.ns2';
baseDir = 'E:\LaCie\all BRFS';

%% 1. LOOP FILES TO PROCESS 
cd(baseDir)
allFiles = dir(baseDir);
allFiles = allFiles(3:size(allFiles,1));
for i = 1:size(allFiles,1) %big loop
    i
clear    EV LFP Unq_cond Cond fileForNSx % the saved variables
stepDir = strcat(baseDir,filesep,allFiles(i).name);
cd(stepDir)
      
    % 2. READ NEV
    fileForNEV = dir(strcat('*',searchExpression,'*','.nev'));
    if isempty(fileForNEV)== 0
        itWorks = i;
    elseif isempty(fileForNEV) == 1
       failedFolder = pwd;
       disp(strcat(failedFolder,'......','searchExpression not found'))
       continue 
    else
        disp('ERROR, check 2. READ NEV')
    end
    NEV = openNEV(fileForNEV(1).name,'noread','nomat','nosave'); %check NPMK version info
            EventCodes = NEV.Data.SerialDigitalIO.UnparsedData - 128;
            EventTimes = double(NEV.Data.SerialDigitalIO.TimeStamp); 
            %EventTimes = NEV.Data.SerialDigitalIO.TimeStampSec * 1000; 
            [pEvC,pEvT] = parsEventCodesML(EventCodes,EventTimes);
            evtFs = double(NEV.MetaTags.SampleRes);
            clear NEV 

            % 2. FIND STIMULUS EVENTS/TIMES
            obs  = 0;
            a = 0;
            b = 0;
            c = 0;
            d = 0;
            pre  = 256/1000; % 256ms
            post = 612/1000; % 612ms
    
            %get Grating info
            fileForGrating = dir(strcat('*',searchExpression,'*','.gBrfsGratings'));
            Grating = readBRFS(fileForGrating(1).name);


            
            
            
            for tr = 1:length(pEvC)
                    t = tr;

                     if ~any(pEvC{t} == 96) % This is not necessary on the evp trails
                         % skip if trial was aborted and animal was not rewarded (event code 96)
                         continue
                     end     
                    
                    stimon   =  pEvC{t} == 23;
                    stimoff  =  pEvC{t} == 24;

                    %Based on the logical stimon index previously created, determine if
                    %there is soa or no soa. No soa gets labeled as start_noSoa - this
                    %will go into groups A and B. With Soa present, start1 and start2
                    %are created. - this will go onti groups C and D. This seperation
                    %may not be necessary and should be reviewed later. 
                    idx = find(stimon);
                    if      numel(idx) == 1     % there is no soa.
                        start_noSoa  =  pEvT{t}(stimon); % idx could also be used here.
                            % ... % However, this was the origional logical used in the script.

                    elseif  numel(idx) == 2     %there is indeed soa
                        start1  =  pEvT{t}(idx(1));
                        start2  =  pEvT{t}(idx(2));
                    else
                        disp('error, please check idx loop')
                    end

                    %The time at which one or both stimuli were removed
                    stop    =  pEvT{t}(stimoff);

            % % % % %         % trigger point
            % % % % %         obs = obs + 1; 

                    % Assign Ev time points with and without soa.
                    if      numel(idx) == 1     % there is no soa.
                       % create EV.A&B
                        if strcmp('Binocular',Grating.stim(t)) %Binocular
                            a = a+1;
                            EV.A(a,:) = [start_noSoa stop];
                        elseif strcmp('dCOS',Grating.stim(t))
                            b = b+1;
                            EV.B(b,:) = [start_noSoa stop];
                        elseif strcmp('Monocular', Grating.stim(t)) % skip Monocular
                            continue % skips and dismisses all Monocular trials.

                        else
                           disp('error, please check EV.A&B loop') 
                           disp(t)
                        end
            % % % % % %             EV.tpNoSoa(obs,:)   = [start_noSoa stop];            
                    elseif  numel(idx) == 2     %there is indeed soa
                        % create EV.C&D 
                        if strcmp('Binocular',Grating.stim(t)) %Binocular
                            c = c+1;
                            EV.C(c,:) = [start1 start2 stop];
                        elseif strcmp('dCOS',Grating.stim(t))
                            d = d+1;
                            EV.D(d,:) = [start1 start2 stop];
                        else
                           disp('error, please check EV.C&D loop') 
                         end
            % % % % % %             EV.tpSoa(obs,:)     = [start1 start1 stop];
                    else
                        disp('error, please check idx loop')
                    end


             end


            % organize stimuli conditions
            % Ignore Monocular stim for now. Look at dCOS and Binocular stim under
            % simultaneous and stimulus onset asynchrony conditions. 
            % 4 groups. 
            % A == Bi, soa=0; B == dCOS, soa=0; C == Bi, soa=800; D == dCOS, soa=800.
            [Cond, Unq_cond] = allocateConditions(Grating, pEvC);

            
            %% Pull This stuff out
            SAVEDATA(i).Grating = Grating;
            SAVEDATA(i).Cond = Cond;
            SAVEDATA(i).Unq_cond = Unq_cond;
            SAVEDATA(i).DateStr = stepDir;
            
            
end             % end of allFiles loop
 
        %notification sound
        load gong
        sound(y,Fs)
