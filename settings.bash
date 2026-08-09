# git ships its own prompt/completion scripts, but doesn't auto-load them.
# path varies by distro, so check common locations and use whichever exists.
for gitprompt in \
    /usr/share/git/completion/git-prompt.sh \
    /usr/share/git-core/contrib/completion/git-prompt.sh \
    /usr/lib/git-core/git-sh-prompt \
    /etc/bash_completion.d/git-prompt; do
    [ -f "$gitprompt" ] && source "$gitprompt" && break
done

# same idea, for git tab-completion
for gitcompletion in \
    /usr/share/git/completion/git-completion.bash \
    /usr/share/git-core/contrib/completion/git-completion.bash \
    /etc/bash_completion.d/git; do
    [ -f "$gitcompletion" ] && source "$gitcompletion" && break
done

# controls what __git_ps1 (above) displays in the prompt
export GIT_PS1_SHOWCOLORHINTS=1
export GIT_PS1_SHOWDIRTYSTATE=1
export GIT_PS1_SHOWSTASHSTATE=1
export GIT_PS1_SHOWUNTRACKEDFILES=0

# builds PS1 dynamically each prompt draw (needed to catch $? before it's
# clobbered, and to reflect current git status).

set_bash_prompt() {
    local exit_code=$?
    local white="\[\033[1;37m\]"
    local green="\[\033[0;32m\]"
    local blue="\[\033[0;34m\]"
    local red="\[\033[0;31m\]"
    local reset="\[\033[0m\]"
    local git_info=""

    if command -v __git_ps1 >/dev/null 2>&1; then
        git_info="$(__git_ps1 " (%s)")"
    fi

    if [ "$EUID" -eq 0 ]; then
        PS1="${white}[${blue}\u${white}@${blue}\h${white}]${reset} ${blue}\w${reset}${git_info}${reset} "
    else
        PS1="${white}[${green}\u${white}@${green}\h${white}]${reset} ${blue}\w${reset}${git_info}${reset} "
    fi

    if [ $exit_code -ne 0 ]; then
        PS1+="${red}> ${reset}"
    else
        PS1+="> "
    fi
}
PROMPT_COMMAND=set_bash_prompt

# Try to keep environment pollution down, EPA loves us.
unset use_color safe_term match_lhs 2>/dev/null
