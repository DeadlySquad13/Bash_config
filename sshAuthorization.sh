export KEYS_PATH="$HOME/.ssh"
# TODO: Rename DeadlySquad13_gitHub_rsa on MacOs to Personal__DeadlySquad13_gitHub
declare -a keys=("$KEYS_PATH/Personal__DeadlySquad13_gitHub" "$KEYS_PATH/DeadlySquad13_gitHub_rsa" "$KEYS_PATH/Personal__DeadlySquad13_gitLab");

# Init ssh agent and add necessary keys.
if [ -f ~/.bash/_utilities/addSshKeys.sh ]; then
  . ~/.bash/_utilities/addSshKeys.sh
fi
