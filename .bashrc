#   Files that are sourced when bash is loaded in non-interactive environment
# For example, from vim ex-mode.
export BASH_ENV="$HOME/.bash/nonInteractive.sh"
# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything.
case $- in
  *i*) ;;
    *) return;;
esac
# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# Had some problems with locales. 
# https://askubuntu.com/questions/599808/cannot-set-lc-ctype-to-default-locale-no-such-file-or-directory
# export LC_ALL="en_US.UTF-8"

# make less more friendly for non-text input files, see lesspipe(1)
[[ -x /usr/bin/lesspipe ]] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [[ -z "${debian_chroot:-}" ]] && [[ -r /etc/debian_chroot ]]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# Always start new interactive bash session in tmux.
# if [[ -f ~/.bash/startupInTmux.sh ]]; then
#     . ~/.bash/startupInTmux.sh
# fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
force_color_prompt=yes

if [[ -n "$force_color_prompt" ]]; then
    if [[ -x /usr/bin/tput ]] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [[ "$color_prompt" = yes ]]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac
# Ranger shell prompt indicator.
if [[ -n "$RANGER_LEVEL" ]]; then export PS1="[ranger]$PS1"; fi

# OLD:
#LS_COLORS="rs=0:di=1;33;44:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:mi=00:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arc=01;31:*.arj=01;31:*.taz=01;31:*.lha=01;31:*.lz4=01;31:*.lzh=01;31:*.lzma=01;31:*.tlz=01;31:*.txz=01;31:*.tzo=01;31:*.t7z=01;31:*.zip=01;31:*.z=01;31:*.dz=01;31:*.gz=01;31:*.lrz=01;31:*.lz=01;31:*.lzo=01;31:*.xz=01;31:*.zst=01;31:*.tzst=01;31:*.bz2=01;31:*.bz=01;31:*.tbz=01;31:*.tbz2=01;31:*.tz=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.war=01;31:*.ear=01;31:*.sar=01;31:*.rar=01;31:*.alz=01;31:*.ace=01;31:*.zoo=01;31:*.cpio=01;31:*.7z=01;31:*.rz=01;31:*.cab=01;31:*.wim=01;31:*.swm=01;31:*.dwm=01;31:*.esd=01;31:*.jpg=01;35:*.jpeg=01;35:*.mjpg=01;35:*.mjpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.svg=01;35:*.svgz=01;35:*.mng=01;35:*.pcx=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.m2v=01;35:*.mkv=01;35:*.webm=01;35:*.ogm=01;35:*.mp4=01;35:*.m4v=01;35:*.mp4v=01;35:*.vob=01;35:*.qt=01;35:*.nuv=01;35:*.wmv=01;35:*.asf=01;35:*.rm=01;35:*.rmvb=01;35:*.flc=01;35:*.avi=01;35:*.fli=01;35:*.flv=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.yuv=01;35:*.cgm=01;35:*.emf=01;35:*.ogv=01;35:*.ogx=01;35:*.aac=00;36:*.au=00;36:*.flac=00;36:*.m4a=00;36:*.mid=00;36:*.midi=00;36:*.mka=00;36:*.mp3=00;36:*.mpc=00;36:*.ogg=00;36:*.ra=00;36:*.wav=00;36:*.oga=00;36:*.opus=00;36:*.spx=00;36:*.xspf=00;36:"

