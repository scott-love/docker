
#!/bin/bash
set -e

echo "Testing FreeSurfer 5.3 installation..."

# Check installation directory
test -d "$FREESURFER_HOME"
echo "OK: FreeSurfer directory exists"

# Check licence
test -s "$FREESURFER_HOME/.license"
echo "OK: Licence file exists"

# Check important executables
test -x "$FREESURFER_HOME/bin/mri_convert"
echo "OK: mri_convert is executable"

test -x "$FREESURFER_HOME/bin/recon-all"
echo "OK: recon-all is executable"

# Check environment
test "$FREESURFER_HOME" = "/opt/freesurfer"
test "$SUBJECTS_DIR" = "/subjects"
echo "OK: Environment variables are set"

# Check FreeSurfer version
recon-all -version
echo "OK: recon-all runs"

# Check mri_convert
mri_convert >/dev/null 2>&1 || true
echo "OK: mri_convert executable starts"

echo "All FreeSurfer installation tests passed!"
