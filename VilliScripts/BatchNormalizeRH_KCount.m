
% Clear all previous data
clc, clear all, close all;

% Display results of each method
verbose = 0;
[tarFilename, tarPathname] = uigetfile({'*.tif';'*.png';'*.jpg'}, 'Select Target Image');
TargetImage = imread(strcat(tarPathname, tarFilename));

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
    [ NormRH ] = Norm( SourceImage, TargetImage, 'Reinhard', verbose );
    [filepath,name,ext] = fileparts(fullFileName);
    outFileName = [myOutput, '\', name, '_NormRH', ext];
    imwrite([ NormRH ],outFileName,'tiff');
    
    %%
    
    lab_NormRH = rgb2lab(NormRH);
    ab = lab_NormRH(:,:,2:3);
    ab = im2single(ab);
    % rgb = im2single(KClust);
    nColors = 4;
%     repeat the clustering 3 times to avoid local minima
    pixel_labels = imsegkmeans(ab,nColors,'NumAttempts',3);
    villi_epi_1 = pixel_labels == 1;
    villi_epi_2 = pixel_labels == 2;
    villi_epi_3 = pixel_labels == 3;
    villi_epi_4 = pixel_labels == 4;
    outFileName = [myOutput, '\', name, '_NormRH_K1', ext];
    imwrite(double((villi_epi_1)),outFileName,'tiff');
    outFileName = [myOutput, '\', name, '_NormRH_K2', ext];
    imwrite(double((villi_epi_2)),outFileName,'tiff');
    outFileName = [myOutput, '\', name, '_NormRH_K3', ext];
    imwrite(double((villi_epi_3)),outFileName,'tiff');
    outFileName = [myOutput, '\', name, '_NormRH_K4', ext];
    imwrite(double((villi_epi_4)),outFileName,'tiff');
    
    count = [count; sum(villi_epi_1(:)), sum(villi_epi_2(:)), sum(villi_epi_3(:)), sum(villi_epi_4(:))]
    row_labels = [row_labels; string(name)]
    
    %% perform k means clustering in the Lab space to find colors

%     [tarFilename, tarPathname] = uigetfile({'*.tif';'*.png';'*.jpg'}, 'Select Target Image');
%     KClust = imread(strcat(tarPathname, tarFilename));
%     lab_KClust = rgb2lab(KClust);
%     ab = lab_KClust(:,:,2:3);
%     ab = im2single(ab);
%     % rgb = im2single(KClust);
%     nColors = 4;
%     % repeat the clustering 3 times to avoid local minima
%     pixel_labels = imsegkmeans(ab,nColors,'NumAttempts',3);
%     villi_epi_3 = pixel_labels == 3;
%     imshow(villi_epi_3,[])
%     title('Image Labeled by Cluster Index');

end
[Asorted, OrigColIdx] = sort(count,2);
counts = [Asorted, OrigColIdx];
T = array2table(counts, 'RowNames', row_labels);
outFileNameCSV = [myOutput, '\', 'Areas_NormRHK.csv'];
writetable(T, outFileNameCSV, 'WriteRowNames',true);

toc;

