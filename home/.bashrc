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


# Set vi mode
set -o vi

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
alias df="df --total"
alias objdump_intel="objdump -M intel -D"

# Aliases to connect to networks
alias connect_abraham_linksys="wpa_cli select_network 2"
alias connect_amandas_wifi="wpa_cli select_network 6"
alias connect_comet_net="wpa_cli select_network 3"
alias connect_cookie_butch="wpa_cli select_network 4"
alias connect_cosby="wpa_cli select_network 7"
alias connect_home="wpa_cli select_network 0"

function ldir {
    ls -alF $1 | grep ^d
}

function lg {
    if [ $# -eq 2 ]; then
        ls -alF $1 | grep $2
    else
        ls -alF | grep $1
    fi
}

# github helpers
if [ -f $HOME/.git_aliases ]; then
    . $HOME/.git_aliases
fi

# setup Github ssh-connection
eval $(ssh-agent -s) > /dev/null 2>&1
ssh-add $HOME/.ssh/github > /dev/null 2>&1
