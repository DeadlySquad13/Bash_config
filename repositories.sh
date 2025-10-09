# TODO: Check for auth.
org=$(printf "%s\n" $(git config --get user.name) $(gh org list) | fzf)

gh repo list $org
