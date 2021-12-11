# This is the .bashrc. This runs on non-interactive sessions. Define
#  paths and others here. The interactive shell calls this one.
#
# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Setup BBP Environment
#export BBP_DIR=/app/bbp/bbp
#export BBP_GF_DIR=/app/bbp/bbp_gf
#export BBP_VAL_DIR=/app/bbp/bbp_val
#export BBP_DATA_DIR=/app/target

#export PYTHONPATH=/app/bbp/bbp/comps:/app/bbp/bbp/comps/PySeismoSoil:$PYTHONPATH
#export PATH=/app/bbp/bbp/comps:/app/bbp/bbp/utils/batch:$PATH
ulimit -s unlimited
#export PATH
