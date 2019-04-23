% BMC manual CSD BRFS
% This code is for two electrodes or weird trials tha need special
% attention

clear 
close all
% github test
%% EDITABLE VARIABLES
%brfs vs BRFS
%ns2 vs ns6
searchExpression = '_evp001'; % do brfs001, brfs002, and evp001 and evp002 (check for more?)
ext = '.ns2';
expDir = 'E:\LaCie\all BRFS completed Workspace Variables\brfs';
baseDir = 'E:\LaCie\all BRFS completed Workspace Variables';
cd(baseDir)
load('SessionParams.mat')
SessionParam.EvalSink = SessionParam.Old_DfS;

FileDatestrName = '161011_E';
FileDatestr     = {'161011a'}; % a for electrode 1. b for electrode 2
ElectrodeToAnalyze = 1;         % 1 for electrode 1. 2 for electrode 2


%% 1. Load required LFP and INFO files
cd(expDir)

nameINFO	= strcat('INFOofBRFS_', FileDatestrName, '_BRFS001.ns2_2019-01-17.mat');
nameLFP     = strcat('LFPofBRFS_',  FileDatestrName, '_BRFS001.ns2_2019-01-17.mat');
load(nameINFO); 
load(nameLFP);
    
    for i = 1:size(SessionParam.Datestr,1)
        if strcmp(SessionParam.Datestr(i),FileDatestr)
            idxSessionParam = i;
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
        if ElectrodeToAnalyze == 1
            stimLFP(tr,:,:) = LFP(refwin,1:24);
        elseif ElectrodeToAnalyze == 2
            stimLFP(tr,:,:) = LFP(refwin,25:48);
        else
            disp('error in ElectrodeToAnalyze Split under LFP stim trigger')
        end
    end

    % COMPUTE AVERAGE ACROSS TRIALS

    % account for direction of electrode. If it is descending (like on the
    % NeuroNexus arrays, typically 32 chan) then the direction of the
    % channels along avgLFP's second dimension must be fliped so the
    % figures line up.
    if  ~strcmp(SessionParam.SortDirection(idxSessionParam),'ascending')
        disp('Sort Direction Error')
    end
    avgLFP = squeeze(mean(stimLFP,1));
    sinkBtm = SessionParam.EvalSink(idxSessionParam);
    
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
                  title(strcat(SessionParam.Datestr(idxSessionParam),' BRFS CSD Line sinkBtm =',num2str(sinkBtm)));
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
    title(strcat(string(SessionParam.Datestr(idxSessionParam)),' BRFS CSD filt sinkBtm =',num2str(sinkBtm)));
    
    FIG2 = gcf;


    % 4. SAVE OUTPUT
        cd('E:\LaCie\all BRFS completed Workspace Variables\brfsSinkFigs')
        saveas(FIG1,strcat(string(SessionParam.Datestr(idxSessionParam)),'_BRFS_CSD_Line'),'jpeg')
        saveas(FIG2,strcat(string(SessionParam.Datestr(idxSessionParam)),'_BRFS_CSD_filt'),'jpeg')