#export LS_COLORS

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Should be after ls aliases to apply color instead of default --auto values.
# Uses ANSI Codes: \u001b[34m - 34 at the end stands for blue color.
# Use `dircolors -p` to look up the file codes.
# Some colors rely not only on extension but also on permissions:
#   - bd = (BLOCK, BLK)   Block device (buffered) special file
#   - cd = (CHAR, CHR)    Character device (unbuffered) special file
#   - di = (DIR)  Directory
#   - do = (DOOR) [Door][1]
#   - ex = (EXEC) Executable file (ie. has 'x' set in permissions)
#   - fi = (FILE) Normal file
#   - ln = (SYMLINK, LINK, LNK)   Symbolic link. If you set this to ‘target’ instead of a numerical value,
#       the color is as for the file pointed to.
#   - mi = (MISSING)  Non-existent file pointed to by a symbolic link (visible when you type ls -l)
#   - no = (NORMAL, NORM) Normal (non-filename) text. Global default, although everything should be something
#   - or = (ORPHAN)   Symbolic link pointing to an orphaned non-existent file
#   - ow = (OTHER_WRITABLE)   Directory that is other-writable (o+w) and not sticky
#   - pi = (FIFO, PIPE)   Named pipe (fifo file)
#   - sg = (SETGID)   File that is setgid (g+s)
#   - so = (SOCK) Socket file
#   - st = (STICKY)   Directory with the sticky bit set (+t) and not other-writable
#   - su = (SETUID)   File that is setuid (u+s)
#   - tw = (STICKY_OTHER_WRITABLE)    Directory that is sticky and other-writable (+t,o+w)
#   - *.extension =   Every file using this extension e.g. *.rpm = files with the ending .rpm
# * Attribute codes:
#   - 00=none 01=bold 04=underscore 05=blink 07=reverse 08=concealed
#   - Text color codes:
#   - 30=black 31=red 32=green 33=yellow 34=blue 35=magenta 36=cyan 37=white
#   - Background color codes:
#   - 40=black 41=red 42=green 43=yellow 44=blue 45=magenta 46=cyan 47=white
LS_COLORS="fi=00;37:ex=01;32:ln=37\
:or=01;30:mi=00:mh=31\
:pi=33:so=43;30:do=35\
:bd=35;01:cd=35\
:su=37;41:sg=30;43:ca=30;41\
:di=01;34:tw=07;34:ow=01;36:st=30;44"

export LS_COLORS

export NPM_CONFIG_PREFIX=~/.npm-global

WIN_PATH_BACKUP="/mnt/e/soft/ConEmu/ConEmu/Scripts:/mnt/e/soft/ConEmu:/mnt/e/soft/ConEmu/ConEmu:/mnt/c/Users/Александр/AppData/Local/Programs/Python/Python38/Scripts/:/mnt/c/Users/Александр/AppData/Local/Programs/Python/Python38/:/mnt/c/Program Files (x86)/Common Files/Oracle/Java/javapath:/mnt/c/Program Files (x86)/ffmpeg/bin:/mnt/c/ProgramData/Oracle/Java/javapath:/mnt/c/Program Files (x86)/Razer Chroma SDK/bin:/mnt/c/Program Files/Razer Chroma SDK/bin:/mnt/c/Windows/system32:/mnt/c/Windows:/mnt/c/Windows/System32/Wbem:/mnt/c/Windows/System32/WindowsPowerShell/v1.0/:/mnt/c/Program Files (x86)/NVIDIA Corporation/PhysX/Common:/mnt/e/TORRENT/Minecraft/WorldPainter:/mnt/e/Lessons/Informatics/Python:/mnt/e/Lessons/Informatics/Python Projects:/mnt/c/ProgramData/chocolatey/bin:/mnt/e/soft/php:/mnt/e/soft/Calibre (Editing Epub files/:/mnt/c/Program Files/MySQL/MySQL Utilities 1.6/:/mnt/c/Program Files/Microsoft/Web Platform Installer/:/mnt/c/Program Files (x86)/Microsoft ASP.NET/ASP.NET Web Pages/v1.0/:/mnt/c/Program Files/Microsoft SQL Server/110/Tools/Binn/:/mnt/c/Program Files/Microsoft SQL Server/120/Tools/Binn/:/mnt/c/Program Files/NVIDIA Corporation/NVIDIA NvDLISR:/mnt/e/soft/Node.js/:/mnt/c/WINDOWS/system32:/mnt/c/WINDOWS:/mnt/c/WINDOWS/System32/Wbem:/mnt/c/WINDOWS/System32/WindowsPowerShell/v1.0/:/mnt/c/WINDOWS/System32/OpenSSH/:/mnt/c/Program Files/Microsoft SQL Server/130/Tools/Binn/:/mnt/c/Program Files/Microsoft SQL Server/Client SDK/ODBC/170/Tools/Binn/:/mnt/c/Program Files (x86)/IncrediBuild:/mnt/e/soft/Graphics Editors/QuickTime/QTSystem/:/mnt/e/soft/Git for Windows/Git/cmd:/mnt/c/Program Files/dotnet/:/mnt/c/Program Files (x86)/Microsoft SQL Server/150/DTS/Binn/:/mnt/c/Program Files/Azure Data Studio/bin:/mnt/c/Program Files (x86)/Microsoft SQL Server/150/Tools/Binn/:/mnt/c/Program Files/Microsoft SQL Server/150/Tools/Binn/:/mnt/c/Program Files/Microsoft SQL Server/150/DTS/Binn/:/mnt/c/Users/Александр/.windows-build-tools/python27/:/mnt/e/soft/JetBrains/JetBrains PyCharm Professional/JetBrains PyCharm Professional 2019.2.4/bin:/mnt/e/soft/Visual Studio Code/VIsual Studio Code 2019/VC/Tools/MSVC/14.25.28610/bin/HostX86/x86:/mnt/e/soft/Visual Studio Code/VIsual Studio Code 2019/Common7/IDE/VC/VCPackages:/mnt/e/soft/Visual Studio Code/VIsual Studio Code 2019/Common7/IDE/CommonExtensions/Microsoft/TestWindow:/mnt/e/soft/Visual Studio Code/VIsual Studio Code 2019/Common7/IDE/CommonExtensions/Microsoft/TeamFoundation/Team Explorer:/mnt/e/soft/Visual Studio Code/VIsual Studio Code 2019/MSBuild/Current/bin/Roslyn:/mnt/e/soft/Visual Studio Code/VIsual Studio Code 2019/Team Tools/Performance Tools:/mnt/c/Program Files (x86)/Microsoft Visual Studio/Shared/Common/VSPerfCollectionTools/vs2019/:/mnt/c/Program Files (x86)/Windows Kits/10/bin/10.0.18362.0/x86:/mnt/c/Program Files (x86)/Windows Kits/10/bin/x86:/mnt/e/soft/Visual Studio Code/VIsual Studio Code 2019/MSBuild/Current/Bin:/mnt/c/Windows/Microsoft.NET/Framework/v4.0.30319:/mnt/e/soft/Visual St:/mnt/c/Users/Александр/AppData/Local/Programs/Microsoft VS Code/bin:/mnt/c/Program Files/Azure Data Studio/bin:/mnt/e/Scripts/Batch/Lessons:/mnt/c/Users/Александр/AppData/Local/atom-nightly/bin:/mnt/c/Users/Александр/.npm-global/bin"
# For clipping and pasting.
WIN_PATH="/mnt/c/ProgramData/WslProgramData:$WIN_HOME/im-select";
# This path was enough on salt@ArchLinux TODO: Clean macos paths.
# export PATH+="$HOME/.local/bin"
# Was needed during wsl operation, not sure if it still viable.
# WIN_PROGRAMS="/mnt/c/ProgramData/Microsoft/Windows/Start Menu/Programs:/mnt/c/Program Files (x86)/XYplorer"
GO_PATH="$HOME/go/bin:/usr/local/go/bin"
NODE_PATH="/usr/local/opt/node@16/bin"
# Because I'm done dealing with nix paths... They're overwritten somewhere in
# .bashrc.
export NIX_PATH="$HOME/.local/bin:$HOME.nix-profile/bin:/nix/var/nix/profiles/default/bin"
export PATH+="$NIX_PATH:$NODE_PATH:$GO_PATH:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:$HOME/.npm-global/bin:$HOME/.local/bin:$WIN_PATH";

