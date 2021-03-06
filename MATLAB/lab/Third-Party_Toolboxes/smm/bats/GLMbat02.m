analDirs = {...
    '/BEEF01/smm/sm9601_Analysis/2-16-04/analysis/',...
    '/BEEF01/smm/sm9603_Analysis/3-21-04/analysis/',...
    '/BEEF02/smm/sm9608_Analysis/7-17-04/analysis/',...
    '/BEEF02/smm/sm9614_Analysis/4-17-05/analysis/',...
    }

analDirs = {...
    '/BEEF01/smm/sm9601_Analysis/2-13-04/analysis/',...
    '/BEEF01/smm/sm9601_Analysis/2-14-04/analysis/',...
    '/BEEF01/smm/sm9601_Analysis/2-15-04/analysis/',...
    '/BEEF01/smm/sm9601_Analysis/2-16-04/analysis/',...
    '/BEEF01/smm/sm9603_Analysis/3-20-04/analysis/',...
    '/BEEF01/smm/sm9603_Analysis/3-21-04/analysis/',...
    '/BEEF02/smm/sm9608_Analysis/7-15-04/analysis/',...
    '/BEEF02/smm/sm9608_Analysis/7-16-04/analysis/',...
    '/BEEF02/smm/sm9608_Analysis/7-17-04/analysis/',...
    '/BEEF02/smm/sm9614_Analysis/4-16-05/analysis/',...
    '/BEEF02/smm/sm9614_Analysis/4-17-05/analysis/',...
%     '/BEEF02/smm/sm9608_Analysis/7-15_16_17-04/analysis/',...
%     '/BEEF02/smm/sm9608_Analysis/7-15_16-04/analysis/',...
  '/BEEF02/smm/sm9608_Analysis/7-15_17-04/analysis/',...
    '/BEEF03/smm/KenjiData/ec013_Analysis/ec013.50/analysis/',...
    '/BEEF03/smm/KenjiData/ec014.27/analysis/',...
    '/BEEF03/smm/KenjiData/ec014_Analysis/ec014.16/analysis/',...
    '/BEEF03/smm/KenjiData/ec013_Analysis/ec013.46/analysis/',...
    '/BEEF03/smm/KenjiData/ec014_Analysis/ec014.17/analysis/',...
    }

analDirs = {...
    '/BEEF03/smm/drugs/DrugsAnal/sm9608_448-455/analysis/',...
    '/BEEF03/smm/drugs/DrugsAnal/sm9614_564-575/analysis/',...
    '/BEEF03/smm/drugs/DrugsAnal/sm9614_544-557/analysis/',...
    }
 fileExtCell = {...
                  '.eeg',...
                 '_LinNearCSD121.csd',...
                 '.csd1',...
                 '.csd111',...
%                   '_NearAveCSD1.csd',...
                }
            
spectAnalBase = {...
    'CalcRunningSpectra12_noExp_MidPoints_MinSpeed0Win626wavParam8',...
    'CalcRunningSpectra12_noExp_MidPoints_MinSpeed0Win626wavParam4',...
    'RemVsRun05_noExp_MinSpeed5wavParam6Win1250',...
    'RemVsRun04_noExp_MinSpeed5wavParam6Win1250',...
    'RemVsRun04_allTheta_MinSpeed5wavParam6Win1250',...
     'RemVsRun04_allTheta_MinSpeed0wavParam6Win1250',...
   'RemVsRun03_noExp_MinSpeed5wavParam6Win1250'...
   'CalcRunningSpectra14_noExp_MinSpeed5wavParam6Win1250',... %btwn 250 and 400 trials on maze
   'CalcRunningSpectra15_noExp_MinSpeed5wavParam6Win1250',... %used for unit calculation (includes all times)ls
   'CalcRemSpectra06_allTimes_wavParam6Win1250',... %good for units and spectra
   'RemVsRun06_allTheta_MinSpeed5wavParam6Win1250',... % CalcRunningSpectra14 & CalcRemSpectra06
   'RemVsRun07_allTheta_MinSpeed5wavParam6Win1250',... % CalcRunningSpectra15 & CalcRemSpectra06
    }

