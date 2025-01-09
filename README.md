# spm_readwrite_nii

https://github.com/VUIIS/spm_readwrite_nii

This is the 1% of the SPM12 Matlab code that is needed to read and write 
data and headers of Nifti files. The purpose of this is to provide a reliable 
tool to use Nifti files in Matlab when the rest of SPM isn't needed.

Source is https://github.com/spm/spm12/tree/c28485d, which is SPM12 r7771
but updated for Mac Silicon binaries. This version has not been actually 
released as of 2024 Mar 28.

SPM12 info: http://www.fil.ion.ucl.ac.uk/spm/software/spm12/

SPM12 license: See LICENCE.txt

For newer Macs, execute permissions can be granted all at once with this
command in Terminal:

    sudo xattr -dr com.apple.quarantine <path>

Where `<path>` is the base path where this code was installed.


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

Also see the help text for the various functions. Compressed nifti files 
(`.nii.gz`) can generally be read on linux, but not written. Matlab's gzip 
function can be applied to written `.nii` files if desired.

### Single 3D .nii

    % Read a single 3D nifti file. V contains Nifti header information in 
    % an SPM-specific format. Y contains the image data after applying the 
    % header scaling factor. XYZ contains world space coordinates in mm, 
    % computed from the Nifti header sform/qform.
    fname = 'image.nii';
    V = spm_vol(fname);
    [Y,XYZ] = spm_read_vols(V);

### Single 4D .nii

    % If it's a 4D series like fMRI, we can reshape to a 2D time x voxel
    % matrix, which is often useful for processing
    origsize = size(Y);
    numvols = origsize(4);
    Yr = reshape(Y,[],numvols)';
    
    % Then we can reshape it back later to be ready to write to file
    Yout = reshape(Yr',origsize);
    
    % To write, we set a filename, then we have to write a single volume 
    % at a time.    
    outfname = 'processed_image.nii';
    
    for v = 1:numvols
    
        % Re-use the original V to get correct headers, but remove
        % the scaling info so SPM can rescale appropriately. Same 
        % scale factor is used for all volumes.
        thisV = rmfield(V(v),'pinfo');
        
        % Choose a data type. float32 is a good compromise between
        % low digitization error and small file size
        thisV.dt(1) = spm_type('float32');
        
        % Alternatively, for integer valued data like ROI images, we
        % should NOT let SPM autoscale, because it may store not-quite-integer
        % values. Instead fix the scaling factor at 1 and use an integer 
        % datatype
        %thisV = V(v);
        %thisV.pinfo(1:2) = [1;0];
        %thisV.dt(1) = spm_type('uint16');
        
        % Don't forget to set the filename so we don't overwrite existing
        thisV.fname = outfname;
        
        % And write this volume
        spm_write_vol(thisV,Yout(:,:,:,v));
        
    end

