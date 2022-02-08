# /etc/skel/.bashrc
#
# This file is sourced by all *interactive* bash shells on startup,
# including some apparently interactive shells such as scp and rcp
# that can't tolerate any output.  So make sure this doesn't display
# anything or bad things will happen !


# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
	# Shell is non-interactive.  Be done now!
	return
fi

# Prompt for non-root user
if [ $(id -u) -ne 0 ]; then
    export PS1='\[\e[1;34m\][ \w ]\n\[\e[1;32m\]\u@\h \[\e[1;34m\]λ\[\e[0m\] '
fi

# GPG secure tty
export GPG_TTY=$(tty)

# Run whenever a command isn't found
function command_not_found_handle {
    declare -a WHAT
    declare -a HELP
    declare -a ALIAS

    # PREFIX holds the first half as-is
    PREFIX=${1:0:$((${#1} / 2))}
    # SUFFIX has the second half and one shorter, with '?' to build pattern
    SUFFIX=("${1:${#PREFIX}}" "${1:$((${#PREFIX} + 1))}")
    SUFFIX=("${SUFFIX[@]//?/?}")
    # A_SUFF has ? replaced with . for use with `alias | grep`
    A_SUFF=("${SUFFIX[@]//?/.}")

    # Read the results of `whatis`, `help`, and `alias`
    readarray WHAT <<< $(whatis -s 1 -w "$PREFIX${SUFFIX[0]}" "$PREFIX${SUFFIX[1]}" 2>/dev/null | sort | uniq | grep -v 'builtin')
    readarray HELP <<< $(help -d "$PREFIX${SUFFIX[0]}" "$PREFIX${SUFFIX[1]}" 2>/dev/null | tail -n +3 | sort)
    readarray ALIAS <<< $(alias | grep -wE "$PREFIX${A_SUFF[0]}=|$PREFIX${A_SUFF[1]}=" 2>/dev/null | sort | uniq)

    # If the first element is fake, nothing was found
    if [ ${#WHAT[0]} -eq 1 ]; then
        unset WHAT
    fi
    if [ ${#HELP[0]} -eq 1 ]; then
        unset HELP
    fi
    if [ ${#ALIAS[0]} -eq 1 ]; then
        unset ALIAS
    fi

    echo "Command not found: $1"

    # Only print the ones that have content
    if [ ${#WHAT[@]} -gt 0 ]; then
        echo "Tools: "
        for line in "${WHAT[@]}"; do
            echo $line
        done
    fi
    if [ ${#HELP[@]} -gt 0 ]; then
        echo "Builtins:"
        for line in "${HELP[@]}"; do
            echo $line
        done
    fi
    if [ ${#ALIAS[@]} -gt 0 ]; then
        echo "Aliases:"
        for line in "${ALIAS[@]}"; do
            echo $line
        done
    fi
}

function man_complete {
    cmd="whatis -w ${2}*"

    # Search section if given
    if [ $3 != $1 ]; then
        cmd+=" -s $3"
    fi

    # Skip "nothing appropriate"
    if [[ $($cmd 2>&1) == *nothing?appropriate* ]]; then
        return 1
    fi

    # ASCII 63, '?' is when mutiple tabs are pressed to show all completions
    # Print a newline so that the output is under the prompt
    if [ $COMP_TYPE -eq 63 ]; then
        echo
    fi

    # Using the output of $cmd as input, parse line by line
    while read c; do
        # Print the whatis summaries when showing all comletion options
        if [ $COMP_TYPE -eq 63 ]; then
            echo "$c"
        fi
        # COMPREPLY is the array of possible completions
        # Add just the name from the whatis summaries to the array
        COMPREPLY[${#COMPREPLY[@]}]=$(echo $c | awk -e '{printf("%s", $1);}')
    done <<< $($cmd)
}

# complete -cf sudo
complete -F man_complete man
complete -A helptopic help

set -o hashall

shopt -s autocd
shopt -s cdspell
shopt -s direxpand
shopt -s dirspell
shopt -s extglob
shopt -s no_empty_cmd_completion

# Start X in active TTY
alias startx="startx -- vt$(tty | sed -e 's|/dev/tty||')"

# alias poweroff="loginctl poweroff"
# alias reboot="loginctl reboot"
alias lh="ls -alFh"
alias ll="ls -alF"
# alias chvt="sudo chvt"
alias hd="hexdump -C"
alias tor_links="links -socks-proxy tor@127.0.0.1:9100"
alias clip_prim="xclip -o -selection clipboard | xclip -i -selection primary"
alias prim_clip="xclip -o -selection primary | xclip -i -selection clipboard"
alias clip_file="xclip -i -selection clipboard"
alias df="df -h --total"
alias objdump_intel="objdump --visualize-jumps=extended-color -M intel -d"
alias dmesg="dmesg -Hx -f kern,user,daemon,syslog"
alias kdmesg="dmesg -Hx -f kern -l debug,info,notice,warn,err,crit,alert,emerg"
alias pv="pv -c -F '%r %T %a %t %p %b %e'"
alias cp="cp --reflink=auto"
alias capacity="cat /sys/class/power_supply/BAT0/capacity"

alias run_arm="qemu-arm -L /usr/armv6j-hardfloat-linux-gnueabi/"
alias gdb_arm="armv6j-hardfloat-linux-gnueabi-gdb --nh -ix ~/.gdbinit_arm"
alias objdump_arm="armv6j-hardfloat-linux-gnueabi-objdump --visualize-jumps=extended-color -d"

# Aliases to connect to networks
alias connect_abraham_linksys="wpa_cli select_network 2"
alias connect_amandas_wifi="wpa_cli select_network 6"
alias connect_chris="wpa_cli select_network 41"
alias connect_comet_net="wpa_cli select_network 3"
alias connect_cookie_butch="wpa_cli select_network 4"
alias connect_cosby="wpa_cli select_network 7"
alias connect_fellas="wpa_cli select_network 12"
alias connect_gwoplock="wpa_cli select_network 14"
alias connect_home="wpa_cli select_network 0"
alias connect_home5g="wpa_cli select_network 42"
alias connect_lamb="wpa_cli select_network 19"
alias connect_lesbo="wpa_cli select_network 32"
alias connect_my_res_net="wpa_cli select_network 25"
alias connect_northside="wpa_cli select_network 40"
alias connect_rose="wpa_cli select_network 11"
alias connect_rose_mom="wpa_cli select_network 34"
alias connect_ree="wpa_cli select_network 26"
alias connect_starbucks="wpa_cli select_network 13"
alias connect_tendies="wpa_cli select_network 27"
alias disconnect="wpa_cli disconnect"
alias reconnect="wpa_cli reconnect"
function connection_test {
    if (ping -c 1 1.1.1.1 &>/dev/null); then
        echo "Connected"
        return 0
    else
        echo "Not connected"
        return 1
    fi
}

# Portage stuff
alias emerge_change_use="emerge --update --deep --changed-use @world"
alias emerge_new_use="emerge --update --deep --newuse @world"
alias emerge_deselect="emerge --deselect"
alias emerge_depclean="emerge --depclean"
alias emerge_portage_update="emerge --oneshot sys-apps/portage"
alias emerge_predict="emerge --update --deep --with-bdeps=y --pretend @world | genlop -p"
alias emerge_sync="emerge --sync"
alias emerge_watch="watch -cn 1 genlop -ci"
function emerge_update {
    local EMERGE_CMD="emerge --update --deep --with-bdeps=y"

    if [ $# -eq 1 ]; then
        $EMERGE_CMD $1
    else
        $EMERGE_CMD @world
    fi
}
alias gen_grub="grub-mkconfig -o /boot/grub/grub.cfg"
alias gen_initramfs="genkernel --sandbox --btrfs --compress-initramfs --compress-initramfs-type=xz initramfs"

function ldir {
    find $1 -maxdepth 1 -type d -exec ls --color -adlF \{\} \+
}

# SELinux stuff
alias lz="ls -alFZ"
alias sysadm="newrole -r sysadm_r"

function lg {
    if [ $# -eq 2 ]; then
        find $1 -regextype egrep -maxdepth 1 -iregex ".*$2.*" -exec ls --color -adlF \{\} \+
    else
        find -regextype egrep -maxdepth 1 -iregex ".*$1.*" -exec ls --color -adlF \{\} \+
    fi
}

function wgetpaste_binary {
    if [ $# -eq 1 ]; then
        xz -9 -e -c "$1" | base64 > "$1.xz.base64"
        echo "$1.xz.base64 can be found at:"
        wgetpaste -u $(wgetpaste -s bpaste -r "$1.xz.base64" 2>&1 | awk 'BEGIN{FS=" "} {print $8}') 2>&1 | awk 'BEGIN{FS=" "} {print $7}'
    else
        echo "Usage: wgetpaste_binary file"
    fi
}

function fsize {
    if [ $# -eq 1 ]; then
        printf '\33]50;%s\007' "xft:Mononoki:size=$1"
    else
        printf '\33]50;%s\007' "xft:Mononoki:size=10"
    fi
}

function pd {
    if [ $# -eq 1 ]; then
        pushd $1
    else
        popd
    fi
}

# github helpers for non-root user
if [ -f $HOME/.git_aliases ]; then
    . $HOME/.git_aliases
fi

# setup Github ssh-connection for non-root user
if [ $(id -u) -ne 0 ]; then
    eval $(ssh-agent -s) > /dev/null 2>&1
    # Use Host block in ~/.ssh/config
    # ssh-add $HOME/.ssh/github > /dev/null 2>&1
    # ssh-add $HOME/.ssh/distcc-debian10 > /dev/null 2>&1
fi
