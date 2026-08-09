# if not running interactively, don't do anything
[[ $- != *i* ]] && return

# fix obnoxious ass ctrl + shift + v stuff
printf '\e[?2004l'`

# Load aliases and settings from this dotfiles folder
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
for f in "$DOTFILES_DIR"/aliases.bash "$DOTFILES_DIR"/settings.bash; do
    [ -f "$f" ] && source "$f"
done

# i mean, obviously... - quick cheat-sheet lookup via cht.sh
cheat() {
    curl cht.sh/$1
}

# Total disk usage of a directory (e.g. `sizeof ~/Downloads`)
sizeof() {
    du -sh "$1"
}

# prettify dust output.
# falls back to plain `du -sh` if dust isn't installed.
dust() {
    if ! command -v dust >/dev/null 2>&1; then
        echo "dust not installed, falling back to du -sh"
        du -sh "${1:-.}"
        return
    fi
    if [ $# -eq 0 ]; then
        command dust -d 1 -rb
    else
        command dust "$@"
    fi
}

# for the snackies
haste() {
    curl -s -F 'file=@-' https://0x0.st
}

# wrapper around haste() for file sharing -
# Usage: snackies file.txt
snackies() {
    read -p "is your IP happy? " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        cat "$1" | haste
    else
        echo "tickle it."
    fi
}

# quick backup: `backup somefile.txt` creates somefile.txt.bak
backup() {
    cp "$1" "$1.bak"
}


# whois. boop.
whois() {
    local domain=$(echo "$1" | awk -F/ '{print $3}')
    if [ -z "$domain" ]; then domain=$1; fi

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
}

# gif like its 2005, needs ffmpeg and gifsicle
# gifify input.mov [output.gif]
gifify() {
    if [[ -z "$1" ]]; then
        echo "usage: gifify <input_video> [output.gif]"
        return 1
    fi

    local input="$1"
    local output="${2:-${input%.*}.gif}"
    local palette="/tmp/gifify-palette-$$.png"

    ffmpeg -i "$input" -vf "fps=10,scale=600:-1:flags=lanczos,palettegen" -y "$palette"
    ffmpeg -i "$input" -i "$palette" -filter_complex "fps=10,scale=600:-1:flags=lanczos[x];[x][1:v]paletteuse" -y "${output}.tmp.gif"
    gifsicle --optimize=3 --colors 128 "${output}.tmp.gif" -o "$output"

    rm -f "$palette" "${output}.tmp.gif"
    echo "Created: $output"
}

# scan for active devices (requires nmap):
snitch() {
    if ! command -v nmap >/dev/null 2>&1; then
        if [[ "$(uname)" == "Darwin" ]]; then
            echo "nmap not installed (brew install nmap)"
        else
            echo "nmap not installed (install nmap... )"
        fi
        return 1
    fi

    local subnet
    if [[ "$(uname)" == "Darwin" ]]; then
        subnet=$(ipconfig getifaddr en0 | awk -F. '{print $1"."$2"."$3".0/24"}')
    else
        subnet=$(ip -o -f inet addr show | awk '/scope global/ {print $4}' | head -1)
    fi

    sudo nmap -sn "$subnet" && echo "*** Further details in ~ One Minute, Please Wait ..."
}

# local/internal network IP
myintip() {
    if [[ "$(uname)" == "Darwin" ]]; then
        ifconfig | awk '/inet /{print $2}' | grep -v '^127'
    else
        hostname -I
    fi
}

# public/external IP via OpenDNS resolver trick
myip() {
    dig +short myip.opendns.com @resolver1.opendns.com
}


# speedtest a hetzner, not at all accurate but good enough to check connection.
speedtest() {
    curl -o /dev/null http://hil-speed.hetzner.com/1GB.bin; true
}