export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc

# Source goto.
[[ -s "/usr/local/share/goto.sh" ]] && source /usr/local/share/goto.sh

# Trim path up to `n` instances.
PROMPT_DIRTRIM=3

# Windows System Variables.
# # Converted to work with Linux filesystem.
# * Special variables.
export WIN_USER=Александр

# * Paths.
export WIN_HOME=/mnt/c/Users/$WIN_USER
export WIN_LOCALAPPDATA=$WIN_HOME/AppData/Local


# # Not converted to work with Windows filesystem.
# * Paths (APPDATA exists already).
export LOCALAPPDATA="C:\Users\\$WIN_USER\AppData\Local"

# * Some commonly used paths.
WORK=/mnt/e/Work
export WORK

# Default editor.
export EDITOR="nvim"

# Keybindings.
# * Vi mode.
set -o vi

# Exceptions.
wrongParameters=2

# Config.
# * History.
# - Directory where all history files are stored.
export HISTPATH="$HOME/.local/share/bash/history";
mkdir -p "$HISTPATH"
# - Saving history to file
export PROMPT_COMMAND='\
  if [[ "$(id -u)" -ne 0 ]]; then\
    echo "$(date "+%Y-%m-%d.%H:%M:%S") $(pwd) $(history 1)" >>\
    ${HISTPATH}/BashHistory{$(date "+%Y-%m-%d")}.log;\
  fi';
# - For setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=200000

# - History file contents format.
export HISTTIMEFORMAT="%d/%m/%y %T  "
# - Avoid duplicates
export HISTCONTROL=ignoredups:erasedups  
# - When the shell exits, append to the history file instead of overwriting it
shopt -s histappend
# - After each command, append to the history file (removed: and reread it
# `; history -c; history -r`)
export PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a"

