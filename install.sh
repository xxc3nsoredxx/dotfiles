#! /bin/bash

#   dotfiles install script
#   Copyright (C) 2020  xxc3nsoredxx
#
#   This program is free software: you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation, either version 3 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program.  If not, see <http://www.gnu.org/licenses/>.

RUNDIR=$PWD
CONTENTS=($(find home -depth -type f -exec realpath --relative-base=home \{\} \+))
declare -a NOT_INSTALLED

# Installs the given file (using hardlinks)
function install_file {
    printf  "%-035s <<< %s\n" "$HOME/$i" "$RUNDIR/$i"
    return
    DIR_PART=$(dirname $1)
    pushd $HOME >/dev/null
        # Create required directories if needed
        mkdir -p $DIR_PART
        cd $DIR_PART
        ln $RUNDIR/home/$1
    popd >/dev/null
}

# Find the files which are not installed
for i in ${CONTENTS[@]}; do
    if [[ ! -a $HOME/$i ]]; then
        NOT_INSTALLED[${#NOT_INSTALLED[@]}]=$i
    elif [[ ! -z $(diff -q $HOME/$i home/$i) ]]; then
        echo "Contents of \"$HOME/$i\" differ from the repo"
    fi
done

# Installer menu
echo "Separate choices by space (' ') to install multiple files at once."
echo "NOTE: 'all' and 'exit' are mutually exclusive with any other choices."
echo "      Individual choices take precedence over 'all' and 'exit'."
while [[ -z $QUIT ]]; do
    # Output choices
    COUNT=1
    for NAME in ${NOT_INSTALLED[@]} all exit; do
        echo "${COUNT}) $NAME"
        COUNT=$(($COUNT + 1))
    done

    # Prompt for input
    echo -n "Install: "
    readarray -n 1 INPUT

    # Sort and remove duplicate entries
    INPUT=($(echo "${INPUT[@]}" | tr -s ' ' '\n' | sort | uniq))

    # These values depend on the state before any files are installed
    # Number of not installed files
    N_NOT_INSTALLED=${#NOT_INSTALLED[@]}
    # The array can (and probably will) have holes, need to index using the
    # array of valid indices
    INDICES=(${!NOT_INSTALLED[@]})

    # Parse each choice from the input
    for C in ${INPUT[@]}; do
        # Remove non-numeric characters
        CHOICE=${C//[^0-9]}

        # Non-numeric choice
        if [ "$CHOICE" != "$C" ]; then
            echo "Invalid choice: '$C' ..."
            continue
        # Out of bounds choices
        elif [ $CHOICE -eq 0 ]; then
            echo "Invalid choice: '$CHOICE' ..."
            continue
        elif [ $CHOICE -gt $(($N_NOT_INSTALLED + 2)) ]; then
            echo "Invalid choice: '$CHOICE' ..."
            continue
        fi

        # Turn into a proper array index
        CHOICE=$(($CHOICE - 1))

        # Test if "all" was selected
        if [[ $CHOICE -eq $N_NOT_INSTALLED ]]; then
            # Test if "all" is the only choice
            if [ ${#INPUT[@]} -eq 1 ]; then
                echo "Installing all ..."
                for f in ${NOT_INSTALLED[@]}; do
                    install_file $f
                done
                unset NOT_INSTALLED
            else
                echo "Invalid choice in this context: 'all' ..."
            fi
        # Test if "exit" was selected
        elif [[ $CHOICE -eq $(($N_NOT_INSTALLED + 1)) ]]; then
            # Test if "exit" is the only choice
            if [ ${#INPUT[@]} -eq 1 ]; then
                echo "Exit..."
                QUIT=1
            else
                echo "Invalid choice in this context: 'exit' ..."
            fi
        # Install
        else
            install_file $FILE
            unset NOT_INSTALLED[${INDICES[$CHOICE]}]
        fi
    done

    # Check if no more files left
    if [[ ${#NOT_INSTALLED[@]} -eq 0 ]]; then
        echo "Nothing left to install, exit..."
        QUIT=1
    fi
    exit
done
