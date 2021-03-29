
% Clear all previous data
clc, clear all, close all;

% Display results of each method
verbose = 0;

% Specify the folder where the files live.
startingFolder = pwd;% Whatever.
endingFolder = pwd;
myInput = uigetdir(startingFolder, 'Select Input Folder');
myOutput = uigetdir(endingFolder, 'Select Output Folder');
%%

% myFolder = 'E:\Microscopy\stain_normalisation_toolbox_v2_2\stain_normalisation_toolbox\Images';
% Check to make sure that folder actually exists.  Warn user if it doesn't.
if ~isdir(myInput)
    errorMessage = sprintf('Error: The following folder does not exist:\n%s', myInput);
    uiwait(warndlg(errorMessage));
    return;
end
% Get a list of all files in the folder with the desired file name pattern.
filePattern = fullfile(myInput, '*.tif'); % Change to whatever pattern you need.
theFiles = dir(filePattern);
tic;

count = [ ];
row_labels = [ ];

for k = 1 : length(theFiles)
    baseFileName = theFiles(k).name;
    fullFileName = fullfile(myInput, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);
    SourceImage = imread(fullFileName);
   
    %% make that threshold
   

    maskedImageVilli = villiMask(SourceImage);
    [filepath,name,ext] = fileparts(fullFileName);
    outFileName = [myOutput, '\', name, '_ColorThreshVilli', ext];
    imwrite(maskedImageVilli,outFileName,'tiff');
    
%     Note: if you want to include other thresholds in your analysis (e.g.
%     a "newMask" file which gives total intestine area) you can do so by
%     adding them to this script as below and including the new quantification in the "count" term. 

%     newMask = exampleMaskName(SourceImage);
%     [filepath,name,ext] = fileparts(fullFileName);
%     outFileName = [myOutput, '\', name, '_newMask', ext];
%     imwrite(newMask,outFileName,'tiff');
% 
%     count = [count; sum(maskedImageVilli(:)), sum(newMask(:))]

    count = [count; sum(maskedImageVilli(:))]
    row_labels = [row_labels; string(name)]
end
[Asorted, OrigColIdx] = sort(count,2);
counts = [Asorted, OrigColIdx];
T = array2table(counts, 'RowNames', row_labels);
outFileNameCSV = [myOutput, '\', 'Areas_ColorThresh.csv'];
writetable(T, outFileNameCSV, 'WriteRowNames',true);

toc;

