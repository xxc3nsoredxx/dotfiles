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
export PS1='\[\033]0;[ \w ]\033\\\]\[\033[01;34m\][ \w ]\n\[\033[01;32m\]\u@\h\[\033[01;34m\] λ\[\033[00m\] '

complete -cf sudo
alias poweroff="sudo poweroff"
alias reboot="sudo reboot"
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

# Aliases to connect to networks
alias connect_abraham_linksys="wpa_cli select_network 2"
alias connect_amandas_wifi="wpa_cli select_network 6"
alias connect_comet_net="wpa_cli select_network 3"
alias connect_cookie_butch="wpa_cli select_network 4"
alias connect_cosby="wpa_cli select_network 7"
alias connect_fellas="wpa_cli select_network 12"
alias connect_gwoplock="wpa_cli select_network 14"
alias connect_home="wpa_cli select_network 0"
alias connect_lamb="wpa_cli select_network 19"
alias connect_rose="wpa_cli select_network 11"
alias connect_starbucks="wpa_cli select_network 13"

function ldir {
    ls -alF $1 | grep ^d
}

function lg {
    if [ $# -eq 2 ]; then
        ls -alF $2 | grep -E $1
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

# github helpers
if [ -f $HOME/.git_aliases ]; then
    . $HOME/.git_aliases
fi

# setup Github ssh-connection
eval $(ssh-agent -s) > /dev/null 2>&1
ssh-add $HOME/.ssh/github > /dev/null 2>&1

ssh-add $HOME/.ssh/psc > /dev/null 2>&1
