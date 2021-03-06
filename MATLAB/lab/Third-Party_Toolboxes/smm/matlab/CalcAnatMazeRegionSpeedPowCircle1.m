function CalcAnatMazeRegionSpeedPowCircle1(taskType,fileBaseMat,fileNameFormat,fileExt,nchannels,winLength,thetaFreqRange,thetaNW,gammaFreqRange,gammaNW,saveBool,plotbool,trialtypesbool)
% function  CalcAnatMazeRegionPow(taskType,fileBaseMat,fileNameFormat,fileExt,nchannels,lowCut,highCut,onePointBool,saveBool,plotbool,trialtypesbool)

if ~exist('trialtypesbool','var')
    trialtypesbool = [1  0  1  0  0   0   0   0   0   0   0   0  0];
                    %LR RR RL LL LRP RRP RLP LLP LRB RRB RLB LLB XP
                    %cr ir cl il crp irp clp ilp crb irb clb ilb xp
end
if ~exist('mazelocationsbool','var')
    mazelocationsbool = [0  0  0  1  1  1   1   1   1];
                       %rp lp dp cp ca rca lca rra lra
end
% [1 0 1 0 0 0 0 0 0 0 0 0 0]
% [0 0 0 1 1 1 1 1 1]

if ~exist('plotbool','var')
    plotbool = 0;
end
if ~exist('saveBool','var')
    saveBool = 0;
end
if ~exist('onePointBool','var')
    onePointBool = 0;
end
plotChan = 35;
bps = 2; % bytes per sample
eegSamp = 1250;
whlSamp = 39.065;
whlWinLength = winLength/eegSamp*whlSamp;
hanFilter = hanning(floor(whlWinLength));
hanFilter = hanFilter./mean(hanFilter);


[numfiles n] = size(fileBaseMat);
ntrials=0;

measurements = struct('speed',[],'accel',[],'thetaPowPeak',[],'thetaPowIntg',[],'gammaPowPeak',[],'gammaPowIntg',[],'thetaNWYo',[],'gammaNWYo',[]);
mazeRegionNames = {'quad1';'quad2';'quad3';'quad4'};

