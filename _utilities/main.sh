#!/bin/bash

# General.
# * Errors.
echoerr() {
  # Copy file descriptor #1 (stdout) to file descriptor #2 (stderr).
  echo "$@" 1>&2;
}

throwException() {
  echoerr "$@";
  return 1;
}

fail() {
  echoerror "$@1";
  exit 1;
}

# Check the name of the current Operating System.
# 
# @example Detect MacOs environment:
# testMacOs() {
#   if osis Darwin; then
#     echo 'MacOs!'
#   else
#     echo 'No'
#   fi
# }
# @example Detect not Linux:
# testNotLinux() {
#   if osis -n Linux; then
#     echo 'Not Linux!'
#   else
#     echo 'Linux...'
#   fi
# }
#
# @see [List of possible os names](https://en.wikipedia.org/wiki/Uname#Examples).
# @ref [StackOverflow answer about detecting OS](https://stackoverflow.com/a/28493970).
osis()
{
    local n=0
    if [[ "$1" = "-n" ]]; then n=1;shift; fi

    # echo $OS|grep $1 -i >/dev/null
    uname -s |grep -i "$1" >/dev/null

    return $(( $n ^ $? ))
}

nodeis()
{
    local n=0
    if [[ "$1" = "-n" ]]; then n=1;shift; fi

    # TODO: Validate.
    # For example, @salt
    local node="$1"
    # Trim prefix up to @.
    local nodename=${node#*@}

    # FIX: Should be exact matches. Now it will match "alt" even if nodename
    # is "salt". It was ok with os names but here it's misleading.
    uname -n |grep -i "$nodename" >/dev/null

    return $(( $n ^ $? ))
}

# * Config.
config() {
  local configPath="$1";
  local command="$2";

  case $command in
    "-e" | "--edit")
      $EDITOR "$configPath";
      ;;

    "-s" | "--source")
      source "$configPath";
      echo "$configPath was sourced!";
      ;;

    "-d" | "--dir" | "--directory")
      local configDirectoryPath="$(dirname "$configPath")";
      cd "$configDirectoryPath";
      ;;

    *)
      return 1;
      ;;
  esac
}

bash() {
  local parameters="$@";
  config ~/.bashrc $parameters;
  if [[ $? -eq 1 ]]; then
    command bash $parameters;
  fi
}

task() {
  local parameters="$@";
  config ~/.taskrc $parameters;
  if [[ $? -eq 1 ]]; then
    command task $parameters;
  fi
}

tmux() {
  local parameters="$@";
  config ~/.tmux.conf $parameters;
  if [[ $? -eq 1 ]]; then
    command tmux $parameters;
  fi
}

# Ranger that will have a Q binding to exit and change your directory.
# @see {@Link https://superuser.com/a/1436077/1133669} for origin.
rangerWithFollow() {
  local IFS=$'\t\n'
  local tempfile="$(mktemp -t tmp.XXXXXX)"
  local ranger_cmd=(
    command
    ranger
    --cmd="map Q chain shell echo %d > \"$tempfile\"; quitall"
  )

  ${ranger_cmd[@]} "$@"
  if [[ -f "$tempfile" ]] && [[ "$(cat -- "$tempfile")" != "$PWD" ]]; then
    cd -- "$(cat -- "$tempfile")" || return
  fi
  command rm -f -- "$tempfile" 2>/dev/null
}

ranger() {
  local parameters="$@";
  config ~/.config/ranger/rc.conf $parameters;
  if [[ $? -eq 1 ]]; then
    rangerWithFollow $parameters;
  fi
}

rg() {
  local parameters="$@";
  config $RIPGREP_CONFIG_PATH $parameters;
  if [[ $? -eq 1 ]]; then
    command rg $parameters;
  fi
}

ssh() {
  local parameters="$@";
  # System config, there's also user config.
  config "/etc/ssh/ssh_config" $parameters;
  if [[ $? -eq 1 ]]; then
    command ssh $parameters;
  fi
}

# Breaks autocomplete. Can't make it goto as `command` is not working with goto,
#   it can't find it as executable. Probably have to reinstall it.
export GOTO_CONFIG_PATH="$HOME/.config/goto";
Goto() {
  local parameters="$@";
  config $GOTO_CONFIG_PATH $parameters;
  if [[ $? -eq 1 ]]; then
    goto $parameters;
  fi
}

