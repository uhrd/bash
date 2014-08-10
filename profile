# /etc/profile

#Set our umask
umask 022

# Set our default path
PATH="/usr/local/bin:/usr/bin:/usr/sbin:/usr/local/sbin:/home/drsp/bin"
export PATH

# Load profiles from /etc/profile.d
if test -d /etc/profile.d/; then
	for profile in /etc/profile.d/*.sh; do
		test -r "$profile" && . "$profile"
	done
	unset profile
fi

# Source global bash config
if test "$PS1" && test "$BASH" && test -r /etc/bash.bashrc; then
	. /etc/bash.bashrc
fi

# Termcap is outdated, old, and crusty, kill it.
unset TERMCAP

# Man is much better than us at figuring this out
unset MANPATH

export BROWSER=elinks
export PAGER=vimpager
export EDITOR=vim

##################################################################
# Aliases

alias ls='ls --color=auto'
alias l='ls --color=auto'
alias lss='ls -sSh'
alias lsd='ls -lhd *(-/DN)'
alias lsa='ls -lhd .*'
alias ll='ls -lh'
alias md='mkdir'
alias rd='rmdir'
alias ..='cd ..'
alias ncmpc='ncmpc --colors'
alias df='df -h'
alias pp='expr "$(ps c $PPID)" : ".* \(.*\)"'
alias s2ram='sudo pm-suspend'
alias s2disk='sudo pm-hibernate'
alias s2both='sudo pm-suspend-hybrid'
alias cpuf800='sudo cpufreq-set -f 800'
alias cpuf1600='sudo cpufreq-set -f 1600'
alias hd='hexdump -C'
alias mplayerfb='mplayer -vo fbdev -ao alsa -zoom -x 1366 -y 768 -nolirc -framedrop -really-quiet'
alias rtorrentd='screen ionice -c 3 rtorrent'
alias copy='rsync -av --progress'
alias xclone="xrandr --output CRT1 --same-as LVDS"
alias xsplit="xrandr --output CRT1 --right-of LVDS"
# pushd/popd

alias d='dirs -v'
for i in {0..10}
do	alias $i="pushd +$i"
done
unset i

##################################################################
# Functions

r() {
pushd "${@:-+1}"
}

mkcd() {
mkdir "$1" && pushd "$1"
}

rdc() {
rmdir $PWD ||return 1
if [[ $(dirs -lp |head -1) == $PWD ]]
then	popd
else	 cd $1
fi
}

google() {
STRING="${@//$/%24}"	   #urlencode '$'
STRING="${STRING//&/%26}"  #urlencode '&'
STRING="${STRING//\(/%28}" #urlencode '('
STRING="${STRING//\)/%29}" #urlencode ')'
STRING="${STRING//+/%2b}"  #urlencode '+'
STRING="${STRING//,/%2c}"  #urlencode ','
STRING="${STRING//\//%2f}" #urlencode '/'
STRING="${STRING//:/%3a}"  #urlencode ':'
STRING="${STRING//;/%3b}"  #urlencode ';'
STRING="${STRING//=/%3d}"  #urlencode '='
STRING="${STRING//\?/%3f}" #urlencode '?'
STRING="${STRING//@/%40}"  #urlencode '@'
STRING="${STRING//\[/%5b}" #urlencode '['
STRING="${STRING//\]/%5d}" #urlencode ']'
STRING="${STRING//\\/%5c}" #urlencode '\'
STRING="${STRING//^/%5e}"  #urlencode '^'
STRING="${STRING//\`/%60}" #urlencode '`'
STRING="${STRING//\{/%7b}" #urlencode '{'
STRING="${STRING//\}/%7d}" #urlencode '}'
STRING="${STRING//|/%7c}"  #urlencode '|'
STRING="${STRING//\~/%7e}" #urlencode '~'
${BROWSER} "http://www.google.no/search?q=${STRING// /+}"
}

connect() { (
trap exit INT
until ping -c 1 google.no 2>/dev/null |grep -B1 "1 recieved"
do	if dhcpcd eth0 2>/dev/null
	then	echo $(date): Success\!
	else	echo $(date): Failed..
fi done
) }

#ap() {
#if [[ $1 == --help ]]
#then	echo 'usage: ap <ESSID> <IP> <GW> <NS>'
#fi
#ESSID=3.1
#GW=192.168.0.2
#NS=$GW
#IP=192.168.0.44
IF=wlan0
#sudo ifconfig $IF up
#sudo iwconfig $IF essid ${1:-$ESSID}
#sudo ifconfig $IF ${2:-$IP}
#sudo route add default gw ${3:-$GW}
#echo nameserver ${4:-$NS} |sudo tee -a /etc/resolv.conf
#}

help() {
bash -c "help $1"
}

pacupg() {
unset UPG
[[ -z $1 ]] &&UPG=(yu u)
su -c "until pacman -S${UPG[1]} $@ --noconfirm; do pacman -S${UPG[2]}w $1 --noconfirm; done"
}

pacsz() {
local LC_ALL=C
pacman -Qi | sed -n '/^Name[^:]*: \(.*\)/{s//\1 /;x};/^Installed[^:]*: \(.*\)/{s//\1/;H;x;s/\n//;p}' | sort -nk2
}
vncd() { (
trap "kill -3 $$" INT
while ! netcat -z localhost:5900
do x11vnc -shared -noxdamage -rfbauth .vnc/passwd
done 
) }
iwscan(){
for l in $(sudo iwlist $IF scanning |grep ESSID)
do	echo ${l:7:$((${#l}-8))} #strip ESSID:""
done
}
readOne () {
oldstty=`stty -g`
stty -icanon min 1 time 0
readChar=`dd bs=1 count=1 2>/dev/null`
stty "$oldstty"
echo
}