depVarCell = {...
                 'powSpec',...
                 'cohSpec',...
                 'phaseSpec',...
                  'thetaPowIntg6-12Hz',...
                'gammaPowIntg40-120Hz',...
                
                  'gammaPowIntg40-100Hz',...
                  'gammaPowIntg50-100Hz',...
                  'gammaPowIntg50-120Hz',...
                  'gammaPowIntg60-120Hz',...

                  'thetaCohMean6-12Hz',...
                  'gammaCohMean40-120Hz',...
                 'thetaPhaseMean6-12Hz',...
                 'gammaPhaseMean40-120Hz',...
                 
                 'thetaFreq6-12Hz',...
                 'gamma40-120HzComodPhaseSpec',...
                 
                  'thetaPowIntg4-12Hz',...
                'gammaPowIntg40-120Hz',...
                 'thetaCohMean4-12Hz',...
                 'gammaCohMean40-120Hz',...
                 'thetaPhaseMean4-12Hz',...
                 'gammaPhaseMean40-120Hz',...
                 
                 'thetaFreq4-12Hz',...

    'gammaCohMean40-120Hz.ECs',...
    'gammaCohMean40-120Hz.ECsm',...
    'gammaCohMean40-120Hz.ECdm',...
    'gammaCohMean40-120Hz.ECd',...
    'gammaCohMean40-120Hz.CA1p',...
    'thetaCohMean4-12Hz.ECs',...
    'thetaCohMean4-12Hz.ECsm',...
    'thetaCohMean4-12Hz.ECdm',...
    'thetaCohMean4-12Hz.ECd',...
    'thetaCohMean4-12Hz.CA1p',...
                 
                 %                 'thetaPowPeak6-12Hz',...
%                  'gammaPowIntg60-120Hz',...
%                   'gammaCohMean60-120Hz',...
%                 'thetaPowIntg6-12Hz',...
%                 'thetaCohMean6-12Hz',...
%                   'thetaPhaseMean6-12Hz',...
%                  'gammaPhaseMean60-120Hz',...
                 
%                 'thetaCohPeakLMF6-12Hz',...
                %'gammaPowPeak60-120Hz',...
                %'thetaCohPeakSelChF6-12Hz',...
                %'thetaCohMedian6-12Hz',...
                %'gammaCohMedian60-120Hz',...
                }
            
analRoutine = {...
     'AlterGood_MRrctg_ThetaFreqLM',...
     'MazeCenter_TT_ThetaFreqLM',...
     'AlterGood_MRrctg',...
     'AlterGood_S0_A0_MRrctg',...
     'MazeCenter_TT',...
     'MazeCenter_S0_A0_TT',...
     'AlterGood_MRrdctg',...
     'AlterGood_S0_A0_MRrdctg',...
     'AlterGood_MRcVrtg',...
     'AlterGood_MRcVrtgEqN',...
     ...
     'AlterCenter_S0_A0_E',...
     'AlterAll_S0_A0_E_MRrctg',...
     'AlterAll_S0_A0_E_MRrctg_ExMRrctg',...
     'AlterGood_S0_A0_RL_MRrctg',...
     'AlterGood_S0_A0_RL_MRrctg_RLxMRrctg',...
     'ControlGood_MRrctg',...
     'ControlGood_S0_A0_MRrctg',...
     'MazeAll_S1000by250e_A1000by250e',...
     ...
     'AlterGood_MRrdctgw',...
     'AlterGood_S0_A0_MRrdctgw',...
     'AlterGood_MRrctgw',...
     'AlterGood_S0_A0_MRrctgw',...
                'MazeCenterGP_TT',...
                'MazeCenterGP_S0_A0_TT',...
%      'RemVsDrugMaze_DrugBeh',...,...I will try to think carefully about the bare minimum of things that need some timing flexibility and how to automate the rest so there is good flow.
%      'RemVsMaze_Beh',...
%      'RemVsMazeGood_Beh',...
%      'RemVsMaze_Beh_ThetaFreqLM',...
%     'RemVsMaze_Beh_ThetaFreqLM_X',...
%     'Rem_ThetaFreqLM',...
%     'Maze_ThetaFreqLM',...
%    'RemVsMaze_BehXThetaFreqLM',...
    };

TrialDesigLists09(analRoutine,analDirs)

for n=1:length(spectAnalDir)
    for m=1:length(analRoutine)
        for j=1:length(fileExtCell)
            for k=1:length(analDirs)
                cd(analDirs{k})
%                  try
                    GlmWholeAnalysisBatch08(spectAnalDir{n},analRoutine{m},'01',fileExtCell{j},depVarCell)
%                     GlmWholeAnalysisBatch07('RemVsRun01_noExp',analRoutine{m},'01',fileExtCell{j},depVarCell,[],0,0,1250,1)
%                  catch
%                      ReportError(['ERROR:  ' date '  GLMbat02bat  ' analDirs{k}  spectAnalDir{n}  fileExtCell{j} '  ' analRoutine{m} '\n']);
%                  end
             end
        end
    end
