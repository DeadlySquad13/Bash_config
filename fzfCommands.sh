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