for i=1:numfiles
    
    eegName = [fileBaseMat(i,:) '.eeg'];
    whlDat = load([fileBaseMat(i,:) '.whl']);
    allMazeRegions = LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,[0 0 0 1 1 1 1 1 1]);
    leftRightTrials = LoadMazeTrialTypes(fileBaseMat(i,:),([1 0 0 0 1 0 0 0 1 0 0 0 0]&trialtypesbool),[0 0 0 0 0 1 1 1 1]);
    rightLeftTrials = LoadMazeTrialTypes(fileBaseMat(i,:),([0 1 0 0 0 1 0 0 0 1 0 0 0]&trialtypesbool),[0 0 0 0 0 1 1 1 1]);
    [speed accel] = MazeSpeedAccel(whlDat);
    [whlm n] = size(whlDat);
    
    
    atports = LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,[1 1 1 0 0 0 0 0 0]);
    
    rReturnArm = LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,[0 0 0 0 0 0 0 1 0]);
    lReturnArm   = LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,[0 0 0 0 0 0 0 0 1]);
    rGoalArm   = LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,[0 0 0 0 0 1 0 0 0]);
    lGoalArm   = LoadMazeTrialTypes(fileBaseMat(i,:),trialtypesbool,[0 0 0 0 0 0 1 0 0]);

   
    %plot(allMazeRegions(:,1),allMazeRegions(:,2))
    trialbegin = find(allMazeRegions(:,1)~=-1);
    while ~isempty(trialbegin),
        trialend = trialbegin(1) + find(atports((trialbegin(1)+1):end,1)~=-1);
        if isempty(trialend),
            breaking = 1
            break;
        end

        trialrReturnArm = trialbegin(1)-1+find(rReturnArm(trialbegin(1):(trialend(1)-1),1)~=-1);
        triallReturnArm = trialbegin(1)-1+find(lReturnArm(trialbegin(1):(trialend(1)-1),1)~=-1);
        trialrGoalArm = trialbegin(1)-1+find(rGoalArm(trialbegin(1):(trialend(1)-1),1)~=-1);
        triallGoalArm = trialbegin(1)-1+find(lGoalArm(trialbegin(1):(trialend(1)-1),1)~=-1);
             
        if ~isempty(trialrReturnArm) & ~isempty(triallReturnArm) & ~isempty(trialrGoalArm) & ~isempty(triallGoalArm)

            if plotbool
                figure(3)
                clf
                hold on
                plot(allMazeRegions(find(allMazeRegions(:,1)~=-1),1),allMazeRegions(find(allMazeRegions(:,1)~=-1),2),'.','color',[1 1 0]);

                plot(rReturnArm(trialrReturnArm,1),rReturnArm(trialrReturnArm,2),'.','color',[0 0 1],'markersize',7);
                plot(lReturnArm(triallReturnArm,1),lReturnArm(triallReturnArm,2),'.','color',[1 0 0],'markersize',7);
                plot(rGoalArm(trialrGoalArm,1),rGoalArm(trialrGoalArm,2),'.','color',[0 0 0],'markersize',7);
                plot(lGoalArm(triallGoalArm,1),lGoalArm(triallGoalArm,2),'.','color',[0 1 1],'markersize',7);
                set(gca,'xlim',[0 368],'ylim',[0 240]);
            end


            rReturnArmMidPointDist = (rReturnArm(trialrReturnArm,1) - mean([max(rReturnArm(trialrReturnArm,1)) min(rReturnArm(trialrReturnArm,1))])).^2 + ...
                (rReturnArm(trialrReturnArm,2) - mean([max(rReturnArm(trialrReturnArm,2)) min(rReturnArm(trialrReturnArm,2))])).^2;
            rReturnArmMidPoint = find(rReturnArmMidPointDist == min(rReturnArmMidPointDist));
            if leftRightTrials(trialbegin(1))~=-1
                quad4MidPoint = trialrReturnArm(rReturnArmMidPoint(1));
            else
                quad1MidPoint = trialrReturnArm(rReturnArmMidPoint(1));
            end

            lReturnArmMidPointDist = (lReturnArm(triallReturnArm,1) - mean([max(lReturnArm(triallReturnArm,1)) min(lReturnArm(triallReturnArm,1))])).^2 + ...
                (lReturnArm(triallReturnArm,2) - mean([max(lReturnArm(triallReturnArm,2)) min(lReturnArm(triallReturnArm,2))])).^2;
            lReturnArmMidPoint = find(lReturnArmMidPointDist == min(lReturnArmMidPointDist));
            if leftRightTrials(trialbegin(1))~=-1
                quad1MidPoint = triallReturnArm(lReturnArmMidPoint(1));
            else
                quad4MidPoint = triallReturnArm(lReturnArmMidPoint(1));
            end

            rGoalArmMidPointDist = (rGoalArm(trialrGoalArm,1) - mean([max(rGoalArm(trialrGoalArm,1)) min(rGoalArm(trialrGoalArm,1))])).^2 + ...
                (rGoalArm(trialrGoalArm,2) - mean([max(rGoalArm(trialrGoalArm,2)) min(rGoalArm(trialrGoalArm,2))])).^2;
            rGoalArmMidPoint = find(rGoalArmMidPointDist == min(rGoalArmMidPointDist));
            if leftRightTrials(trialbegin(1))~=-1
                quad3MidPoint = trialrGoalArm(rGoalArmMidPoint(1));
            else
                quad2MidPoint = trialrGoalArm(rGoalArmMidPoint(1));
            end

            lGoalArmMidPointDist = (lGoalArm(triallGoalArm,1) - mean([max(lGoalArm(triallGoalArm,1)) min(lGoalArm(triallGoalArm,1))])).^2 + ...
                (lGoalArm(triallGoalArm,2) - mean([max(lGoalArm(triallGoalArm,2)) min(lGoalArm(triallGoalArm,2))])).^2;
            lGoalArmMidPoint = find(lGoalArmMidPointDist == min(lGoalArmMidPointDist));
            if leftRightTrials(trialbegin(1))~=-1
                quad2MidPoint = triallGoalArm(lGoalArmMidPoint(1));
            else
                quad3MidPoint = triallGoalArm(lGoalArmMidPoint(1));
            end

            midPoints = [quad1MidPoint; quad2MidPoint; quad3MidPoint; quad4MidPoint];
            plotColors = [1 0 0;0 1 1;0 0 0;0 0 1];

            if plotbool
                for k=1:4
                    plot(whlDat(round(midPoints(k)-whlWinLength/2+1):round(midPoints(k)+whlWinLength/2),1),...
                        whlDat(round(midPoints(k)-whlWinLength/2+1):round(midPoints(k)+whlWinLength/2),2),'o','color',plotColors(k,:),'markersize',5);
                    plot(whlDat(midPoints(k),1),whlDat(midPoints(k),2),'.','color',[0 1 0],'markersize',20);
                end
                %plot(choicepoint(trialchoicepoint(choicePointMidPoint(1)),1),choicepoint(trialchoicepoint(choicePointMidPoint(1)),2),'.','color',[0 1 0],'markersize',20);
                %plot(centerarm(trialcenterarm(centerArmMidPoint(1)),1),centerarm(trialcenterarm(centerArmMidPoint(1)),2),'.','color',[0 1 0],'markersize',20);
                %plot(goalarm(trialgoalarm(choiceArmMidPoint(1)),1),goalarm(trialgoalarm(choiceArmMidPoint(1)),2),'.','color',[0 1 0],'markersize',20);

                %plot(returnarm(round(mean(trialreturnarm)),1),returnarm(round(mean(trialreturnarm)),2),'.','color',[0 1 0],'markersize',7);
                %plot(centerarm(round(mean(trialcenterarm)),1),centerarm(round(mean(trialcenterarm)),2),'.','color',[0 1 0],'markersize',7);
                %plot(choicepoint(round(mean(trialchoicepoint)),1),choicepoint(round(mean(trialchoicepoint)),2),'.','color',[0 1 0],'markersize',7);
                %plot(goalarm(round(mean(trialgoalarm)),1),goalarm(round(mean(trialgoalarm)),2),'.','color',[0 1 0],'markersize',7);
            end
        else
            fprintf('\nSkipping trial because of bad indexing!\n')
            keyboard
        end
        ntrials = ntrials + 1;
        trialbegin = trialend(1)-1+find(allMazeRegions(trialend(1):end,1)~=-1);

        j = 's';
        if ~plotbool
            fprintf('n=%d : ',ntrials);
            j = 0;
            while ~strcmp(j,'s') & ~strcmp(j,'d')
                j = input('Save (s) or delete (d)? ','s');
            end
        end
        if strcmp(j,'s')

            if ~exist('mazeMeasStruct','var')
                %nPoints = size(getfield(speedPowStruct,mazeRegionNames{1},'speed'),1);
                mazeMeasStruct = struct(mazeRegionNames{1},measurements,mazeRegionNames{2},measurements,mazeRegionNames{3},measurements,mazeRegionNames{4},measurements);

                trialNum = 1;
            else
                trialNum = trialNum+1;
            end
            %mazeMeasStruct(trialNum) = struct('returnArm',measurements,'centerArm',measurements,'Tjunction',measurements,'goalArm',measurements);
            if plotbool
                figure(2)
                clf
            end

            if size(midPoints,1) == size(mazeRegionNames,1)
                for k=1:size(mazeRegionNames,1)
                    %%%%%% speed %%%%%%%
                    speedSeg = hanFilter.*speed(round(midPoints(k)-whlWinLength/2+1):round(midPoints(k)-whlWinLength/2)+size(hanFilter,1));
                    indexes = find(speedSeg >= 0);
                    if isempty(indexes)

                        fprintf('error_speed_cant_be_reliably_measured');
                        keyboard
                    else
                        mazeMeasStruct = setfield(mazeMeasStruct,mazeRegionNames{k},'speed',{trialNum},mean(speedSeg(indexes)));
                        %speedPowStruct = setfield(speedPowStruct,mazeRegionNames{k},'speed',{nPoints + 1,1}, mean(speedSeg(indexes)));
                        %returnArmSpeed = mean(speedSeg(indexes));
                        %whlSpeedSeg(indexes)
                    end

                    %%%%% accel %%%%%%%
                    accelSeg = hanFilter.*accel(round(midPoints(k)-whlWinLength/2+1):round(midPoints(k)-whlWinLength/2)+size(hanFilter,1));
                    indexes = find(speedSeg >= 0);
                    if isempty(indexes)

                        fprintf('error_accel_cant_be_reliably_measured');
                        keyboard
                    else
                        mazeMeasStruct = setfield(mazeMeasStruct,mazeRegionNames{k},'accel',{trialNum},mean(accelSeg(indexes)));
                        %speedPowStruct = setfield(speedPowStruct,mazeRegionNames{k},'speed',{nPoints + 1,1}, mean(speedSeg(indexes)));
                        %returnArmSpeed = mean(speedSeg(indexes));
                        %whlSpeedSeg(indexes)
                    end

                    eegPos = round(midPoints(k)/whlSamp*eegSamp-winLength/2);
                    %%%% for theta %%%%
                    [yo, fo] = mtpsd_sm(bload(eegName,[nchannels winLength],eegPos*nchannels*bps,'int16'),winLength*2,eegSamp,winLength,0,thetaNW);
                    mazeMeasStruct = setfield(mazeMeasStruct,mazeRegionNames{k},'thetaNWYo',{trialNum,1:length(fo),1:nchannels},yo);
                    powPeak = 10.*log10(max(yo(find(fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2)),:)));
                    powIntg = 10.*log10(sum(yo(find(fo>=thetaFreqRange(1) & fo<=thetaFreqRange(2)),:)));
                    mazeMeasStruct = setfield(mazeMeasStruct,mazeRegionNames{k},'thetaPowPeak',{trialNum,1:nchannels},powPeak);
                    mazeMeasStruct = setfield(mazeMeasStruct,mazeRegionNames{k},'thetaPowIntg',{trialNum,1:nchannels},powIntg);
                    %mazeMeasStruct = setfield(mazeMeasStruct,mazeRegionNames{k},'power',{nPoints + 1,1:nchannels}, power);
                    if plotbool
                        subplot(2,4,k)
                        hold on
                        plot([0 100],[powPeak(plotChan) powPeak(plotChan)],'--r');
                        plot([0 100],[powIntg(plotChan) powIntg(plotChan)]-7,'--g');
                        plot(fo(find(fo<=100)),10.*log10(yo(find(fo<=100),plotChan)))
                        plot([thetaFreqRange(1) thetaFreqRange(1)],[40 80],':k')
                        plot([thetaFreqRange(2) thetaFreqRange(2)],[40 80],':k')
                        set(gca,'ylim',[40 80]);
                        title(mazeRegionNames{k});
                        if k==1
                            ylabel('theta');
                        end
                    end

                    %%%%% for gamma %%%%%%
                    [yo, fo] = mtpsd_sm(bload(eegName,[nchannels winLength],eegPos*nchannels*bps,'int16'),winLength*2,eegSamp,winLength,0,gammaNW);
                    mazeMeasStruct = setfield(mazeMeasStruct,mazeRegionNames{k},'gammaNWYo',{trialNum,1:length(fo),1:nchannels},yo);
                    powPeak = 10.*log10(max(yo(find(fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2)),:)));
                    powIntg = 10.*log10(sum(yo(find(fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2)),:)));
                    mazeMeasStruct = setfield(mazeMeasStruct,mazeRegionNames{k},'gammaPowPeak',{trialNum,1:nchannels},powPeak);
                    mazeMeasStruct = setfield(mazeMeasStruct,mazeRegionNames{k},'gammaPowIntg',{trialNum,1:nchannels},powIntg);
                    if plotbool
                        subplot(2,4,k+4)
                        hold on
                        plot([0 100],[powPeak(plotChan) powPeak(plotChan)],'--r');
                        plot([0 100],[powIntg(plotChan) powIntg(plotChan)]-12,'--g');
                        plot(fo(find(fo<=100)),10.*log10(yo(find(fo<=100),plotChan)))
                        plot([gammaFreqRange(1) gammaFreqRange(1)],[40 80],':k')
                        plot([gammaFreqRange(2) gammaFreqRange(2)],[40 80],':k')
                        %plot([0 100],[power(plotChan) power(plotChan)],'r');
                        %plot(fo(find(fo<=100)),10.*log10(max(yo(find(fo>=gammaFreqRange(1) & fo<=gammaFreqRange(2)),plotChan))),'g');
                        set(gca,'ylim',[40 80]);
                        if k==1
                            legend('peak','intg')
                            ylabel('gamma');
                        end
                        xlabel(['speed: ' num2str(getfield(mazeMeasStruct,mazeRegionNames{k},'speed',{trialNum}),3)...
                            ', accel: ' num2str(getfield(mazeMeasStruct,mazeRegionNames{k},'accel',{trialNum}),3)]);
                    end
                end
            else
                We_got_problems
            end
        end
    end
