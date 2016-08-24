# random
alias newpy="~/.boilerplater boilerplate-python"
alias newbash="~/.boilerplater boilerplate-bash"
alias clean='history -c; clear'
alias ls='ls --color -h --group-directories-first' # directories first
alias ll='ls -l'
alias la='ls -a'
alias las='ls -al'
alias ..='cd ..'
alias timez="~/.world_time"

alias syua='pacaur -Syua'
alias pacs='pacaur -Ss'
alias paci='pacaur -S'
alias drives='df -h'
alias record="ffmpeg -f x11grab -s 1920x1080 -r 25 -i :0.0 -f alsa -i hw:0,0 -strict -2"


alias myip='dig +short myip.opendns.com @resolver1.opendns.com'
alias speedtest='curl -o /dev/null http://cachefly.cachefly.net/100mb.test; true'
alias snitch='sudo nmap -sP 10.0.0.0/24 && echo "*** Further details in ~ One Minute, Please Wait ..." && sudo nmap -sP 10.0.0.0/24'
alias dates="date +%H:%M"


# ssh

# Shortcut to get the disk size of a directory and contents
sizeof() {
    du -ch "$1" | grep total
}


# Quick d0x: $dox filename.txt
# I would like to tweak this, maybe prompt for another file? and whole dir.
haste()
{
    a=$(cat);
    curl -X POST -s -d "$a" http://hastebin.com/documents |
    awk -F '"' '{print "http://hastebin.com/"$4}';
}

dox()
{
  read -p "Is your IP scrubbed? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
  cat "$1" | haste
else
  echo "Bounce first."
fi
}
