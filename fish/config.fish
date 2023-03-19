# !/usr/bin/env fish

set script_path (realpath (status -f))
set script_dir (dirname $script_path)

source $script_dir/../env/PATH
