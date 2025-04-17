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

# # Searching in index.
INDEX_SYSTEM_DELIMITER="@"

# * Query only part *before* index system delimiter when fzf'nding.
# For example,
# We have "test@per.1" and "percussion@per.2"
# then `search_by_not_index --query "per"` will match only "percussion@per.2".
search_by_not_index() {
  fzf --delimiter=$INDEX_SYSTEM_DELIMITER --nth=1 "$@"
}

# * Query *whole* string when fzf'nding.
# For example,
# We have "test@per.1" and "percussion@per.2"
# then `search_including_index --query "per"` will match both.
search_including_index() {
  fzf "$@"
}

# * Query only part *after* index system delimiter when fzf'nding.
# For example,
# We have "test@per.1" and "percussion@per.2"
# then `search_by_index --query "per.1"` will match "test@per.1".
search_by_index() {
  fzf --delimiter=$INDEX_SYSTEM_DELIMITER --nth=2 "$@"
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
function yayf() {
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
