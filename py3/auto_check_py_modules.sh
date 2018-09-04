#! /bin/sh
#
# auto_check_py_modules.sh
# Copyright (C) 2018 jackchuang <jackchuang@Jack-desktop>
#
# Distributed under terms of the MIT license.
#


MODULES="
math
pandas
"

for module in $MODULES; do
    python -c "import $module" >> /dev/null &&
    #
        echo "INSTALLED" ||
    #
        echo "NOT INSTALLED YET" # pip install $module
    #

done