end


animalDirs = {...
    {'/BEEF01/smm/sm9601_Analysis/2-13-04/analysis/',...
    '/BEEF01/smm/sm9601_Analysis/2-14-04/analysis/',...
    '/BEEF01/smm/sm9601_Analysis/2-15-04/analysis/',...
    '/BEEF01/smm/sm9601_Analysis/2-16-04/analysis/'},...
    {'/BEEF01/smm/sm9603_Analysis/3-20-04/analysis/',...
    '/BEEF01/smm/sm9603_Analysis/3-21-04/analysis/'},...
    {'/BEEF02/smm/sm9608_Analysis/7-15-04/analysis/',...
    '/BEEF02/smm/sm9608_Analysis/7-16-04/analysis/'},...
    {'/BEEF02/smm/sm9614_Analysis/4-16-05/analysis/',...
    '/BEEF02/smm/sm9614_Analysis/4-17-05/analysis/'},...
    }

animalDirs = {...
    {'/BEEF01/smm/sm9603_Analysis/3-21-04/analysis/'},...
    {'/BEEF02/smm/sm9608_Analysis/7-17-04/analysis/'},...
    {'/BEEF02/smm/sm9614_Analysis/4-17-05/analysis/'},...
    }

animalDirs = {...
    {'/BEEF01/smm/sm9601_Analysis/2-13-04/analysis/'},...
    {'/BEEF01/smm/sm9601_Analysis/2-14-04/analysis/'},...
    {'/BEEF01/smm/sm9601_Analysis/2-15-04/analysis/'},...
    {'/BEEF01/smm/sm9601_Analysis/2-16-04/analysis/'},...
    }
animalDirs = {...
    {'/BEEF01/smm/sm9603_Analysis/3-20-04/analysis/'},...
    {'/BEEF01/smm/sm9603_Analysis/3-21-04/analysis/'},...
    }
animalDirs = {...
    {'/BEEF02/smm/sm9608_Analysis/7-15-04/analysis/'},...
    {'/BEEF02/smm/sm9608_Analysis/7-16-04/analysis/'},...
     {'/BEEF02/smm/sm9608_Analysis/7-17-04/analysis/'},...
    }
animalDirs = {...
    {'/BEEF02/smm/sm9614_Analysis/4-16-05/analysis/'},...
    {'/BEEF02/smm/sm9614_Analysis/4-17-05/analysis/'},...
    }
animalDirs = {...
    {'/BEEF02/smm/sm9608_Analysis/7-15_16_17-04/analysis/'},...
    }
animalDirs = {...
    {'/BEEF02/smm/sm9608_Analysis/7-15_16-04/analysis/'},...
    }
animalDirs = {...
    {'/BEEF03/smm/KenjiData/ec013_Analysis/ec013.46/analysis/'}...
    {'/BEEF03/smm/KenjiData/ec014_Analysis/ec014.17/analysis/'}...
    }


depVarRefLayer = '.ca3Pyr'

chanLocVersion = {...
    'Min',...
%    'Full',...
    }

scaleCell = {...
     {[0 1],[-0.05 0.05],[-0.05 0.05]},...    
    {[0 1],[-3.5e-3 3.5e-3],[-7e-4 7e-4],[-0.05 0.05],[-0.05 0.05]},...
     {[0 1],[-0.05 0.05],[-0.05 0.05]},...    
    {[0 1],[-3.5e-3 3.5e-3],[-7e-4 7e-4],[-0.05 0.05],[-0.05 0.05]},...

    {[0 100],[-1 1],[-1 1]},...    
    {[0 100],[-0.02 0.02],[-0.01 0.01],[-1 1],[-1 1]},...
     {[0 100],[-1 1],[-1 1]},...    
    {[0 100],[-0.02 0.02],[-0.01 0.01],[-1 1],[-1 1]},...
    
    []
    {[0 1],[-3.5e-3 3.5e-3],[-7e-4 7e-4],[-0.02 0.02],[-0.02 0.02]},...

    }

saveDir = ...
    'MazePaper/EachAnimal/sm9608_15_16_17merge/'
    'MazePaper/EachAnimal/sm9608_15_16merge/'
    'MazePaper/EachAnimal/sm9608newAll/'
    'REMPaper/EC_02/'

reportFigBool = ...
    0
    1

statAlpha = ...
    0.05
    0.001

for n=1:length(spectAnalDir)
    for k=1:length(chanLocVersion)
        for m=1:length(analRoutine)
            for j=1:length(fileExtCell)
