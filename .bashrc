# This is the .bashrc. This runs on non-interactive sessions. Define
#  paths and others here. The interactive shell calls this one.
#
# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Setup BBP Environment
export BBP_DIR=/app/bbp/bbp
export BBP_GF_DIR=/app/bbp/bbp_gf
export BBP_VAL_DIR=/app/bbp/bbp_val
export BBP_DATA_DIR=/app/target

export PYTHONPATH=/app/bbp/bbp/comps:/app/bbp/bbp/comps/PySeismoSoil:$PYTHONPATH
export PATH=/app/bbp/bbp/comps:/app/bbp/bbp/utils/batch:$PATH
ulimit -s unlimited
export PATH

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/bbp/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/bbp/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/bbp/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/bbp/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
