# goggleViewer README and Quickstart#


### What does goggleViewer do? ###

* goggleViewer is an experimental image viewer, designed for large (>100GB) 3D image datasets.
* It works by creating a downsampled stack, which is then navigated as you would a regular 3D image stack. 
* However, the program pulls data from the hard disk to a cache when zoomed in, allowing all the original detail to be viewed
* A plugin class can be easily subclassed to create user-defined plugins. For example, a cell counter plugin is included.

### What kind of data can I view in goggleViewer? ###

* In theory, goggleViewer should work with *any* 3d image set, stored in disk in individual xy planes saved as .tif images
* goggleViewer has been designed to accept the standard output of the tvpy stitching package for serial two-photon tomography images
* Creating such an output for images generated by other packages should not be difficult. goggleViewer works nicely with tvmat stitched image files too (I'm told...)

### How do I get set up? ###

* Clone the repo and add to the MATLAB path
* Dependencies:
    * MATLAB
        * Image Processing Toolbox
        * Parallel Processing Toolbox
        * Statistics Toolbox
    * [Subpixel Registration](http://www.mathworks.com/matlabcentral/fileexchange/18401-efficient-subpixel-image-registration-by-cross-correlation)
* Run 'goggleViewer'

### Using goggleViewer ###
1. If data were stitched with tvMat. CD to data directory in MATLAB and run tvMat2goggleList('stitchedImages_100') or whatever the directory name is.
The purpose of this is to produce a text file containing a list of all of the stitched image slices in your data set. 
2. From the MATLAB command line run 'goggleViewer'
3. With the GUI windows that pops up, select the base path of the stitched experiment you would like to view. This is the directory that contains the master Mosaic file, the stitched images sub-directory, and the text files you made in the first step. 
4. If you have already run goggleViewer on this data set you will be able to select the down-sampled stack to work with. 
5. If you have not previously run goggleViewer you will need to generate a down-sampled stack. This is done as follows:

 - Select 'New'
 - Select the channel (these appear by virtue of the text files you generated)
 - Specify which slices to use. For example, to use every 3rd slice (in an experiment with 3000 slices), the correct settings would be 1, 3, 3000
 - Specify downsampling factor in XY. 10 works nicely for Alex. A reasonable starting point would be a downsampling factor that will reduce the size of the images to one roughly the number of pixels on your monitor. If the stitched images are 10,000 pixels wide, and your monitor has 1600x1200 pixels, a factor of 6-7 would be about right.
  - The downsampled stack will be created and saved to disk, then the viewer will open.

** A note on the preferences file **

If you are working on a multi-user analysis machine you will want to have a copy of the goggleViewer preferences in your home directory. If you use the version in the goggleViewer source directory then you risk running into permissions issues or having your preferences overwritten by another user. Simply copy the gogglePrefs.yml file to a directory in your path that you have write access to and that is higher up the path hierarchy then the goggleViewer  directories. Type "path" into the prompt. You may find that your user directory is already at the top of the list, in which case you can create a copy there. goggleViewer will then automatically use this copy.


### This is crap, it doesn't work ###

* Email alex