%                 try
%                 PlotGLMResultsBatch08('GlmWholeModel08',[analRoutine{m} '_01'],{[depVarCell{1} repmat(depVarRefLayer,size(depVarCell))]} ,spectAnalDir{n},fileExtCell{j},0,'linear',1)
%                 PlotGlmCoh09(depVarCell,spectAnalDir{n},fileExtCell{j},chanLocVersion{k},[analRoutine{m} '_01'],animalDirs,scaleCell{m},reportFigBool,[],saveDir,statAlpha,1,1)
               PlotGlmBarh04(depVarCell,spectAnalDir{n},fileExtCell{j},chanLocVersion{k},[analRoutine{m} '_01'],animalDirs,scaleCell{m},reportFigBool,[],saveDir,statAlpha)
%                PlotGlmScat10(depVarCell,spectAnalDir{n},fileExtCell{j},chanLocVersion{k},[analRoutine{m} '_01'],animalDirs,scaleCell{m},reportFigBool,[],saveDir,statAlpha)
                %try
                 %PlotGLMResults07('GlmWholeModel07',[analRoutine{1} '_01'],depVarCell{1},fileExtCell{1},0,'linear',1)
                %PlotGLMResults07('GlmWholeModel07','RemVsMaze_Beh_01','gammaPowIntg40-100Hz','.eeg',0,'linear',1)
               %PlotGlmScat08('Min',depVarCell,fileExtCell{j},[analRoutine{m} '_01'],animalDirs,'GlmWholeModel05/','MazePaper/new/',0)
                %         catch end
                %            try
                %                  PlotGlmBarh02('Min',depVarCell,fileExtCell{j},[analRoutine{m} '_01'],animalDirs,'GlmWholeModel05/','MazePaper/new/')
                %           catch end
                %         try
                %             PlotGlmCoh07('Min',depVarCell,fileExtCell{j},[analRoutine{m} '_01'],animalDirs,'GlmWholeModel05/','MazePaper/new/')
                %         catch end
                %        try
                %              PlotGlmPhase06('Perp',depVarCell,fileExtCell{j},[analRoutine{m} '_01'],animalDirs)
                %        catch end
%                 end
            end
        end
    end
end

PlotBehavHist02(animalDirs,depVarCell{1},'.eeg',spectAnalDir{1},analRoutine{1})

ReportFigSM([],['NewFigs/GlmWholeModel08/' analRoutine{1} '/' Dot2Underscore(fileExtCell{1}) '/'])

MakeGLMBetaR2SummaryReport(analRoutine,'_01',spectAnalDir,fileExtCell,depVarCell,plotTypeCell,figNums)

RmGLMPlots(chanLocVersion,analRoutine,'_01',spectAnalDir,fileExtCell,'*PhaseMean*')
 
ReportFigSM([],['NewFigs/GlmWholeModel08/' analRoutine{1} '/' Dot2Underscore(fileExtCell{1}) '/'])

PlotBehavAnatMap04(depVarCell{1},fileExtCell{1},spectAnalDir{1},analRoutine{1})

PlotGLMResults08('GlmWholeModel08',[analRoutine{1} '_01'],depVarCell{1},spectAnalDir{1},fileExtCell{1},0,'linear',0,[-0.05 0.05])

% PlotBehavAnatMap02(depVarCell{1},fileExtCell{1},spectAnalDir{1},analRoutine{1},[])

% PlotBehavPowerSpectra03(depVarCell{1},fileExtCell{1},spectAnalDir{1},analRoutine{1})

PlotBehavPowerSpectra04(depVarCell{1},fileExtCell{1},spectAnalDir{1},analRoutine{1},[],1,0,[35 75]) 

PlotBehavCohSpectra01(depVarCell{1},fileExtCell{1},spectAnalDir{1},analRoutine{1})

PlotBehavPhaseSpectra03(depVarCell{1},fileExtCell{1},spectAnalDir{1},analRoutine{1})

GlmWholeModel05(dataDescription,analRoutine,outNameNote,fileExt,depVar,varargin)
GlmWholeModel05(analProgName,analRoutine,nameNote,fileExt,'thetaPowPeak4-12Hz',nchan,0,varargin)

PlotBehavIndepVsDepScat01('speed.p0',depVarCell{1},fileExtCell{1},spectAnalDir{1},analRoutine{1})

