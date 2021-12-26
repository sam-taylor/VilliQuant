# VilliQuant
A tool for quantifying villus area in small intestine H&E images

## Requirements
<ul>
  <li>MATLAB - https://www.mathworks.com/products/matlab.html</li>
  <li>RGB Tiff images of swiss-rolled intestines with known scale</li>
  <li>Fiji - https://fiji.sc/</li>
</ul>

## Usage
Villi quantification proceeds in several steps
<ol>  
<li>Perform stain normalization on the images, if needed, using the included stain normalization toolbox: https://warwick.ac.uk/fac/cross_fac/tia/software/sntoolbox/</li>
  <li>Use MATLAB's interactive Color Thresholder tool on one image from the normalized set to create an RGB threshold which best distinguishes villi from non-villi areas</li>
<li>Export this function and name the file "villiMask" and add it to the working directory</li>
<li>Run the "ColorThresh.m" script in the VilliScripts folder and follow the prompts to select the folder containing the normalized input images and the desired output folder</li>
<li>The script will produce a results .csv file containing the area calculated for each image as well as the accompanying thresholded images</li>
<li>Check the images for any obvious artifacts/errors</li>
<li>Open the normalized images in Fiji and use the freehand draw tool to trace and then measure the entire length of the roll (follow the muscular tissue)</li>
<li>Repeat this for each image in the set--these values should be the same scale as the quantified areas</li>
<li>Divide the quantified areas by their respective gut section lengths and then convert this unit to um using the known scale (results should range from 100-500um for villi)</li>
</ol>

## Description
On appropriately processed tissues, this tool can vastly simplify and accelerate the analysis of villous hypertrophy. Since this method relies on the color values of 
the tissues analyzed, however, it should only be used to compare tissues processed with the same staining protocol and/or sections that have been stain-normalized to the 
same standard image.

See [https://www.nature.com/articles/s41586-021-03827-2] for details.


## Contact
Samuel Taylor: sat2031@med.cornell.edu
