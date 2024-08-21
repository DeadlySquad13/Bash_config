# Module with functions that help edit text from cli.
# For example, using Unix utils, 3rd party services, one-shot sql functions, interpolate with other
# shells and so on.

# NeoVim Edit (norm mode).
#   Doesn't apply any user configurations.
# May be fixed wit `-u` option according to docs.
# [Source][@Tips:Shirolb/TipsNeovimSilent.2023]|[Zotero][z@Tips:Shirolb/TipsNeovimSilent.2023]
ne() {
  nvim -Es +"norm gg0$1" +'%print'
}

# References:
# [@Tips:Shirolb/TipsNeovimSilent.2023]: <www.reddit.com/r/neovim/comments/16fmrte/tips_neovim_silent_mode_nvim_es/> 'Tips: Neovim Silent Mode `nvim -Es`'
# [z@Tips:Shirolb/TipsNeovimSilent.2023]: <zotero://select/items/@Tips:Shirolb/TipsNeovimSilent.2023> 'Select in Zotero: Tips: Neovim Silent Mode `nvim -Es`'
