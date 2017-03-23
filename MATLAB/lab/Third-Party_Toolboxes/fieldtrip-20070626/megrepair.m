function [interp] = megrepair(cfg, data);

% MEGREPAIR repairs bad channels in MEG data by replacing them
% with the average of its neighbours. It cannot be used reliably to
% repair multiple bad channels that ly next to each other. It accepts
% input data from the PREPROCESSING or TIMELOCKANALYSIS functions.
%
% Use as
%   [interp] = megrepair(cfg, data)
%
% The configuration can contain
%   cfg.badchannel     = cell-array, see CHANNELSELECTION for details
%   cfg.neighbourdist  = default is 4 cm 
%
% See also MEGINTERPOLATE

% Copyright (C) 2004, Robert Oostenveld
%
% $Log: megrepair.m,v $
% Revision 1.13  2007/05/02 15:59:13  roboos
% be more strict on the input and output data: It is now the task of
% the private/checkdata function to convert the input data to raw
% data (i.e. as if it were coming straight from preprocessing).
% Furthermore, the output data is NOT converted back any more to the
% input data, i.e. the output data is the same as what it would be
% on raw data as input, regardless of the actual input.
%
% Revision 1.12  2007/04/03 15:37:07  roboos
% renamed the checkinput function to checkdata
%
% Revision 1.11  2007/03/30 17:05:40  ingnie
% checkinput; only proceed when input data is allowed datatype
%
% Revision 1.10  2007/03/27 11:05:19  ingnie
% changed call to fixdimord in call to checkinput
%
% Revision 1.9  2006/02/23 10:28:16  roboos
% changed dimord strings for consistency, changed toi and foi into time and freq, added fixdimord where neccessary
%
% Revision 1.8  2005/06/29 12:46:29  roboos
% the following changes were done on a large number of files at the same time, not all of them may apply to this specific file
% - added try-catch around the inclusion of input data configuration
% - moved cfg.version, cfg.previous and the assignment of the output cfg to the end
% - changed help comments around the configuration handling
% - some changes in whitespace
%
% Revision 1.7  2005/06/02 12:18:41  roboos
% changed handling of input data: All input data that contains averages is converted to raw trials (like the output from preprocessing) prior to further processing. The output data is converted back into a format similar to the original input data using RAW2MEG.
%
% Revision 1.6  2004/08/23 06:34:58  roboos
% fixed bug in output labels
%
% Revision 1.5  2004/05/05 13:55:20  roberto
% fixed bug that occured when average data was made with keeptrials=yes
%
% Revision 1.4  2004/04/13 16:31:09  roberto
% fixed bug in dbstack selection of function filename for Matlab 6.1
%
% Revision 1.3  2004/04/13 14:25:24  roberto
% wrapped code-snippet around mfilename to make it compatible with Matlab 6.1
%
% Revision 1.2  2004/04/06 20:12:07  roberto
% Note: The previous revision was not just copy-and-paste from meginterpolate,
% but was actually a complete rewrite of the function. This current revision
% has only changes in help and comments.
%
% Revision 1.1  2004/04/06 20:01:49  roberto
% created new implementation by moving all functionality from meginterpolate to this function
%

% check if the input data is valid for this function
data = checkdata(data, 'datatype', 'raw', 'feedback', 'yes');

% set the default configuration 
if ~isfield(cfg, 'neighbourdist'), cfg.neighbourdist = 4;         end
if ~isfield(cfg, 'badchannel'),    cfg.badchannel = {};           end

Ntrials = length(data.trial);
Nchans = length(data.label);
Ngrad  = length(data.grad.label);

% get the selection of channels that are bad
cfg.badchannel = channelselection(cfg.badchannel, data.label);

repair = eye(Nchans,Nchans);
[badindx] = match_str(data.label, cfg.badchannel);

for k=badindx(:)'
  fprintf('repairing channel %s\n', data.label{k}); 
  repair(k,k) = 0;
  
  gradindx = match_str(data.grad.label, data.label{k});
  for l=setdiff(1:Ngrad, gradindx)
    distance = norm(data.grad.pnt(l,:)-data.grad.pnt(gradindx,:));
    if distance<cfg.neighbourdist
      % include this channel as neighbour, weigh with inverse distance
      repair(k,l) = 1/distance;
      fprintf('  using neighbour %s\n', data.grad.label{l});
    end
  end
  
  % normalise the repair matrix to unit weight
  repair(k,:) = repair(k,:) ./ sum(repair(k,:));
end

% use sparse matrix to speed up computations
repair = sparse(repair);

% compute the repaired data for each trial
for i=1:Ntrials
  fprintf('repairing bad channels for trial %d\n', i);
  interp.trial{i} = repair * data.trial{i};
end

% store the realigned data in a new structure
interp.label   = data.label;
interp.grad    = data.grad;
interp.fsample = data.fsample;
interp.time    = data.time;

% store the configuration of this function call, including that of the previous function call
try
  % get the full name of the function
  cfg.version.name = mfilename('fullpath');
catch
  % required for compatibility with Matlab versions prior to release 13 (6.5)
  [st, i] = dbstack;
  cfg.version.name = st(i);
end
cfg.version.id   = '$Id: megrepair.m,v 1.13 2007/05/02 15:59:13 roboos Exp $';
% remember the configuration details of the input data
try, cfg.previous = data.cfg; end
% remember the exact configuration details in the output 
interp.cfg = cfg;
