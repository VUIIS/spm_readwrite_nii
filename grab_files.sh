#!/usr/bin/env bash

# Check out the spm12 repo here (not copied to this repo - see README for URL) 
# and then run this to get the needed bits

for f in \
LICENCE.txt \
spm_vol.m \
spm_fileparts.m \
spm_existfile.m \
spm_unlink.m \
spm_vol_nifti.m \
\@nifti \
\@file_array \
spm_read_vols.m \
spm_check_orientations.m \
spm_mesh_detect.m \
spm_slice_vol.m \
spm_matrix.m \
spm_type.m \
spm_write_vol.m \
spm_create_vol.m \
spm_file.m \
spm_write_plane.m \
; do
    cp -R spm12/${f}* .
done
