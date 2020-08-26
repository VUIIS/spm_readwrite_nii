# spm_readwrite_nii


This is the 1% of the SPM12 Matlab r7487 code that is needed to read and write data and headers of Nifti files. The purpose of this is to provide a reliable tool to use Nifti files in Matlab when the rest of SPM isn't needed.

SPM12 info: http://www.fil.ion.ucl.ac.uk/spm/software/spm12/

SPM12 license: See LICENCE.txt


## Files included from the SPM distribution

     spm_vol.m
        spm_fileparts.m
        spm_existfile.m*
        spm_unlink.m*
        spm_vol_nifti.m
        @nifti/*
	@file_array/*
     spm_read_vols.m
        spm_check_orientations.m
           spm_mesh_detect.m
        spm_slice_vol.m*
        spm_matrix.m
        spm_type.m
     spm_write_vol.m
        spm_create_vol.m
	   spm_file.m
	spm_write_plane.m


## Usage

Also see the help text for the various functions. Compressed nifti files (`.nii.gz`) can generally be read, but not written. Matlab's gzip function can be applied to written `.nii` files if desired.

### Single 3D or 4D .nii

    # Read a single 3D or 4D nifti file
    fname = 'image.nii';
    V = spm_vol(fname);
	[Y,XYZ] = spm_read_vols(V);
	
	# If it's a 4D series like fMRI, we can reshape to a 2D time x voxel
	# matrix, which is often useful for processing
	origsize = size(Y);
	Yr = reshape(Y,[],origsize(4))';
	
	# Then we can reshape it back later to be ready to write to file
	Yout = reshape(Yr,)
	


V contains information about the Nifti file(s) in an SPM-specific format.
Y contains image data.
XYZ contains world space coordinates in mm.


To write a data matrix Y, update an existing V with new filenames, 
or create V from scratch, and

>> spm_write_vol(V,Y);