export LAZYGIT_CONFIG_PATH="$HOME/.config/lazygit/config.yml";
lazygit() {
  local parameters="$@";
  # System config, there's also user config.
  config $LAZYGIT_CONFIG_PATH $parameters;
  if [[ $? -eq 1 ]]; then
    command lazygit $parameters;
  fi
}

export KITTY_CONFIG_PATH="$HOME/.config/kitty/kitty.conf";
kitty() {
  local parameters="$@";
  config $KITTY_CONFIG_PATH $parameters;
  if [[ $? -eq 1 ]]; then
    command kitty $parameters;
  fi
}

export ALACRITTY_CONFIG_PATH="$HOME/.config/alacritty/alacritty.yml";
alacritty() {
  local parameters="$@";
  config $ALACRITTY_CONFIG_PATH $parameters;
  if [[ $? -eq 1 ]]; then
    command alacritty $parameters;
  fi
}

if osis Darwin; then
  export WEZTERM_CONFIG_PATH="$HOME/.config/wezterm/wezterm.lua";
else
  export WEZTERM_CONFIG_PATH="/mnt/e/soft/Applied/Programming/Console Stuff/WezTerm/wezterm.lua";
fi

wezterm() {
  local parameters="$@";
  config "$WEZTERM_CONFIG_PATH" $parameters;
  if [[ $? -eq 1 ]]; then
    command wezterm $parameters;
  fi
}

printColors() {
  for i in {0..255}; do
    printf "\x1b[38;5;${i}mcolor%-5i\x1b[0m" $i;
    if ! (( ($i + 1 ) % 8 )); then
      echo;
    fi;
  done
}

isWsl() {
  if [[ -n "$IS_WSL" || -n "$WSL_DISTRO_NAME" ]]; then
    return 0
  else
    return 1
  fi
}

# Linux on Windows specific functions to interact with Windows.
if isWsl; then
  wsl() {
    local parameters="$@";
    config $WIN_HOME/.wslconfig $parameters;
    if [[ $? -eq 1 ]]; then
      command wsl $parameters;
    fi
  }

  wsltty() {
    local parameters="$@";
    config $WIN_LOCALAPPDATA/wsltty/home/$WIN_USER/.minttyrc $parameters;
    if [[ $? -eq 1 ]]; then
      command wsltty $parameters;
    fi
  }

  # Activating windows explorer from Wsl.
  explorer() {
    XYPlorer.exe "$@"
  }
fi

dotPng() {
  dot -Tpng $1.dot > $1.png && open $1.png
}

smug() {
  local command="$1";
  local parameters="$@";
  if [[ "$command" = "start" ]]; then
    command smug $parameters --attach;
  else
    command smug $parameters;
  fi 
}

# Timewarrior advanced aliases.
tw() {
  local parameters="$@";
  local command="$1";

  case $command in
    "-s")
      local param="$2"
      case $param in 
        ":w")
          timew summary \:week \:id;
          ;;
        ":lw")
          timew summary \:lastweek \:id;
          ;;
        *)
          # Should shift params and pass there.
          timew summary \:id;
          ;;
      esac
      ;;

    *)
      timew $parameters;
      ;;
  esac
}

#test() {
  #echo "$@"
  #while getopts ":a" opt; do
    #case $opt in
      #a)
        #echo "-a was triggered!" >&2
        #;;
      #\?)
        #echo "Invalid option: -$OPTARG" >&2
        #;;
    #esac
  #done
#}

# * Which.
# TODO: Support -a parameter of the which?
whichd() {
  local tmp="$(which $1)";
  echo ${tmp%$1};
}

cdwhich() {
  local whichSearchResult="$(whichd $1)";
  if [[ -z "$whichSearchResult" ]]; then
    throwException "${1} not found!"
  else
    cd $(whichd $1);
  fi
}


# Generate gitignore.
gengi() {
  curl -sL https://www.toptal.com/developers/gitignore/api/$@
}

# Go to corresponding KnowledgeBase section of a current directory (searches
#   symlinks).
goToKbd() {
  cd $(find . -maxdepth 1 -type l | rg 'KnowledgeBase__') && ll
}

if [[ -f ~/.bash/_utilities/bookmark.sh ]]; then
  source ~/.bash/_utilities/bookmark.sh
fi


if [[ -f ~/.bash/_utilities/systemctlWrapper.sh ]]; then
  source ~/.bash/_utilities/systemctlWrapper.sh
fi