end
keyboard
addpath /u12/smm/matlab/draft
PlotSpeedPow

if saveBool

    if fileNameFormat == 1,
        outname1 = [taskType '_' fileBaseMat(1,1:8) '-' fileBaseMat(end,1:8) ];
    end
    if fileNameFormat == 2,
        outname1 = [taskType '_' fileBaseMat(1,[1:10]) '-' fileBaseMat(end,[8:10]) ];
    end
    if fileNameFormat == 0,
        outname1 = [taskType '_' fileBaseMat(1,[1:7 10:12 14 17:19]) '-' fileBaseMat(end,[7 10:12 14 17:19])];
    end
    outname2 = [fileExt '_Win' num2str(winLength) '_thetaF' num2str(thetaFreqRange(1)) '-' num2str(thetaFreqRange(2)) ...
        'NW' num2str(thetaNW) '_gammaF' num2str(gammaFreqRange(1)) '-' num2str(gammaFreqRange(2)) 'NW' num2str(gammaNW) ...
        '_MazeRegionsSpeedPow.mat'];
    outname = [outname1 outname2];
    fprintf('Saving %s\n', outname);
    matlabVersion = version;
    if str2num(matlabVersion(1)) > 6
        save(outname,'-v6','winLength','thetaFreqRange','thetaNW','gammaFreqRange','gammaNW','fo','mazeMeasStruct');

    else
        save(outname,'winLength','thetaFreqRange','thetaNW','gammaFreqRange','gammaNW','fo','mazeMeasStruct');
    end
