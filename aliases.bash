alias clean='history -c; clear'
alias sudo='sudo '

# directories first, now with color!)
if [[ "$(uname)" == "Darwin" ]]; then
    alias ls='ls -G -a -h'
else
    alias ls='ls --color -a -h --group-directories-first'
fi
alias ll='ls -l'
alias la='ls -a'
alias las='ls -al'

alias cp='cp -v'
alias mv='mv -v'
alias rm='rm -i -v'
alias chmox='chmod -x'
alias timez='~/.dotfiles/world_time'
alias wthr='curl wttr.in/Portland'

alias drives='df -h'

#
# need to fix this thinger.
# alias record="ffmpeg -f x11grab -s 1920x1080 -r 25 -i :0.0 -f alsa -i hw:0,0 -strict -2"


alias ytv="yt-dlp -f 'bestvideo+bestaudio/best' --merge-output-format mp4"
alias yta="yt-dlp -x -f 'bestaudio/best' --audio-format mp3"

if [[ "$(uname)" == "Darwin" ]]; then
    alias ports='netstat -anv | grep LISTEN'
else
    alias ports='ss -tulanp'
fi
alias dates='date +%H:%M'


alias grep='grep --color=auto'
alias mkdir='mkdir -pv'
alias path='echo -e ${PATH//:/\\n}'
alias reload='source ~/.bashrc'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias h='history'
alias c='clear'
alias please='sudo'

# get list of recently installed pacman packages. (arch only, needs expac)
rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"

#
# newpy/newbash - lost the boilerplaterer files....
#
# alias newpy="~/.dotfiles/.boilerplater boilerplate-python"
# alias newbash="~/.dotfiles/.boilerplater boilerplate-bash"

#
# macos specific
#
if [[ "$(uname)" == "Darwin" ]]; then
    alias brwe=brew # typos lol

    # this trash cleaner is hopelessly out of date...
    # empty the Trash on all mounted volumes and the main HDD.
    # also, clear Apple’s System Logs to improve shell startup speed.
    # inally, clear download history from quarantine. https://mths.be/bum
    # alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"

    alias stfu="osascript -e 'set volume output muted true'"
    alias pumpitup="osascript -e 'set volume output volume 100'"
    alias afk="/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend"
fi
