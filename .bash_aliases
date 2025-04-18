# Directories.
alias ..='cd ..';
alias ...='cd ../../';
alias ....='cd ../../../';
alias .3='cd ../../../';
alias .4='cd ../../../../';
alias .5='cd ../../../../../';

alias .b='cd ./build'
alias .s='cd ./src'

# * Shells
# - Bash.
alias bsh='bash';
# - Powershell.
alias psh='powershell.exe';

# NeoVim.
alias vi='nvim';
alias gvi='neovide';

alias hs='historySearch';

# Open (for wsl).
# alias open='cmd.exe /C start';

# Taskwarrior.
alias t='task';

# Goto.
# automatically pushes directory to stack.
alias gp='goto -p';

# Ranger.
alias r='ranger';

# Batch.
alias rn='batchProcess --map '"'"'rename "$1" "$2"'"'"'';

# Lazygit.
alias lg='lazygit';

# Python.
alias py='python';
# alias py='python3.10';
alias python='python3';
#alias pip='pip3';
# * Venv.
alias venv='python -m venv';
# - Install from requirements (not actually venv functionality but highly
#   related (similar to npm i)).
# TODO: checks for running env.
alias venv_i='pip3 install -r requirements.txt';
# TODO: optional venv location.
alias venv_create='python -m venv ./.venv';
# TODO: optional venv location.
alias venv_activate='source ./.venv/bin/activate';
alias venv_deactivate='deactivate';
# TODO: venv_init (create, activate, i), venv_run (create if no .venv, activate)

alias pipi='pip3 install -U';
alias piprm='pip3 uninstall';
# Data science kit.
# TODO: Wrap pip into it's own function.
alias pipi_ds='pipi numpy pandas seaborn matplotlib';
# # Jupyter
# * Jupyter Lab.
# - Start jupyter lab server.
alias julab='jupyter-lab'
alias julab_start='jupyter-lab --no-browser';

# * Jupyter Notebook.
# - Start jupyter notebook server.
alias junote='jupyter notebook --no-browser';

# * Jupyter ascending.
# - Make pair python file for notebook via jupyter ascending.
alias juasc='python -m jupyter_ascending.scripts.make_pair --base';

# * Jupytext.
# @see{@link [jupytextCliDocs]{https://github.com/mwouts/jupytext/blob/main/docs/using-cli.md}}.
# - Alias.
alias jutext='jupytext';
# - Convert existing file to python in preferred cell format.
preferredCellFormat='percent'
alias jutextconvert="jupytext --to py:$preferredCellFormat";


# Directory aliases.
alias ll='ls -alF';
alias la='ls -A';
alias l='ls -CF';
alias dirs='dirs -v';

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"';

# Enable color support of ls and also add handy aliases.
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)";
    alias ls='ls --color=auto';
    alias dir='dir --color=auto';
    alias vdir='vdir --color=auto';

    alias grep='grep --color=auto';
    alias fgrep='fgrep --color=auto';
    alias egrep='egrep --color=auto';
fi

# Only the newer Ubuntus get the unified names (datediff, dateadd...).
alias datediff='dateutils.ddiff';
# alias wget='curl -O';

# Searching.
#   Search filenames with ripgrep (alternative to find that respects ripgrep ignore
# files, for example, it doesn't search in node_modules).
#   Reference: https://github.com/BurntSushi/ripgrep/issues/193#issuecomment-513201558
alias rgf='rg --files | rg'
rgvi() {
    rg --vimgrep "$1" | nvim -c ':cbuffer'
}

# Search file-contents with broot.
alias brc='br --cmd c/'

# Alsa's speaker-test.
# Linux aliases.
# # Alsa aliases.
if [ -x /usr/bin/alsamixer ]; then
    # Alsa's speaker-test.
    #   Play human voice pronouncing channel names one by one instead of pink
    # noise.
    alias speaker-test="speaker-test -t wav -c 6";
fi

# # Awesome aliases.
if [ -x /usr/bin/awesome ]; then
    # Test awesome with separate X-server instance via Xephyr.
    alias xephyr-awesome="Xephyr -screen 800x600 :5 & sleep 1 ; DISPLAY=:5 awesome"
fi
# Network.
# Source: https://stackoverflow.com/a/13322549
alias lanip="ifconfig | sed -En 's/127.0.0.1//;s/.*inet (addr:)?(([0-9]*\.){3}[0-9]*).*/\2/p'"

# Systemctl.
if [[ "$(command -v systemctlWrapper)" ]]; then
    # - my wrapper
    alias sct="systemctlWrapper"
else
    # - builtin
    alias sct="systemctl"
fi

# - Add systemctl completion to my function.
# Source: “Answer to ‘How to Make Alias to Systemctl with Autocomplete.’” Ask Ubuntu, October 22, 2021. https://askubuntu.com/a/1370852.
# if [[ -r /usr/share/bash-completion/completions/systemctl ]]; then
  # FIX: For some reason 'complete' is not found so it errors on
  # last line of the script. Even though it should be
  # bundled with bash.
#   (. /usr/share/bash-completion/completions/systemctl || true) && complete -F _systemctl systemctl systemctlWrapper sct || true
# fi

#   Aliases for easy copy-pasting.
# Source: Legend "Answer to ‘How Can I Copy the Output of a Command Directly into My Clipboard?’” Stack Overflow, February 27, 2011. https://stackoverflow.com/a/5130969/24067232.
# Usage: 
# - yank via piping or redirection: `cat file | yank` or `pwd | yank`
# - put via command substitution (see Mika, D. “Answer to ‘What Does Grave Accent (`) Symbol Do in Terminal.’” Stack Overflow, March 6, 2017. https://stackoverflow.com/a/42619058/24067232):
# ```bash
# cd $(put)
# # Or shorter variant:
# cd `put`
# # Or if have spaces in put (not sure if it works with ``):
# cd "$(put)"
# ```
#   Can be further enhanced, see url below, maybe it will be better than my
# implementation.
# Bronosky, Bruno. “Answer to ‘How Can I Copy the Output of a Command Directly into My Clipboard?’” Stack Overflow, January 25, 2017. https://stackoverflow.com/a/41843618/24067232.
# - Linux variants via xclip (may not be installed).
if [[ -x "$(command -v xclip)" ]]; then
    alias yank="xclip -selection clipboard"
    alias put="xclip -o -selection clipboard"
# - Macos variants.
elif [[ -x "$(command -v pbcopy)" ]]; then
    alias yank="pbcopy"
    if [[ -x "$(command -v pbcopy)" ]]; then
        alias put="pbpaste"
    fi
fi

alias y="yank"
alias p="put"

# Broot aliases.
if [[ -x "$(command -v broot)" ]]; then
    # Like tongue-twisted broot du and broot.
    alias brud="br --sizes --sort-by-size --hidden"
fi