end

figure(4)
clf
chans = [33;37;39;42;59;62];
for i=1:length(chans)
    subplot(length(chans),1,i)
    plotChan = chans(i);
    hold on
    colors = [0 0 1;1 0 0;0 1 0;0.5 0.5 0.5];
    allRegionsPow = [];
    allRegionsSpeed = [];
    nPoints = length(mazeMeasStruct);
    for k=1:size(mazeRegionNames,1)
        for ii=1:nPoints
            plot(getfield(mazeMeasStruct(ii),mazeRegionNames{k},'speed'),getfield(mazeMeasStruct(ii),mazeRegionNames{k},'thetaPowPeak',{plotChan}),'.','color',colors(k,:));
            %         [p s] = polyfit(getfield(speedPowStruct,mazeRegionNames{k},'speed',{1:nPoints,1}),getfield(speedPowStruct,mazeRegionNames{k},'power',{1:nPoints,plotChan}),1);
            %    endPoints = [min(getfield(speedPowStruct,mazeRegionNames{k},'speed')) max(getfield(speedPowStruct,mazeRegionNames{k},'speed'))];
            %         plot(endPoints,p(1).*endPoints+p(2),'k')
            set(gca,'xlim',[35 130]);
            %set(gca,'ylim',[68,84],'xlim',[35 130]);

            title(['channel: ' num2str(plotChan)]);
            allRegionsPow = [allRegionsPow; getfield(mazeMeasStruct(ii),mazeRegionNames{k},'thetaPowPeak',{plotChan})];
            allRegionsSpeed = [allRegionsSpeed; getfield(mazeMeasStruct(ii),mazeRegionNames{k},'speed')];
        end
    end
    %[p s] = polyfit(allRegionsSpeed,allRegionsPow,1);
    %plot([35 130],p(1).*[35 130]+p(2),'k','linewidth',2)
    [b,bint,r,rint,stats] = regress(allRegionsPow, [ones(size(allRegionsSpeed)) allRegionsSpeed], 0.01);
    plot([35 130],b(2).*[35 130]+b(1),'k','linewidth',2);
    fprintf('\nchan:%i, r2=%1.4f %1.20f',plotChan,stats(1),stats(3));
