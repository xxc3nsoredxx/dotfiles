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

CONTENTS=($(find home -depth -type f -exec realpath --relative-base=home \{\} \+))
declare -a NOT_INSTALLED

# Respect custom PS3 prompts
if [ -e $PS3 ]; then
    PS3="Install: "
fi

# Find the files which are not installed
for i in ${CONTENTS[@]}; do
    if [[ ! -a $HOME/$i ]]; then
        NOT_INSTALLED[${#NOT_INSTALLED[@]}]=$i
    fi
done

while [[ -z $QUIT ]]; do
    select FILE in ${NOT_INSTALLED[@]} all exit; do
        # Turn into a proper array index
        REPLY=$(($REPLY - 1))

        # Have to index into the indices of the array
        INDEX=(${!NOT_INSTALLED[@]})

        # Test if "all" was selected
        if [[ $REPLY -eq ${#NOT_INSTALLED[@]} ]]; then
            echo "Install all"
            QUIT=1
        # Test if "exit" was selected
        elif [[ $REPLY -eq $((${#NOT_INSTALLED[@]} + 1)) ]]; then
            echo "Exit"
            exit
        # Install the selected file
        elif [[ $REPLY -lt ${#NOT_INSTALLED[@]} ]]; then
            echo $FILE
            unset NOT_INSTALLED[${INDEX[$REPLY]}]
        # Invalid
        else
            echo "Invalid choice!"
        fi
        break
    done
done
