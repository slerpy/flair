
# here fishy fishy

# clear
function c
    clear
end

# cheat-sheet lookup via cht.sh (e.g. `cheat tar`)
function cheat
    curl cht.sh/$argv[1]
end

# wipes shell history and clears the screen
function clean
    history clear
    clear
end

# wrapper around haste() for file sharing -
function snackies
    read -P "is your IP happy? " -n 1 -l reply
    if string match -qr '^[Yy]' -- $reply
        cat $argv[1] | haste
    else
        echo "tickle it."
    end
end


# needed for !! and !$
function __history_previous_command
  switch (commandline -t)
  case "!"
    commandline -t $history[1]; commandline -f repaint
  case "*"
    commandline -i !
  end
end

function __history_previous_command_arguments
  switch (commandline -t)
  case "!"
    commandline -t ""
    commandline -f history-token-search-backward
  case "*"
    commandline -i '$'
  end
end

if [ "$fish_key_bindings" = fish_vi_key_bindings ];
  bind -Minsert ! __history_previous_command
  bind -Minsert '$' __history_previous_command_arguments
else
  bind ! __history_previous_command
  bind '$' __history_previous_command_arguments
end

# backup a file.
function backup --argument filename
    cp $filename $filename.bak
end

# prettify dust output.
# falls back to plain `du -sh` if dust isn't installed.
function dust
    if not command -v dust >/dev/null 2>&1
        echo "dust not installed, falling back to du -sh"
        set -l target .
        if test (count $argv) -gt 0
            set target $argv[1]
        end
        du -sh $target
        return
    end

    if test (count $argv) -eq 0
        command dust -d 1 -rb
    else
        command dust $argv
    end
end


function fish_prompt
    set -l last_status $status

    if test (id -u) -eq 0
        set_color red
        echo -n (prompt_hostname)
        set_color blue
        echo -n " "(prompt_pwd)
        set_color normal
    else
        set_color white
        echo -n "["
        set_color green
        echo -n (whoami)
        set_color white
        echo -n "@"
        set_color green
        echo -n (prompt_hostname)
        set_color white
        echo -n "]"
        set_color normal
        echo -n " "
        set_color blue
        echo -n (prompt_pwd)
        set_color normal
    end

    printf '%s' (__fish_git_prompt)

    if test (count (jobs)) -gt 0
        set_color cyan
        echo -n " ["(count (jobs))"]"
        set_color normal
    end

    if test $last_status -ne 0
        set_color red
    end
    echo -n '> '
    set_color normal
end

# gif like its 2005, needs ffmpeg and gifsicle
# gifify input.mov [output.gif]
function gifify
    if test (count $argv) -eq 0
        echo "usage: gifify <input_video> [output.gif]"
        return 1
    end

    set -l input $argv[1]
    set -l output $argv[2]
    if test -z "$output"
        set output (string replace -r '\.[^.]*$' '.gif' $input)
    end
    set -l palette "/tmp/gifify-palette-"(status current-pid)".png"

    ffmpeg -i "$input" -vf "fps=10,scale=600:-1:flags=lanczos,palettegen" -y "$palette"
    ffmpeg -i "$input" -i "$palette" -filter_complex "fps=10,scale=600:-1:flags=lanczos[x];[x][1:v]paletteuse" -y "$output.tmp.gif"
    gifsicle --optimize=3 --colors 128 "$output.tmp.gif" -o "$output"

    rm -f "$palette" "$output.tmp.gif"
    echo "Created: $output"
end

# colorfulgreps
function grep
    command grep --color=auto $argv
end

function h
    history
end

# for the snackies
function haste
    curl -s -F 'file=@-' https://0x0.st
end

function mkdir
    command mkdir -pv $argv
end

# get local ip
function myintip
    if test (uname) = "Darwin"
        # macOS: BSD tools, no `hostname -I` equivalent - parse ifconfig instead
        ifconfig | awk '/inet /{print $2}' | grep -v '^127'
    else
        # Linux: GNU hostname supports this directly
        hostname -I
    end
end

# get public ip
function myip
    dig +short myip.opendns.com @resolver1.opendns.com
end

# print $PATH one entry per line, easier to read
function path
    echo $PATH | tr ' ' '\n'
end

function please
    sudo $argv
end

# show listening ports
function ports
    if test (uname) = "Darwin"
        netstat -anv | grep LISTEN
    else
        command ss -tulanp
    end
end

# reload fish config
function reload
    source ~/.config/fish/config.fish
end

function sizeof
    du -sh $argv[1]
end

# scan local network for active devices (requires nmap)
function snitch
    if not command -v nmap >/dev/null 2>&1
        if test (uname) = "Darwin"
            echo "nmap not installed (brew install nmap)"
        else
            echo "nmap not installed (install it)"
        end
        return 1
    end

    set -l subnet
    if test (uname) = "Darwin"
        set subnet (ipconfig getifaddr en0 | awk -F. '{print $1"."$2"."$3".0/24"}')
    else
        set subnet (ip -o -f inet addr show | awk '/scope global/ {print $4}' | head -1)
    end

    sudo nmap -sn $subnet
    and echo "*** Further details in ~ One Minute, Please Wait ..."
end

# speedtest a hetzner, not at all accurate but good enough to check connection.
function speedtest
    curl -o /dev/null http://hil-speed.hetzner.com/1GB.bin
end

# whois. boop.
function whois
    set -l domain (echo $argv[1] | awk -F/ '{print $3}')
    if test -z "$domain"
        set domain $argv[1]
    end

    curl -s -H "Accept: application/rdap+json" "https://rdap.org/domain/$domain" | python3 -c "
import json, sys
d = json.load(sys.stdin)
print('Domain:     ', d.get('ldhName'))
for e in d.get('events', []):
    if e['eventAction'] == 'registration': print('Registered: ', e['eventDate'])
    if e['eventAction'] == 'expiration': print('Expires:    ', e['eventDate'])
print('Status:     ', ', '.join(d.get('status', [])))
for ns in d.get('nameservers', []):
    print('Nameserver: ', ns.get('ldhName'))
"
end

# grab audio from yt vids
function yta
    yt-dlp -x -f 'bestaudio/best' --audio-format mp3 $argv
end

# grab yt video
function ytv
    yt-dlp -f 'bestvideo+bestaudio/best' --merge-output-format mp4 $argv
end

