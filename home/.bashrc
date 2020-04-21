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

# Prompt
export PS1='\[\e[1;34m\][ \w ]\n\[\e[1;32m\]\u@\h \[\e[1;34m\]λ\[\e[0m\] '

function command_not_found_handle {
    echo "Command not found: $1"
}

function man_complete {
    cmd="whatis -w $2*"

    # Search section if given
    if [ $3 != $1 ]; then
        cmd+=" -s $3"
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

complete -cf sudo
complete -F man_complete man
complete -A helptopic help

shopt -s cdspell
shopt -s direxpand
shopt -s dirspell

alias poweroff="sudo poweroff"
alias reboot="sudo reboot"
alias lh="ls -alFh"
alias ll="ls -alF"
alias slack_followersofenarc="irssi -c followersofenarc.irc.slack.com -p 6667 -n snek_case -w $(cat $HOME/foe_irc_pass)"
alias chvt="sudo chvt"
alias hd="hexdump -C"
alias tor_links="links -socks-proxy tor@127.0.0.1:9100"
alias clip_prim="xclip -o -selection clipboard | xclip -i -selection primary"
alias prim_clip="xclip -o -selection primary | xclip -i -selection clipboard"
alias clip_file="xclip -i -selection clipboard"
alias df="df --total"
alias objdump_intel="objdump -M intel -D"
alias dmesg="dmesg -Hx -f kern,user,daemon,syslog"
alias pv="pv -c -F '%r %T %a %t %p %b %e'"

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

# SSH aliases
alias cslinux="ssh avp150830@cslinux.utdallas.edu"

function ldir {
    ls -alF $1 | grep ^d
}

function lg {
    if [ $# -eq 2 ]; then
        ls -alF $1 | grep -E $2
    else
        ls -alF | grep -E $1
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

# github helpers
if [ -f $HOME/.git_aliases ]; then
    . $HOME/.git_aliases
fi

# setup Github ssh-connection
eval $(ssh-agent -s) > /dev/null 2>&1
ssh-add $HOME/.ssh/github > /dev/null 2>&1

ssh-add $HOME/.ssh/psc > /dev/null 2>&1
ssh-add $HOME/.ssh/oskari_utd2 > /dev/null 2>&1
