#! /bin/sh
#
# auto_check_py_modules.sh
# Copyright (C) 2018 jackchuang <jackchuang@Jack-desktop>
#
# Distributed under terms of the MIT license.
#



# up-to-date pip (doesn't work)
#curl https://bootstrap.pypa.io/get-pip.py | python3.4

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
