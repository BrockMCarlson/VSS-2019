%% BMC test greek Logicals
clear
BRdatafile    = '160523_E_brfs001'; 

% load grating info
cd('E:\LaCie\all BRFS\160523_E')
fileForGrating = strcat(BRdatafile,'.gBrfsGratings');
Grating = readBRFS(fileForGrating);

PS = 135;
NPS = 45;

%% THE ALPHA GRAPH ----
% dCOS PS in eye 2
% brfs PS in eye 2, PS flashed

% alpha dCOS trials and timestamps
count = 0;
for ad = 1:size(Grating.stim,1)
    if strcmp('dCOS',Grating.stim(ad)) && Grating.soa(ad) == 0 && ...
            ((Grating.s1_eye(ad) == 2 && Grating.s1_tilt(ad) == PS) || ...
            (Grating.s1_eye(ad) == 3 && Grating.s1_tilt(ad) == NPS))
        
        count = count+1;
        alpha.dCOS(count).trial     = Grating.trial(ad);
        alpha.dCOS(count).timestamp = Grating.timestamp(ad);        
    end
end

% alpha brfs trials and timestamps
count = 0;
for abrfs = 1:size(Grating.stim,1)
    if strcmp('dCOS',Grating.stim(abrfs)) && Grating.soa(abrfs) == 800 && ...
            (Grating.s2_eye(abrfs) == 2 && Grating.s2_tilt(abrfs) == PS)
        
        count = count+1;
        alpha.brfs(count).trial     = Grating.trial(abrfs);
        alpha.brfs(count).timestamp = Grating.timestamp(abrfs);        
    end
end

% % % making sure there are no overlapping trials. Should be mutually exclusive
% % % if the code works properly.
% % for sanitycheck = 1:size(alpha.dCOS,2)
% %    for altcondcheck = 1:size(alpha.brfs,2)
% %       if alpha.dCOS(sanitycheck).trial == alpha.brfs(altcondcheck).trial
% %           disp('error')
% %           disp(alpha.brfs(altcondcheck).trial)
% %           test = alpha.brfs(altcondcheck).trial;
% %       end
% %    end 
% % end

%% THE BETA GRAPH ----
% dCOS PS in eye 2
% brfs PS in eye 2, NPS flashed

% beta dCOS trials and timestamps
count = 0;
for bd = 1:size(Grating.stim,1)
    if strcmp('dCOS',Grating.stim(bd)) && Grating.soa(bd) == 0 && ...
            ((Grating.s1_eye(bd) == 2 && Grating.s1_tilt(bd) == PS) || ...
            (Grating.s1_eye(bd) == 3 && Grating.s1_tilt(bd) == NPS))
        
        count = count+1;
        beta.dCOS(count).trial     = Grating.trial(bd);
        beta.dCOS(count).timestamp = Grating.timestamp(bd);        
    end
end

% beta brfs trials and timestamps
count = 0;
for bbrfs = 1:size(Grating.stim,1)
    if strcmp('dCOS',Grating.stim(bbrfs)) && Grating.soa(bbrfs) == 800 && ...
            (Grating.s2_eye(bbrfs) == 3 && Grating.s2_tilt(bbrfs) == NPS)
        
        count = count+1;
        beta.brfs(count).trial     = Grating.trial(bbrfs);
        beta.brfs(count).timestamp = Grating.timestamp(bbrfs);        
    end
end

%% THE GAMMA GRAPH ----
% dCOS PS in eye 3
% brfs PS in eye 3, PS flashed

% gamma dCOS trials and timestamps
count = 0;
for gd = 1:size(Grating.stim,1)
    if strcmp('dCOS',Grating.stim(gd)) && Grating.soa(gd) == 0 && ...
            ((Grating.s1_eye(gd) == 3 && Grating.s1_tilt(gd) == PS) || ...
            (Grating.s1_eye(gd) == 2 && Grating.s1_tilt(gd) == NPS))
        
        count = count+1;
        gamma.dCOS(count).trial     = Grating.trial(gd);
        gamma.dCOS(count).timestamp = Grating.timestamp(gd);        
    end
end

% gamma brfs trials and timestamps
count = 0;
for gbrfs = 1:size(Grating.stim,1)
    if strcmp('dCOS',Grating.stim(gbrfs)) && Grating.soa(gbrfs) == 800 && ...
            (Grating.s2_eye(gbrfs) == 3 && Grating.s2_tilt(gbrfs) == PS)
        
        count = count+1;
        gamma.brfs(count).trial     = Grating.trial(gbrfs);
        gamma.brfs(count).timestamp = Grating.timestamp(gbrfs);        
    end
end

%% THE DELTA GRAPH ----
% dCOS PS in eye 3
% brfs PS in eye 3, NPS flashed

% delta dCOS trials and timestamps
count = 0;
for dd = 1:size(Grating.stim,1)
    if strcmp('dCOS',Grating.stim(dd)) && Grating.soa(dd) == 0 && ...
            ((Grating.s1_eye(dd) == 3 && Grating.s1_tilt(dd) == PS) || ...
            (Grating.s1_eye(dd) == 2 && Grating.s1_tilt(dd) == NPS))
        
        count = count+1;
        delta.dCOS(count).trial     = Grating.trial(dd);
        delta.dCOS(count).timestamp = Grating.timestamp(dd);        
    end
end

% delta brfs trials and timestamps
count = 0;
for dbrfs = 1:size(Grating.stim,1)
    if strcmp('dCOS',Grating.stim(dbrfs)) && Grating.soa(dbrfs) == 800 && ...
            (Grating.s2_eye(dbrfs) == 2 && Grating.s2_tilt(dbrfs) == NPS)
        
        count = count+1;
        delta.brfs(count).trial     = Grating.trial(dbrfs);
        delta.brfs(count).timestamp = Grating.timestamp(dbrfs);        
    end
end
