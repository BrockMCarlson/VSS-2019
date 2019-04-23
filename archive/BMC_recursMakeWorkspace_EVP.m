% BMC
% recursive Make Workspace 
% EVP
% This gets the workspace variables from all raw data files in a given
% directory.
% Outputs - LFP (1kHz from ns2 file), 
%         - INFO: EV (30kHz. Downsample later), and fileForNSx.name gives 
%           the file origion. 
clear 
close all

%% EDITABLE VARIABLES
%brfs vs evp
%ns2 vs ns6
searchExpression = '_evp001'; % do brfs001, brfs002, and evp001 and evp002 (check for more?)
ext = '.ns2';
baseDir = 'E:\LaCie\all BRFS';

%% 1. LOOP FILES TO PROCESS 
cd(baseDir)
allFiles = dir(baseDir);
allFiles = allFiles(3:size(allFiles,1));
for i = 1:size(allFiles,1) %big loop
clear    EV LFP fileForNSx % the saved variables
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
                pre  = 256/1000; % 256ms
                post = 612/1000; % 612ms
                trls = find(cellfun(@(x) sum(x == 23) == sum(x == 24),pEvC));
                for tr = 1:length(trls)
                        t = trls(tr);

% % % % %    not necessary for evp                     if ~any(pEvC{t} == 96) % This is not necessary on the evp trails
% % % % %                             % skip if trial was aborted and animal was not rewarded (event code 96)
% % % % %                             continue
% % % % %                         end

                        stimon   =  pEvC{t} == 23 | pEvC{t} == 25  | pEvC{t} == 27   | pEvC{t} == 29  | pEvC{t} == 31;
                        stimoff  =  pEvC{t} == 24 | pEvC{t} == 26  | pEvC{t} == 28   | pEvC{t} == 30  | pEvC{t} == 32;

                        start   =  pEvT{t}(stimon);
                        stop    =  pEvT{t}(stimoff);

                        maxpres = length(stop);

                    for p = 1:maxpres

                            % trigger point
                            obs = obs + 1;

                            % file info
                            EV.ec(obs,:)     = [stimon(p) stimoff(p)];
                            EV.tp(obs,:)     = [start(p) stop(p)];
                    end
                end
                clearvars -except allFiles EV fileForNEV searchExpression ext baseDir   

    
    
    
    
	% 3. LOAD MATCHING NEURAL DATA
    fileForNSx = dir(strcat('*',searchExpression,'*','.ns2'));
      NS_Header = openNSx(fileForNSx(1).name,'noread');
                % 3.2 get basic info about recorded data
                neural = ~strcmp('E',{NS_Header.ElectrodesInfo.ConnectorBank}); % bank E is the BNCs on the front of the NSP
                N.electrodes = length(neural);
                N.neural = sum( neural);
                N.analog = sum(~neural);

                % 3.3 get labels
                NeuralLabels = {NS_Header.ElectrodesInfo(neural).Label};
                NeuralInfo = NS_Header.ElectrodesInfo(neural);

                % 3.4 get sampling frequency
                Fs = NS_Header.MetaTags.SamplingFreq;

                % 3.5 process data electrode by electrode
                clear act nct
                nct = 0; % prepare counters
                for e = 1:N.electrodes
                  e;

                    if neural(e) == 1
                        nct = nct+1;

                        clear NS DAT
                        electrode = sprintf('c:%u',e);       
                        NS = openNSx(fileForNSx(1).name,electrode,'read','uV','precision','double');
                        if iscell(NS.Data)
                            DAT = cell2mat(NS.Data); 
                        else
                            DAT = NS.Data;
                        end
                        NS.Data = [];


                        %preallocation
                        if nct == 1
                            N.samples.DAT = length(DAT);
                            clear LFP rawLFP
                            rawLFP = zeros(ceil(N.samples.DAT),N.neural);
                        end
                        rawLFP(:,nct) = DAT;
                        clear  DAT

                    end

                end
                
                
                % sort electrodes order
                electrodes = unique(NeuralLabels);
                 for ch = 1:length(electrodes)
                    chname = electrodes{ch}; 
                    id = find(~cellfun('isempty',strfind(NeuralLabels,chname)));
                    if ~isempty(id)
                        ids(ch) = id;
                    end
                 end  

                 clear  prefilteredLFP

                prefilteredLFP = rawLFP(:,ids);
                clear rawLFP

                % Filter LFP (MUA was already filtered in 3.5's loop with f_calcMUA function)
                % Eventually, this section should be consolidated to a function
                lpc = 300; %low pass cutoff
                nyq = Fs/2;
                lWn = lpc/nyq;
                [bwb,bwa] = butter(4,lWn,'low');
                for chan = 1:size(prefilteredLFP,2)
                    lpLFP(:,chan) = filtfilt(bwb,bwa,prefilteredLFP(:,chan));  %low pass filter to avoid aliasing
                end
                clear prefilteredLFP bwb bwa 1Wn
                clear LFP
                %%% LFP = downsample(lpLFP,30); % downsample to 1kHz % Not
                %%% needed in EVP taken from ns2. Check other ns2 data for
                %%% BRFS days
                LFP = lpLFP;
                clear lpLFP


      
      
    % 4. SAVE OUTPUT
    clearvars -except allFiles EV LFP fileForNSx searchExpression ext baseDir   

        if exist('EV','var') == 1
            cd(baseDir)
            %Final variable exports are 'EV', 'LFP', 'Unq_cond' 'fileForNSx'
            dateFormatOut = 'yyyy-mm-dd';
            saveDate = datestr(now,dateFormatOut);
            saveNameINFO = strcat('INFOofBRFS','_',fileForNSx(1).name,'_',saveDate);
            save(strcat(saveNameINFO,'.mat'),'EV','fileForNSx');

            saveNameLFP = strcat('LFPofBRFS','_',fileForNSx(1).name,'_',saveDate);
            save(strcat(saveNameLFP,'.mat'),'LFP','-v7.3');

            clear dateFormatOut saveDate
        elseif exist('EV','var') == 0
            failedFolder = pwd;
            disp(strcat(failedFolder,'......','EV dne.'))
            continue 
        end

end             % end of allFiles loop

        %notification sound
        load gong
        sound(y,Fs)