end

keyboard
fprintf('total n=%d : ',ntrials);
if saveBool
    
    if fileNameFormat == 1,
            outname = [taskType '_' fileBaseMat(1,1:8)  ...
                '-' fileBaseMat(end,1:8) ...
                fileExt '_' num2str(freqRange(1)) '-' num2str(freqRange(2)) 'Hz_Win' num2str(winLength) '_NW' num2str(NW) '_MazeRegionsSpeedPow.mat'];
    end
    if fileNameFormat == 2,
        outname = [taskType '_' fileBaseMat(1,[1:10]) '-' fileBaseMat(end,[8:10]) ...
            fileExt '_' num2str(freqRange(1)) '-' num2str(freqRange(2)) 'Hz_Win' num2str(winLength) '_NW' num2str(NW) '_MazeRegionsSpeedPow.mat'];
 
     end
    if fileNameFormat == 0,
        outname = [taskType '_' fileBaseMat(1,[1:7 10:12 14 17:19]) '-' fileBaseMat(end,[7 10:12 14 17:19]) ...
            fileExt '_' num2str(freqRange(1)) '-' num2str(freqRange(2)) 'Hz_Win' num2str(winLength) '_NW' num2str(NW) '_MazeRegionsSpeedPow.mat'];
     end
    fprintf('Saving %s\n', outname);
    matlabVersion = version;
    if str2num(matlabVersion(1)) > 6
        save(outname,'-V6','speedPowStruct');
    else
        save(outname,'speedPowStruct');
    end
end

return
plotChan = 41;
speed = [];
power = [];
group = [];
mazeRegionNames = fieldnames(speedPowStruct);
nPoints = size(speedPowStruct.returnArm.speed,1);
for k=1:2
speed = [speed; getfield(speedPowStruct,mazeRegionNames{k},'speed',{1:nPoints,1})];
power = [power; getfield(speedPowStruct,mazeRegionNames{k},'power',{1:nPoints,plotChan})];
group = [group; k*ones(size(getfield(speedPowStruct,mazeRegionNames{k},'speed',{1:nPoints,1})))];
end
aoctool(speed,power,group,0.05,'Speed','Log10(Power)');