# First argument is a command to search
historySearch() {
  ls -rt $HISTPATH/*.log | xargs rg "$1";
}

# Show names of the keys pressed.
function print-keys() {
    if [[ -x /usr/bin/xev ]]; then
        xev | awk -F'[ )]+' '/^KeyPress/ { a[NR+2] } NR in a { printf "%-3s %s\n", $5, $8 }'
    fi
}

# Powerline.
if [[ -x "$(command -v powerline-daemon)" ]]; then
    powerline-daemon -q
    POWERLINE_BASH_CONTINUATION=1
    POWERLINE_BASH_SELECT=1
fi
# How to make it more generic?
# - WSL.
if [[ -f /home/dubuntus/.local/lib/python3.8/site-packages/powerline/bindings/bash/powerline.sh ]]; then
    source /home/dubuntus/.local/lib/python3.8/site-packages/powerline/bindings/bash/powerline.sh
    #source /usr/local/lib/python3.8/dist-packages/powerline/bindings/bash/powerline.sh
fi
# - MacOs.
if [[ -f /usr/local/lib/python3.9/site-packages/powerline/bindings/bash/powerline.sh ]]; then
    source /usr/local/lib/python3.9/site-packages/powerline/bindings/bash/powerline.sh
fi

# C-z shortcut can be used to take a suspended job to foreground.
stty susp undef
bind -x '"\C-z":"fg"'

# Utilities.
if [[ -f ~/.bash/_utilities/main.sh ]]; then
  . ~/.bash/_utilities/main.sh
fi

# MacOs specific settings.
if [[ -f ~/.bash/.bash_macos ]]; then
  . ~/.bash/.bash_macos
fi

# Authorize ssh 
if [[ -f ~/.bash/sshAuthorization.sh ]]; then
  . ~/.bash/sshAuthorization.sh
fi

# Templates.
if [[ -f ~/.bash/templates.sh ]]; then
    export TEMPLATE_PATH="/mnt/e/Projects/--personal/ModuleT/src";

    . ~/.bash/templates.sh
fi

# Taskwarrior project management.
if [[ -f ~/.bash/taskwarriorProjectManagement.sh ]]; then
    # Declares an array of projects in bash
    # The position in the array counts for the id and starts counting at 1
    declare -a projects=('Thmoon.OG.P' 'Lessons');

    . ~/.bash/taskwarriorProjectManagement.sh
fi

# Searching.
# Fzf.
if type fzf &> /dev/null; then
  # * Setting autocompletion and default keybindings.
  if [[ -f ~/.fzf.bash ]]; then
    source ~/.fzf.bash
  fi

  # # Prefer rg over find.
  if type rg &> /dev/null; then
      export FZF_DEFAULT_COMMAND='rg --files --hidden'
  fi

  # # Options.
  # * Keybindings.
  # -- Vim like scroll keybindings for preview.
  FZF_DEFAULT_OPTS='--bind=ctrl-f:preview-half-page-down,ctrl-b:preview-half-page-up '

  # * Bat preview.
  if [[ -f /usr/local/bin/bat ]]; then
    FZF_DEFAULT_OPTS+="--preview-window 'right:60%' --preview 'bat --color=always --style=header,grid --line-range :300 {}' "
  fi

  export FZF_DEFAULT_OPTS

  smug_start_with_fzf() {
      smug start $(smug list | fzf --preview "bat --color=always --style=plain --line-range :300 $HOME/.config/smug/{}.yml")
  }

  #open_with_fzf() {
      #fd -t f -H -I | fzf -m --preview="xdg-mime query default {}" | xargs -ro -d "\n" xdg-open 2>&-
  #}

  #cd_with_fzf() {
      #cd $HOME && cd "$(fd -t d | fzf --preview="tree -L 1 {}" --bind="space:toggle-preview" --preview-window=:hidden)"
  #}

  #pacs() {
      #sudo pacman -Syy $(pacman -Ssq | fzf -m --preview="pacman -Si {}" --preview-window=:hidden --bind=space:toggle-preview)
  #}


  # run npm script (requires jq)
  fnrun() {
      local script
      script=$(cat package.json | jq -r '.scripts | keys[] ' | sort | fzf) && npm run $(echo "$script")
  }

  # Select a docker container to start and attach to
  function da() {
    local cid
    cid=$(docker ps -a | sed 1d | fzf -1 -q "$1" | awk '{print $1}')
  
    [ -n "$cid" ] && docker start "$cid" && docker attach "$cid"
  }
  # Select a running docker container to stop
  function ds() {
    local cid
    cid=$(docker ps | sed 1d | fzf -q "$1" | awk '{print $1}')
  
    [ -n "$cid" ] && docker stop "$cid"
  }
  # Select a docker container to remove
  function drm() {
    local cid
    cid=$(docker ps -a | sed 1d | fzf -q "$1" | awk '{print $1}')
  
    [ -n "$cid" ] && docker rm "$cid"
  }
  # Same as above, but allows multi selection:
  function drm() {
    docker ps -a | sed 1d | fzf -q "$1" --no-sort -m --tac | awk '{ print $1 }' | xargs -r docker rm
  }
  # Select a docker image or images to remove
  function drmi() {
    docker images | sed 1d | fzf -q "$1" --no-sort -m --tac | awk '{ print $3 }' | xargs -r docker rmi
  }

  # Install packages using yay (change to pacman/AUR helper of your choice)
  function in() {
      yay -Slq | fzf -q "$1" -m --preview 'yay -Si {1}'| xargs -ro yay -S
  }
  # Remove installed packages (change to pacman/AUR helper of your choice)
  function re() {
      yay -Qq | fzf -q "$1" -m --preview 'yay -Qi {1}' | xargs -ro yay -Rns
  }
  # Helper function to integrate yay and fzf
  yzf() {
    pos=$1
    shift
    sed "s/ /\t/g" |
      fzf --nth=$pos --multi --history="${FZF_HISTDIR:-$XDG_STATE_HOME/fzf}/history-yzf$pos" \
        --preview-window=60%,border-left \
        --bind="double-click:execute(xdg-open 'https://archlinux.org/packages/{$pos}'),alt-enter:execute(xdg-open 'https://aur.archlinux.org/packages?K={$pos}&SB=p&SO=d&PP=100')" \
         "$@" | cut -f$pos | xargs
  }
  
  # Dev note: print -s adds a shell history entry
  
  # List installable packages into fzf and install selection
  # yas() {
  #   cache_dir="/tmp/yas-$USER"
  #   test "$1" = "-y" && rm -rf "$cache_dir" && shift
  #   mkdir -p "$cache_dir"
  #   preview_cache="$cache_dir/preview_{2}"
  #   list_cache="$cache_dir/list"
  #   { test "$(cat "$list_cache$@" | wc -l)" -lt 50000 && rm "$list_cache$@"; } 2>/dev/null
  #   pkg=$( (cat "$list_cache$@" 2>/dev/null || { pacman --color=always -Sl "$@"; yay --color=always -Sl aur "$@" } | sed 's/ [^ ]*unknown-version[^ ]*//' | tee "$list_cache$@") |
  #     yzf 2 --tiebreak=index --preview="cat $preview_cache 2>/dev/null | grep -v 'Querying' | grep . || yay --color always -Si {2} | tee $preview_cache")
  #   if test -n "$pkg"
  #     then echo "Installing $pkg..."
  #       cmd="yay -S $pkg"
  #       print -s "$cmd"
  #       eval "$cmd"
  #       rehash
  #   fi
  # }
  # # List installed packages into fzf and remove selection
  # # Tip: use -e to list only explicitly installed packages
  # yar() {
  #   pkg=$(yay --color=always -Q "$@" | yzf 1 --tiebreak=length --preview="yay --color always -Qli {1}")
  #   if test -n "$pkg"
  #     then echo "Removing $pkg..."
  #       cmd="yay -R --cascade --recursive $pkg"
  #       print -s "$cmd"
  #       eval "$cmd"
  #   fi
  # }
fi

# TODO: Rust env setup (breaks? nix paths)
# source "$HOME/.cargo/env"

# asdf version manager.
# When new node version comes out and you’ll update to it by running brew
# upgrade, the link will be removed and the most recent node version will be
# linked instead. To fix that place node before $PATH.


# Set CLICOLOR if you want Ansi Colors in iTerm2 
# export CLICOLOR=1

# Set colors to match iTerm2 Terminal Colors
# export TERM=xterm-256color

# . "/usr/local/opt/asdf/libexec/asdf.sh"

# . "/usr/local/opt/asdf/libexec/asdf.sh"

# TODO: Seems like it's not needed anymore, remove after 2024-06-01.
# export NODE_OPTIONS=--openssl-legacy-provider

# Alias definitions.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [[ -f ~/.bash/.bash_aliases ]]; then
    . ~/.bash/.bash_aliases
fi
