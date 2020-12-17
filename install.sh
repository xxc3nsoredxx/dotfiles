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

# The root of the dotfiles repo
# Assumes that the script is run from the root
RUNDIR=$PWD
# Populates all the files in the repo
# Currently only looks under home/ since that's the only existing directory
CONTENTS=($(find home -depth -type f -exec realpath --relative-base=home \{\} \+))
declare -a NOT_INSTALLED
# Ensure these variables don't exist (eg, as an env var)
unset EXTRA_BLANK
unset FORCE

# Installs the file given as argument 1
# Uses hardlinks in case programs test for a file and not a symlink
# Links enable running `git pull` in the repo root to update installed files
function install_file {
    printf  "%-035s <<< %s\n" "$HOME/$1" "$RUNDIR/$1"
    DIR_PART=$(dirname $1)
    pushd $HOME >/dev/null
        # Create required directories if needed
        mkdir -p $DIR_PART
        cd $DIR_PART
        ln $RUNDIR/home/$1
    popd >/dev/null
}

# Print the usage string
# Triggered by '-h' or invalid argument
function usage {
    echo "Usage: $0 [args]"
    echo "Args:"
    echo "    -f    Force"
    echo "          Overwrites existing files."
    echo "    -h    Display this help"
    exit 1
}

# Test the commandline arguments
if [ $# -ge 1 ]; then
    if [ "$1" == "-f" ]; then
        echo "WARNING: '-f' given. Will mercilessly overwrite existing files."
        echo -n "Continuing in: 5"
        sleep 1
        echo -n " 4"
        sleep 1
        echo -n " 3"
        sleep 1
        echo -n " 2"
        sleep 1
        echo -n " 1"
        sleep 1
        echo " Now!"
        FORCE=1
    else
        usage
    fi
fi

# Find the files which are not installed
# Notifies if existing files differ from the repo files (unless -f)
for i in ${CONTENTS[@]}; do
    if [[ ! -a $HOME/$i ]]; then
        NOT_INSTALLED[${#NOT_INSTALLED[@]}]=$i
    elif [[ ! -z $FORCE ]]; then
        echo "'$HOME/$i' exists, deleting..."
        rm -f $HOME/$i
        NOT_INSTALLED[${#NOT_INSTALLED[@]}]=$i
        EXTRA_BLANK=1
    elif [[ ! -z $(diff -q $HOME/$i home/$i) ]]; then
        echo "Contents of '$HOME/$i' differ from the repo..."
        EXTRA_BLANK=1
    fi
done
if [ ! -z $EXTRA_BLANK ]; then
    echo ""
fi

# Check if any files need to be installed
if [[ ${#NOT_INSTALLED[@]} -eq 0 ]]; then
    echo "Nothing to install, exiting..."
    exit
fi

# Installer menu
echo "Separate choices by space (' ') to install multiple files at once."
echo "NOTE: 'all' is mutually exclusive with everything."
echo "      Other choices take precedence over 'all'."
while true; do
    # Output choices
    COUNT=1
    for NAME in ${NOT_INSTALLED[@]} all exit; do
        echo "${COUNT}) $NAME"
        COUNT=$(($COUNT + 1))
    done

    # Read into an array to enable multi-choice
    echo -n "Install: "
    readarray -n 1 INPUT

    # Sort and remove duplicate entries
    INPUT=($(echo "${INPUT[@]}" | tr -s ' ' '\n' | sort -n | uniq))
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
            echo "Invalid choice: '$C', ignoring..."
            continue
        # Out of bounds choices
        elif [ $CHOICE -eq 0 ]; then
            echo "Invalid choice: '$CHOICE', ignoring..."
            continue
        elif [ $CHOICE -gt $(($N_NOT_INSTALLED + 2)) ]; then
            echo "Invalid choice: '$CHOICE', ignoring..."
            continue
        fi

        # Turn into a proper array index
        CHOICE=$(($CHOICE - 1))

        # Test if "all" was selected
        if [[ $CHOICE -eq $N_NOT_INSTALLED ]]; then
            # Install all the files only if "all" is the only choice
            if [ ${#INPUT[@]} -eq 1 ]; then
                echo "Installing all..."
                for FILE in ${NOT_INSTALLED[@]}; do
                    install_file $FILE
                done
                unset NOT_INSTALLED
            else
                echo "Invalid choice in this context: 'all', ignoring..."
            fi
        # Test if "exit" was selected
        # Always the last possible choice so it's safe to exit if given
        elif [[ $CHOICE -eq $(($N_NOT_INSTALLED + 1)) ]]; then
            echo "Exit..."
            exit
        # Install a single file
        else
            install_file ${NOT_INSTALLED[${INDICES[$CHOICE]}]}
            unset NOT_INSTALLED[${INDICES[$CHOICE]}]
        fi
    done

    # Check if no more files left
    if [[ ${#NOT_INSTALLED[@]} -eq 0 ]]; then
        echo "Nothing left to install, exiting..."
        exit
    fi
done
