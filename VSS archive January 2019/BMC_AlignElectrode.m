% BMC Align Electrode.
clear
close all

%% EDITABLE VARIABLES

ext = '.ns2';
baseDir = 'E:\LaCie\all BRFS completed Workspace Variables\brfs';
cd('E:\LaCie\all BRFS completed Workspace Variables')
load('SessionParam.mat')
SessionParam.EvalSink = SessionParam.BMC_ChanNum;

%% 1. Calculate CSD from LFP
cd(baseDir)


%% 2. Average CSD across entire condition per day

%% 3. Create Matrix aligned on sink -- maybe in excel?
% ('padded electrode idx/depth vector' x 'avgCSD signal at timesample' x recording day) where
% the third dimension will have each day and, within that dimension, the
% electrode idx will fluxuate to have bottom of sink be bottom of sink

%% 4. Average across session to create master CSD for condition.

%% 5. subtract one condition from another to create difference plot.

%% 6. filter CSD to create images of the seperate conditions AND the difference plot.

