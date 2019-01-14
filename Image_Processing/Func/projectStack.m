%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Max-intensity projection of 3D stack over time
% parameterDatabase includes the following parameters % generated by Image_Processing_v1_1
% timepoints: range of time points
% inputFilePattern: patterns of input files with time points replaced by '?' 
% periodStart: array of start of periods
% nPeriod: total number of time period
% outputFolder: location of outputfiles
% timeWindow: number of time points to be projected, downsampling rate
%
%
% -------------------------------------------------------------------------
% Yinan Wan
% wany@janelia.hhmi.org
%

function projectStack(parameterDatabase, i)
load(parameterDatabase);
start = periodStart(i);
t = start: min(start + timeWindow-1, timepoints(end));

disp(['Processing period TM' num2str(t(1), '%.6d') ' to TM' num2str(t(end), '%.6d')]);

maxStack = readImage(recoverFilenameFromPattern(inputFilePattern, t(1)));
for j = 2:numel(t)
    stack = readImage(recoverFilenameFromPattern(inputFilePattern, t(j)));
    maxStack = max(maxStack, stack);
end
[~, ~, fileExtension] = fileparts(inputFilePattern);
writeImage(maxStack, [outputFolder '\Period_TM' num2str(i-1, '%.6d') fileExtension]);