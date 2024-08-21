export KEYS_PATH="$HOME/.ssh"
declare -a keys=("$KEYS_PATH/Personal__DeadlySquad13_gitHub" "$KEYS_PATH/Personal__DeadlySquad13_gitLab" "$KEYS_PATH/Work__Rutube_gitLab");

# Init ssh agent and add necessary keys.
if [[ -f ~/.bash/_utilities/addSshKeys.sh ]]; then
  . ~/.bash/_utilities/addSshKeys.sh
fi
