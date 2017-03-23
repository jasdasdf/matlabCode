%CheckCohereMeanBat01
analDirs = {...
    '/BEEF02/smm/sm9614_Analysis/analysis02/',...
    '/BEEF02/smm/sm9608_Analysis/analysis02',...
    '/BEEF01/smm/sm9601_Analysis/analysis03/',...
    '/BEEF01/smm/sm9603_Analysis/analysis04/',...
    }
animals = {...
    'sm9614',...
    'sm9608',...
    'sm9601',...
    'sm9603',...
    }

for j=1:length(analDirs)
    cd(analDirs{j})
    CheckCohereMean01(animals{j})
end