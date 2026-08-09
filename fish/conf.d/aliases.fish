# directories first, colorized ls (GNU on Linux, BSD-flavored on macOS)
if test (uname) = "Darwin"
    alias ls 'ls -G -a -h'
else
    alias ls 'ls --color -a -h --group-directories-first'
end
alias ll 'ls -l'
alias la 'ls -a'
alias las 'ls -al'

# ARCH ONLY - get list of recently installed pacman packages. (needs expac)
alias rip="expac --timefmt='%Y-%m-%d %T' '%l\t%n %v' | sort | tail -200 | nl"


#
# newpy/newbash - lost the boilerplaterer files....
#
# alias newpy "~/.dotfiles/.boilerplater boilerplate-python"
# alias newbash "~/.dotfiles/.boilerplater boilerplate-bash"

if test (uname) = "Darwin"
    alias brwe brew # typos lol

    # this trash cleaner is hopelessly out of date...
    # empty the Trash on all mounted volumes and the main HDD.
    # also, clear Apple’s System Logs to improve shell startup speed.
    # inally, clear download history from quarantine. https://mths.be/bum
    # alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl; sqlite3 ~/Library/Preferences/com.apple.LaunchServices.QuarantineEventsV* 'delete from LSQuarantineEvent'"

    function stfu
        osascript -e 'set volume output muted true'
    end
    function pumpitup
        osascript -e 'set volume output volume 100'
    end
    alias afk '/System/Library/CoreServices/Menu\ Extras/User.menu/Contents/Resources/CGSession -suspend'
end