dataStruct = GlmResultsLoad01(depVarCell{1},chanLocVersion{1},spectAnalDir{1},fileExtCell{2},[analRoutine{1} '_01'],animalDirs,'GlmWholeModel08',0);
dataStruct = GlmResultsCatAnimal(dataStruct,0,'pow');
dataStruct = GlmResultsLoad01(depVarCell{1},chanLocVersion{1},spectAnalDir{1},fileExtCell{1},[analRoutine{1} '_01'],analDirs,'GlmWholeModel08',1);
dataStruct = GlmResultsCatAnimal(dataStruct,1,'coh');
anatNames = fieldnames(LoadVar([analDirs{1}{1} 'ChanInfo/ChanLoc_' chanLocVersion{1} fileExtCell{1}]));
GlmResultsMultCompare01(dataStruct.coeffs.task_alter,anatNames);

GlmWholeModel05(analProgName,analRoutine,nameNote,files,fileExt,['thetaCohMedian4-12Hz' selChanName],nchan,0,varargin)
GlmWholeModel05(dataDescription,analRoutine,outNameNote,fileExt,depVar,varargin)
[nChan,freqBool,maxFreq,midPointsBool,minSpeed,winLength] ...
    = DefaultArgs(varargin,{96,0,150,1,0,626});

PlotBehavPhaseScat01(analDirs,depVarCell{1},fileExtCell{1},spectAnalDir{1},analRoutine{1},'PhasePaper/EachAnimal/sm9603/')

for j=1:14
    set(j,'position',[2 2 6 6])
    set(j,'paperposition',[2 2 6 6])
end

TrialDesigLists09(analRoutine,analDirs)

analRoutine = {...
                'RemVsThetaFreqSelCh1_01'...
                'RemVsRun_01'...
                'RemVsRun_allTrials_01'...
                'RemVsRun_thetaFreqSelCh1_01'...
                'RemVsRun_thetaFreqSelCh1_allTrials_01'...
                'RemVsRunXthetaFreqSelCh1_01'...
                'RemVsRunXthetaFreqSelCh1_allTrials_01'...
                'RemVsRun_thetaFreqSelCh1_X_01'...
                'RemVsRun_thetaFreqSelCh1_X_allTrials_01'...
                'Maze_PCP',...
                'Maze_Scopolamine',...
                'AlterGood_S0_A0_MRall',...
                'AlterGood_MRrctg',...
                'AlterGood_MRrctg_ThetaFreqLM'
                'AlterCenter_S0_A0_E',...
                'AlterGood_S0_A0_MRrdctgw',...
                'AlterGood_MRrctgw',...
                'AlterGood_S0_A0_MRrctgw',...
                'MazeCenterGP_TT',...
                'MazeCenterGP_S0_A0_TT',...
                'RemVsMaze_All',...
                'RemVsMaze_SpeedGE5',...
                'RemVsMaze_SpeedGE5old',...
                'TonicVsPhasic_SD1.5_R2',...
                };
for j=1:length(analRoutine)
    PlotGlmScat03('Min',analRoutine{j});
end



analDirs = {...
            '/BEEF02/smm/sm9614_Analysis/analysis02/',...
            '/BEEF02/smm/sm9608_Analysis/analysis02',...
            '/BEEF01/smm/sm9601_Analysis/analysis03/'...
            '/BEEF01/smm/sm9603_Analysis/analysis04/'...
            }
for k=1:length(analDirs)
    cd(analDirs{k});
    CalcPartCoh01([LoadVar('MazeFiles');LoadVar('RemFiles')],{'.eeg'},[4 12],[60 120]);
end


for j=1:length(analDirs)
    cd(analDirs{j})
    %RecalcThetaGammaRange03(LoadVar('MazeFiles'),fileExtCell,[6 12],[]);
    %RecalcThetaGammaRange03(LoadVar('MazeFiles'),fileExtCell,[],[40 60]);
    %RecalcThetaGammaRange03(LoadVar('MazeFiles'),fileExtCell,[],[40 100]);
    RecalcThetaGammaRange03(LoadVar('FileInfo/MazeFiles'),fileExtCell,[],[40 120],'CalcRunningSpectra12_noExp_MidPoints_MinSpeed0Win626wavParam4');
    RecalcThetaGammaRange03(LoadVar('FileInfo/MazeFiles'),fileExtCell,[],[50 100],'CalcRunningSpectra12_noExp_MidPoints_MinSpeed0Win626wavParam4');
    RecalcThetaGammaRange03(LoadVar('FileInfo/MazeFiles'),fileExtCell,[],[50 120],'CalcRunningSpectra12_noExp_MidPoints_MinSpeed0Win626wavParam4');
    %RecalcThetaGammaRange03(LoadVar('MazeFiles'),fileExtCell,[],[60 120]);
end




