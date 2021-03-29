
% Clear all previous data
clc, clear all, close all;
%% Display results of each method
verbose = 0;
[tarFilename, tarPathname] = uigetfile({'*.tif';'*.png';'*.jpg'}, 'Select Target Image');
TargetImage = imread(strcat(tarPathname, tarFilename));
gpuTargetImage = gpuArray(TargetImage);


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
for k = 1 : length(theFiles)
    baseFileName = theFiles(k).name;
    fullFileName = fullfile(myInput, baseFileName);
    fprintf(1, 'Now reading %s\n', fullFileName);
    SourceImage = imread(fullFileName);
    gpuSourceImage = gpuArray(SourceImage);
    % Now do whatever you want with this file name,
    % such as reading it in as an image array with imread()
    % imageArray = imread(fullFileName);
    % imshow(imageArray);  % Display image.
    % drawnow; % Force display to update immediately.
    %     disp('Stain Normalisation using Macenko''s Method');
    %     [ NormMM ] = Norm(SourceImage, TargetImage, 'Macenko', 255, 0.15, 1, verbose);
    %     [filepath,name,ext] = fileparts(fullFileName);
    %     outFileName = [myOutput, '\', name, '_NormMM', ext];
    %     imwrite([ NormMM ],outFileName,'tiff');
    %
    %     disp('Stain Normalisation using the Non-Linear Spline Mapping Method');
    %     [ NormSM ] = Norm(SourceImage, TargetImage, 'SCD', [], verbose);
    %     outFileName = [myOutput, '\', name, '_NormSM', ext];
    %     imwrite([ NormSM ],outFileName,'tiff');
    
    %% Stain Normalisation using RGB Histogram Specification Method
    
    disp('Stain Normalisation using Reinhard''s Method');
    %[ NormRH ] = Norm( SourceImage, TargetImage, 'Reinhard', verbose );
    [ NormRH ] = Norm( gpuSourceImage, gpuTargetImage, 'Reinhard', verbose );
    [filepath,name,ext] = fileparts(fullFileName);
    outFileName = [myOutput, '\', name, '_NormRH', ext];
    imwrite([ NormRH ],outFileName,'tiff');
    % perform k means clustering in the Lab space to find colors
    %lab_NormMM = rgb2lab(NormMM);
    %ab = lab_NormMM(:,:,2:3);
    %ab = im2single(ab);
    %rgb = im2single(NormMM);
    %nColors = 5;
    % repeat the clustering 3 times to avoid local minima
    %pixel_labels = imsegkmeans(ab,nColors,'NumAttempts',3);
    %imshow(pixel_labels,[])
    %title('Image Labeled by Cluster Index');
    
end
toc;

